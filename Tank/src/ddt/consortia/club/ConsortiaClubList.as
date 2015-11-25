package ddt.consortia.club
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	
	import ddt.consortia.ConsortiaModel;
	import ddt.consortia.data.ConsortiaApplyInfo;
	import ddt.consortia.event.ConsortiaDataEvent;

	
	public class ConsortiaClubList extends Sprite
	{
		private var _list        : SimpleGrid;
		private var _items       : Array;
		private var _currentInfo : ConsortiaItem;
		private var _model       : ConsortiaModel
		public function ConsortiaClubList(model : ConsortiaModel)
		{
			_model = model;
			init();
			addEvent();
		}
		private function init() : void
		{
			_list = new SimpleGrid(485,33,1);
			_list.setSize(485,210);
			addChild(_list);
			_list.horizontalScrollPolicy = ScrollPolicy.OFF;
			_list.verticalScrollPolicy   = ScrollPolicy.OFF;
			_items = new Array();
		}
		private function addEvent() : void
		{
			_model.addEventListener(ConsortiaDataEvent.CONSORTIA_LIST_CHANGE, __consortiaListHandler);
		}
		private function __consortiaListHandler(evt : ConsortiaDataEvent) : void
		{
			clearList();
			var data : Array = _model.consortiaList;
			var length : int = data.length;
			length = (length >6 ? 6 : length);
			for(var i:int = 0;i<length;i++)
			{
				var item : ConsortiaItem = new ConsortiaItem();
				item.info = data[i];
				_list.appendItem(item);
				_items.push(item)
				item.addEventListener(MouseEvent.CLICK, __itemClickHandler);
				isApply(item);
			}
		}
		/*该公会是否已经申请*/
		private function isApply(item : ConsortiaItem) : void
		{
			if(!item.info || !_model.myConsortiaAuditingApplyData)return;
			for(var i:int = 0;i<_model.myConsortiaAuditingApplyData.length;i++)
			{
				var applyInfo : ConsortiaApplyInfo = _model.myConsortiaAuditingApplyData[i] as ConsortiaApplyInfo;
				if(applyInfo.ConsortiaID == item.info.ConsortiaID)
				{
					item.status=false;
					break;
				}
			}
		}
		private function clearList() : void
		{
			for(var i:int=0;i<_items.length;i++)
			{
				var item : ConsortiaItem = _items[i] as ConsortiaItem;
				_list.removeItem(item);
				item.removeEventListener(MouseEvent.CLICK, __itemClickHandler);
				item.dispose();
			}
			_items = new Array();
		}
		private function __itemClickHandler(evt : MouseEvent) : void
		{
			if(!(evt.currentTarget as ConsortiaItem).isApply)
			{
				SoundManager.instance.play("008");
		    	if(_currentInfo)_currentInfo.selectStatus = false;
		    	_currentInfo = evt.target as ConsortiaItem;
			    _currentInfo.selectStatus = true;
		    	this.dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.SELECT_CLICK_ITEM));
			}
			
		}
		public function currentItemEmpty() : void
		{
			if(_currentInfo)_currentInfo.selectStatus = false;
			_currentInfo = null;
			this.dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.SELECT_CLICK_ITEM));
		}
		public function get currentSelectItem() : ConsortiaItem
		{
			return this._currentInfo;
		}
		
		public function dispose() : void
		{
			clearList();
			if(_list)_list.clearItems();
			if(_list && _list.parent)_list.parent.removeChild(_list);
			_list = null;
			_items = null;
			_currentInfo = null;
			_model.removeEventListener(ConsortiaDataEvent.CONSORTIA_LIST_CHANGE, __consortiaListHandler);
			if(this.parent)this.parent.removeChild(this);
		}

	}
}