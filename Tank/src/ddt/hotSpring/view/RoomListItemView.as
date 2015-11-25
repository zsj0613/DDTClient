package ddt.hotSpring.view
{
	import flash.events.MouseEvent;
	
	import road.ui.controls.ISelectable;
	
	import ddt.data.HotSpringRoomInfo;
	import ddt.hotSpring.events.HotSpringRoomListEvent;
	import ddt.hotSpring.model.HotSpringRoomListModel;
	import tank.hotSpring.roomItemAsset;
	
	public class RoomListItemView extends roomItemAsset implements ISelectable
	{
		private var _roomVO:HotSpringRoomInfo;
		private var _selected:Boolean;
		private var _model:HotSpringRoomListModel;
		
		public function RoomListItemView(model:HotSpringRoomListModel, roomVO:HotSpringRoomInfo)
		{
			_model=model;
			_roomVO=roomVO;
			initialize();
		}
		
		private function initialize():void
		{
			this.mouseChildren = false;
			this.selected = false;
			this.buttonMode=true;
			updateView();
			setEvent();
		}
		
		private function updateView():void
		{
			var roomNumber:String=_roomVO.roomNumber.toString();
			lblRoomNumber.text=roomNumber;
			lblRoomName.text=_roomVO.roomName;
			lblCurCount.text=_roomVO.curCount.toString();
			lblMaxCount.text=_roomVO.maxCount.toString();
			mcLock.visible=_roomVO.roomIsPassword;
			
			gotoAndStop(_roomVO.roomType);//列表项背景:1帧=金币房;2帧=2元点卷;3帧=私人
			if(_roomVO.curCount>=_roomVO.maxCount)
			{//如果人满
				gotoAndStop(4);
			}
		}
		
		private function setEvent():void
		{
			_model.addEventListener(HotSpringRoomListEvent.ROOM_UPDATE, roomUpdate);
		}
		
		/**
		 * 更新房间信息
		 */		
		private function roomUpdate(evt:HotSpringRoomListEvent):void
		{
			var roomVO:HotSpringRoomInfo=evt.data as HotSpringRoomInfo;
			if(_roomVO.roomID==roomVO.roomID)
			{//如果更新的房间是当前房间
				_roomVO=roomVO;
				updateView();
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value) return;
			_selected = value;
		}
		
		/**
		 * 取得房间信息
		 */		
		public function get roomVO():HotSpringRoomInfo
		{
			return _roomVO;
		}
		
		public function dispose():void
		{
			_model.removeEventListener(HotSpringRoomListEvent.ROOM_UPDATE, roomUpdate);
			
			lblRoomNumber.text="";
			lblRoomName.text="";
			lblCurCount.text="";
			lblMaxCount.text="";
			
			_roomVO=null;
		}
	}
}