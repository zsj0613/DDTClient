package ddt.roomlist
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.roomlistII.RoomListIIModeTypeAsset;
	import game.crazyTank.view.roomlistII.RoomListIIModeTypeIIAsset;
	
	import ddt.manager.SocketManager;
	
	public class RoomListIIModeSortTipPanel extends RoomListIISortTipPanel
	{
		public function RoomListIIModeSortTipPanel(controller:IRoomListBGView)
		{
			var data:Array;
			_controller = controller;
			if(_controller && _controller.IsPve)
			{
				data=[{type:"mode",index:5},{type:"mode",index:6},{type:"mode",index:7},{type:"mode",index:8}];
			}else
			{
				data=[{type:"mode",index:1}];
			}
			super(controller,data);
		}
		
		override protected function configUI():void
		{
			cellWidth = 63;
			cellHeight = 27;
			super.configUI();
			if(_controller && _controller.IsPve)
			{
				for(var i:int = 0; i < _data.length; i++)
				{
					var t:Sprite = createItem(_data[i]);
					appendItem(t);
					t.addEventListener(MouseEvent.CLICK,__itemClick);
				}
			}else
			{
				for(var j:int = 0;j<_data.length;j++)
				{
					var T:Sprite = createItem(_data[j]);
					appendItem(T);
					T.addEventListener(MouseEvent.CLICK,__itemClick);
				}
			}
		}
		
		override protected function createItem(data:*):Sprite
		{
			var sprite:Sprite;
			if(_controller && _controller.IsPve)
			{
				return new RoomListIITipItem(new RoomListIIModeTypeIIAsset(),data);
			}else
			{
				return new RoomListIITipItem(new RoomListIIModeTypeAsset(),data);
			}
		}
		
		private var _index:int;
		override protected function __itemClick(evt:MouseEvent):void
		{
			super.__itemClick(evt);
			_index = (evt.currentTarget as RoomListIITipItem).info["index"];
			_index-=5;
			_controller.sortT(_controller.dataList.list,"hardLevel",_index);
			_controller.updateList();
			if(_controller.IsPve)
			{
				SocketManager.Instance.out.sendUpdateRoomList(lookupEnumerate.DUNGEON_LIST,_index+1007);
			}else
			{
				SocketManager.Instance.out.sendUpdateRoomList(lookupEnumerate.ROOM_LIST,lookupEnumerate.ROOMLIST_DEFAULT);
			}
		}
	}
}