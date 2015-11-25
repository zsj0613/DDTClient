package ddt.consortia.consortiadiplomatism
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	
	import road.ui.controls.SimpleGrid;
	
	import ddt.consortia.event.ConsortiaDataEvent;

	public class ConsortiaInfoList extends Sprite
	{
		private var _list                : SimpleGrid;
		private var _items               : Array;
		private var _current             : ConsortiaInfoItem;
		public function ConsortiaInfoList()
		{
			super();
			init();
			addEvent();
		}
		
		private function init() : void
		{
			_list = new SimpleGrid(525,33,1);
			_list.horizontalScrollPolicy = ScrollPolicy.OFF;
			_list.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_list);
			_list.setSize(530,210);
			
			_items = new Array();
			
			
			
		}
		private function addEvent() : void
		{
			
		}
		
		private function __selectItemHandler(evt : ConsortiaDataEvent) : void
		{
			if(_current)_current.selectd = false;
			this._current = evt.data as ConsortiaInfoItem;
			_current.selectd = true;
			this.dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.SELECT_CLICK_ITEM,_current));
		}
		public function get currentItem() : ConsortiaInfoItem
		{
			return this._current;
		}
		public function currentItemEmpty() : void
		{
			if(_current)_current.selectd = false;
			this._current = null;
			this.dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.SELECT_CLICK_ITEM,_current));
		}
		public function infoList($list : Array) : void
		{
			clearList();
			for(var i:int=0;i<$list.length;i++)
			{
				var item : ConsortiaInfoItem = new ConsortiaInfoItem();
				item.addEventListener(ConsortiaDataEvent.SELECT_CLICK_ITEM, __selectItemHandler);
				item.info = $list[i];
				_list.appendItem(item);
				_items.push(item);
			}
		}
		public function removeItem(id : int) : void
		{
			for(var i:int=0;i<_items.length;i++)
			{
				var item : ConsortiaInfoItem = _items[i] as ConsortiaInfoItem; 
				if(item.info.ConsortiaID == id)
				{
					item.clearItem();
					break;
				}
			}
		}
		
		
		public function clearList() : void
		{
			for(var i:int=0;i<_items.length;i++)
			{
				var item : ConsortiaInfoItem = _items[i] as ConsortiaInfoItem;
				item.removeEventListener(ConsortiaDataEvent.SELECT_CLICK_ITEM, __selectItemHandler);
				_list.removeItem(item);
				item.dispose();
			}
			_items = new Array();
		}
		public function dispose() : void
		{
			clearList();
			_list.clearItems();
			this.removeChild(_list);
			_items = null;
		}
		
	}
}