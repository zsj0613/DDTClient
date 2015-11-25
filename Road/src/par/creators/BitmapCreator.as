package par.creators
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;

	public class BitmapCreator implements IParticalCreator
	{
		private var _bitmap:BitmapData
		public function BitmapCreator(bitmap:BitmapData)
		{
			_bitmap = bitmap;
		}

		public function createPartical():DisplayObject
		{
			var bitmap:Bitmap = new Bitmap(_bitmap.clone(),PixelSnapping.AUTO,true);
			bitmap.smoothing = true;
			bitmap.x = - bitmap.width /2;
			bitmap.y = - bitmap.height / 2;
			return bitmap;
		}
		
	}
}