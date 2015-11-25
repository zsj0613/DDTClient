package ddt.consortia.club
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import road.ui.controls.SimpleGrid;
	
	import ddt.consortia.ConsortiaControl;
	import ddt.consortia.ConsortiaModel;
	import ddt.consortia.event.ConsortiaDataEvent;

	public class ConsortiaRecordList extends Sprite
	{
		private var _list   : SimpleGrid;
		private var _items  : Array; 
		private var _contro : ConsortiaControl;
		private var _model  : ConsortiaModel;
		private var _defaultType : int=1;/*1是邀请记录，2是申请记录*/
		public function ConsortiaRecordList(model:ConsortiaModel,contro:ConsortiaControl)
		{
			super();
			this._contro = contro;
			this._model  = model;
			init();
			addEvent();
			
		}
		private function init() : void
		{
			_list = new SimpleGrid(422,29,1);
			_list.setSize(442,154);
			_list.horizontalScrollPolicy = "off";
			_list.verticalScrollPolicy   = "on";
			addChild(_list);
			_items = new Array();
			_contro.searchConsortiaApplyList();
		}
		private function addEvent() : void
		{
			_model.addEventListener(ConsortiaDataEvent.MY_CONSORTIA_AUDITING_APPLY_DATA_CHAGE,  __applyRecordChange);
			_model.addEventListener(ConsortiaDataEvent.CONSORTIA_INVITE_RECORD_CHANGE,          __inviteRecordChange);
			_model.addEventListener(ConsortiaDataEvent.DELETE_CONSORTIA_APPLY,                  __deleteRecordHandler);

		}
		private function removeEvent() : void
		{
			_model.removeEventListener(ConsortiaDataEvent.MY_CONSORTIA_AUDITING_APPLY_DATA_CHAGE,  __applyRecordChange);
			_model.removeEventListener(ConsortiaDataEvent.CONSORTIA_INVITE_RECORD_CHANGE,          __inviteRecordChange);
			_model.removeEventListener(ConsortiaDataEvent.DELETE_CONSORTIA_APPLY,                  __deleteRecordHandler);
		}
		/*外部调用，选择页面*/
		public function displayRecordType(type : int=1) : void
		{
			type == 2 ? __applyRecordChange(null) : __inviteRecordChange(null);
		}
		
		/*记录操作后删除*/
        private function __deleteRecordHandler(evt : ConsortiaDataEvent) : void
        {
        	var id : int = int(evt.data);
        	removeItem(id);
        }
		/*申请记录*/
		private function __applyRecordChange(evt : ConsortiaDataEvent) : void
		{
			if(_defaultType == 1)
			{
				_defaultType = 0;
				return;
			}
			clearList();
			if(_model.myConsortiaAuditingApplyData == null) return;
     		for(var i:int = 0;i<_model.myConsortiaAuditingApplyData.length;i++)
			{
				var item : ConsortiaRecordItem = new ConsortiaRecordItem(_contro);
				item.info = _model.myConsortiaAuditingApplyData[i];
				addItem(item);
				if(i % 2 != 0)item.gotoRecordTxtBg(false);
				item.type = "applyRecord";
			}
			this.dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.SELECT_RECORD_TYPE,2));
			
		}
		/*邀请记录*/
		private function __inviteRecordChange(evt : ConsortiaDataEvent) : void
		{
			clearList();
			for(var i:int = 0;i<_model.consortiaInventList.length;i++)
			{
				var item : ConsortiaRecordItem = new ConsortiaRecordItem(_contro);
				item.info = _model.consortiaInventList[i];
				addItem(item);
				if(i % 2 != 0)item.gotoRecordTxtBg(false);
				item.type = "inviteRecord";
			}
			this.dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.SELECT_RECORD_TYPE,1));
		}
		public function addItem(mc : DisplayObject) : void
		{
			_list.appendItem(mc);
			_items.push(mc);
		}
		public function removeItem(id : int) : void
		{
			for(var i:int =0;i<_items.length;i++)
			{
				var item : ConsortiaRecordItem = _items[i] as ConsortiaRecordItem;
				if(id == item.info.ID)
				{
					_list.removeItem(_items[i]);
					_items[i].dispose();
					_items.splice(i,1);
					break;
				}
			}
			gotoFrames();
		}
		private function gotoFrames() : void
		{
			for(var i:int=0;i<_items.length;i++)
			{
				var item : ConsortiaRecordItem = _list.getItemAt(i) as ConsortiaRecordItem;
				if(i%2 == 0)item.applyRecordBg.gotoAndStop(1);
				else item.applyRecordBg.gotoAndStop(2);
			}
			
		}
		
		public function clearList() : void
		{
			for(var i:int =0;i<_items.length;i++)
			{
				_list.removeItem(_items[i]);
				_items[i].dispose();
			}
			_items = [];
		}
		
		public function dispose() : void
		{
			removeEvent();
			clearList();
			if(_list)_list.clearItems();
			if(_list.parent)_list.parent.removeChild(_list);
			_list = null;
			_items = null;
			if(this.parent)this.parent.removeChild(this);
		}
		
		
	}
}