package ddt.consortia.myconsortia
{
	import flash.events.MouseEvent;
	
	import road.data.DictionaryEvent;
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HTipButton;
	import road.ui.controls.SimpleGrid;
	
	import tank.consortia.accect.MyConsortiMemberGirdAsset;
	import ddt.consortia.event.ConsortiaDataEvent;
	import ddt.data.player.ConsortiaPlayerInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.menu.RightMenu;

	public class MyConsortiaMemberList extends MyConsortiMemberGirdAsset
	{
		private var _list        : SimpleGrid;
		private var _sortBtnItems: Array;
		private var _currentItem : MyConsortiaMemberInfoItem;
		private var _tipArr      : Array = [LanguageMgr.GetTranslation("ddt.consortia.myconsortia.MyConsortiaMemberList.tipArr.name"),LanguageMgr.GetTranslation("ddt.consortia.myconsortia.MyConsortiaMemberList.tipArr.duty"),LanguageMgr.GetTranslation("ddt.consortia.myconsortia.MyConsortiaMemberList.tipArr.level"),
		LanguageMgr.GetTranslation("ddt.consortia.myconsortia.MyConsortiaMemberList.tipArr.contribute"),LanguageMgr.GetTranslation("ddt.consortia.myconsortia.MyConsortiaMemberList.tipArr.battle"),LanguageMgr.GetTranslation("ddt.consortia.myconsortia.MyConsortiaMemberList.tipArr.time")];
		private var _infoItems   : Array;
		private var _lastSort    : String = "";
		public function MyConsortiaMemberList()
		{
			super();
			init();
			addEvent();
		}
		private function init() : void
		{
			_list = new SimpleGrid(655,33.5,1);
			_list.horizontalScrollPolicy = "off";
			_list.verticalScrollPolicy = "on";
			_list.setSize(665,212);
			addChild(_list);
			_list.x = listPos.x;
			_list.y = listPos.y;
			listPos.visible = false;
			_infoItems = new Array();
			_sortBtnItems = new Array();
			for(var i:int=0;i<6;i++)
			{
//				var btns : HBaseButton = new HBaseButton(this["sort"+i]);
				var btns : HBaseButton = new HTipButton(this["sort"+i],"",_tipArr[i]);
				btns.useBackgoundPos = true;
				addChild(btns);
				_sortBtnItems.push(btns);
			}
		}
		private function addEvent() : void
		{
			for(var i:int=0;i<6;i++)
			_sortBtnItems[i].addEventListener(MouseEvent.CLICK,   __sortOnHandler);
			if(PlayerManager.Instance.consortiaMemberList)
			PlayerManager.Instance.consortiaMemberList.addEventListener(DictionaryEvent.REMOVE,  __removeMemberItem);
		}
		
		public function set memberList($list : Array) : void
		{
			clearList();
//			_infoItems = $list;
			var count : int = $list.length;
			count = count < 6 ? 6 : count;
			for(var i:int=0;i<count;i++)
			{
				var item : MyConsortiaMemberInfoItem = new MyConsortiaMemberInfoItem();
				item.addEventListener(ConsortiaDataEvent.SELECT_CLICK_ITEM,  __selectItemHandler)
				if($list[i])
				{
					item.info = $list[i];				
				}
				if(i % 2)item.itemBgAsset.gotoAndStop(2);
				_list.appendItem(item);
				if(item.info)_infoItems.push(item);
				
			}
			if(_lastSort == "") {
				_lastSort = "Level";
				_isDes = true;
			}
			sortOnItem(_lastSort,_isDes);
//			sortOnItem("_State",true);//默认按是否在线来排序
//			sortOnItem("Grade",true);//等级
			
		}
		
		private function __selectItemHandler(evt : ConsortiaDataEvent) : void
		{
			if(_currentItem)_currentItem.isSelelct(false);
			_currentItem = evt.data as MyConsortiaMemberInfoItem;
			_currentItem.isSelelct(true);
			
			
			RightMenu.show(_currentItem.info.info);
			
		}
		private var _isDes : Boolean = false;
		private function __sortOnHandler(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			_isDes = (_isDes ? false : true);
            switch(evt.target.name)
            {
            	case "sort0":
					_lastSort = "NickName";
            	break;
            	case "sort1":
					_lastSort = "Level";
            	break;
            	case "sort2":
					_lastSort = "Grade";
            	break;
            	case "sort3":
					_lastSort = "Offer";
            	break;
				case "sort4":
					_lastSort = "battle";
				break;
            	case "sort5":
					_lastSort = "offLineHour";
            	break;
            }
			sortOnItem(_lastSort,_isDes);
		}
		public function upItem($info : ConsortiaPlayerInfo) : void
		{
			for(var i:int=0;i<_infoItems.length;i++)
			{
				var item : MyConsortiaMemberInfoItem = _infoItems[i] as MyConsortiaMemberInfoItem;
				if(item.info.ID == $info.ID)
				{
					item.info = $info;
					break;
				}
			}
		}
		private function __removeMemberItem(evt : DictionaryEvent) : void
		{
			var info : ConsortiaPlayerInfo = evt.data as ConsortiaPlayerInfo;
			if(!_infoItems)return;
			for(var i:int=0;i<_infoItems.length;i++)
			{
				var item : MyConsortiaMemberInfoItem = _infoItems[i] as MyConsortiaMemberInfoItem;
				if(item.info.ID == info.ID)
				{
					this._list.removeItem(item);
					item.dispose();
					_infoItems.splice(i,1);
					break;
				}
			}
		}
		
		
		internal function sortOnItem(field : String,des : Boolean=false) : void
		{
			for(var i:int=0;i<_infoItems.length;i++)
			{
				var item : MyConsortiaMemberInfoItem = _infoItems[i] as MyConsortiaMemberInfoItem;
				_list.removeItem(item);
			}
			_infoItems.sortOn(field,2|1|16);
			if(des)_infoItems.reverse();
			for(var j:int=0;j<_infoItems.length;j++)
			{
				var item2 : MyConsortiaMemberInfoItem = _infoItems[j] as MyConsortiaMemberInfoItem;
				_list.appendItemAt(item2,j);
				item2.itemBgAsset.gotoAndStop(int((j % 2)+1));
			}
			
			
			
		}
		
		private function clearList() : void
		{
			for(var i:int=0;i<_infoItems.length;i++)
			{
				var item : MyConsortiaMemberInfoItem = _infoItems[i] as MyConsortiaMemberInfoItem;
				_list.removeItem(item);
				item.removeEventListener(ConsortiaDataEvent.SELECT_CLICK_ITEM,  __selectItemHandler)
				item.dispose();
			}
			var $items : Array = _list.getItems();
			for(var j:int=($items.length-1);j>=0;j--)
			{
				var item2 : MyConsortiaMemberInfoItem = $items[j] as MyConsortiaMemberInfoItem;
				if(item2)
				{
					_list.removeItem(item2);
					item2.removeEventListener(ConsortiaDataEvent.SELECT_CLICK_ITEM,  __selectItemHandler);
					item2.dispose();
				}
			}
			_list.clearItems();
			_infoItems = [];
		}
		internal function dispose() : void
		{
			clearList();
			for(var i:int=0;i<6;i++)
			{
				var btn : HBaseButton = _sortBtnItems[i] as HBaseButton;
				_sortBtnItems[i].removeEventListener(MouseEvent.CLICK,   __sortOnHandler);
				btn.dispose();
				btn = null;
			}
			if(PlayerManager.Instance.consortiaMemberList)
			PlayerManager.Instance.consortiaMemberList.removeEventListener(DictionaryEvent.REMOVE,  __removeMemberItem);
			if(_list && _list.parent)_list.parent.removeChild(_list);
			_list = null;
			_sortBtnItems = null;
			_infoItems = null;
		}
		
	}
}