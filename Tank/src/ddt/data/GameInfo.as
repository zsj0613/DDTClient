package ddt.data
{
	import flash.events.EventDispatcher;
	
	import road.data.DictionaryData;
	
	import ddt.data.game.Living;
	import ddt.data.game.LocalPlayer;
	import ddt.data.game.Player;
	import ddt.data.player.RoomPlayerInfo;
	import ddt.events.ArrayChangeEvent;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.loader.MapLoader;
	import ddt.states.StateType;
	
	public class GameInfo extends EventDispatcher
	{
		public static const ADD_ROOM_PLAYER:String = "addRoomPlayer";
		public static const REMOVE_ROOM_PLAYER:String = "removeRoomPlayer";
		
		public var mapIndex:int;
		
		/**
		 * 房间类型，自由 1 撮合 0 ，2探险，3 BOSS战，4夺宝  
		 */		
		public var roomType:int;
//		public var teamType:int;
		/**
		 * 战斗类型. 1为PVP   5为PVE 
		 */
		 /**
		 * 战斗类型.   
		 * 0 公会自由
		 * 1 公会战
		 * 2 训练战
		 * 3 
		 * 4
		 * 5 探险
		 * 6 BOSS战
		 * 7 夺宝
		 */		
		private var _gameType:int;
		public function set gameType(value:int):void{
			_gameType = value;
		}
		public function get gameType():int{
			return _gameType;
		}
		public var timeType:int;
		public var maxTime:int;
		public var loaderMap:MapLoader;
		
		private var _resultCard:Array = [];
		public function get resultCard():Array
		{
			return _resultCard;
		}
		public function set resultCard(arr:Array):void
		{
			_resultCard = arr;
		}
//		public var resultCard:Array = new Array();
		public var showAllCard:Array = new Array();
		public var startEvent:CrazyTankSocketEvent;
		public var GainRiches:int;
		public var PlayerCount:int;
		public var startPlayer:int;
		public var hasNextSession:Boolean;
		public var neededMovies:Array = new Array();
		private var _selfGamePlayer:LocalPlayer;
		
		
		public var roomPlayers:Array = [];
//		public var gamePlayers:DictionaryData = new DictionaryData();
		public var livings:DictionaryData = new DictionaryData();
		
		public var missionInfo:MissionInfo;
		public var dungeonInfo:DungeonInfo;
		public var missionCount:int;
		
		public var gameOverNpcMovies:Array = [];
		public function addGamePlayer(info:Living):void
		{
			var p:Living = livings[info.LivingID];
			if(p)
			{
				p.dispose();
			}
			if(info is LocalPlayer) _selfGamePlayer = info as LocalPlayer;
			livings.add(info.LivingID,info);
		}
		
		public function removeGamePlayer(livingID:int):Living
		{
			var info:Living = livings[livingID];
			if(info)
			{
				livings.remove(livingID);
				info.dispose();
			}
			
			return info;
		}
		
		public function removeGamePlayerByPlayerID(zoneID:int,playerID:int):void
		{
			for each(var living:Living in livings)
			{
				if((living is Player) && living.playerInfo)
				{
					if(living.playerInfo.ZoneID == zoneID && living.playerInfo.ID == playerID)
					{
						livings.remove(living.LivingID);
						living.dispose();
					}
				}
			}
		}
		
		public function isAllReady():Boolean
		{
			var allReady:Boolean = true;
			for each(var info : Player in livings)
			{
				if(info.isReady == false)
				{
					allReady = info.isReady;
					break;
				}
			}
			
			return allReady;
		}
		
		public function findPlayer(livingID:int):Player
		{
			return livings[livingID] as Player;
		}
		/**
		 * 通过用户ID获取Player信息
		 * @param playerid
		 * @return 
		 * 
		 */		
		public function findPlayerByPlayerID(playerid:int):Player
		{
			for each(var i:Living in livings)
			{
				if(i.isPlayer() && (i.playerInfo.ID == playerid))
				{
					return i as Player;
				}
			}
			return null;
		}
		
		public function get haveAllias():Boolean{
			for each(var info:Living in this.livings){
				if(info.isLiving && info.team == selfGamePlayer.team){
					return true;
				}
			}
			return false;
		}
		
		
		public function findLiving(livingID:int):Living
		{
			return livings[livingID];
		}
		
		public function findLivingByPlayerID(playerID:int,zoneID:int):Living
		{
			for each(var living:Living in livings)
			{
				if((living is Player) && living.playerInfo)
				{
					if(living.playerInfo.ID == playerID && living.playerInfo.ZoneID == zoneID)
					{
						return living;
					}
				}
			}
			return null;
		}
		
		public function removeAllMonsters():void
		{
			for each(var living:Living in livings)
			{
				if(!(living is Player))
				{
					livings.remove(living.LivingID);
					living.dispose();
				}
			}
		}
		
		public function get selfGamePlayer():LocalPlayer
		{
			return _selfGamePlayer;
		}
		
		public function addRoomPlayer(info:RoomPlayerInfo):void
		{
			var index:int = roomPlayers.indexOf(info);
			if(index > -1)
			{
				removeRoomPlayer(info.info.ZoneID,info.info.ID);
			}
			roomPlayers.push(info);
			dispatchEvent(new ArrayChangeEvent(ADD_ROOM_PLAYER,[info]));
		}
		
		public function removeRoomPlayer(zoneID:int,playerID:int):void
		{
			var info:RoomPlayerInfo = findRoomPlayer(playerID,zoneID);
			if(info)
			{
				roomPlayers.splice(roomPlayers.indexOf(info),1);
			}
			dispatchEvent(new ArrayChangeEvent(REMOVE_ROOM_PLAYER,[info]));
		}
		
		public function findRoomPlayer(userID:int,zoneID:int):RoomPlayerInfo
		{
			for each(var rp:RoomPlayerInfo in roomPlayers)
			{
				if(rp.info == null) continue;
				if(rp.info.ID == userID && rp.info.ZoneID == zoneID)
				{
					return rp;
				}
			}
			return null;
		}
		
		private var _wind:Number = 0;
		/**
		 *  
		 * @param value
		 * @param isSelfTurn 是否为自己的回合，需手动设置
		 * 
		 */		
		public function setWind(value:Number,isSelfTurn:Boolean=false):void
		{
			_wind = value;
			dispatchEvent(new GameEvent(GameEvent.WIND_CHANGED,{wind:_wind,isSelfTurn:isSelfTurn}));
		}
		
		public function get wind():Number
		{
			return _wind;
		}
		
		private var _hasNextMission:Boolean;
		public function get hasNextMission():Boolean
		{
			return _hasNextMission;
		}
		
		public function set hasNextMission(value:Boolean):void
		{
			if(_hasNextMission == value) return;
			_hasNextMission = value;
		}
		
		public function resetResultCard():void
		{
			_resultCard = [];
		}
//		private var _hasTakeCard:Boolean;
//		public function get hasTakeCard():Boolean
//		{
//			return _hasTakeCard;
//		}
//		public function set hasTakeCard(val:Boolean):void
//		{
//			if(_hasTakeCard == val) return;
//			_hasTakeCard = val;
//		}
		
		public function dispose():void
		{
			if(roomPlayers)
			{
				roomPlayers = null;
			}
			if(livings)
			{
				livings.clear();
			}
			if(_resultCard)
			{
				_resultCard = [];
			}
			
			missionInfo = null;
			dungeonInfo = null;
		}
		
	}
}