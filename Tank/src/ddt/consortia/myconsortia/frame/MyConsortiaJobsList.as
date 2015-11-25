package ddt.consortia.myconsortia.frame
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import road.ui.controls.SimpleGrid;
	
	import ddt.consortia.event.ConsortiaDataEvent;

	public class MyConsortiaJobsList extends Sprite
	{
		private var _list : SimpleGrid;
		private var _items : Array;
		private var _current : MyConsortiaJobItem;
		public function MyConsortiaJobsList()
		{
			super();
			init();
		}
		private function init() : void
		{
			_list = new SimpleGrid(155,38,1);
			_list.horizontalScrollPolicy = ScrollPolicy.OFF;
			_list.verticalScrollPolicy   = ScrollPolicy.OFF;
			_list.setSize(175,200);
			addChild(_list);
			
			_items = new Array();
			this.addEventListener(Event.ADDED_TO_STAGE ,  __addStageHandler);
		}
		public function set info($list : Array) : void
		{
			clearList();
			var name : Array = new Array();
			for(var j:int=0;j<$list.length;j++)
			name.push($list[j]["DutyName"]);
			for(var i:int=0;i<$list.length;i++)
			{
				var item : MyConsortiaJobItem = new MyConsortiaJobItem();
				item.addEventListener(ConsortiaDataEvent.SELECT_CLICK_ITEM, __currentItemHandler);
				item.info = $list[i];
				_list.appendItem(item);
				item.nameItems = name;
				_items.push(item);
				if(item.info.Level == 1)
				{
					_defaultItem = item;
				}
				
			}
			__addStageHandler(null);
		}
		private var _defaultItem : MyConsortiaJobItem;
		private function __addStageHandler(evt:Event ) : void
		{
			if(_defaultItem)_defaultItem.selectItem();
		}
		private function clearList() : void
		{
			for(var i: int=0;i<_items.length;i++)
			{
				var item : MyConsortiaJobItem = _items[i] as  MyConsortiaJobItem;
				item.removeEventListener(ConsortiaDataEvent.SELECT_CLICK_ITEM, __currentItemHandler)
				_list.removeItem(item);
				item.dispose();
			}
			_items = [];
			_current = null;
		}
		public function hideRightsFrams() : void
		{
			if(_current)_current.defaultStatus();
		}
		private function __currentItemHandler(evt : ConsortiaDataEvent) : void
		{
			var item : MyConsortiaJobItem = evt.data as MyConsortiaJobItem;
			if(_current && _current != item )_current.defaultStatus();
			this._current = item;
			this.dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.SELECT_CLICK_ITEM,_current));
		}
		public function dispose() : void
		{
			clearList();
			this.removeChild(_list);
			this.removeEventListener(Event.ADDED_TO_STAGE ,  __addStageHandler);
			if(this.parent)this.parent.removeChild(this);
		}
		public function get currentItem() : MyConsortiaJobItem
		{
			return this._current;
		}
	}
}