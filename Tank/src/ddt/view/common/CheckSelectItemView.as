package ddt.view.common
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import game.crazyTank.view.common.CheckCodeSelectItemAccect;

	public class CheckSelectItemView extends CheckCodeSelectItemAccect
	{
		private var txtPos:Point;
		private var textContainer:Sprite;
		public function CheckSelectItemView()
		{
			super();
			txtPos = new Point(txt.x,txt.y);
			removeChild(txt);
			txt.mouseEnabled = false;
			txt.selectable = false;
			over_mc.visible = false;
			
			this.buttonMode = true;
			
			addEventListener(MouseEvent.CLICK,__clickHandler);
			addEventListener(MouseEvent.ROLL_OVER,__overHandler);
			addEventListener(MouseEvent.ROLL_OUT,__outHandler);
			
			textContainer = new Sprite();
			addChild(textContainer);
		}
		public var index:int = 0;
		private var _selected:Boolean = false;
		public function set selected (b:Boolean):void
		{
			_selected = b;
			if(_selected)
			{
				over_mc.visible = true;
			}else
			{
				over_mc.visible = false;
			}
		}
		
		public function get selected ():Boolean
		{
			return _selected
		}
		
		private function __overHandler(e:MouseEvent):void
		{
			if(!_selected)
			{
				over_mc.visible = true;
			}
		}
		
		private function __outHandler(e:MouseEvent):void
		{
			if(!_selected)
			{
				over_mc.visible = false;
			}
		}
		
		private function __clickHandler(e:MouseEvent):void
		{
			if(_selected)
			{
				e.stopImmediatePropagation();
			}
		}
		
		public function set text (s:String):void
		{
			txt.text = s;
			clearnTextBitmap();
			drawTextBitmap();
		}
		
		private function drawTextBitmap():void
		{
			txt.x = 0;
			txt.y = 0;
			var tempSprite:Sprite = new Sprite();
			tempSprite.addChild(txt);
			var bmd:BitmapData = new BitmapData(tempSprite.width,tempSprite.height,true,0xffffff);
			bmd.draw(tempSprite);
			var bm:Bitmap = new Bitmap(bmd);
			bm.x = txtPos.x;
			bm.y = txtPos.y;
			textContainer.addChild(bm);
		}
		
		private function clearnTextBitmap():void
		{
			while(textContainer.numChildren >0)
			{
				textContainer.removeChildAt(0);
			}
		}
	}
}