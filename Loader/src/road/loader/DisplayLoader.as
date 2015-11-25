package road.loader
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	public class DisplayLoader extends BaseLoader
	{
		public static var Context:LoaderContext;
		
		public function DisplayLoader(id:int,url:String)
		{
			_displayLoader = new Loader();
			super(id,url,args);
		}
		override public function get content():*
		{
			return _displayLoader.content;
		}
		
		
		
		public var _displayLoader:Loader;
		
		override public function loadFromLocal(data:ByteArray):void
		{
			_displayLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,__onContentLoadComplete);
			_displayLoader.loadBytes(data,Context);
		}
		
		protected function __onContentLoadComplete(event:Event):void
		{
			_displayLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,__onContentLoadComplete);
			fireComplete();
		}
		
		override protected function __onDataLoadComplete(event:Event):void
		{
			removeEvent();
			_loader.close();
			_displayLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,__onContentLoadComplete);
			if(_loader.data.length == 0)return;
			LoaderSavingManager.cacheFile(_url,_loader.data,false);
			_displayLoader.loadBytes(_loader.data,Context);
		}

		
		override protected function getLoadDataFormat():String
		{
			return URLLoaderDataFormat.BINARY;
		}
		
		override public function get type():int
		{
			return BaseLoader.DISPLAY_LOADER;
		}
		override public function dispose():void
		{
			super.dispose();
		}
	}
}