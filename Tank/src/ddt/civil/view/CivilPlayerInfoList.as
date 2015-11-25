package ddt.civil.view
{
	import ddt.civil.CivilDataEvent;
	import ddt.civil.CivilModel;
	
	import flash.display.Sprite;
	
	import road.ui.controls.SimpleGrid;
	
	import ddt.data.player.CivilPlayerInfo;
	
	public class CivilPlayerInfoList extends Sprite
	{
		private var _list:SimpleGrid;
		private var _currentItem:CivilPlayerItemFrame;
		private var _infoItems:Array;
		
		private var _model: CivilModel;
		
		public function CivilPlayerInfoList($_model : CivilModel)
		{
			_model  = $_model;
			init();
			addEvent();
		}
		private function init():void
		{
			_list = new SimpleGrid(418,24,1);
			_list.horizontalScrollPolicy = "off";
			_list.verticalScrollPolicy = "off";
			_list.setSize(418,316);
			addChild(_list);
			_infoItems = [];
		}
		
		public function set MemberList($list:Array):void
		{
			clearList();
			var count:int = $list.length;
			count = count < 12 ? 12 : count;
			for(var i:int=0;i<count;i++)
			{
				var item:CivilPlayerItemFrame = new CivilPlayerItemFrame();
				item.addEventListener(CivilDataEvent.SELECT_CLICK_ITEM,__selectItemHandler);
				
				if($list[i])item.info = $list[i];
				_list.appendItem(item);
				if(item.info)_infoItems.push(item);
				
			}
		}
		public function clearList() : void
		{
			for(var i:int=0;i<_infoItems.length;i++)
			{
				_list.items[i].removeEventListener(CivilDataEvent.SELECT_CLICK_ITEM,__selectItemHandler);
				_list.items[i].dispose();
			}
			_list.clearItems();
			_infoItems = [];
		}
		public function upItem($info:CivilPlayerInfo):void
		{
			for(var i:int=0;i<_infoItems.length;i++)
			{
				var item : CivilPlayerItemFrame = _infoItems[i] as CivilPlayerItemFrame;
				if(item.info.info.ID == $info.info.ID)
				{
					item.info = $info;
					break;
				}
			}
		}
		
		private function addEvent():void
		{
			_model.addEventListener(CivilDataEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE,__civilListHandle);
		}
		private function removeEvent():void
		{
			_model.removeEventListener(CivilDataEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE,__civilListHandle);
		}
		
		private function __civilListHandle(e:CivilDataEvent):void
		{
			if(_model.civilPlayers == null) return;
			clearList();
			var data : Array = _model.civilPlayers;
			var length : int = data.length;
			length = (length >12 ? 12 : length);
			for(var i:int = 0;i<length;i++)
			{
				var item : CivilPlayerItemFrame = new CivilPlayerItemFrame();
				item.info = data[i];
				_list.appendItem(item);
				_infoItems.push(item)
				
				if(i == 0)
				{
					_currentItem = item;
					_currentItem.isSelect(true);
					_model.currentcivilItemInfo = _currentItem.info;
				}
				
				item.addEventListener(CivilDataEvent.SELECT_CLICK_ITEM,__selectItemHandler);
			}
		}
		
		private var temp:int;
		private function __selectItemHandler(e:CivilDataEvent):void
		{
			if(_currentItem)_currentItem.isSelect(false);
			_currentItem = e.data as CivilPlayerItemFrame;
			if(_currentItem.info == _model.currentcivilItemInfo)
			{
				temp +=1;
				if(temp > 1)
				{
					_currentItem.isSelect(true);
					temp = 0;
				}
				return;
			}
			_currentItem.isSelect(true);
			_model.currentcivilItemInfo = _currentItem.info;
		}
		public function dispose():void
		{
			removeEvent();
			clearList();
			if(_currentItem)
			{
				_currentItem.dispose();
			}
			_currentItem = null;
			_model = null;
			_infoItems = null;
			if(parent)parent.removeChild(this);
		}
		
	}
}