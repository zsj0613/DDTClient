package ddt.register.uicontrol
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import road.ui.accect.LabelButtonAccect;

	public class HLabelButton extends HBaseButton
	{
		private var _bgBitmap:Bitmap;
		private var _bgBitmapData:Sprite;
		public function HLabelButton()
		{
			creatBg();
			super(_bgBitmapData, "y");
		}

		private function creatBg():void
		{
			_bgBitmapData = new LabelButtonAccect();
			var rt:Rectangle = new Rectangle();
			rt.left = 22;
			rt.right = 50;
			rt.top = 7;
			rt.bottom = 22;
			_bgBitmapData.scale9Grid = rt;
		}
		
		override public function set label(s:String):void
		{
			super.label = s;
			width = textField.width+40;
		}
		
		override public function dispose():void
		{
			super.dispose();
			_bgBitmapData = null;
		}
		
	}
}