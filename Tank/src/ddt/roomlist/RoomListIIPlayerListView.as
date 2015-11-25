package ddt.roomlist
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.roomlistII.RoomListIIPlayerListAsset;
	
	import road.data.DictionaryData;
	import road.data.DictionaryEvent;
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	import road.utils.ComponentHelper;
	
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.manager.PlayerManager;
	import ddt.menu.RightMenu;
	import ddt.view.buffControl.BuffControl;
	import ddt.view.characterII.CharactoryFactory;
	import ddt.view.characterII.ICharacter;
	import ddt.view.common.ConsortiaIcon;
	import ddt.view.common.LevelIcon;
	import ddt.view.common.MarryIcon;
	import ddt.view.common.OfferText;
	import ddt.view.common.Repute;

	public class RoomListIIPlayerListView extends RoomListIIPlayerListAsset
	{
		private var _list:SimpleGrid;
		private var _data:DictionaryData;
		private var _info:PlayerInfo;
		private var _player:ICharacter;
		private var _levelIcon:LevelIcon;
		private var _cIcon:ConsortiaIcon;
		
		private var _mIcon:MarryIcon;
		
		private var _currentShowPlayerInfo:PlayerInfo;
		private var _buffs:BuffControl;
		private var selfInfo:PlayerInfo;
		
		public function RoomListIIPlayerListView(info:PlayerInfo,data:DictionaryData)
		{
			_info = info;
			_data = data;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			_buffs = new BuffControl();
			addChild(_buffs);
			_buffs.x = buff_pos.x;
			_buffs.y = buff_pos.y;
			removeChild(buff_pos);
			selfInfo = PlayerManager.Instance.Self;
			
			
			_list = new SimpleGrid(166,20,1);
			_list.verticalScrollPolicy = ScrollPolicy.ON;
			_list.horizontalScrollPolicy = ScrollPolicy.OFF;
			_list.cellPaddingHeight = 6;
			ComponentHelper.replaceChild(this,playerlist_pos,_list);
			
			nick_txt.text = String(selfInfo.NickName);
			if(selfInfo.ConsortiaName == "")
			{
				consortiaName_txt.text = "";
			}else
			{
				consortiaName_txt.text = String("<" + selfInfo.ConsortiaName + ">"); //bret 09.6.8
			}
			_player = CharactoryFactory.createCharacter(selfInfo);
			_player.show();
			_player.setShowLight(true);
			figure_pos.addChild(_player as DisplayObject);
			/* 公会图标 */
			if(selfInfo.ConsortiaID==0)
			{
				
			}else
			{
				_cIcon = new ConsortiaIcon(selfInfo.ConsortiaID,ConsortiaIcon.BIG,false);
				_cIcon.x = cicon_pos.x;
				_cIcon.y = cicon_pos.y;
				addChild(_cIcon);
			}
			cicon_pos.visible = false;
			
			reputeTxt.text = String(selfInfo.Repute);
		
			gesteTxt.text = String(selfInfo.Offer);
			/* 个人等级图标 */
			_levelIcon = new LevelIcon("b",selfInfo.Grade,selfInfo.Repute,selfInfo.WinCount,selfInfo.TotalCount,selfInfo.FightPower);
			_levelIcon.x = icon_pos.x;
			_levelIcon.y = icon_pos.y;
			addChild(_levelIcon);
			if(_cIcon && _cIcon.parent)_cIcon.parent.addChild(_cIcon);
			icon_pos.visible = false;
			
			if(selfInfo.IsMarried)
			{
				_mIcon = new MarryIcon(selfInfo);
				
				var tempObj:DisplayObject = selfInfo.ConsortiaID==0?cicon_pos:micon_pos;
				
				_mIcon.x = tempObj.x;
				_mIcon.y = tempObj.y;
				addChild(_mIcon);
			}
			micon_pos.visible = false;
			
			_list.content.addEventListener(MouseEvent.CLICK,menuClickHandler);
			addSelfItem();
			
			playerListBg_mc.gotoAndStop(1);
		}
		
		public function set playerListBgFrame(value:int):void
		{
			playerListBg_mc.gotoAndStop(value);
		}

		private function __updateGrade(evt:PlayerPropertyEvent):void
		{
			if(evt.changedProperties["Grade"])
			{
				_levelIcon.level = selfInfo.Grade;
			}
			if(evt.changedProperties["SpouseName"])
			{
				if(selfInfo.IsMarried && _mIcon == null)
				{
					_mIcon = new MarryIcon(selfInfo);
					
					var tempObj:DisplayObject = selfInfo.ConsortiaID==0?cicon_pos:micon_pos;
					
					_mIcon.x = tempObj.x;
					_mIcon.y = tempObj.y;
					addChild(_mIcon);
				}
				if(!selfInfo.IsMarried && _mIcon != null)
				{
					_mIcon.dispose()
					_mIcon=null;
				}
			}
			if(evt.changedProperties["IsMarried"])
			{
				if(_mIcon && !selfInfo.IsMarried)
				{
					_mIcon.dispose()
					_mIcon=null;
				}
			}
		}
		
		private function initEvent():void
		{
			_data.addEventListener(DictionaryEvent.ADD,__addWaitingPlayer);
			_data.addEventListener(DictionaryEvent.REMOVE,__removeWaitingPlayer);
			selfInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__updateGrade);
		}
		/**将自已也加入到列表的第一位**/
		private function addSelfItem() : void
		{
			var self : PlayerInfo = PlayerManager.Instance.Self;
			var item:RoomListIIPlayerItem = new RoomListIIPlayerItem(self);
			item.addEventListener(MouseEvent.CLICK,__itemClickHandler);
			_list.appendItemAt(item,0);
		}
		/**房间列表中玩家列表,第一位是自已**/
		private function upSelfItem() : void
		{
			for(var i : int=0;i<_list.getItems().length;i++)
			{
				var item : RoomListIIPlayerItem = _list.getItemAt(i) as RoomListIIPlayerItem;
				if(item.info.ID == PlayerManager.Instance.Self.ID)
				{
					_list.removeItem(item);
					_list.appendItemAt(item,0);
					break;
				}
			}
		}
		
		private function __addWaitingPlayer(evt:DictionaryEvent):void
		{
			var player:PlayerInfo = evt.data as PlayerInfo;
			if(_list.getItem("id",player.ID) ) return;
			var item:RoomListIIPlayerItem = new RoomListIIPlayerItem(player);
			item.addEventListener(MouseEvent.CLICK,__itemClickHandler);
			_list.appendItem(item);
			_list.sortByCustom(sortItem);
		}
		
		private function sortItem(items:Array):void
		{
			items.sortOn(["Grade","Nick"],[Array.NUMERIC,Array.DESCENDING]);
			items.reverse();
			upSelfItem();
		}
		
		
		private function __removeWaitingPlayer(evt:DictionaryEvent):void
		{
			var item:RoomListIIPlayerItem = _list.getItem("id",(evt.data as PlayerInfo).ID) as RoomListIIPlayerItem;
			item.removeEventListener(MouseEvent.CLICK,__itemClickHandler);
			_list.removeItem(item);
			item.dispose();
			item = null;
		}
		
		public function setMenuDisvisiable():void
		{
		}
		
		public function dispose():void
		{
			_data.removeEventListener(DictionaryEvent.ADD,__addWaitingPlayer);
			_data.removeEventListener(DictionaryEvent.REMOVE,__removeWaitingPlayer);
			
			selfInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__updateGrade);
			
			clearListItem();
			
			if(_player != null)
				_player.dispose();
			_player = null;
			
			if(_buffs)
				_buffs.dispose();
	    	_buffs = null;
	    	
	    	if(_levelIcon)
	    		_levelIcon.dispose();
	    	_levelIcon = null;
	    	
	    	if(_cIcon)
	    		_cIcon.dispose();
	    	_cIcon = null;
	    	
	    	if(_mIcon)
	    		_mIcon.dispose();
	    	_mIcon = null;
	    	
	    	_currentShowPlayerInfo = null;
	    	selfInfo = null;
			_data = null;
			_info = null;
	    	
	    	if(parent)
	    		parent.removeChild(this);
		}
		
		private function clearListItem():void
		{
			if(_list)
			{
				for each(var item:RoomListIIPlayerItem in _list.items)
				{
					item.removeEventListener(MouseEvent.CLICK,__itemClickHandler);
					item.dispose();
					item = null;
				}
				_list.content.removeEventListener(MouseEvent.CLICK,menuClickHandler);
				_list.clearItems();
				
				if(_list.parent)
					_list.parent.removeChild(_list);
			}
			_list = null;
		}
		
		private function menuClickHandler(e:Event):void
		{
			if(_list.selectedItem as RoomListIIPlayerItem)
			{
				RightMenu.show((_list.selectedItem as RoomListIIPlayerItem).info);		
			}
		}
		
		private function __itemClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.play("008");
			_list.selectedItem = e.currentTarget as DisplayObject;
			_currentShowPlayerInfo = (e.currentTarget as RoomListIIPlayerItem).info;
		}
		
	}
}