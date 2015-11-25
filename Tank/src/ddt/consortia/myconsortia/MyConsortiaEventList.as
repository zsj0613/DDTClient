package ddt.consortia.myconsortia
{
	import flash.display.Sprite;
	
	import road.ui.controls.SimpleGrid;
	
	import ddt.consortia.ConsortiaModel;
	import ddt.consortia.event.ConsortiaDataEvent;
	import ddt.view.common.MyConsortiaEventItem;

	public class MyConsortiaEventList extends Sprite
	{
		private var _list    : SimpleGrid;
		private var _items   : Array;
		private var _model   : ConsortiaModel;
		public function MyConsortiaEventList(model : ConsortiaModel)
		{
			this._model = model;
			super();
			init();
			addEvent();
		}
		private function init() : void
		{
			_list = new SimpleGrid(225,50,1);
			_list.setSize(247,208);
			_list.horizontalScrollPolicy = "off";
			_list.verticalScrollPolicy   = "on";
			addChild(_list);
			_list.y = 2;
			_items = new Array();
			
		}
		private function addEvent() : void
		{
			_model.addEventListener(ConsortiaDataEvent.CONSORTIA_EVENT_LIST_CHANGE, __upConsortiaEventListHandler);
		}
		public function __upConsortiaEventListHandler(evt : ConsortiaDataEvent) : void
		{
			clearList();
			var $list : Array = _model.consortiaEventList;
			for(var i:int=0;i<$list.length;i++)
			{
				var item : MyConsortiaEventItem = new MyConsortiaEventItem();
				item.info = $list[i];
				_items.push(item);
				_list.appendItem(item);
			}
		}
		private function clearList() : void
		{
			for(var i:int=0;i<_items.length;i++)
			{
				var item : MyConsortiaEventItem = _items[i] as MyConsortiaEventItem;
				_list.removeItem(item);
				item.dispose();
				
			}
			_items = new Array();
		}
		public function dispose() : void
		{
			clearList();
			_model.removeEventListener(ConsortiaDataEvent.CONSORTIA_EVENT_LIST_CHANGE, __upConsortiaEventListHandler);
			_list = null;
			_items  = null;
			if(this.parent)this.parent.removeChild(this);
		}
	}
}