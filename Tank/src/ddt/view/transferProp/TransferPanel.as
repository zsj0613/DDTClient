package ddt.view.transferProp
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import road.ui.controls.hframe.HFrame;
	
	/**
	 * @author wicki LA
	 * @time 11/26/2009
	 * @description 转换面板
	 * */

	public class TransferPanel extends HFrame
	{
		private var _bg:PropTransferBG;
		
		public function TransferPanel(propPlace:int)
		{
			super();
			_bg = new PropTransferBG(propPlace);
			init();
		}
		
		private function init():void
		{
			showBottom = false;
			showClose = true;
			
			setSize(785,445);
			addContent(_bg,true);
			_bg.x = 10;
			_bg.y = 25;
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
		}
		
		override protected function __closeClick(e:MouseEvent):void
		{
			super.__closeClick(e);
			_bg.dispose();
		}
		
		override protected function __addToStage(e:Event):void
		{
			addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			super.__addToStage(e);
			blackGound = true;
		}
		
		override protected function __removeToStage(e:Event):void
		{
			blackGound = false;
			super.__removeToStage(e);
		}
		
		private function onKeyDown(evt:KeyboardEvent):void
		{
			if(evt.keyCode == Keyboard.ESCAPE)
			{
				evt.stopImmediatePropagation();
				removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
				__closeClick(null);
			}
		}
		
		override public function dispose():void
		{
			removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			_bg.dispose();
			_bg = null;
			super.dispose();
		}
		
	}
}