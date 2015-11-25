package road.loader
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.net.URLVariables;
	public class BitmapLoader extends DisplayLoader
	{
		public function BitmapLoader(id:int,url:String)
		{
			super(id,url);
		}

		private var _sourceBitmap:Bitmap;
		
		override public function get content():*
		{
			if(_sourceBitmap == null)return null;
			var bData:BitmapData = _sourceBitmap.bitmapData.clone();
			return new Bitmap(bData);
		}
		
		override protected function __onContentLoadComplete(event:Event):void
		{
			_sourceBitmap = _displayLoader.content as Bitmap;
			super.__onContentLoadComplete(event);
		}
		
		override public function get type():int
		{
			return BaseLoader.BITMAP_LOADER;
		}
	}
}