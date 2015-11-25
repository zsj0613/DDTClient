package ddt.church.weddingRoom
{
	import flash.display.Sprite;
	
	import road.data.DictionaryData;
	
	import ddt.data.ChurchRoomInfo;
	import ddt.events.ChurchRoomEvent;
	
	public class WeddingRoomModel extends Sprite
	{
		private var _roomList:DictionaryData;
		
		public function get roomList():DictionaryData
		{
			return _roomList;
		}
		
		public function WeddingRoomModel()
		{
			_roomList = new DictionaryData(true);
		}
		
		public function addRoom(info:ChurchRoomInfo):void
		{
			if(info)
			{
				_roomList.add(info.id,info);
			}
		}
		
		public function removeRoom(id:int):void
		{
			if(_roomList[id])
			{
				_roomList.remove(id);
			}
		}
		
		public function updateRoom(info:ChurchRoomInfo):void
		{
			if(info)
			{
				_roomList.add(info.id,info);
			}
		}
		
		public function dispose():void
		{
			_roomList = null;
		}
	}
}