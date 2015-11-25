package ddt.roomlist
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.roomlistII.RoomListIISceondTypeAsset;
	
	public class RoomListIISecondTipPanel extends RoomListIISortTipPanel
	{
		public function RoomListIISecondTipPanel(controller:IRoomListBGView)
		{
			var data:Array;
			data=[{type:"round",index:0},{type:"round",index:1},{type:"round",index:2}];
			super(controller,data);
		}
		
		override protected function configUI():void
		{
			cellWidth = 63;
			cellHeight = 25;
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
			return new RoomListIITipItem(new RoomListIISceondTypeAsset(),data);
		}
		
		private var _index:int;
		override protected function __itemClick(evt:MouseEvent):void
		{
			super.__itemClick(evt);
			_index = (evt.currentTarget as RoomListIITipItem).info["index"];
			_controller.sortT(_controller.dataList.list,"timeType",_index);
			_controller.updateList();
//			timeType
//			_controller.roomlist.sortByCustom(sort);
		}
		
//		private function sort(items:Array):void
//		{
//			_controller.sortT(items,"roundType",_index);
//		}
	}
}