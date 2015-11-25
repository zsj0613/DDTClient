package ddt.data
{
	public class HotSpringRoomInfo
	{
		private var _roomID:int;
		private var _roomNumber:int;
		private var _roomType:int;
		private var _roomName:String;
		private var _playerID:int;
		private var _playerName:String;
		private var _roomIsPassword:Boolean;
		private var _roomPassword:String;
		private var _effectiveTime:int;
		private var _maxCount:int;
		private var _curCount:int;
		private var _mapIndex:int;
		private var _startTime:Date;
		private var _breakTime:Date;
		private var _roomIntroduction:String;
		private var _serverID:int;
		
		/**
		 * 取得房间ID
		 */		
		public function get roomID():int
		{
			return _roomID;
		}
		
		/**
		 * 设置房间ID
		 */		
		public function set roomID(value:int):void
		{
			_roomID=value;
		}
		
		/**
		 * 取得房间类型(1=普通公共房间(金币房), 2=高级公共房间(2元房)，3=私有(8元房/16元房))
		 */		
		public function get roomType():int
		{
			return _roomType;
		}
		
		/**
		 * 设置房间类型(1=普通公共房间(金币房), 2=高级公共房间(2元房)，3=私有(8元房/16元房))
		 */		
		public function set roomType(value:int):void
		{
			_roomType=value;
		}
		
		/**
		 * 取得房间名称
		 */		
		public function get roomName():String
		{
			return _roomName;
		}
		
		/**
		 * 设置房间名称
		 */		
		public function set roomName(value:String):void
		{
			_roomName=value;
		}
		
		/**
		 * 取得创建者玩家ID
		 */		
		public function get playerID():int
		{
			return _playerID;
		}
		
		/**
		 * 设置创建者玩家ID
		 */		
		public function set playerID(value:int):void
		{
			_playerID=value;
		}
		
		/**
		 * 取得创建者玩家名称
		 */		
		public function get playerName():String
		{
			return _playerName;
		}
		
		/**
		 * 设置创建者玩家名称
		 */		
		public function set playerName(value:String):void
		{
			_playerName=value;
		}		
		
		/**
		 * 取得房间是否有密码
		 */	
		public function get roomIsPassword():Boolean
		{
			return _roomIsPassword;
		}
		
		/**
		 * 设置房间是否有密码
		 */		
		public function set roomIsPassword(value:Boolean):void
		{
			_roomIsPassword=value;
		}
		
		/**
		 * 取得房间密码
		 */		
		public function get roomPassword():String
		{
			return _roomPassword;
		}
		
		/**
		 * 设置房间密码
		 */		
		public function set roomPassword(value:String):void
		{
			_roomPassword=value;
			_roomIsPassword=(_roomPassword && _roomPassword!="" && _roomPassword.length>0);
		}
		
		/**
		 * 取得房间有效时间(分钟)
		 */		
		public function get effectiveTime():int
		{
			return _effectiveTime;
		}
		
		/**
		 * 设置房间有效时间(分钟)
		 */
		public function set effectiveTime(value:int):void
		{
			_effectiveTime=value;
		}	
		
		/**
		 * 取得房间最大容纳玩家数
		 */		
		public function get maxCount():int
		{
			return _maxCount;
		}
		
		/**
		 * 设置房间最大容纳玩家数
		 */		
		public function set maxCount(value:int):void
		{
			_maxCount=value;
		}
		
		/**
		 * 取得房间当前玩家数
		 */		
		public function get curCount():int
		{
			return _curCount;
		}
		
		/**
		 * 设置房间当前玩家数
		 */		
		public function set curCount(value:int):void
		{
			_curCount=value;
		}
		
		/**
		 * 取得房间开始时间
		 */		
		public function get startTime():Date
		{
			return _startTime;
		}
		
		/**
		 * 设置房间开始时间
		 */		
		public function set startTime(value:Date):void
		{
			_startTime=value;
		}
		
		/**
		 * 取得房间中止时间
		 */		
		public function get breakTime():Date
		{
			return _breakTime;
		}
		
		/**
		 * 设置房间中止时间
		 */		
		public function set breakTime(value:Date):void
		{
			_breakTime=value;
		}	
		
		/**
		 * 取得房间介绍
		 */		
		public function get roomIntroduction():String
		{
			return _roomIntroduction;
		}
		
		/**
		 * 设置房间介绍
		 */		
		public function set roomIntroduction(value:String):void
		{
			_roomIntroduction = value;
		}
		
		/**
		 * 取得房间所在频道ID
		 */		
		public function get serverID():int
		{
			return _serverID;
		}
		
		/**
		 * 设置房间所在频道ID
		 */	
		public function set serverID(value:int):void
		{
			_serverID = value;
		}
		
		/**
		 * 取得房间编号
		 */		
		public function get roomNumber():int
		{
			return _roomNumber;
		}
		
		/**
		 * 设置房间编号
		 */		
		public function set roomNumber(value:int):void
		{
			_roomNumber = value;
		}
	}
}