/**
 * @file
 *
 * @brief
 *
 * @copyright BSD License (see LICENSE.md or https://www.libelektra.org)
 */

#include <sys/utsname.h>

int main ()
{
	struct utsname buf;

	uname (&buf);
	(void)buf.sysname;
	(void)buf.nodename;
	(void)buf.release;
	(void)buf.version;
	(void)buf.machine;

	return 0;
}
