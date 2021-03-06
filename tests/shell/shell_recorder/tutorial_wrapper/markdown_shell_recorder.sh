#!/bin/bash
INFILE="$1"

@INCLUDE_COMMON@

BLOCKS=$(sed -n '/```sh/,/```\n/p' "$1")
BUF=
SHELL_RECORDER_ERROR=0

COMMAND=
RET=
ERRORS=
WARNINGS=
STDOUT=
STDOUTRE=
STDOUTGLOB=
STDERR=
DIFF=
OUTBUF=
MOUNTPOINT=

writeBlock()
{
	OUTFILE="$1"
	if [ ! -z "$RET" ];
	then
		echo "RET: $RET" >> "$TMPFILE"
	else
		if [ -z "$ERRORS" ];
		then
			echo "RET: 0" >> "$TMPFILE"
		fi
	fi
	if [ ! -z "$ERRORS" ];
	then
		echo "ERRORS: $ERRORS" >> "$TMPFILE"
	fi
	if [ ! -z "$WARNINGS" ];
	then
		echo "WARNINGS: $WARNINGS" >> "$TMPFILE"
	fi
	if [ ! -z "$DIFF" ];
	then
		echo "DIFF: $DIFF" >> "$TMPFILE"
	fi
	if [ ! -z "$STDERR" ];
	then
		echo "STDERR: $STDERR" >> "$TMPFILE"
	fi
	if [ ! -z "$OUTBUF" ];
	then
		tmp=$(replace_newline_return <<< "$OUTBUF")
		tmp=$(echo "$tmp" | regex_escape)
		echo "STDOUT: $tmp" >> "$TMPFILE"
	elif [ ! -z "$STDOUT" ];
	then
		tmp=$(replace_newline_return <<< "$STDOUT")
		tmp=$(echo "$tmp" | regex_escape)
		echo "STDOUT: $tmp" >> "$TMPFILE"
	else
		if [ ! -z "$STDOUTRE" ]
		then
			echo "STDOUT-REGEX: $STDOUTRE" >> "$TMPFILE"
		else
			if [ ! -z "$STDOUTGLOB" ];
			then
				echo "STDOUT-GLOB: $STDOUT"
			fi
		fi
	fi
	COMMAND=$(sed s/sudo\ //g <<<"$COMMAND")
	echo "< $COMMAND" >> "$TMPFILE"

	COMMAND=
	RET=
	ERRORS=
	WARNINGS=
	STDOUT=
	STDOUTRE=
	STDOUTGLOB=
	STDERR=
	DIFF=
	OUTBUF=
}

translate()
{
	TMPFILE=$(mktemp)
	MOUNTPOINT=$(echo "$BUF" | head -n 1)
	grep -Eq "Backup-and-Restore:" <<< "$MOUNTPOINT"
	if [ "$?" -eq 0 ];
	then
		MOUNTPOINT=$(echo "$MOUNTPOINT" | cut -d ':' -f2)
		echo "Mountpoint: $MOUNTPOINT" >> "$TMPFILE"
	else
		echo "Mountpoint: /examples" >> "$TMPFILE"
	fi
	COMMAND=
	RET=
	ERRORS=
	WARNINGS=
	STDOUT=
	STDOUTRE=
	STDOUTGLOB=
	STDERR=
	DIFF=
	OUTBUF=
	MOUNTPOINT=
	IFS=''
	while read -r line;
	do
		grep -Eq "^(\s)*#>" <<< "$line"
		if [ "$?" -eq 0 ];
		then
			if [ -z "$OUTBUF" ];
			then
				tmp=$(sed -n 's/\(\s\)*#> \(.*\)/\2/p' <<<"$line")
				OUTBUF="$tmp"
			else
				tmp=$(sed -n 's/\(\s\)*#> \(.*\)/\2/p' <<<"$line")
				[ -z "$tmp" ] && OUTBUF="${OUTBUF}⏎" || OUTBUF=$(echo -en "${OUTBUF}\n$tmp")
			fi
		fi

		grep -Eq "^(\s*)#" <<< "$line"
		if [ "$?" -eq 0 ];
		then
			tmp=$(sed -n 's/\(\s\)*# \(.*\)/\2/p' <<<"$line")
			cmd=$(cut -d ':' -f1 <<< "$tmp")
			arg=$(cut -d ':' -f2- <<< "$tmp" | sed 's/[[:space:]]*//')

			case "$cmd" in
				RET)
					RET="$arg"
					;;
				STDOUT)
				    	STDOUT="$arg"
					;;
				STDOUT-REGEX)
					STDOUTRE="$arg"
					;;
				STDOUT-GLOB)
					STDOUTGLOB="$arg"
					;;
				STDERR)
					STDERR="$arg"
					;;
				ERRORS)
					ERRORS="$arg"
					;;
				WARNINGS)
					WARNINGS="$arg"
					;;
				DIFF)
					DIFF="$arg"
					;;
				*)
					;;
			esac
			continue
		fi
		if [ ! -z "$line" ];
		then
			if [ ! -z "$COMMAND" ];
			then
				writeBlock "$TMPFILE"
			fi
			COMMAND=$(grep -Eo "[^ \\t].*" <<< "$line")
			COMMAND=$(sed "s/^sudo\ //" <<< "$COMMAND")
			COMMAND=$(sed "s/\`[[:blank:]]*sudo\ /\`/" <<< "$COMMAND")
			if [ "${line: -1}" == "\\" ];
			then
				COMMAND="${COMMAND%?}"
			fi
			while [ "${line: -1}" == "\\" ];
			do
				read -r line
				line=$(sed "s/^sudo\ //" <<< "$line")
				line=$(sed "s/\`[[:blank:]]*sudo\ /\`/" <<< "$line")
				if [ "${line: -1}" == "\\" ];
				then
					COMMAND=$(printf "%s\\\n%s" "$COMMAND" "${line%?}")
				else
					COMMAND=$(printf "%s\\\n%s\\\n" "$COMMAND" "$line")
				fi
			done
			continue
		fi
	done <<<"$BUF"
	writeBlock "$TMPFILE"
	../shell_recorder.sh "$TMPFILE" || SHELL_RECORDER_ERROR=1
	rm "$TMPFILE"
}
INBLOCK=0
IFS=''

MOUNTPOINTS_BACKUP=$("$KDBCOMMAND" mount)

while read -r line;
do
	grep -Eq '(\s)*```sh$' <<<"$line"
	if [ "$?" -eq 0 ];
	then
		INBLOCK=1
		continue;
	fi
	grep -Eq '(\s)*```$' <<<"$line"
	if [ "$?" -eq 0 ];
	then
		INBLOCK=0
		continue
	fi
	if [ $INBLOCK -eq 0 ];
	then
		continue
	fi
	if [ -z "$BUF" ];
	then
		BUF="$line"
	else
		BUF=$(printf "%s\n%s" "${BUF}" "${line}")
	fi
done <<<"$BLOCKS"

translate

MOUNTPOINTS=$("$KDBCOMMAND" mount)

if [ "$MOUNTPOINTS_BACKUP" != "$MOUNTPOINT" ];
then
IFS='
'
	TOUMOUNT=$(diff <(echo "$MOUNTPOINTS_BACKUP") <(echo "$MOUNTPOINTS") | grep -Eo "^>.*")
	for line in $TOUMOUNT;
	do
		mp=$(sed -n 's/\(.*\)with name \(.*\)/\2/p' <<< "$line")
		"$KDBCOMMAND" umount "$mp"
	done
fi

exit "$SHELL_RECORDER_ERROR"
