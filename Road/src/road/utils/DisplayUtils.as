package road.utils
{
	import road.geom.InnerRectangle;
	import road.toplevel.StageReferance;
	import road.ui.Component;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * 
	 * @author Herman
	 * 
	 */	
	public final class DisplayUtils
	{
		
		/**
		 * 
		 * @param $width 矩形的宽
		 * @param $height 矩形的高
		 * @param target : 绘制矩形的shape
		 * @return 创建完成的shape
		 * 
		 */		
		public static function drawRectShape($width:Number,$height:Number,target:Shape = null):Shape
		{
			var sp:Shape;
			if(target == null)
			{
				sp = new Shape();
			}else
			{
				sp = target;
			}
			sp.graphics.clear();
			sp.graphics.beginFill(0xFF0000,1);
			sp.graphics.drawRect(0,0,$width,$height);
			sp.graphics.endFill();
			return sp;
		}
		/**
		 * 绘制文本的shape
		 * @param 目标文本框
		 * @return 文本的shape
		 * 
		 */		
		public static function drawTextShape(sourceTextField:TextField):DisplayObject
		{
			var textBitmapData:BitmapData = new BitmapData(sourceTextField.width,sourceTextField.height,true,0xff0000);
			textBitmapData.draw(sourceTextField);
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
		/**
		 * 检查点是否在显示范围之内
		 * @param point : 需要检查的点
		 * @param parent : 此点所参考的父级，如果为stage可以不传
		 * @return point是否在显示范围之内
		 * 
		 */		
		public static function isInTheStage(point:Point,parent:DisplayObjectContainer = null):Boolean
		{
			var stagePoint:Point = point;
			if(parent)
			{
				stagePoint = parent.localToGlobal(point);
			}
			if(stagePoint.x < 0 || stagePoint.y < 0 || stagePoint.x > StageReferance.stageWidth || stagePoint.y > StageReferance.stageHeight) 
			{
				return false;
			}
			return true;
		}
		
		public static function layoutDisplayWithInnerRect(com:DisplayObject,innerRect:InnerRectangle,width:int,height:int):void
		{
			if(com is Component)Component(com).beginChanges();
			var rect:Rectangle = innerRect.getInnerRect(width,height);
			com.x = rect.x;
			com.y = rect.y;
			com.width = rect.width;
			com.height = rect.height;
			if(com is Component)Component(com).commitChanges();
		}
		
		public function DisplayUtils()
		{
		}
	}
}