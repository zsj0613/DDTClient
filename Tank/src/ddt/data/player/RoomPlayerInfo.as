package ddt.data.player
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import ddt.data.DeputyWeaponInfo;
	import ddt.data.WeaponInfo;
	import ddt.data.WebSpeedInfo;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.events.RoomEvent;
	import ddt.manager.ItemManager;
	import ddt.view.characterII.CharactoryFactory;
	import ddt.view.characterII.GameCharacter;
	import ddt.view.characterII.ICharacter;
	import ddt.view.characterII.ShowCharacter;
	
	public class RoomPlayerInfo extends EventDispatcher
	{
		
		public function RoomPlayerInfo(player:PlayerInfo)
		{
			_info = player;
			initEvent();
			super();
			webSpeedInfo = new WebSpeedInfo(_info.webSpeed);
			setWeaponInfo();
			setDeputyWeaponInfo();
		}
		
		private function initEvent():void
		{
			_info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__playerPropChanged);
		}
		
		private function removeEvent():void
		{
			_info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__playerPropChanged);
		}
		
		private function __playerPropChanged(event:PlayerPropertyEvent):void
		{
			if(event.changedProperties["Grade"])
			{
				isUpGrade = _info.IsUpdate;
			}
		}
		
		/* 经验，功勋，财富加成信息 */
		private var _additionInfo:PlayerAdditionInfo = new PlayerAdditionInfo();
		public function get AdditionInfo():PlayerAdditionInfo
		{
			return _additionInfo;
		}
		
		private var _info:PlayerInfo;
		public function get info():PlayerInfo
		{
			return _info;
		}
		
		public var webSpeedInfo:WebSpeedInfo;
		
		public function get isSelf():Boolean
		{
			return _info is SelfInfo;
		}
		
		/**
		 * 房间中的位置 
		 */
		private var _roomPos:uint;
		
		public function get roomPos():uint
		{
			return _roomPos;
		}
		
		public function set roomPos(pos:uint):void
		{
			if(pos != _roomPos)
			{
				_roomPos = pos;
				dispatchEvent(new RoomEvent(RoomEvent.ROOMPLACE_CHANGED));
			}
		}
		
		/**
		 * 是否准备　玩家状态 0 未准备 1 准备 2房主
		 */		
		private var _roomState:int;
		public function setRoomState(value:int):void
		{
			if(_roomState == value) return;
			_roomState = value;
			dispatchEvent(new RoomEvent(RoomEvent.PLAYER_STATE_CHANGED));
		}
		
		public function get isHost():Boolean
		{
			return _roomState == 2;
		}
		
		public function get isReady():Boolean
		{
			return _roomState > 0;
		}
		
		public function hasWeapon():Boolean
		{
			return _info.WeaponID > 0;
		}
		
		public function hasDeputyWeapon():Boolean
		{
			return _info.DeputyWeaponID > 0;
		}
		
		/**
		 * 队伍信息 
		 */		
		private var _team:int;
		public function get team():int
		{
			return _team;
		}
		public function set team(value:int):void
		{
			if(value == _team || value <1 || value > 8) return;
			_team = value;
			dispatchEvent(new RoomEvent(RoomEvent.TEAM_CHANGE));
		}
		
		public function resetReady():void
		{
			if(!isHost)
			{
				_roomState = 0;
			}
		}
		
		
		private var _character:ShowCharacter;
		public function get character():ShowCharacter
		{
			if(info == null)return null;
			if(shouldReloadShowCharacter())
			{
				if(_character)_character.dispose();
				_character = CharactoryFactory.createCharacter(info) as ShowCharacter;
				_character.show();
			}
			return _character;
		}
		
		public function getCurrentCharacter():ICharacter
		{
			return _character;
		}
		
		public function resetCharacter():void
		{
			character.x = 0;
			character.y = 0;
			character.doAction(ShowCharacter.STAND);
		}
		
		private var _movie:GameCharacter;
		public function get movie():GameCharacter
		{
			return _movie;
		}
		public function set movie(value:GameCharacter):void
		{
			if(_movie == value) return;
			if(_movie)
				_movie.dispose();
			_movie = value;
		}
		private var _gameStyleRecord:String;
		private var _showStyleRecord:String;
		private var _gameColorsRecord:String;
		private var _showColorsRecord:String;
		public function shouldReloadGameCharacter():Boolean
		{
			if(_movie == null || _gameStyleRecord != info.Style || _gameColorsRecord != info.Colors)
			{
				_gameStyleRecord = info.Style;
				_gameColorsRecord = info.Colors;
				return true;
			}
			return false;
		}
		public function shouldReloadShowCharacter():Boolean
		{
			if(_character == null || _showStyleRecord != info.Style || _showColorsRecord != info.Colors)
			{
				_showStyleRecord = info.Style;
				_showColorsRecord = info.Colors;
				return true;
			}
			return false;
		}
		
		public var isUpGrade:Boolean = false;
		
		/**
		 * 房间loading加载进度 
		 */		
		private var _loadingProgress:int;
		public function get loadingProgress():int
		{
			if(!(_loadingProgress > 0))return 0;
			return _loadingProgress;
		}
		public function set loadingProgress(value:int):void
		{
			_loadingProgress = value;
			dispatchEvent(new RoomEvent(RoomEvent.LOADING_PROGRESS));
		}
		
		public function resetLoadingProgress():void
		{
			_loadingProgress = 0;
		}
		
		public function setWeaponInfo():void
		{
			var iteminfo:InventoryItemInfo = new InventoryItemInfo();
			iteminfo.TemplateID = _info.WeaponID;
			ItemManager.fill(iteminfo);
			_currentWeapInfo = new WeaponInfo(iteminfo);
		}
		
		/**
		 *当前的武器 
		 */		
		private var _currentWeapInfo:WeaponInfo;
		public function get currentWeapInfo():WeaponInfo
		{
			return _currentWeapInfo;
		}
		
		public function setDeputyWeaponInfo():void
		{
			var iteminfo:InventoryItemInfo = new InventoryItemInfo();
			iteminfo.TemplateID = _info.DeputyWeaponID;
			ItemManager.fill(iteminfo);
			_currentDeputyWeaponInfo = new DeputyWeaponInfo(iteminfo);
		}

		private var _currentDeputyWeaponInfo:DeputyWeaponInfo
		public function get currentDeputyWeaponInfo():DeputyWeaponInfo
		{
			return _currentDeputyWeaponInfo;
		}
			
		
		public function dispose():void
		{
			removeEvent();
			
			if(_character)_character.dispose();
			_character = null;
			if(_movie) _movie.dispose();
			_movie = null;
			webSpeedInfo = null;
			if(_currentWeapInfo)_currentWeapInfo.dispose(); 
			_currentWeapInfo = null;
			if(_currentDeputyWeaponInfo)_currentDeputyWeaponInfo.dispose();
			_currentDeputyWeaponInfo = null;
			_info = null;
		}
	}
}