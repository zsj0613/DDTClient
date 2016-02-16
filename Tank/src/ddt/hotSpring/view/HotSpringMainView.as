package ddt.hotSpring.view
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import road.comm.PackageIn;
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HFrameButton;
	import road.ui.manager.TipManager;
	
	import ddt.data.HotSpringRoomInfo;
	import ddt.events.CrazyTankSocketEvent;
	import tank.hotSpring.MainViewAsset;
	import ddt.hotSpring.controller.HotSpringRoomListController;
	import ddt.hotSpring.events.HotSpringRoomListEvent;
	import ddt.hotSpring.model.HotSpringRoomListModel;
	import ddt.hotSpring.view.frame.RoomCreateView;
	import ddt.hotSpring.view.frame.RoomEnterConfirmView;
	import ddt.hotSpring.view.frame.RoomEnterPasswordView;
	import ddt.manager.BossBoxManager;
	import ddt.manager.ChatManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StateManager;
	import ddt.states.StateType;
	import ddt.utils.DisposeUtils;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.bossbox.SmallBoxButton;
	import ddt.view.common.BellowStripViewII;
	
	public class HotSpringMainView extends Sprite
	{
		private var _model:HotSpringRoomListModel;
		private var _controller:HotSpringRoomListController;
		private var _mainViewAsset:MainViewAsset;
		private var _chatFrame:Sprite;
		private var _roomList:RoomListView;
		private var _pageFirst:HFrameButton;
		private var _pageFront:HFrameButton;
		private var _pageNext:HFrameButton;
		private var _pageLast:HFrameButton;
		private var _btnCreateRoom:HBaseButton;
		private var _btnQuickEnterRoom:HBaseButton;
		private var _roomEnterPasswordView:RoomEnterPasswordView;
		private var _roomEnterConfirmView:RoomEnterConfirmView;
		private var _boxButton:SmallBoxButton;
		
		public function HotSpringMainView(controller:HotSpringRoomListController, model:HotSpringRoomListModel)
		{
			_controller=controller;
			_model=model;
			initialize();
		}
		
		/**
		 * 初始化运行
		 */		
		protected function initialize():void
		{
			BellowStripViewII.Instance.show();
			BellowStripViewII.Instance.enabled = true;
			SoundManager.Instance.playMusic("062");
			
			_mainViewAsset=new MainViewAsset();
			addChild(_mainViewAsset);
			
			_mainViewAsset.removeChild(_mainViewAsset.roomListPosAsset);
			
			_roomList=new RoomListView(_controller, _model);
			_roomList.x=_mainViewAsset.roomListPosAsset.x;
			_roomList.y=_mainViewAsset.roomListPosAsset.y;
			_mainViewAsset.addChild(_roomList);
			
			if(_mainViewAsset.btnCreateRoom.parent) _mainViewAsset.btnCreateRoom.parent.removeChild(_mainViewAsset.btnCreateRoom);
			_btnCreateRoom = new HBaseButton(_mainViewAsset.btnCreateRoom);
			_btnCreateRoom.useBackgoundPos = true;
			_btnCreateRoom.useHandCursor = true;
			_btnCreateRoom.enable=false;
			addChild(_btnCreateRoom);
			
			if(_mainViewAsset.btnQuickEnterRoom.parent) _mainViewAsset.btnQuickEnterRoom.parent.removeChild(_mainViewAsset.btnQuickEnterRoom);
			_btnQuickEnterRoom = new HBaseButton(_mainViewAsset.btnQuickEnterRoom);
			_btnQuickEnterRoom.useBackgoundPos = true;
			_btnQuickEnterRoom.useHandCursor = true
			addChild(_btnQuickEnterRoom);
			
			if(_mainViewAsset.pageFirst.parent) _mainViewAsset.pageFirst.parent.removeChild(_mainViewAsset.pageFirst);
			_pageFirst = new HFrameButton(_mainViewAsset.pageFirst,"");
			_pageFirst.useBackgoundPos = true;
			addChild(_pageFirst);
			
			if(_mainViewAsset.pageFront.parent) _mainViewAsset.pageFront.parent.removeChild(_mainViewAsset.pageFront);
			_pageFront = new HFrameButton(_mainViewAsset.pageFront,"");
			_pageFront.useBackgoundPos = true;
			addChild(_pageFront);
			
			if(_mainViewAsset.pageNext.parent) _mainViewAsset.pageNext.parent.removeChild(_mainViewAsset.pageNext);
			_pageNext = new HFrameButton(_mainViewAsset.pageNext,"");
			_pageNext.useBackgoundPos = true;
			addChild(_pageNext);
			
			if(_mainViewAsset.pageLast.parent) _mainViewAsset.pageLast.parent.removeChild(_mainViewAsset.pageLast);
			_pageLast = new HFrameButton(_mainViewAsset.pageLast,"");
			_pageLast.useBackgoundPos = true;
			addChild(_pageLast);
			
			
			ChatManager.Instance.state = ChatManager.CHAT_HOTSPRING_VIEW;
			_chatFrame = ChatManager.Instance.view;
			_mainViewAsset.addChild(_chatFrame);
			
			if(BossBoxManager.instance.isShowBoxButton())
			{
				_boxButton = new SmallBoxButton();
				_boxButton.x = _mainViewAsset._smallBoxButton.x;
				_boxButton.y = _mainViewAsset._smallBoxButton.y;
				BossBoxManager.instance.smallBoxButton = _boxButton;
				addChild(_boxButton);
			}
			
			roomListUpdateView();
			setEvent();
		}
		
		/**
		 * 设置事件
		 */		
		private function setEvent():void
		{
			_pageFirst.addEventListener(MouseEvent.CLICK, getPageList);
			_pageFront.addEventListener(MouseEvent.CLICK, getPageList);
			_pageNext.addEventListener(MouseEvent.CLICK, getPageList);
			_pageLast.addEventListener(MouseEvent.CLICK, getPageList);
			_btnCreateRoom.addEventListener(MouseEvent.CLICK, createRoom);
			_btnQuickEnterRoom.addEventListener(MouseEvent.CLICK, quickEnterRoom);
			_roomList.addEventListener(HotSpringRoomListEvent.ROOM_LIST_UPDATE_VIEW, roomListUpdateView);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_ENTER_CONFIRM,roomEnterConfirmSucceed);//接受服务器处理后进入房间前确认
		}
		
		/**
		 * 视图中房间列表加载/更新完成
		 */		
		private function roomListUpdateView(evt:HotSpringRoomListEvent=null):void
		{
			_mainViewAsset.roomCurCount.text=_roomList.pageCount>0 ? _roomList.pageIndex.toString() : "0";
			_mainViewAsset.roomCount.text=_roomList.pageCount.toString();
			
			_pageFirst.enable=_pageFront.enable=(_roomList.pageCount>0 && _roomList.pageIndex>1);
			_pageNext.enable=_pageLast.enable=(_roomList.pageCount>0 && _roomList.pageIndex<_roomList.pageCount);
		}
		
		/**
		 * 房间列表翻页
		 */		
		private function getPageList(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			switch(evt.target)
			{
				case _mainViewAsset.pageFirst://首页
					_roomList.pageIndex=1;
					break;
				case _mainViewAsset.pageFront://上一页
					_roomList.pageIndex=_roomList.pageIndex-1>0 ? _roomList.pageIndex-1 : 1;
					break;
				case _mainViewAsset.pageNext://下一页
					_roomList.pageIndex=_roomList.pageIndex+1 <= _roomList.pageCount ? _roomList.pageIndex+1 : _roomList.pageCount;
					break;
				case _mainViewAsset.pageLast://尾页
					_roomList.pageIndex=_roomList.pageCount;
					break;
			}
		}
		
		/**
		 * 发送创建房间请求 
		 */	
		private function createRoom(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			
			var roomCreateView:RoomCreateView = new RoomCreateView(_controller, _model);
			roomCreateView.show();
		}
		
		/**
		 * 接受服务器处理后进入房间前确认
		 */		
		public function roomEnterConfirmSucceed(evt:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = evt.pkg;
			var roomID:int=pkg.readInt();
			var roomVO:HotSpringRoomInfo = _model.roomList[roomID];
			
			if(roomVO.roomType==3)
			{//私人房间
				if(roomVO.roomIsPassword)
				{//如果房间有密码(只有私人房间需要密码)
					if(_roomEnterPasswordView)
					{
						if(_roomEnterPasswordView.parent) _roomEnterPasswordView.parent.removeChild(_roomEnterPasswordView);
						_roomEnterPasswordView.dispose();
					}
					_roomEnterPasswordView=null;
					
					_roomEnterPasswordView = new RoomEnterPasswordView(RoomEnterPassword);
					_roomEnterPasswordView.roomVO = roomVO;
					_roomEnterPasswordView.okBtnEnable = false;
					_roomEnterPasswordView.show();
				}
				else
				{
					_controller.roomEnter(roomVO.roomID, "");//执行进入房间
				}
			}
			else
			{
				if(_roomEnterConfirmView)
				{
					if(_roomEnterConfirmView.parent) _roomEnterConfirmView.parent.removeChild(_roomEnterConfirmView);
					_roomEnterConfirmView.dispose();
				}
				_roomEnterConfirmView=null;
				
				_roomEnterConfirmView = new RoomEnterConfirmView(_controller, roomVO);
				TipManager.AddTippanel(_roomEnterConfirmView, true);
				_roomEnterConfirmView.blackGound=true;
				_roomEnterConfirmView.setFoucs();
			}
		}
		
		/**
		 * 发送快速进入房间请求
		 */		
		private function quickEnterRoom(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			
			_controller.quickEnterRoom();
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
		 * 显示视图
		 */		
		public function show():void
		{
			_controller.addChild(this);
			_controller.hotSpringEnter();
		}
		
		/**
		 * 隐藏视图
		 */		
		public function hide():void
		{
			_controller.removeChild(this);
		}
		
		public function dispose():void
		{
			_pageFirst.removeEventListener(MouseEvent.CLICK, getPageList);
			_pageFront.removeEventListener(MouseEvent.CLICK, getPageList);
			_pageNext.removeEventListener(MouseEvent.CLICK, getPageList);
			_pageLast.removeEventListener(MouseEvent.CLICK, getPageList);
			_btnCreateRoom.removeEventListener(MouseEvent.CLICK, createRoom);
			_btnQuickEnterRoom.removeEventListener(MouseEvent.CLICK, quickEnterRoom);
			_roomList.removeEventListener(HotSpringRoomListEvent.ROOM_LIST_UPDATE_VIEW, roomListUpdateView);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_ENTER_CONFIRM,roomEnterConfirmSucceed);//接受服务器处理后进入房间前确认
			
			
			BellowStripViewII.Instance.backFunction = null;
			BellowStripViewII.Instance.hide();
			
			if(_roomEnterPasswordView)
			{
				if(_roomEnterPasswordView.parent) _roomEnterPasswordView.parent.removeChild(_roomEnterPasswordView);
				_roomEnterPasswordView.dispose();
			}
			_roomEnterPasswordView=null;
			
			if(_roomEnterConfirmView)
			{
				if(_roomEnterConfirmView.parent) _roomEnterConfirmView.parent.removeChild(_roomEnterConfirmView);
				_roomEnterConfirmView.dispose();
			}
			_roomEnterConfirmView=null;
			
			DisposeUtils.disposeHBaseButton(_pageFirst);
			_pageFirst=null;
			DisposeUtils.disposeHBaseButton(_pageFront);
			_pageFront=null;
			DisposeUtils.disposeHBaseButton(_pageNext);
			_pageNext=null;
			DisposeUtils.disposeHBaseButton(_pageLast);
			_pageLast=null
			DisposeUtils.disposeHBaseButton(_btnCreateRoom);
			_btnCreateRoom=null	
			DisposeUtils.disposeHBaseButton(_btnQuickEnterRoom);
			_btnQuickEnterRoom=null	
			
			if(_roomList)
			{
				if(_roomList.parent) _roomList.parent.removeChild(_roomList);
				_roomList.dispose();
			}
			_roomList=null;
			
			if(_chatFrame && _chatFrame.parent) _chatFrame.parent.removeChild(_chatFrame);
			_chatFrame=null;
			
			if(_mainViewAsset && _mainViewAsset.parent) _mainViewAsset.parent.removeChild(_mainViewAsset);
			_mainViewAsset=null;
			
			if(_boxButton)
			{
				BossBoxManager.instance.deleteBoxButton();
				_boxButton.dispose();
			}
			_boxButton = null;
		}
	}
}