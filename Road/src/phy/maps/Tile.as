package phy.maps
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class Tile extends Bitmap
	{
		private var _digable:Boolean;
		
		public function Tile(bitmapData:BitmapData,digable:Boolean)
		{
			super(bitmapData);
			_digable = digable;
		}
	
		public function Dig(center:Point,surface:Sprite,border:Sprite = null):void
		{
			var matrix:Matrix = new Matrix(1,0,0,1,center.x,center.y);
			if(surface && _digable)
			{
				bitmapData.draw(surface,matrix,null,BlendMode.ERASE);
			}
			if(border && (_digable || border.blendMode == BlendMode.NORMAL))
			{
				var tb:BitmapData = new BitmapData(border.width,border.height,true,0);
				matrix.tx = border.width /2;
				matrix.ty = border.height /2;
				tb.draw(border,matrix);
				matrix.tx = - center.x + border.width/2;
				matrix.ty = - center.y + border.height/2;
				tb.draw(this,matrix,null,BlendMode.ALPHA);
				matrix.tx = center.x - border.width/2;
				matrix.ty = center.y - border.height/2;
				bitmapData.draw(tb,matrix,null,border.blendMode);
			}
		}
		
		public function GetAlpha(x:int,y:int):uint
		{
			return bitmapData.getPixel32(x,y) >> 24 & 0xFF;
		}
		
		public function dispose():void
		{
			bitmapData.dispose();
		}
		
	}
}