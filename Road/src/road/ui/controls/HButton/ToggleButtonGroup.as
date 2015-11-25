package road.ui.controls.HButton
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ToggleButtonGroup extends Sprite
	{
		private var _items:Array;
		private var _canSelectCount:int;
		public function ToggleButtonGroup(canSelectCount:int = 1)
		{
			_canSelectCount = canSelectCount;
			_items = [];
		}
		
		public function addItem(item:TogleButton):void
		{
			if(item == null) return;
			item.addEventListener(MouseEvent.CLICK,__clickHandler);
			item.addEventListener(Event.SELECT,__selectedChangeHandler);
			_items.push(item);
			tryUnselecteLast();
			if(item.selected)_lastSelectedItem = item;
		}
		
		private function __clickHandler(event:MouseEvent):void
		{
			event.currentTarget.selected = true;
		}
		
		
		private var _lastSelectedItem:TogleButton;
		private function __selectedChangeHandler(event:Event):void
		{
			tryUnselecteLast();
			_lastSelectedItem = event.currentTarget as TogleButton;
		}
		
		public function getCurrentSelectedCount():int
		{
			var count:int = 0;
			for(var i:int = 0;i<_items.length;i++)
			{
				if(_items[i].selected == true)
				{
					count++;
				}
			}
			return count;
		}
		
		private function tryUnselecteLast():void
		{
			if(_lastSelectedItem && getCurrentSelectedCount() > _canSelectCount)
			{
				_lastSelectedItem.selected = false;
			}
		}
		
		public function dispose():void
		{
			
		}
	}
}