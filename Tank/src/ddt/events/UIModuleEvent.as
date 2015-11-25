package ddt.events
{
	import road.loader.BaseLoader;
	
	import flash.events.Event;
	
	public class UIModuleEvent extends Event
	{
		public static const UI_MODULE_COMPLETE:String = "uiModuleComplete";
		public static const UI_MODULE_ERROR:String = "uiModuleError";
		public static const UI_MODULE_PROGRESS:String = "uiMoudleProgress";
		
		public var module:String;
		public var loader:BaseLoader;
		public function UIModuleEvent(type:String,module:String,loader:BaseLoader = null)
		{
			this.module = module;
			this.loader = loader;
			super(type);
		}
	}
}