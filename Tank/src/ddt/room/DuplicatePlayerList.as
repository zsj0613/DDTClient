package ddt.room
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import road.data.DictionaryData;
	import road.data.DictionaryEvent;
	import road.ui.controls.SimpleGrid;
	
	import ddt.data.GameEvent;
	import ddt.data.GameInfo;
	import ddt.data.RoomInfo;
	import ddt.data.WebSpeedInfo;
	import ddt.data.game.Player;
	import ddt.data.gameover.BaseSettleInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.data.player.RoomPlayerInfo;
	import ddt.events.RoomEvent;
	import ddt.events.WebSpeedEvent;
	import ddt.manager.GameManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PersonalInfoManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.RoomManager;
	import ddt.manager.StateManager;
	import ddt.socket.GameInSocketOut;
	import ddt.states.StateType;

	public class DuplicatePlayerList extends Sprite
	{
		private var _playerFigureList:SimpleGrid;
		private var _players:DictionaryData;
		private var _items:Array;
		private var _room:RoomInfo;
		private var _game:GameInfo;
		private var _gamePlayers:DictionaryData;
		private var _self:RoomPlayerInfo;
		
		public function DuplicatePlayerList()
		{
			init();
			initEvent();
			tryStartGame();
		}
		
		private function init():void
		{
			_items = [];
			
			_room = RoomManager.Instance.current;
			
			_game = GameManager.Instance.Current;
			
			_players = RoomManager.Instance.current.players;
			
			_gamePlayers = GameManager.Instance.Current.livings;
			
			_self = PlayerManager.selfRoomPlayerInfo;
			
			_playerFigureList = new SimpleGrid(186,193,2);
			
			_playerFigureList.verticalScrollPolicy = ScrollPolicy.OFF;
			_playerFigureList.horizontalScrollPolicy = ScrollPolicy.OFF;
			_playerFigureList.cellPaddingHeight = _playerFigureList.cellPaddingWidth = 2;
			
			for(var i:uint = 0; i < 4; i++)
			{
				var playerfigure:RoomIIPlayerItem = new RoomIIPlayerItem(i);
				
				playerfigure.addEventListener(RoomIIPlayerItem.SHOWINFO, __showPlayerInfo);
				playerfigure.addEventListener(Event.OPEN, __openPlaceHandler);
				playerfigure.addEventListener(Event.CLOSE, __closePlaceHandler);
				
				_playerFigureList.appendItem(playerfigure);
				_items.push(playerfigure);
			}
			
			_playerFigureList.drawNow();
			
			_playerFigureList.setSize(_playerFigureList.getContentWidth(),_playerFigureList.getContentHeight());
			
			addChild(_playerFigureList);
			
			updatePlaceState();
		}
		
		private function initEvent():void
		{
			_players.addEventListener(DictionaryEvent.ADD, __addPlyaerHandler);
			_players.addEventListener(DictionaryEvent.REMOVE, __removePlayerHandler);
			_gamePlayers.addEventListener(DictionaryEvent.ADD,__addGamePlayerHandler);
			_gamePlayers.addEventListener(DictionaryEvent.REMOVE, __removeGamePlayerHandler);
			_room.addEventListener(RoomEvent.ROOMPLACE_CHANGED,__closePosUpdate);
			_self.addEventListener(RoomEvent.PLAYER_STATE_CHANGED,__updateButton);
//			_room.addEventListener(RoomEvent.STATE_CHANGED,__updateButton);
			for each(var i:RoomPlayerInfo in _room.players)
			{
				i.addEventListener(RoomEvent.ROOMPLACE_CHANGED,__roomPosChange);
				i.webSpeedInfo.addEventListener(WebSpeedEvent.STATE_CHANE,__stateChange);
				i.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPlayerChange);
				i.addEventListener(RoomEvent.PLAYER_STATE_CHANGED, __readyChange);
				if(i.info)
				{
					i.info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPopChange);
				}
			}
			
			for(var j:uint = 0; j < _gamePlayers.list.length; j++)
			{
				var p:Player = _gamePlayers.list[j] as Player;
				if(p)
				{
					p.addEventListener(GameEvent.READY_CHANGED, __readyChangedII);
				}
			}
			
			GameManager.Instance.dispatchAllGameReadyState(GameManager.Instance.gameReadyStateResults);
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
		
		private function __stateChange(e:WebSpeedEvent):void
		{
			var tmp:WebSpeedInfo = e.currentTarget as WebSpeedInfo;
			var rpi:RoomIIPlayerItem = findItemWithWebSpeedInfo(tmp);
			
			if(rpi)
			{
				rpi.stateChange();
			}
		}
		
		private function __addGamePlayerHandler(e:DictionaryEvent):void
		{
			var p:Player = e.data as Player;
			if(p)
			{
				p.addEventListener(GameEvent.READY_CHANGED, __readyChangedII);
				
				var rpi:RoomIIPlayerItem = findItemWithInfo(_room.findPlayer(p.playerInfo.ID));
				
				if(rpi)
				{
					rpi.gameReadyChange(p.isReady);
				}
				
				tryStartGame();
			}
		}
		
		private function __removeGamePlayerHandler(e:DictionaryEvent):void
		{
			var p:Player = e.data as Player;
			
			if(p)
			{
				p.removeEventListener(GameEvent.READY_CHANGED, __readyChangedII);
				
				if(_self.isHost)
				{
					tryStartGame();
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
				rpi.gameReadyChange(_game.findPlayerByPlayerID(rpi.info.info.ID).isReady);
			}
		}
		
		private function __readyChangedII(e:GameEvent):void
		{
			var p:Player = e.currentTarget as Player;
			
			if(p)
			{
				var rpi:RoomIIPlayerItem = findItemWithInfo(_room.findPlayer(p.playerInfo.ID));
				
				if(rpi)
				{
					rpi.gameReadyChange(p.isReady);
					if(!rpi.info.isHost)
					{
						tryStartGame();
					}
				}
			}
		}
		
		private function tryStartGame():void
		{
			var isAllReady:Boolean = true;
			if(_self.isHost)
			{
				for(var i:uint = 0; i < _gamePlayers.list.length; i++)
				{
					var player:Player = _gamePlayers.list[i] as Player;
					
					if(player)
					{
						var rpi:RoomPlayerInfo = _room.findPlayer(player.playerInfo.ID);
						if(rpi && !player.isReady && !rpi.isHost)
						{
							isAllReady = false;
							break;
						}
					}
				}
				_game.selfGamePlayer.isReady = isAllReady;
			}
		}
		
		private function findItemWithInfo(t:RoomPlayerInfo):RoomIIPlayerItem
		{
			for each(var i:RoomIIPlayerItem in _items)
			{
				if(i.info == t)
				{
					return i;
				}
			}
			return null;
		}
		
		private function findItemWithWebSpeedInfo(speedinfo:WebSpeedInfo):RoomIIPlayerItem
		{
			for each(var i:RoomIIPlayerItem in _items)
			{
				if(i.info && i.info.webSpeedInfo == speedinfo)
				{
					return i;
				}
			}
			return null;
		}
		
		private function __openPlaceHandler(e:Event):void
		{
			var figureItem:RoomIIPlayerItem = e.currentTarget as RoomIIPlayerItem;
			if(figureItem)
			{
				openPlace(figureItem.place);
			}
		}
		
		private function __closePlaceHandler(e:Event):void
		{
			var figureItem:RoomIIPlayerItem = e.currentTarget as RoomIIPlayerItem;
			if(figureItem)
			{
				closePlace(figureItem.place);
			}
		}
		
		private function __updateButton(event:Event):void
		{
			for each(var it:RoomIIPlayerItem in _items)
			{
				it.updateButton(_self,_room);
				if(it.info && it.info.isHost)
				{
					it.gameReadyChange(_game.findPlayerByPlayerID(it.info.info.ID).isReady);
				}
			}
			
			tryStartGame();
		}
		
		private function __roomPosChange(evt:RoomEvent):void
		{
			var info:RoomPlayerInfo = evt.currentTarget as RoomPlayerInfo;
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
		
		private function __showPlayerInfo(e:Event):void
		{
			PersonalInfoManager.instance.addPersonalInfo((e.currentTarget as RoomIIPlayerItem).info.info.ID,PlayerManager.Instance.Self.ZoneID);
		}
		
		/**
		 * 邀请玩家进入房间时
		 * @param e
		 * 
		 */		
		private function __addPlyaerHandler(e:DictionaryEvent):void
		{
			addPlayerItem(e.data as RoomPlayerInfo);
		}
		
		/**
		 * 添加玩家
		 * @param $info
		 * 
		 */		
		private function addPlayerItem($info : RoomPlayerInfo) : void
		{
			_playerFigureList.items[$info.roomPos].info = $info;
			_playerFigureList.items[$info.roomPos].stateChange();
			
			$info.addEventListener(RoomEvent.ROOMPLACE_CHANGED,__roomPosChange);
			$info.webSpeedInfo.addEventListener(WebSpeedEvent.STATE_CHANE,__stateChange);
			$info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPlayerChange);
			$info.addEventListener(RoomEvent.PLAYER_STATE_CHANGED, __readyChange);
			if($info.info)
			{
				$info.info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPopChange);
			}
		}
		
		/**
		 * 玩家离开或被踢出房间时
		 * @param e
		 * 
		 */		
		private function __removePlayerHandler(e:DictionaryEvent):void
		{
			var $info:RoomPlayerInfo = e.data as RoomPlayerInfo;
			if($info.isSelf)
			{
				_players.removeEventListener(DictionaryEvent.REMOVE, __removePlayerHandler);
			}
			removePlayerItem($info);
			updatePlaceState();
			if($info.isSelf)
			{
				StateManager.setState(StateType.DUNGEON);
			}
			tryStartGame();
		}
		
		/**
		 * 移除玩家
		 * @param $info
		 * 
		 */		
		private function removePlayerItem($info : RoomPlayerInfo):void
		{
			$info.removeEventListener(RoomEvent.ROOMPLACE_CHANGED,__roomPosChange);
			$info.webSpeedInfo.removeEventListener(WebSpeedEvent.STATE_CHANE,__stateChange);
			$info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPlayerChange);
			$info.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED, __readyChange);
			if($info.info)
			{
				$info.info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPopChange);
			}
			_playerFigureList.items[$info.roomPos].info = null;
		}
		
		private function __closePosUpdate(evt:Event):void
		{
			updatePlaceState();
		}
		
		public function updatePlaceState():void
		{
			var temp:Array = _room.placesState;
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
					_items[i].info = player;
					
					if(player)
					{
						_items[i].stateChange();
						var gplayer:Player = _game.findPlayerByPlayerID(player.info.ID);
						if(gplayer)
						{
							_items[i].gameReadyChange(gplayer.isReady);
						}
					}
				}
				_items[i].updateButton(_self,_room);
			}
		}
		
		
		
		/**
		 * 所有玩家是否都准备完毕
		 * 
		 */		
		private function isAllReady():Boolean
		{
			for each(var i:RoomPlayerInfo in _players)
			{
				if(!i.isReady)
				{
					return false;
				}
			}
			
			return true;
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
			if(!(_room.canKitPlayer()))
				return false;
			if(_room.roomType == 1)
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
		
		public function updateSettle(arr:Array):void
		{
			if(arr == null || arr.length == 0) return;
			
			for(var i:uint = 0; i < arr.length; i++)
			{
				var settle:BaseSettleInfo = arr[i] as BaseSettleInfo;
				var $roomplayerinfo:RoomPlayerInfo = _players[settle.playerid] as RoomPlayerInfo;
				if($roomplayerinfo)
				{
					$roomplayerinfo.info.Grade = settle.level;
					_playerFigureList.items[$roomplayerinfo.roomPos].info = $roomplayerinfo;
				}
			}
		}
		
		public function dispose():void
		{
			GameManager.Instance.gameReadyStateResults = [];
			_players.removeEventListener(DictionaryEvent.ADD, __addPlyaerHandler);
			_players.removeEventListener(DictionaryEvent.REMOVE, __removePlayerHandler);
			_gamePlayers.removeEventListener(DictionaryEvent.ADD,__addGamePlayerHandler);
			_gamePlayers.removeEventListener(DictionaryEvent.REMOVE, __removeGamePlayerHandler);
			_room.removeEventListener(RoomEvent.ROOMPLACE_CHANGED,__closePosUpdate);
			_self.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED,__updateButton);
//			_room.removeEventListener(RoomEvent.STATE_CHANGED,__updateButton);
			
			for each(var i:RoomPlayerInfo in _room.players)
			{
				i.removeEventListener(RoomEvent.ROOMPLACE_CHANGED,__roomPosChange);
				if(i.webSpeedInfo)
					i.webSpeedInfo.removeEventListener(WebSpeedEvent.STATE_CHANE,__stateChange);
				i.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPlayerChange);
				i.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED, __readyChange);
				if(i.info)
				{
					i.info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPopChange);
				}
			}
			
			for(var j:uint = 0; j < _gamePlayers.list.length; j++)
			{
				var p:Player = _gamePlayers.list[j] as Player;
				if(p)
				{
					p.removeEventListener(GameEvent.READY_CHANGED, __readyChangedII);
				}
			}
			
			for each(var k:RoomIIPlayerItem in _playerFigureList.items)
			{
				k.removeEventListener(RoomIIPlayerItem.SHOWINFO, __showPlayerInfo);
				k.removeEventListener(Event.OPEN, __openPlaceHandler);
				k.removeEventListener(Event.CLOSE, __closePlaceHandler);
				k.dispose();
				k = null;
			}
			
			_playerFigureList.clearItems();
			
			if(_playerFigureList && _playerFigureList.parent)
			{
				_playerFigureList.parent.removeChild(_playerFigureList);
			}
			
			_items = null;
			_playerFigureList = null;
			_players = null;
			_gamePlayers = null;
			_game = null;
			_room = null;
			_self = null;
			
			if(parent)
			{
				parent.removeChild(this);
			}
			
		}
	}
}