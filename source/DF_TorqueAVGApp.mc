using Toybox.Application as App;

class DF_TorqueAVGApp extends App.AppBase {

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
		var D, T, V;
		
		D = getProperty("AVG_Duration");
		T  = getProperty("DF_Title");
		V  = getProperty("App_Version");

        return [ new DF_TorqueAVGView(D,T,V) ];
    }

}