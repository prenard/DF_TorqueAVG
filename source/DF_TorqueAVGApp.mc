// History:
//
// 2017-12-28: Version 1.06
//
//		* CIQ 2.41 to support Edge 1030
//      * 1030 support
//

using Toybox.Application as App;

var AppVersion="1.07-03";

class DF_TorqueAVGApp extends App.AppBase
{
    function initialize()
    {
        AppBase.initialize();
    }

    //! onStart() is called on application start up
    function onStart(state)
    {
    }

    //! onStop() is called when your application is exiting
    function onStop(state)
    {
    }

    //! Return the initial view of your application here
    function getInitialView()
    {

		System.println("AppVersion = " + AppVersion);
		setProperty("App_Version", AppVersion);

		var Args = new [1];

		Args[0] = readPropertyKeyInt("AVG_Duration",3);
		
        return [ new DF_TorqueAVGView(Args) ];

    }

	function readPropertyKeyInt(key,thisDefault)
	{
		var value = getProperty(key);
        if(value == null || !(value instanceof Number))
        {
        	if(value != null)
        	{
            	value = value.toNumber();
        	}
        	else
        	{
                value = thisDefault;
        	}
		}
		return value;
	}

}