package ddt.loader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import ddt.events.UIModuleEvent;
	import ddt.manager.PathManager;
	
	import road.loader.BaseLoader;
	import road.loader.LoaderEvent;
	import road.loader.LoaderManager;
	import road.loader.TextLoader;
	import road.ui.ComponentFactory;
	
	[Event(name="uiModuleComplete",type="ddt.events.UIModuleEvent")]
	public class UIModuleLoader extends EventDispatcher
	{
		public static const FONT:String = "font";
		public static const HALL:String = "hall";
		public static const SETTING:String = "setting";
		public static const VIP:String = "vip";
		
		private var _currentLoadingModule:String;
		
		public function UIModuleLoader(module:String)
		{
			_currentLoadingModule = module;
			loadNextModule();
		}
		
		
		
		private function __onConfigLoadComplete(event:LoaderEvent):void
		{
			event.loader.removeEventListener(LoaderEvent.COMPLETE,__onConfigLoadComplete);
			event.loader.removeEventListener(LoaderEvent.LOAD_ERROR,__onLoadError);
			if(event.loader.isSuccess)
			{
				var config:XML = new XML(event.loader.content);
				var resourcePath:String = config.child("module").child(_currentLoadingModule).attribute("value");	
				var uiResourceLoader:BaseLoader = LoaderManager.Instance.createLoader(PathManager.solveSWFPath()+resourcePath,BaseLoader.MODULE_LOADER);
				uiResourceLoader.loadErrorMessage = "加载ui资源："+uiResourceLoader.url+"出现错误";
				uiResourceLoader.addEventListener(LoaderEvent.LOAD_ERROR,__onLoadError);
				uiResourceLoader.addEventListener(LoaderEvent.PROGRESS,__onResourceProgress);
				uiResourceLoader.addEventListener(LoaderEvent.COMPLETE,__onResourceComplete);
				LoaderManager.Instance.startLoad(uiResourceLoader);
			}
		}
		
		private function __onResourceComplete(event:LoaderEvent):void
		{
			event.loader.removeEventListener(LoaderEvent.LOAD_ERROR,__onLoadError);
			event.loader.removeEventListener(LoaderEvent.PROGRESS,__onResourceProgress);
			event.loader.removeEventListener(LoaderEvent.COMPLETE,__onResourceComplete);
			dispatchEvent(new UIModuleEvent(UIModuleEvent.UI_MODULE_COMPLETE,_currentLoadingModule,event.loader));
		}
		
		private function __onLoadError(event:LoaderEvent):void
		{
			dispatchEvent(new UIModuleEvent(UIModuleEvent.UI_MODULE_ERROR,_currentLoadingModule,event.loader));
		}
		
		private function __onResourceProgress(event:LoaderEvent):void
		{
			dispatchEvent(new UIModuleEvent(UIModuleEvent.UI_MODULE_PROGRESS,_currentLoadingModule,event.loader));
		}
		
		private function loadNextModule():void
		{
			var textLoader:BaseLoader = LoaderManager.Instance.createLoader("config.xml",BaseLoader.TEXT_LOADER);
			textLoader.addEventListener(LoaderEvent.COMPLETE,__onConfigLoadComplete);
			textLoader.addEventListener(LoaderEvent.LOAD_ERROR,__onLoadError);
			textLoader.loadErrorMessage = "加载UI配置文件"+textLoader.url+"出现错误";
			LoaderManager.Instance.startLoad(textLoader);
		}
	}
}