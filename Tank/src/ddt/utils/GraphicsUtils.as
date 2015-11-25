package ddt.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class GraphicsUtils
	{
		/**
		 * 扇形 
		 * @param x
		 * @param y
		 * @param radius
		 * @param sAngle
		 * @param lAngle
		 * @return 
		 * 
		 */		
		public static function drawSector(x:Number, y:Number, radius:Number, sAngle:Number, lAngle:Number):Sprite
		{
			var sprite:Sprite = new Sprite();
    		var sx:Number = radius;
    		var sy:Number = 0;
    		if (sAngle != 0)
    		{
    	    	sx = Math.cos(sAngle * Math.PI/180) * radius;
    	    	sy = Math.sin(sAngle * Math.PI/180) * radius;
    		}
    		sprite.graphics.beginFill(0xffff00,1);
    		sprite.graphics.moveTo(x, y)
    		sprite.graphics.lineTo(x + sx, y - sy);
    		var a:Number=  lAngle * Math.PI / 180 / lAngle;
    		var cos:Number = Math.cos(a);
   			var sin:Number = Math.sin(a);
    		var b:Number = 0;
    		for (var i:Number = 0; i<lAngle; i++) 
    		{
    	    	var nx:Number = cos * sx - sin * sy;
    	    	var ny:Number = cos * sy + sin * sx;
    	    	sx = nx;
    	    	sy = ny;
   	 	    	sprite.graphics.lineTo(sx + x, -sy + y);
    		}
    		sprite.graphics.lineTo(x, y);
    		sprite.graphics.endFill();
    		return sprite;
		}
		
		public static function drawDisplayMask(source:DisplayObject):DisplayObject
		{
			var textBitmapData:BitmapData = new BitmapData(source.width,source.height,true,0xff0000);
			textBitmapData.draw(source);
			var textGraphics:Shape=new Shape();
			textGraphics.cacheAsBitmap = true;
			for (var i:uint=0; i<textBitmapData.width; i++) {
				for (var j:uint=0; j<textBitmapData.height; j++) {
					var col:uint=textBitmapData.getPixel32(i,j);
					var alphaChannel:uint = col >> 24 & 0xFF;
					var alphaValue:Number = alphaChannel/0xFF;
					if (col > 0) {
						textGraphics.graphics.beginFill(0x000000,alphaValue);
						textGraphics.graphics.drawCircle(i,j,1);
					}
				}
			}
			return textGraphics;
		}	
		
		public static function changeSectorAngle(sprite:Sprite,x:Number,y:Number,radius:Number,sAngle:Number,lAngle:Number):void
		{
			sprite.graphics.clear();
    		var sx:Number = radius;
    		var sy:Number = 0;
    		if (sAngle != 0)
    		{
    	    	sx = Math.cos(sAngle * Math.PI/180) * radius;
    	    	sy = Math.sin(sAngle * Math.PI/180) * radius;
    		}
    		sprite.graphics.beginFill(0xffff00,1);
    		sprite.graphics.moveTo(x, y)
    		sprite.graphics.lineTo(x + sx, y - sy);
    		var a:Number=  lAngle * Math.PI / 180 / lAngle;
    		var cos:Number = Math.cos(a);
   			var sin:Number = Math.sin(a);
    		var b:Number = 0;
    		for (var i:Number = 0; i<lAngle; i++) 
    		{
    	    	var nx:Number = cos * sx - sin * sy;
    	    	var ny:Number = cos * sy + sin * sx;
    	    	sx = nx;
    	    	sy = ny;
   	 	    	sprite.graphics.lineTo(sx + x, -sy + y);
    		}
    		sprite.graphics.lineTo(x, y);
    		sprite.graphics.endFill();
		}	
	}
}