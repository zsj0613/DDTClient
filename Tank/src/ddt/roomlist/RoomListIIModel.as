package ddt.roomlist
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import road.data.DictionaryData;
	
	import ddt.data.SimpleRoomInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.RoomPlayerInfo;
	import ddt.manager.PlayerManager;
	
	public class RoomListIIModel extends EventDispatcher implements IRoomListIIModel
	{
		public static const ROOMSHOWMODE_CHANGE:String = "roomshowmodechange";
		
		private var _roomList:DictionaryData;
		private var _playerlist:DictionaryData;
		private var _self:PlayerInfo;
		private var _roomTotal:int;
		/**
		 * showRoomMode : 0,showAll  1,showWaiting 
		 */		
		private var _roomShowMode:int;
		
		public function RoomListIIModel()
		{
			_roomList = new DictionaryData(true);
			_playerlist = new DictionaryData(true);
			_self = PlayerManager.Instance.Self;
			_roomShowMode = 1;
		}
		
		public function getSelfPlayerInfo():PlayerInfo
		{
			return _self;
		}
		private var _temListArray:Array;
		private var _isAddEnd:Boolean;
		
		public function get isAddEnd():Boolean
		{
			return _isAddEnd;
		}
		
		public function updateRoom(arr:Array):void
		{
			_roomList.clear();
			_isAddEnd = false;
			if(arr.length == 0)return;
			arr = RoomListIIController.disorder(arr);
			for(var i:int = 0 ; i < arr.length ;i ++)
			{
				if(i == arr.length - 1)_isAddEnd = true;
				_roomList.add((arr[i] as SimpleRoomInfo).ID,arr[i] as SimpleRoomInfo);
			}
		}
		
		public function set roomTotal(value:int):void
		{
			_roomTotal = value;
		}
		
		public function get roomTotal():int
		{
			return _roomTotal;
		}
		
		public function getRoomById(id:int):SimpleRoomInfo
		{
			return _roomList[id];
		}
		
		public function getRoomList():DictionaryData
		{
			return _roomList;
		}
		
		public function addWaitingPlayer(info:PlayerInfo):void
		{
			_playerlist.add(info.ID,info);
		}
		
		public function removeWaitingPlayer(id:int):void
		{
			_playerlist.remove(id);
		}
		
		public function getPlayerList():DictionaryData
		{
			return _playerlist;
		}
		
		public function get roomShowMode():int
		{
			return _roomShowMode;
		}
		
		public function set roomShowMode(value:int):void
		{
//			if(_roomShowMode == value)return;
			_roomShowMode = value;
			dispatchEvent(new Event(ROOMSHOWMODE_CHANGE));
		}
		
		public function dispose():void
		{
			_roomList = null;
			_playerlist = null;
			_self = null;
		}
	}
}