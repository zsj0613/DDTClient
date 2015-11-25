package ddt.roomlist
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.roomlistII.RoomListIIRoomModeAsset;
	import game.crazyTank.view.roomlistII.RoomListIIRoomModeIIAsset;
	
	import ddt.manager.SocketManager;
	
	public class RoomListIIRoomModeTipSort extends RoomListIISortTipPanel
	{
		public function RoomListIIRoomModeTipSort(controller:IRoomListBGView)
		{
			var data:Array;
			_controller = controller;
			if(_controller && _controller.IsPve)
			{
				data=[{type:"roomType",index:3},{type:"roomType",index:4}];
			}else
			{
				data=[{type:"roomType",index:0},{type:"roomType",index:1}];
			}
			super(_controller,data);
			
			cellWidth = 85;
			cellHeight = 27;
		}

		override protected function configUI():void
		{
			cellWidth = 85;
			cellHeight = 27;
			super.configUI();
			for(var i:int = 0; i < _data.length; i++)
			{
				var t:Sprite = createItem(_data[i]);
				appendItem(t);
				t.addEventListener(MouseEvent.CLICK,__itemClick);
			}
		}
		
		override protected function createItem(data:*):Sprite
		{
			if(_controller && _controller.IsPve)
			{
				return new RoomListIITipItem(new RoomListIIRoomModeAsset(),data);
			}else
			{
				return new RoomListIITipItem(new RoomListIIRoomModeIIAsset(),data);
			}
		}
		
		private var _index:String;
		override protected function __itemClick(evt:MouseEvent):void
		{
			super.__itemClick(evt);
			_index = (evt.currentTarget as RoomListIITipItem).info["index"];
			_controller.sortT(_controller.dataList.list,"roomType",_index);
			_controller.updateList();
			switch(_index)
			{
				case "0":
					SocketManager.Instance.out.sendUpdateRoomList(lookupEnumerate.ROOM_LIST,lookupEnumerate.ROOMLIST_ATHLETICTICS);
				break;
				case "1":
					SocketManager.Instance.out.sendUpdateRoomList(lookupEnumerate.ROOM_LIST,lookupEnumerate.ROOMLIST_DEFY);
				break;
				case "2":
					SocketManager.Instance.out.sendUpdateRoomList(lookupEnumerate.ROOM_LIST,lookupEnumerate.ROOMLIST_EXPLORE);
				break;
				case "3":
					SocketManager.Instance.out.sendUpdateRoomList(lookupEnumerate.DUNGEON_LIST,lookupEnumerate.DUNGEON_LIST_BOOS);
				break;
				case "4":
					SocketManager.Instance.out.sendUpdateRoomList(lookupEnumerate.DUNGEON_LIST,lookupEnumerate.DUNGEON_LIST_DUNGEON);
				break;
			}
		}
	}
}