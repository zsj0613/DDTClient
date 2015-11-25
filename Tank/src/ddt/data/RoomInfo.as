package ddt.data
{
	import road.data.DictionaryData;
	
	import ddt.data.player.RoomPlayerInfo;
	import ddt.events.RoomEvent;
	import ddt.manager.ChatManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	
	[Event(name = "roomplaceChanged", type = "ddt.events.RoomEvent")]
	[Event(name = "playerStateChanged",type = "ddt.events.RoomEvent")]
	[Event(name = "stateChanged",type = "ddt.events.RoomEvent")]
	public class RoomInfo extends SimpleRoomInfo
	{
		public static const STATE_READY:String = "ready";
		public static const STATE_UNREADY:String = "unready";
		public static const STATE_PICKING:String = "picking";
		public static const STATE_LOADING:String = "loading";
		public static var   SucideTime : int = 2 * 60 * 1000;
		
		private var _state:String;
		public var resultCard:Array;
		public function get roomState():String
		{
			return _state;
		}
		
		public function set roomState(value:String):void
		{
			if(_state == value) return;
			_state = value;
			dispatchEvent(new RoomEvent(RoomEvent.STATE_CHANGED));
		}
		
		private var _placesState:Array = [-1,-1,-1,-1,-1,-1,-1,-1];
		public function get placesState():Array
		{
			return _placesState;
		}
		public function updatePlaceState(states:Array):void
		{
			var changed:Boolean;
			for(var i:int = 0; i < 8 ; i ++)
			{
				if(_placesState[i] != states[i])
				{
					changed = true;
					break;
				}
			}
			if(changed)
			{
				_placesState = states;
				dispatchEvent(new RoomEvent(RoomEvent.ROOMPLACE_CHANGED));
			}
		}
		
		public function CanInvitePVE():Boolean
		{
			for(var i:uint = 0; i < 4; i++)
			{
				if(int(_placesState[i]) == -1)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public var players:DictionaryData;
		
		public function addPlayer(info:RoomPlayerInfo):void
		{
			var p:RoomPlayerInfo = players[info.info.ID];
			players.add(info.info.ID,info);
			if(!isPlaying)
			{
				tryStartGame();
			}
		}
		
		public function removePlayer(zoneID:int,id:int):RoomPlayerInfo
		{
			if(zoneID != PlayerManager.Instance.Self.ZoneID) return null;
			var info:RoomPlayerInfo = players[id];
			if(info)
			{
				players.remove(id);
				_placesState[info.roomPos] = -1;
				if(!isPlaying)
				{
					tryStartGame();
				}
			}
			return info;
		}
		
		public function findPlayer(id:int,zoneID:int=-1):RoomPlayerInfo
		{
			if(zoneID == PlayerManager.Instance.Self.ZoneID || zoneID == -1)
			{
				return players[id];
			}else
			{
				return null;
			}
		}
		
		private var _allowCrossZone:Boolean = false;
		
		public function set allowCrossZone(value:Boolean):void
		{
			if(_allowCrossZone == value) return;
			_allowCrossZone = value;
			dispatchEvent(new RoomEvent(RoomEvent.ALLOW_CROSS_CHANGE));
		}
		
		public function get allowCrossZone():Boolean
		{
			return _allowCrossZone;
		}
		
		public function getPlayerAt(place:int):RoomPlayerInfo
		{
			for each(var i:RoomPlayerInfo in players)
			{
				if(i.roomPos == place) 
				return i;
			}
			return null;
		}
		
		public function removePlayerAt(place:int):void
		{
			for each(var player:RoomPlayerInfo in players)
			{
				if( player.roomPos == place )
				{
					players.remove(player.info.ID);
					return;
				}
			}
		}
		
		public function resetReadyStates():void
		{
			for each(var player:RoomPlayerInfo in players)
			{
				player.resetReady();
			}	
		}
		
		public function reset():void
		{
			isPlaying = false;
			
			//撮合站，重置队员的队伍
			if(roomType == 0)
			{
				for each(var p:RoomPlayerInfo in players)
				{
					 p.team = 1;			
				}
			}

			roomState = STATE_UNREADY;
			tryStartGame();
		}
		
		public function tryStartGame():void
		{
			if(!isPlaying)
			{
				if(canStart())
				{
					roomState = STATE_READY;
				}
				else
				{
					if(PlayerManager.selfRoomPlayerInfo.isHost)
					{
						roomState = STATE_UNREADY;
					}
				}
			}
		}
		//房主是否能开始
		public function canStart():Boolean
		{
			if(PlayerManager.selfRoomPlayerInfo.isHost)
			{
				var allReady:Boolean = isAllReady();
				//撮合
				if(roomType == 0 || roomType >= 2)
				{
					return allReady;
				}
				else
				{
					return allReady && isTeamBalance();
				}
			}
			return false;
		}
		
		public function canKitPlayer():Boolean
		{
			return _state == STATE_UNREADY || _state == STATE_READY;
		}
		
		public function isAllReady():Boolean
		{
			for each(var p:RoomPlayerInfo in players)
			{
				if(!p.isReady)
				{
					return false;
				}
			}
			return true;
		}
		
		public function isTeamBalance():Boolean
		{
			var count1:int = 0;
			var count2:int = 0;
			for each(var player:RoomPlayerInfo in players)
			{
				if ( player.team == 1 )
				{
					count1+=1;
				}
				else
				{
					count2+=1;
				}
			}
			return count1 >= 1 && count2 >= 1; 
//			return ( count1 == count2 );
		}
		
		/**
		 * 所有队员是否为同一工会 
		 * @return true 是 false 不是
		 * 
		 */		
		public function isAllPlayerConsortia():Boolean
		{
			//目前禁用掉工会站
			var clubId:int = PlayerManager.Instance.Self.ConsortiaID;
			for each(var info:RoomPlayerInfo in players)
			{
				if(info.info.ConsortiaID != clubId)
				{
					return false;
				}
			}
			return true;
		}
		
		/**
		 * 能否开始工会战 
		 * @return true 能 false 不能
		 * 
		 */		
		public function canStartConsortiaFight():Boolean
		{
			//目前禁用掉工会站
			if(players.length <2) return false;
			//if(PlayerManager.SelfConsortiaPlayer.ConsortiaLevel < 3) return false;
			var clubId:int = PlayerManager.Instance.Self.ConsortiaID;
			for each(var info:RoomPlayerInfo in players)
			{
				if(info.info.ConsortiaID != clubId || info.info.Grade < 5)
				{
					return false;
				}
			}
			return true;
		}
		/**
		 * 通过Object更新房间内所有玩家状态
		 * @param states
		 * 
		 */		
		public function updatePlayerStateByObj(obj:Object):void
		{
			var p:RoomPlayerInfo = players[obj.id];
			if(p)
			{
				if(!(p.isHost))
				{
					p.setRoomState(int(obj.state));
				}
			}
			else
			{
				return;
			}
			if(p.isHost)
			{
				if(!isPlaying)
				{
					tryStartGame();
				}
			}
			else
			{
				if(p.isSelf)
				{
					if(p.isReady)
					{
						roomState = STATE_READY;
					}
					else
					{
						roomState = STATE_UNREADY;
					}
				}
			}
			
			if(PlayerManager.selfRoomPlayerInfo.isHost)
			{
				tryStartGame();
			}
		}
		
		/**
		 * 通过数组更新房间内所有玩家状态
		 * @param states
		 * 
		 */		
		public function updatePlayerState(states:Array):void
		{
			var self:RoomPlayerInfo = null;
			for each(var p:RoomPlayerInfo in players)
			{
				p.setRoomState(states[p.roomPos]);
				if(p.isSelf)
				{
					self = p;
				}
			}
			if(self.isHost)
			{
				if(!isPlaying)
				{
					tryStartGame();
				}
			}
			else
			{
				if(self.isReady)
				{
					roomState = STATE_READY;
				}
				else
				{
					roomState = STATE_UNREADY;
				}
			}
		}
		
		public function updatePlayerTeam(id:int,team:int,place:int):void
		{
			var p:RoomPlayerInfo = players[id];
			if(p)
			{
				p.team = team;
				p.roomPos = place;
				tryStartGame();
			}
		}
		
		public function pickupFailed():void
		{
			isPlaying = false;
			roomState = STATE_READY;
		}
		/**
		 *存训练战胜利玩家和失败玩家ID 
		 */	
		private var _defyInfo:Array;
		public function get defyInfo():Array
		{
			return _defyInfo;
		}
		
		public function set defyInfo(value:Array):void
		{
			_defyInfo = value;
		}
		
		public function startPickup():void
		{
			isPlaying = true;
			roomState = STATE_PICKING;
		}
		
		public function cancelPickup():void
		{
			isPlaying = false;
			var p:RoomPlayerInfo = players[PlayerManager.Instance.Self.ID];
			if(p && p.isHost)
			{
				tryStartGame();
			}
			else
			{
				roomState = (p.isReady ? STATE_READY : STATE_UNREADY);
			}
		}
		
		public function dispose():void
		{
			if(players)
				players.clear();
		}
		
		public function startLoading(g:GameInfo):void
		{
			isPlaying = true;
			resetReadyStates();
			roomState = STATE_LOADING;
			dispatchEvent(new RoomEvent(RoomEvent.START_LOADING));
			if(roomType == 0)
			{
				if(g.gameType == 0)
				{
					ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("ddt.data.RoomInfo.BeginFree"));
				}
				else
				{
					ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("ddt.data.RoomInfo.BeginClub"));
				}
			}
		}
	}
}