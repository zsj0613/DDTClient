package road.loader
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLVariables;

	public class TextLoader extends BaseLoader
	{
		public static var TextLoaderKey:String;
		public function TextLoader(id:int,url:String,args:URLVariables = null)
		{
			super(id,url,args);
		}
		
		override public function get content():*
		{
			return _loader.data;
		}
		
		override protected function getLoadDataFormat():String
		{
			return URLLoaderDataFormat.TEXT;
		}
		
		override public function get type():int
		{
			return BaseLoader.TEXT_LOADER;
		}
	}
}