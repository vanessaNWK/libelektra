/**
 * @file this file contains the entry point to the plugin as a gateway between c and c++
 *
 * @brief Plugin enables storage to xml files via the Xerces library
 *
 * @copyright BSD License (see LICENSE.md or https://www.libelektra.org)
 */

#include "xerces.hpp"
#include "deserializer.hpp"
#include "serializer.hpp"
#include "util.hpp"

#include <xercesc/dom/DOM.hpp>
#include <xercesc/util/OutOfMemoryException.hpp>
#include <xercesc/util/PlatformUtils.hpp>

using namespace ckdb; // required for kdberrors.h
using namespace xerces;

#include <kdberrors.h>
#include <kdbhelper.h>

XERCES_CPP_NAMESPACE_USE

int elektraXercesOpen (Plugin * handle ELEKTRA_UNUSED, Key * errorKey ELEKTRA_UNUSED)
{
	XMLPlatformUtils::Initialize ();
	return 1;
}

int elektraXercesClose (Plugin * handle ELEKTRA_UNUSED, Key * errorKey ELEKTRA_UNUSED)
{
	XMLPlatformUtils::Terminate ();
	return 1;
}

int elektraXercesGet (Plugin * handle ELEKTRA_UNUSED, KeySet * returned, Key * parentKey)
{
	if (!elektraStrCmp (keyName (parentKey), "system/elektra/modules/xerces"))
	{
		KeySet * contract =
			ksNew (30, keyNew ("system/elektra/modules/xerces", KEY_VALUE, "xerces plugin waits for your orders", KEY_END),
			       keyNew ("system/elektra/modules/xerces/exports", KEY_END),
			       keyNew ("system/elektra/modules/xerces/exports/open", KEY_FUNC, elektraXercesOpen, KEY_END),
			       keyNew ("system/elektra/modules/xerces/exports/close", KEY_FUNC, elektraXercesClose, KEY_END),
			       keyNew ("system/elektra/modules/xerces/exports/get", KEY_FUNC, elektraXercesGet, KEY_END),
			       keyNew ("system/elektra/modules/xerces/exports/set", KEY_FUNC, elektraXercesSet, KEY_END),
			       keyNew ("system/elektra/modules/xerces/exports/error", KEY_FUNC, elektraXercesError, KEY_END),
			       keyNew ("system/elektra/modules/xerces/exports/checkconf", KEY_FUNC, elektraXercesCheckConfig, KEY_END),
#include ELEKTRA_README (xerces)
			       keyNew ("system/elektra/modules/xerces/infos/version", KEY_VALUE, PLUGINVERSION, KEY_END), KS_END);
		ksAppend (returned, contract);
		ksDel (contract);

		return 1;
	}

	kdb::KeySet ks (returned);
	kdb::Key k (parentKey);
	int ret = 0;
	// Bridge the C++ exceptions to elektra error messages
	try
	{
		deserialize (k, ks);
		ret = 1;
	}
	catch (const OutOfMemoryException & e)
	{
		ELEKTRA_SET_ERROR (174, parentKey, asCStr (e.getMessage ()));
	}
	catch (const XMLException & e)
	{
		ELEKTRA_SET_ERROR (174, parentKey, asCStr (e.getMessage ()));
	}
	catch (const DOMException & e)
	{
		ELEKTRA_SET_ERROR (174, parentKey, asCStr (e.getMessage ()));
	}
	catch (const XercesPluginException & e)
	{
		ELEKTRA_SET_ERROR (174, parentKey, e.what ());
	}
	catch (...)
	{
		ELEKTRA_SET_ERROR (174, parentKey, "Unknown exception occurred while reading xml file");
	}

	// Avoid destruction of the pointers at the end
	k.release ();
	ks.release ();
	return ret;
}

int elektraXercesSet (Plugin * handle ELEKTRA_UNUSED, KeySet * returned, Key * parentKey)
{
	// Bridge the C++ exceptions to elektra error messages
	kdb::KeySet ks (returned);
	kdb::Key k (parentKey);
	int ret = 0;
	try
	{
		serialize (k, ks);
		ret = 1;
	}
	catch (const OutOfMemoryException & e)
	{
		ELEKTRA_SET_ERROR (174, parentKey, asCStr (e.getMessage ()));
	}
	catch (const XMLException & e)
	{
		ELEKTRA_SET_ERROR (174, parentKey, asCStr (e.getMessage ()));
	}
	catch (const DOMException & e)
	{
		ELEKTRA_SET_ERROR (174, parentKey, asCStr (e.getMessage ()));
	}
	catch (const XercesPluginException & e)
	{
		ELEKTRA_SET_ERROR (174, parentKey, e.what ());
	}
	catch (...)
	{
		ELEKTRA_SET_ERROR (174, parentKey, "Unknown exception occurred while writing xml file");
	}

	// Avoid destruction of the pointers at the end
	k.release ();
	ks.release ();
	return ret;
}

int elektraXercesError (Plugin * handle ELEKTRA_UNUSED, KeySet * returned ELEKTRA_UNUSED, Key * parentKey ELEKTRA_UNUSED)
{
	// handle errors (commit failed)
	// this function is optional

	return 1; // success
}

int elektraXercesCheckConfig (Key * errorKey ELEKTRA_UNUSED, KeySet * conf ELEKTRA_UNUSED)
{
	// validate plugin configuration
	// this function is optional

	// the return codes have the following meaning:
	// 0: The configuration was OK and has not been changed
	// 1: The configuration has been changed and now it is OK
	// -1: The configuration was not OK and could not be fixed. An error has to be set to errorKey.
	return 0;
}

Plugin * ELEKTRA_PLUGIN_EXPORT (xerces)
{
	// clang-format off
	return elektraPluginExport("xerces",
		ELEKTRA_PLUGIN_OPEN,  &elektraXercesOpen,
		ELEKTRA_PLUGIN_CLOSE, &elektraXercesClose,
		ELEKTRA_PLUGIN_GET,   &elektraXercesGet,
		ELEKTRA_PLUGIN_SET,   &elektraXercesSet,
		ELEKTRA_PLUGIN_ERROR, &elektraXercesError,
		ELEKTRA_PLUGIN_END);
}
