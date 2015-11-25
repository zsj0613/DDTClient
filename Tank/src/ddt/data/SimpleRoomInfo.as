package ddt.data
{
	import flash.events.EventDispatcher;
	
	import ddt.events.RoomEvent;
	import tank.fightLibChooseFightLibTypeView.BookShine;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MapManager;
	import ddt.manager.PlayerManager;
	import ddt.states.StateType;
	
	[Event(name = "changed", type = "ddt.events.RoomEvent")]
	public class SimpleRoomInfo extends EventDispatcher
	{
		public var ID:Number;
		
		public var Name:String;
		
		public var IsLocked:Boolean;
		
		private var _totalPlayer:int;
		
		public static const PVE_GAME_MODE:int = 5;
		public static const PVP_GAME_MODE:int = 1;
		public function get totalPlayer():int
		{
			return _totalPlayer;
		}
		public function set totalPlayer(value:int):void
		{
			if(_totalPlayer == value) return;
			_totalPlayer = value;
			update();
		}
		
		private var _placeCount:int;
		public function get placeCount():int
		{
			return _placeCount;
		}
		public function set placeCount(value:int):void
		{
			if(_placeCount == value) return;
			_placeCount = value;
			update();
		}
		
		private var _isPlaying:Boolean;
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		public function set isPlaying(value:Boolean):void
		{
			if(_isPlaying == value)return;
			_isPlaying = value;
			update();
		}
		
		/**
		 * 房间类型，自由 1 撮合 0 ，2探险，3 BOSS战，4夺宝  5作战实验室
		 * 
		 */		
		private var _roomType:int;
		public function get roomType():int
		{
			return _roomType;
		}
		public function set roomType(value:int):void
		{
			if(_roomType == value) return;
			_roomType = value;
			update();
		}
		
		public var frightMatchWithNPC:Boolean;
		
		public function get isPVPRoom():Boolean
		{
			return _roomType <= 1;
		}
		
		public function get isPVERoom():Boolean
		{
			return _roomType >=2;
		}
		
		private var _backRoomListType:String;

		public function set backRoomListType(value:String):void{
			_backRoomListType = value;
		}
		public function get backRoomListType():String{
			if(_backRoomListType){
				return _backRoomListType;
			}
			if(_roomType <= 2){
				return StateType.ROOM_LIST;
			}
			return StateType.DUNGEON;
		}
		
		/**
		 * 战斗类型.   
		 * 0 自由
		 * 1 公会战
		 * 2 训练战
		 * 3 
		 * 4
		 * 5 探险
		 * 6 BOSS战
		 * 7 夺宝
		 * 9 撮合NPC
		 */		
		private var _gameMode:int;
		public function get gameMode():int
		{
			return _gameMode;
		}
		public function set gameMode(value:int):void
		{
			if(_gameMode == value)return;
			_gameMode = value;
			update();
		}
		
		/**
		 * 时间类型. 1:5秒, 2:7秒, 3:10秒。 
		 */		
		private var _timeType:int;
		public function get timeType():int
		{
			return _timeType;
		}
		public function set timeType(value:int):void
		{
			if(_timeType == value)return;
			_timeType = value;
			update();
		}
		
		/**
		 *难度等级 
		 */		
		private var _hardLevel:int
		public function get hardLevel():int
		{
			return _hardLevel;
		}
		public function set hardLevel(level:int):void
		{
			if(_hardLevel == level) return;
			_hardLevel = level;
			update();
		}
		
		public function getDifficulty(hardlevel:int):String
		{
			switch(hardlevel)
			{
				case 0:
					return LanguageMgr.GetTranslation("ddt.room.difficulty.simple");
//					return "简单";
				case 1:
					return LanguageMgr.GetTranslation("ddt.room.difficulty.normal");
//					return "普通";
				case 2:
					return LanguageMgr.GetTranslation("ddt.room.difficulty.hard");
//					return "困难";
				case 3:
					return LanguageMgr.GetTranslation("ddt.room.difficulty.hero");
//					return "英雄";
			}
			
			return "";
		}
		
		
		private var bIsRandMap:Boolean = true;			//TRUE:随即地图   flase:反之
		public function set isRandMap(b:Boolean):void
		{
			bIsRandMap = b;
		}
		public function get isRandMap():Boolean
		{
			return bIsRandMap;
		}
		
		private var _mapId:int = 0;
		public function get mapId():int
		{
			if(_roomType >= 2 && _mapId == 0)
			{
				_mapId = 10000;
			}
			return _mapId;
		}
		public function set mapId(value:int):void
		{	
			if(value == _mapId) return;
			_mapId = value;
			if ( _mapId == 0 ) 
			{
				this.isRandMap = true;
			}
			else
			{
				this.isRandMap = false;
			}
			
			update();
		}
		
		public function get mapInfo():MapInfo
		{
			return MapManager.getMapInfo(_mapId);
		}
		
		public function get dungeonInfo():DungeonInfo
		{
			return MapManager.getDungeonInfo(_mapId);
		}
		
		//撮合战 游戏类型  0:自由站   1：工会战     2:全部
		private var _gameStyle:int = 0;
		public function get gameStyle():int
		{
			return _gameStyle;
		}
		public function set gameStyle(style:int):void
		{
//			if ( _gameStyle != style )
//			{
//				_gameStyle = style;
//				update();
//			}
			_gameStyle = style;
			update();
		}
		public var isServer : int = 0;
		 
		
		/**
		 *  0 自由 10 撮合自用 11 撮合工会，这个与roomType的值有些相反，因为按roomType值排列不好设置值。
		 */		
		public function get roomTypeString():int
		{
			return _roomType == 1  ?  0 : (_gameStyle == 0 ?  10 : 11);
		}
		
		protected function update():void
		{
			dispatchEvent(new RoomEvent(RoomEvent.CHANGED));
		}
		
		/**
		 * 难度
		 * 0 简单 * 1 普通 * 2 困难	 * 3 噩梦
		 */
//		private var _permission : int;
//		public function set permission(p : int) : void
//		{
//			_permission = p;
//			update();
//		} 
//		public function get permission() : int
//		{
//			return _permission;
//		}
		
		private var _levelLimits : int;
		public function set levelLimits(i : int) : void
		{
			_levelLimits = i;
			update();
		}
		public function get levelLimits() : int
		{
			return _levelLimits;
		}
		public function get selfLevelLimits() : int
		{
			var grade : int = PlayerManager.Instance.Self.Grade;
			if(grade < 11)
			{
				return 1;
			}
			else if(grade < 16)
			{
				return 2;
			}
			else if(grade < 26)
			{
				return 3;
			}
			else if(grade < 31)
			{
				return 4;
			}
			else
			{
				return 5;
			}
		}
	}
}