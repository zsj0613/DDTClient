package road.BitmapUtil
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	public class BitmapReader extends EventDispatcher
	{
		private var loader:Loader;
		public var bitmap:Bitmap;
		[Event(name="complete",type="flash.events.Event")]
		public function BitmapReader()
		{
			
		}
		public function readByteArray(ba:ByteArray):void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,dataComplete);
			loader.loadBytes(ba);
		}
		
		public function dataComplete(e:Event):void
		{
			bitmap = e.target.content;
			dispatchEvent(new Event(Event.COMPLETE));
		}

	}
}