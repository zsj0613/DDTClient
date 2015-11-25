package ddt.loader
{

	import flash.events.EventDispatcher;
	
	import ddt.events.StartupEvent;
	import ddt.events.UIModuleEvent;
	import ddt.manager.PathManager;
	import ddt.utils.LeavePage;
	
	import road.loader.LoaderEvent;
	import road.loader.QueueLoader;
	import road.ui.controls.hframe.HAlertDialog;
	
	public class StartupResourceLoader extends EventDispatcher
	{

		private var _loaderQueue:QueueLoader;
		public function StartupResourceLoader()
		{
		}
		
		private static var _instance:StartupResourceLoader;
		public static function get Instance():StartupResourceLoader
		{
			if(_instance == null)
			{
				_instance = new StartupResourceLoader();
			}
			return _instance;
		}
		
		public function start():void
		{
			new UIModuleLoader(Modules[0]).addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__onUIMoudleComplete);
		}
		private static var Modules:Array=[UIModuleLoader.HALL,UIModuleLoader.FONT,UIModuleLoader.SETTING];
		private var count:int = 0;
		private function __onUIMoudleComplete(event:UIModuleEvent):void
		{
			count++;
			if(count>=Modules.length)
			{
		    	dispatchEvent(new StartupEvent(StartupEvent.CORE_LOAD_COMPLETE));
			}
			else
			{
				new UIModuleLoader(Modules[count]).addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__onUIMoudleComplete);
			}
		}
		private function __onLoadError(event:LoaderEvent):void
		{
			var msg:String = event.loader.loadErrorMessage;
			if(event.loader.analyzer)msg = event.loader.loadErrorMessage +"\n"+event.loader.analyzer.message;
			HAlertDialog.show("警告：",event.loader.loadErrorMessage,true,__onAlertResponse,false,null,__onAlertResponse);
		}
		
		private function __onAlertResponse():void
		{
			LeavePage.LeavePageTo(PathManager.solveLogin(),"_self");
		}
		
	}
}