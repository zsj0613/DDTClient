package ddt.room
{
	import fl.controls.ScrollPolicy;
	
	import flash.events.Event;
	
	import game.crazyTank.view.roomII.RoomIIPlayerListBg2Asset;
	
	import road.data.DictionaryData;
	import road.data.DictionaryEvent;
	import road.ui.controls.SimpleGrid;
	import road.utils.ComponentHelper;
	
	import ddt.data.RoomInfo;
	import ddt.data.WebSpeedInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.data.player.RoomPlayerInfo;
	import ddt.events.RoomEvent;
	import ddt.events.WebSpeedEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.RoomManager;
	import ddt.manager.StateManager;
	import ddt.socket.GameInSocketOut;
	import ddt.states.StateType;

	public class RoomIIPlayer2List extends RoomIIPlayerListBg2Asset
	{
		private var _list1:SimpleGrid;
		private var _list2:SimpleGrid;
		private var _items:Array;
		private var _data:DictionaryData;
		private var _self:RoomPlayerInfo;
		private var _room:RoomInfo;
		private var _team:int;
		private var _controller:RoomIIController;
		
		public function get room():RoomInfo
		{
			return _room;
		}
		
		public function get self():RoomPlayerInfo
		{
			return _self;
		}
		
		public function RoomIIPlayer2List(data:DictionaryData,self:RoomPlayerInfo,controller:RoomIIController)
		{
			super();
			_controller = controller;
			_data = data;
			_self = _controller.self;;
			_room = _controller.room;
			if(_controller.room.roomType == 1)
			{
				init();
			}
			else if(_controller.room.roomType == 0)
			{
				initEx();
			}
			else 
			{
				initExII();
			}
			initEvent();
		}
		private function init():void
		{
			_items = [];
			_list1 = new SimpleGrid(172,193,2);
			_list1.marginHeight = 52;
			_list1.cellPaddingHeight = _list1.cellPaddingWidth = 1;
			_list1.verticalScrollPolicy = _list1.horizontalScrollPolicy = ScrollPolicy.OFF;
			ComponentHelper.replaceChild(this,list1_pos,_list1);
			_list2 = new SimpleGrid(172,193,2);
			_list2.marginHeight = 52;
			_list2.cellPaddingHeight = _list2.cellPaddingWidth = 1;
			_list2.verticalScrollPolicy = _list2.horizontalScrollPolicy = ScrollPolicy.OFF;
			ComponentHelper.replaceChild(this,list2_pos,_list2);
			for(var i:int = 0; i < 8; i += 2)
			{
				var item1:RoomIIPlayerItem = new RoomIIPlayerItem(i,this);
				_items.push(item1);
				_list1.appendItem(item1);
				var item2:RoomIIPlayerItem = new RoomIIPlayerItem(i + 1,this);
				_items.push(item2);
				_list2.appendItem(item2);
				item1.addEventListener(RoomIIPlayerItem.SHOWINFO,__showPlayerInfo);
				item2.addEventListener(RoomIIPlayerItem.SHOWINFO,__showPlayerInfo);
				item1.updateButton(_self,_room);
				item2.updateButton(_self,_room);
			}
			for each(var j:RoomPlayerInfo in _data)
			{
				if(j != null)
				{
					_items[j.roomPos].info = j;
					_items[j.roomPos].roomReadyChange();
					_items[j.roomPos].stateChange();
				}
			}
			for(var k:int=4 ;k<8 ; k++)
			{
				if(_items[k].info == null && _data.length <= 1)
				{
					this.closePlace(k);
				}
			}
			updatePlaceState();
		}
		
		private function initEx():void
		{
			_items = [];
			_list1 = new SimpleGrid(186,193,2);
			_list1.marginHeight = 52;
			_list1.cellPaddingHeight = _list1.cellPaddingWidth = 2;
			_list1.verticalScrollPolicy = _list1.horizontalScrollPolicy = ScrollPolicy.OFF;
			list1_pos.x += 10;
			ComponentHelper.replaceChild(this,list1_pos,_list1);
			this.removeChild(list2_pos);
			list2_pos = null;
			
			for(var i:int = 0; i < 4; i ++ )
			{
				var item1:RoomIIPlayerItem = new RoomIIPlayerItem(i,this);
				_items.push(item1);
				_list1.appendItem(item1);
				item1.updateButton(_self,_room);
				item1.addEventListener(RoomIIPlayerItem.SHOWINFO,__showPlayerInfo);
			}
			for each(var j:RoomPlayerInfo in _data)
			{
				_items[j.roomPos].info = j;
				_items[j.roomPos].roomReadyChange();
				_items[j.roomPos].stateChange();
			}
			if(_data.length<=1)
			{
				if(_items[2].info==null) this.closePlace(2);
				if(_items[3].info==null) this.closePlace(3);
			}
			updatePlaceState();
		}
		
		private function initExII():void
		{
			_items = [];
			_list1 = new SimpleGrid(186,193,2);
			_list1.marginHeight = 52;
			_list1.cellPaddingHeight = _list1.cellPaddingWidth = 2;
			_list1.verticalScrollPolicy = _list1.horizontalScrollPolicy = ScrollPolicy.OFF;
			list1_pos.x += 10;
			ComponentHelper.replaceChild(this,list1_pos,_list1);
			
			this.removeChild(list2_pos);
			list2_pos = null;
			
			for(var i:int = 0; i < 4; i ++ )
			{
				var item1:RoomIIPlayerItem = new RoomIIPlayerItem(i,this);
				_items.push(item1);
				_list1.appendItem(item1);
				item1.updateButton(_self,_room);
				item1.addEventListener(RoomIIPlayerItem.SHOWINFO,__showPlayerInfo);
			}
			for each(var j:RoomPlayerInfo in _data)
			{
				_items[j.roomPos].info = j;
				_items[j.roomPos].roomReadyChange();
				_items[j.roomPos].stateChange();
			}
//			if(_data.length<=1)
//			{
//				if(_items[2].info==null) this.closePlace(2);
//				if(_items[3].info==null) this.closePlace(3);
//			}
			
			updatePlaceState();
		}
		
		
		override public function get width():Number
		{
			return 715;
		}
		override public function get height():Number
		{
			return 330;
		}
		
		public function clearFace():void
		{
			for(var i:int = 0; i < _items.length; i++)
			{
				_items[i].clearFace();
			}
		}
		
		public function getItems():Array
		{
			return _items;
		}
		
		private function initEvent():void
		{
			_data.addEventListener(DictionaryEvent.ADD,__addPlayer);
			_data.addEventListener(DictionaryEvent.REMOVE,__removePlayer);
			_controller.room.addEventListener(RoomEvent.ROOMPLACE_CHANGED,__closePosUpdate);
			_self.addEventListener(RoomEvent.PLAYER_STATE_CHANGED,__updateButton);
			_room.addEventListener(RoomEvent.STATE_CHANGED,__updateButton);
			for each(var i:RoomPlayerInfo in _controller.room.players)
			{
				i.addEventListener(RoomEvent.ROOMPLACE_CHANGED,__roomPosChange);
				i.addEventListener(RoomEvent.TEAM_CHANGE, __teamChange);
				i.addEventListener(RoomEvent.PLAYER_STATE_CHANGED, __readyChange);
				i.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPlayerChange);
				i.webSpeedInfo.addEventListener(WebSpeedEvent.STATE_CHANE,__stateChange);
				if(i.info)
				{
					i.info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPopChange);
				}
				// TODO with RoomIIPlayerItem's initInfoEvent method
			}
		}
		
		private function removeEvent():void
		{
			_data.removeEventListener(DictionaryEvent.ADD,__addPlayer);
			_data.removeEventListener(DictionaryEvent.REMOVE,__removePlayer);
			_controller.room.removeEventListener(RoomEvent.ROOMPLACE_CHANGED,__closePosUpdate);
			_self.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED,__updateButton);
			_room.removeEventListener(RoomEvent.STATE_CHANGED,__updateButton);
			for each(var i:RoomPlayerInfo in _controller.room.players)
			{
				i.removeEventListener(RoomEvent.ROOMPLACE_CHANGED,__roomPosChange);
				i.removeEventListener(RoomEvent.TEAM_CHANGE, __teamChange);
				i.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED, __readyChange);
				i.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPlayerChange);
				i.webSpeedInfo.removeEventListener(WebSpeedEvent.STATE_CHANE,__stateChange);
				if(i.info)
				{
					i.info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPopChange);
				}
				// TODO with RoomIIPlayerItem's initInfoEvent method
			}
		}
		
		private function __onPopChange(e:PlayerPropertyEvent):void
		{
			var tmp:RoomPlayerInfo = e.currentTarget as RoomPlayerInfo;
			var rpi:RoomIIPlayerItem = findItemWithInfo(tmp);
			
			if(rpi)
			{
				if(e.changedProperties["ConsortiaLevel"])
				{
					rpi.ConsortiaLevelChange(e.target.ConsortiaLevel);
				}
				if(e.changedProperties["ConsortiaID"])
				{
					rpi.ConsortiaIDChange(e.target.ConsortiaID);
				}
				if(e.changedProperties["ConsortiaRepute"])
				{
					rpi.ConsortiaReputeChange(e.target.ConsortiaRepute);
				}
			}
		}
		
		private function __stateChange(e:WebSpeedEvent):void
		{
			var tmp:WebSpeedInfo = e.currentTarget as WebSpeedInfo;
			var rpi:RoomIIPlayerItem = findItemWithWebSpeedInfo(tmp);
			
			if(rpi)
			{
				rpi.stateChange();
			}
		}
		
		private function findItemWithWebSpeedInfo(speedinfo:WebSpeedInfo):RoomIIPlayerItem
		{
			for each(var i:RoomIIPlayerItem in _items)
			{
				if(i.info && i.info.webSpeedInfo && i.info.webSpeedInfo == speedinfo)
				{
					return i;
				}
			}
			return null;
		}
		
		private function __onPlayerChange(e:PlayerPropertyEvent):void
		{
			if(e.changedProperties["GP"])
			{
				var tmp:RoomPlayerInfo = e.currentTarget as RoomPlayerInfo;
				var rpi:RoomIIPlayerItem = findItemWithInfo(tmp);
				if(rpi)
				{
					rpi.playerGPChange();
				}
			}
		}
		
		private function __readyChange(e:RoomEvent):void
		{
			var tmp:RoomPlayerInfo = e.currentTarget as RoomPlayerInfo;
			var rpi:RoomIIPlayerItem = findItemWithInfo(tmp);
			
			if(rpi)
			{
				rpi.roomReadyChange();
			}
		}
		
		private function __teamChange(e:RoomEvent):void
		{
			var tmp:RoomPlayerInfo = e.currentTarget as RoomPlayerInfo;
			var rpi:RoomIIPlayerItem = findItemWithInfo(tmp);
			
			if(rpi)
			{
				rpi.changeTeam();
			}
		}
		
		private function findItemWithInfo(t:RoomPlayerInfo):RoomIIPlayerItem
		{
			for each(var i:RoomIIPlayerItem in _items)
			{
				if(i.info && i.info == t)
				{
					return i;
				}
			}
			return null;
		}
		
		private function __updateButton(event:Event):void
		{
			for each(var it:RoomIIPlayerItem in _items)
			{
				it.updateButton(_self,_room);
			}
		}
		
		public function openPlace(pos:int):void
		{
			GameInSocketOut.sendGameRoomPlaceState(pos,-1);
		}
		
		public function closePlace(pos:int):void
		{
			if(canClosePlace(pos))
			{
				GameInSocketOut.sendGameRoomPlaceState(pos,0);
			}
		}
		
		private function canClosePlace(pos:int):Boolean
		{
			if(!_controller.room.canKitPlayer())
				return false;
			if(_controller.room.roomType == 1)
			{
				//至少保留一个位置
				var team:int = pos % 2;
				for(var i:int = team; i < 8; i+= 2)
				{
					if(i != pos && _items[i].close == false)
					{
						return true;
					}
				}
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.RoomIIPlayerItem.position"));
				return false;
			}
			else
			{
				return true;
			}
			return false;
		}
		
		public function PlaceFill():Boolean
		{
			if(_room.roomType >=2 || _room.roomType ==0)
			{
				var j:int=0;
				for(var i:int=0;i<_items.length;i++)
				{
					if(_items[i].close)
					j++;
				}
				if(j+_room.players.length == 4)
				{
					return true;
				}else
				{
					return false;
				}
			}
			return false;
		}
		
		private function __addPlayer(evt:DictionaryEvent):void
		{
			var info:RoomPlayerInfo = evt.data as RoomPlayerInfo;
			_items[info.roomPos].info = info;
			_items[info.roomPos].roomReadyChange();
			_items[info.roomPos].stateChange();
			info.addEventListener(RoomEvent.ROOMPLACE_CHANGED,__roomPosChange);
			info.addEventListener(RoomEvent.TEAM_CHANGE, __teamChange);
			info.addEventListener(RoomEvent.PLAYER_STATE_CHANGED, __readyChange);
			info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPlayerChange);
			info.webSpeedInfo.addEventListener(WebSpeedEvent.STATE_CHANE,__stateChange);
			if(info.info)
			{
				info.info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPopChange);
			}
		}
		
		private function __removePlayer(evt:DictionaryEvent):void
		{
			var info:RoomPlayerInfo = evt.data as RoomPlayerInfo;
			info.removeEventListener(RoomEvent.ROOMPLACE_CHANGED,__roomPosChange);
			info.removeEventListener(RoomEvent.TEAM_CHANGE, __teamChange);
			info.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED, __readyChange);
			info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPlayerChange);
			info.webSpeedInfo.removeEventListener(WebSpeedEvent.STATE_CHANE,__stateChange);
			if(info.info)
			{
				info.info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPopChange);
			}
			_items[info.roomPos].info = null;
			if(info.isSelf)
			{
				if(_room){
					StateManager.setState(_room.backRoomListType);
				}else{
					StateManager.setState(StateType.DUNGEON);
				}
			}
				
		}
		
		private function __roomPosChange(evt:RoomEvent):void
		{
			var info:RoomPlayerInfo = evt.currentTarget as RoomPlayerInfo;
			info.removeEventListener(RoomEvent.ROOMPLACE_CHANGED,__roomPosChange);
			info.removeEventListener(RoomEvent.TEAM_CHANGE, __teamChange);
			info.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED, __readyChange);
			info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPlayerChange);
			info.webSpeedInfo.removeEventListener(WebSpeedEvent.STATE_CHANE,__stateChange);
			for(var i:int = 0; i < _items.length; i++)
			{
				if(_items[i].id == info.info.ID)
				{
					_items[i].info = null;
					break;
				}
			}
			_items[info.roomPos].info = info;
		}
		
		
		private function __closePosUpdate(evt:Event):void
		{
			updatePlaceState();
		}
		
		private function __showPlayerInfo(evt:Event):void
		{
			_controller.showPlayerInfo((evt.currentTarget as RoomIIPlayerItem).info.info);
		}
		
		private function updatePlaceState():void
		{
			var temp:Array = _controller.room.placesState;
			for(var i:int = 0; i < _items.length; i++)
			{
				if(temp[i] < 0)
				{
					_items[i].close = false;
					_items[i].info = null;
				}else if(temp[i] == 0)
				{
					_items[i].close = true;
					_items[i].info = null;
				}else{
					var player:RoomPlayerInfo = RoomManager.Instance.findRoomPlayer(temp[i]);
					
					if(player)
					{
						_items[i].info = player;
						_items[i].roomReadyChange();
						_items[i].stateChange();
					}
					else
					{
						if(_items[i].info)
						{
							_items[i].info.removeEventListener(RoomEvent.ROOMPLACE_CHANGED,__roomPosChange);
							_items[i].info.removeEventListener(RoomEvent.TEAM_CHANGE, __teamChange);
							_items[i].info.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED, __readyChange);
							_items[i].info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPlayerChange);
							_items[i].info.webSpeedInfo.removeEventListener(WebSpeedEvent.STATE_CHANE,__stateChange);
						}
						_items[i].info = player;
					}
				}
			}
		}
		
		public function dispose():void
		{
			clearFace();
			removeEvent();
			
			for(var j:int = 0; j < _items.length; j++)
			{
				_items[j].removeEventListener(RoomIIPlayerItem.SHOWINFO,__showPlayerInfo);
				_items[j].dispose();
			}
			_items = null;
			
			if(_list1)
			{
				_list1.clearItems();
				if(_list1.parent)
					_list1.parent.removeChild(_list1);
			}
			_list1 = null;
			
			if ( _list2 )
			{
				_list2.clearItems();
				if(_list2.parent)
					_list2.parent.removeChild(_list2);
			}
			_list2 = null;
			
			_data = null;
			_self = null;
			_controller = null;
			
			if(parent)
				parent.removeChild(this);
		}
	}
}