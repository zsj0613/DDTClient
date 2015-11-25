package ddt.hotSpring.view
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HFrameButton;
	import road.ui.controls.HButton.HGlowButton;
	import road.ui.manager.TipManager;
	
	import ddt.data.HotSpringRoomInfo;
	import ddt.hotSpring.controller.HotSpringRoomListController;
	import ddt.hotSpring.events.HotSpringRoomListEvent;
	import ddt.hotSpring.model.HotSpringRoomListModel;
	import ddt.hotSpring.view.frame.RoomEnterConfirmView;
	import ddt.hotSpring.view.frame.RoomEnterPasswordView;
	import ddt.manager.PlayerManager;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	
	public class RoomListView extends Sprite
	{
		private var _controller:HotSpringRoomListController;
		private var _model:HotSpringRoomListModel;
		private var _roomListItem:RoomListItemView;
		private var _roomListItemHb:HBaseButton;		
		private var _pageCount:int;//总页数
		private var _pageIndex:int=1;//当前页索引
		private var _pageSize:int=8;//页信息大小
		private var _roomEnterPasswordView:RoomEnterPasswordView;
		private var _roomEnterConfirmView:RoomEnterConfirmView;
		
		public function RoomListView(controller:HotSpringRoomListController, model:HotSpringRoomListModel, pageIndex:int=1, pageSize:int=8)
		{
			_controller = controller;
			_model=model;
			_pageIndex=pageIndex;
			_pageSize=pageSize;
			initialize();
		}
		
		private function initialize():void
		{
			setRoomList();
			setEvent();
		}
		
		private function setEvent():void
		{
			_model.addEventListener(HotSpringRoomListEvent.ROOM_LIST_UPDATE, setRoomList);
		}
		
		/**
		 * 设置房间列表
		 */		
		public function setRoomList(evt:HotSpringRoomListEvent=null):void
		{
			removeRoomList();//移除原加载列表
			
			if(!_model.roomList || _model.roomList.length<=0) return;
			
			var pageList:Array = _model.roomList.list.slice(_pageIndex * _pageSize - _pageSize, (_pageIndex * _pageSize)<=_model.roomList.length ? (_pageIndex * _pageSize) : _model.roomList.length);
			var i:int=0;
			for each(var roomVO:HotSpringRoomInfo in pageList)
			{
				_roomListItem=new RoomListItemView(_model, roomVO);
				_roomListItem.addEventListener(MouseEvent.CLICK, rootListItemClick);
				_roomListItemHb=new HBaseButton(_roomListItem);
				_roomListItemHb.y=i*_roomListItem.height+(i*1);
				addChild(_roomListItemHb);
				i++;
			}
			
			dispatchEvent(new HotSpringRoomListEvent(HotSpringRoomListEvent.ROOM_LIST_UPDATE_VIEW));
		}
		
		/**
		 * 点击进入房间
		 */		
		private function rootListItemClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			
			evt.stopImmediatePropagation();
			var roomVO:HotSpringRoomInfo = evt.currentTarget.roomVO;
			
			if(roomVO.roomType==1 || roomVO.roomType==2)
			{//系统金币房及系统2元点卷房(由系统判定是否弹出扣除费用提示)
				_controller.roomEnterConfirm(roomVO.roomID);
			}
			else if(roomVO.roomType==3)
			{//私人房间
				if(roomVO.roomIsPassword && roomVO.playerID!=PlayerManager.Instance.Self.ID)
				{//如果房间有密码且不是房主(只有私人房间需要密码)
					_roomEnterPasswordView = new RoomEnterPasswordView(RoomEnterPassword);
					_roomEnterPasswordView.roomVO = roomVO;
					_roomEnterPasswordView.okBtnEnable = false;
					_roomEnterPasswordView.show();
				}
				else
				{//私人房间直接进入房间
					_controller.roomEnter(roomVO.roomID, roomVO.playerID==PlayerManager.Instance.Self.ID ? roomVO.roomPassword : "");//执行进入房间
				}
			}
		}
		
		/**
		 * 执行房间输入密码后的结果处理
		 */
		private function RoomEnterPassword(inputPassword:String, roomVO:HotSpringRoomInfo):void
		{
			if(roomVO.roomType==1 || roomVO.roomType==2)
			{//只有公共房间才需要扣费用
				if(_roomEnterConfirmView)
				{
					if(_roomEnterConfirmView.parent) _roomEnterConfirmView.parent.removeChild(_roomEnterConfirmView);
					_roomEnterConfirmView.dispose();
				}
				_roomEnterConfirmView=null;
				
				_roomEnterConfirmView = new RoomEnterConfirmView(_controller, roomVO, inputPassword);
				TipManager.AddTippanel(_roomEnterConfirmView,true);
				_roomEnterConfirmView.blackGound=true;
				_roomEnterConfirmView.setFoucs();
			}
			else
			{
				_controller.roomEnter(roomVO.roomID, inputPassword);
			}
		}
		
		/**
		 * 移除原加载列表
		 */		
		private function removeRoomList():void
		{
			if(_roomListItem) _roomListItem.dispose();
			_roomListItem=null;
			
			while(this.numChildren>0)
			{
				var roomListItemViewHb:HBaseButton= this.getChildAt(0) as HBaseButton;
				if(roomListItemViewHb)
				{
					var roomListItemView:RoomListItemView = roomListItemViewHb.bg as RoomListItemView;
					if(roomListItemView)
					{
						roomListItemView.removeEventListener(MouseEvent.CLICK, rootListItemClick);
						if(roomListItemView.parent) roomListItemView.parent.removeChild(roomListItemView);
						roomListItemView.dispose();
						roomListItemView=null;
					}
					if(roomListItemViewHb.parent) roomListItemViewHb.parent.removeChild(roomListItemViewHb);
					roomListItemViewHb.dispose();
				}
				roomListItemViewHb=null;
			}
		}
		
		/**
		 * 取得当前页索引
		 */		
		public function get pageIndex():int
		{
			return _pageIndex;
		}
		
		/**
		 * 设置当前页索引
		 */		
		public function set pageIndex(value:int):void
		{
			_pageIndex = value;
			setRoomList();
		}
		
		/**
		 * 取得总页数
		 */		
		public function get pageCount():int
		{
			_pageCount=_model.roomList.length/_pageSize;
			if(_model.roomList.length % _pageSize > 0)
			{
				_pageCount+=1;
			}
			return _pageCount;
		}
		
		public function dispose():void
		{
			_model.removeEventListener(HotSpringRoomListEvent.ROOM_LIST_UPDATE, setRoomList);
			
			
			removeRoomList();
			
			if(_roomEnterPasswordView)
			{
				if(_roomEnterPasswordView.parent)
				{
					_roomEnterPasswordView.parent.removeChild(_roomEnterPasswordView);
				}
				_roomEnterPasswordView.dispose();
			}
			_roomEnterPasswordView=null;
			
			if(_roomEnterConfirmView)
			{
				if(_roomEnterConfirmView.parent)
				{
					_roomEnterConfirmView.parent.removeChild(_roomEnterConfirmView);
				}
				_roomEnterConfirmView.dispose();
			}
			_roomEnterConfirmView=null;
			
			if(_roomListItem) _roomListItem.dispose();
			_roomListItem=null;
			
			if(_roomListItemHb) _roomListItemHb.dispose();
			_roomListItemHb=null;			
		}
	}
}