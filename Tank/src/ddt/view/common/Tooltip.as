package ddt.view.common
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import road.ui.manager.TipManager;
	public class Tooltip extends Sprite
	{
		private static  var _tooltip:Tooltip
		private var bg:Sprite;
		private var tf:TextField;
		private static const tipRadies:uint = 5;
		public function Tooltip()
		{
			super();
			drawShap();
			addText();
//			this.alpha = 0;
//			this.visible = false;
		}
		private function drawShap():void
		{
			bg = new Sprite();
			var max:Matrix = new Matrix();
			max.createGradientBox(100,30,90,0,0);
			//bg.graphics.lineStyle(2,0xB3B3B3,1);
			bg.graphics.lineStyle(2,0xae0005,1);
			bg.graphics.beginGradientFill(GradientType.LINEAR,[0xffffff,0xe0e0e0],[1,1],[0, 255],max);
			bg.graphics.drawRoundRectComplex(0,0,100,30,tipRadies,tipRadies,tipRadies,tipRadies);
			bg.graphics.endFill();
			
			bg.scale9Grid = new Rectangle(tipRadies,tipRadies,100-(tipRadies*2),30-(tipRadies*2));
			addChild(bg);
		}
		private function addText():void
		{
			tf = new TextField;
			tf.autoSize = "left";
			tf.text = "tipssss";
			tf.textColor = 0x676767;
			tf.x = 5;
			tf.y = 5;
			addChild(tf);
		}
		
		public static function get Instance ():Tooltip
		{
			if(_tooltip == null)
			{
				_tooltip = new Tooltip();
			}
			return _tooltip;
		}
		
		public function refresh (tar:DisplayObject,msg:String):void
		{
			tf.text = msg;
			bg.width = tf.width+(tipRadies*2);
		}
		
		
		public function show ():void
		{
			TipManager.AddTippanel(_tooltip);
		}
		
		public function hide ():void
		{
			TipManager.RemoveTippanel(_tooltip);
		}
		
	}
}