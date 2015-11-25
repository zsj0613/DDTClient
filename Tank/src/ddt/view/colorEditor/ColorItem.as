package ddt.view.colorEditor
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.shopII.ColorOverAsset;
	import game.crazyTank.view.shopII.ColorSelectedAsset;
	
	import road.ui.controls.ISelectable;

	public class ColorItem extends Sprite implements ISelectable
	{
		private var _color:uint;
		private var _doClick:Function;
		private var _bg:ColorSelectedAsset;
		private var _selected:Boolean;
		private var _over:ColorOverAsset;
		
		public function ColorItem(color:uint,doclick:Function = null)
		{
			_doClick = doclick;
			_color = color;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			graphics.beginFill(_color,0);
			graphics.drawRect(2,3,14,15);
			graphics.endFill();
			
			_bg = new ColorSelectedAsset();
			addChild(_bg);
			_bg.visible = false;
			_selected = false;
			
			_over = new ColorOverAsset();
			_over.visible = false;
			_over.x = _over.y = 3;
			addChild(_over);
		}
		
		private function initEvent():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,__mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,__mouseOut);
		}
		
		private function removeEvents():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER,__mouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT,__mouseOut);
		}
		
		private function __mouseOver(evt:MouseEvent):void
		{
			_over.visible = true;
		}
		
		private function __mouseOut(evt:MouseEvent):void
		{
			_over.visible = false;
		}
			
		public function getColor():uint
		{
			return _color;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
			_bg.visible = value;
		}
		
		public function dispose():void
		{
			removeEvents();
			if(_bg.parent)
			{
				_bg.parent.removeChild(_bg);
			}
			if(_over.parent)
			{
				_over.parent.removeChild(_over);
			}
		}
		
	}
}