package ddt.manager
{
	import flash.events.EventDispatcher;
	
	import road.comm.PackageIn;
	
	import ddt.data.HotSpringRoomInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.events.HotSpringEvent;
	import ddt.states.StateType;
	
	public class HotSpringManager extends EventDispatcher
	{
		private var _roomCurrently:HotSpringRoomInfo;
		private var _playerEffectiveTime:int;//当前玩家所在房间的有效时间
		private var _playerEnterRoomTime:Date;//玩家进入当前房间时间
		
		private static var  _instance:HotSpringManager;
		public static function get instance():HotSpringManager
		{
			if(!_instance)
			{
				_instance = new HotSpringManager();
			}
			return _instance;
		}
		
		public function setup():void
		{
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_ENTER,roomEnterSucceed);//成功进入房间
		}
		
		public function get roomCurrently():HotSpringRoomInfo
		{
			return _roomCurrently;
		}
		
		public function set roomCurrently(value:HotSpringRoomInfo):void
		{
			if(value && (!_roomCurrently || _roomCurrently.roomID!=value.roomID))
			{//如果设置的当前房间不是玩家所在的当前房间，则执行让玩家进入房间方法
				_roomCurrently=value;
				roomEnter();
				return;
			}
			_roomCurrently=value;
		}
		
		/**
		 * 成功进入房间
		 */		
		private function roomEnterSucceed(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			var hotSpringRoomInfo:HotSpringRoomInfo=new HotSpringRoomInfo();
			hotSpringRoomInfo.roomID=pkg.readInt();
			hotSpringRoomInfo.roomNumber=pkg.readInt();//房间编号
			hotSpringRoomInfo.roomName=pkg.readUTF();
			hotSpringRoomInfo.roomPassword=pkg.readUTF();
			hotSpringRoomInfo.effectiveTime=pkg.readInt();//房间的有效剩余时间
			hotSpringRoomInfo.curCount=pkg.readInt();
			hotSpringRoomInfo.playerID=pkg.readInt();
			hotSpringRoomInfo.playerName=pkg.readUTF();
			hotSpringRoomInfo.startTime=pkg.readDate();
			hotSpringRoomInfo.roomIntroduction=pkg.readUTF();
			hotSpringRoomInfo.roomType=pkg.readInt();
			hotSpringRoomInfo.maxCount=pkg.readInt();
			_playerEnterRoomTime=pkg.readDate();//玩家进入当前房间时间
			_playerEffectiveTime=pkg.readInt();//当前玩家所在房间的有效时间(只对公共房间有效，其它类型房间值为0)
			
			roomCurrently=hotSpringRoomInfo;
		}
		
		/**
		 * 进入房间
		 */		
		private function roomEnter():void
		{
			StateManager.setState(StateType.HOT_SPRING_ROOM);
		}
		
		/**
		 * 当前玩家所在房间的有效时间
		 */		
		public function get playerEffectiveTime():int
		{
			return _playerEffectiveTime;
		}
		
		/**
		 * 当前玩家所在房间的有效时间
		 */		
		public function set playerEffectiveTime(value:int):void
		{
			_playerEffectiveTime = value;
		}

		/**
		 * 玩家进入当前房间时间
		 */		
		public function get playerEnterRoomTime():Date
		{
			return _playerEnterRoomTime;
		}

		/**
		 * 玩家进入当前房间时间
		 */		
		public function set playerEnterRoomTime(value:Date):void
		{
			_playerEnterRoomTime = value;
		}
	}
}