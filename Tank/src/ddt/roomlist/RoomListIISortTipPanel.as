package ddt.roomlist
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.roomlistII.RoomListIITipBgAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	
	import ddt.game.map.MapSmallIcon;

	public class RoomListIISortTipPanel extends SimpleGrid
	{
		protected var _controller:IRoomListBGView;
		private var _bg:RoomListIITipBgAsset;
		protected var _data:Array;
		
		public function RoomListIISortTipPanel(controller:IRoomListBGView,data:Array)
		{
			_controller = controller;
			_data = data;
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			var temp:Sprite = new Sprite();
			temp.graphics.beginFill(0x000000,0);
			temp.graphics.drawRect(-3000,-3000,6000,6000);
			temp.graphics.endFill();
			addChildAt(temp,0);
			temp.addEventListener(MouseEvent.CLICK,__mouseClick);
			
			horizontalScrollPolicy = ScrollPolicy.OFF;
			
			_bg = new RoomListIITipBgAsset();
			addChildAt(_bg,0);
		}
		
		protected function __itemClick(evt:MouseEvent):void
		{
			_controller.closeSortTip();
			SoundManager.Instance.play("008");
		}
		private function __itemMouseOver(evt : MouseEvent) : void
		{
			var t : Sprite = evt.target as Sprite;
			t.graphics.beginFill(0xFFFFFF,.7);
			t.graphics.drawRect(0,0,130,26);
			t.graphics.endFill();
		}
		private function __itemMouseOut(evt : MouseEvent) : void
		{
			var t : Sprite = evt.target as Sprite;
			t.graphics.clear();
		}
		override public function set width(value:Number):void
		{
			super.width = value;
			_bg.width = value;
		}
		override public function set height(value:Number):void
		{
			super.height = value;
			_bg.height = value;
		}
		
		private function __mouseClick(evt:MouseEvent):void
		{
			visible = false;
		}
		
		public function dispose ():void
		{
			for(var i:int = 0;i<itemCount;i++)
			{
				items[i].dispose();
				items[i].removeEventListener(MouseEvent.CLICK,__itemClick);
				items[i].removeEventListener(MouseEvent.MOUSE_OVER, __itemMouseOver);
				items[i].removeEventListener(MouseEvent.MOUSE_OUT, __itemMouseOut);
			}
			clearItems();
			
			if(_bg && _bg.parent)
				_bg.parent.removeChild(_bg);
			_bg = null;
			
			_controller = null;
			_data = null;
			
			if(this.parent)
				this.parent.removeChild(this);
		}
		
		protected function createItem(data:*):Sprite
		{
			return new RoomListIITipItem(new MapSmallIcon(),data);
		}
	}
}