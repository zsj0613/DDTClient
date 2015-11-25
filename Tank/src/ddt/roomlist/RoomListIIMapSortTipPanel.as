package ddt.roomlist
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import ddt.data.DungeonInfo;
	import ddt.data.MapInfo;
	import ddt.game.map.MapSmallIcon;
	import ddt.manager.MapManager;
	import ddt.manager.SocketManager;
	
	public class RoomListIIMapSortTipPanel extends RoomListIISortTipPanel
	{
		private var data:Array;
		public function RoomListIIMapSortTipPanel(controller:IRoomListBGView)
		{
			data = new Array();
			_controller = controller;
			if(_controller && _controller.IsPve)
			{
				for each(var M:DungeonInfo in MapManager.getListByType(MapManager.PVE_LINK_MAP))
				{
					data.push({type:"map",index:M.ID});
				}
			}else
			{
				for each(var m:Object in MapManager.getListByType(MapManager.PVP_MAP))
				{
					if(m is MapInfo)
					{
						if(m.isOpen)
						{
							data.push({type:"map",index:m.ID});
						}
					}else if(m is DungeonInfo)
					{
						data.push({type:"map",index:m.ID});
					}
				}		
			}
			super(_controller,data);
		}
		
		override protected function configUI():void
		{
			cellWidth = 103;
			cellHeight = 26;
			super.configUI();
			for(var i:int = 0; i < _data.length; i++)
			{
				var T:Sprite = createItem(_data[i]);
				appendItem(T);
				T.addEventListener(MouseEvent.CLICK,__itemClick);
				T.addEventListener(MouseEvent.MOUSE_OVER, __itemMouseOver);
				T.addEventListener(MouseEvent.MOUSE_OUT, __itemMouseOut);
			}
		}
		
		override protected function createItem(data:*):Sprite
		{
			return new RoomListIITipItem(new MapSmallIcon(),data);
		}
		
		private function __itemMouseOver(evt : MouseEvent) : void
		{
			var t : Sprite = evt.target as Sprite;
			t.graphics.beginFill(0xFFFFFF,.7);
			t.graphics.drawRect(0,0,165,26);
			t.graphics.endFill();
		}
		
		private function __itemMouseOut(evt : MouseEvent) : void
		{
			var t : Sprite = evt.target as Sprite;
			t.graphics.clear();
		}
		
		private var _index:int;
		override protected function __itemClick(evt:MouseEvent):void
		{
			super.__itemClick(evt);
			_index = (evt.currentTarget as RoomListIITipItem).info["index"];
			_controller.sortT(_controller.dataList.list,"mapId",_index);
			_controller.updateList();
			SocketManager.Instance.out.sendUpdateRoomList(lookupEnumerate.ROOM_LIST,_index);
		}
		
	}
}