package ddt.hotSpring.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.manager.TipManager;
	
	import tank.fightLibChooseFightLibTypeView.BookShine;
	import ddt.hotSpring.controller.HotSpringRoomController;
	import ddt.hotSpring.model.HotSpringRoomModel;
	import tank.hotSpring.roomMenuAsset;
	import ddt.hotSpring.view.frame.RoomEditView;
	import ddt.hotSpring.view.frame.RoomGuestListView;
	import ddt.hotSpring.view.frame.RoomInviteView;
	
	public class RoomMenuView extends roomMenuAsset
	{
		private var _controller:HotSpringRoomController;
		private var _model:HotSpringRoomModel;
		private var _roomInviteView:RoomInviteView;
		private var _roomGuestListView:RoomGuestListView;
		private var _roomEditView:RoomEditView;
		private var _menuIsOpen:Boolean=true;
		private var _isShowAdminMenu:Boolean;
		
		public function RoomMenuView(controller:HotSpringRoomController, model:HotSpringRoomModel, isShowAdminMenu:Boolean)
		{
			_controller=controller;
			_model=model;
			_isShowAdminMenu=isShowAdminMenu;
			initialize();
		}
		
		private function initialize():void
		{
			btnSwitchMenu.stop();
			btnSwitchMenu.buttonMode=true;
			gotoAndStop(_isShowAdminMenu ? 1 : 2);
			
			setEvent();
		}
		
		/**
		 * 设置事件
		 */		
		private function setEvent():void
		{
			btnRoomBack.addEventListener(MouseEvent.CLICK, backRoomList);
			if(_isShowAdminMenu)
			{
				btnInviteGuest.addEventListener(MouseEvent.CLICK, inviteGuest);
				btnGuestList.addEventListener(MouseEvent.CLICK, guestList);
				btnRoomConfig.addEventListener(MouseEvent.CLICK, roomConfig);
			}
			btnSwitchMenu.addEventListener(MouseEvent.CLICK, switchMenu);
			switchBtn.addEventListener(MouseEvent.CLICK, switchMenu);
		}
		
		/**
		 * 邀请宾客
		 */		
		private function inviteGuest(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(_roomInviteView)
			{
				if(_roomInviteView.parent) _roomInviteView.parent.removeChild(_roomInviteView);
				_roomInviteView.dispose();
				_roomInviteView=null;
			}
			else
			{
				_roomInviteView=new RoomInviteView(_controller, _model, roomInviteCallBack);
				_roomInviteView.x=(stage.stageWidth-_roomInviteView.width)/2;
				_roomInviteView.y=(stage.stageHeight-_roomInviteView.height)/2;
				TipManager.AddTippanel(_roomInviteView,true);	
			}
		}
		
		private function roomInviteCallBack():void
		{
			if(_roomInviteView)
			{
				if(_roomInviteView.parent) _roomInviteView.parent.removeChild(_roomInviteView);
				_roomInviteView.dispose();
				_roomInviteView=null;
			}
		}
		
		/**
		 * 宾客列表
		 */		
		private function guestList(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(_roomGuestListView)
			{
				if(_roomGuestListView.parent) _roomGuestListView.parent.removeChild(_roomGuestListView);
				_roomGuestListView.dispose();
				_roomGuestListView=null;
			}
			else
			{
				_roomGuestListView=new RoomGuestListView(_model.roomPlayerList, roomGuestListCallBack);
				_roomGuestListView.x=stage.stageWidth-_roomGuestListView.width;
				_roomGuestListView.y=this.y-_roomGuestListView.height;
				TipManager.AddTippanel(_roomGuestListView,false);
			}
		}
		
		private function roomGuestListCallBack():void
		{
			if(_roomGuestListView)
			{
				if(_roomGuestListView.parent) _roomGuestListView.parent.removeChild(_roomGuestListView);
				_roomGuestListView.dispose();
				_roomGuestListView=null;
			}
		}
		
		/**
		 * 房间设置
		 */		
		private function roomConfig(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(_roomEditView)
			{
				if(_roomEditView.parent) _roomEditView.parent.removeChild(_roomEditView);
				_roomEditView.dispose();
				_roomEditView=null;
			}
			else
			{
				_roomEditView=new RoomEditView(_controller, _model, roomConfigCallBack);
				_roomEditView.x=(stage.stageWidth-_roomEditView.width)/2;
				_roomEditView.y=(stage.stageHeight-_roomEditView.height)/2;
				TipManager.AddTippanel(_roomEditView,true);
			}
		}
		
		private function roomConfigCallBack():void
		{
			_roomEditView=null;
		}
		
		/**
		 * 返回房间列表(退出房间)
		 */		
		private function backRoomList(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			_controller.roomPlayerRemoveSend();
		}
		
		/**
		 * 开关管理菜单
		 */		
		private function switchMenu(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			btnSwitchMenu.gotoAndStop(_menuIsOpen ? 1 : 2);
			addEventListener(Event.ENTER_FRAME,menuShowOrHide);
		}
		
		private function menuShowOrHide(evt:Event):void
		{
			if(_menuIsOpen)
			{//执行关闭
				this.x+=20;
				if(this.x>=stage.stageWidth-this.width+(this.width-34))
				{
					removeEventListener(Event.ENTER_FRAME,menuShowOrHide);
					this.x=stage.stageWidth-this.width+(this.width-34);
					_menuIsOpen=false;
				}
			}
			else
			{//执行开启
				this.x-=20;
				if(this.x<=stage.stageWidth-this.width)
				{
					removeEventListener(Event.ENTER_FRAME,menuShowOrHide);
					this.x=stage.stageWidth-this.width;
					_menuIsOpen=true;
				}
			}
		}
		
		public function dispose():void
		{
			btnRoomBack.removeEventListener(MouseEvent.CLICK, backRoomList);
			if(_isShowAdminMenu)
			{
				btnInviteGuest.removeEventListener(MouseEvent.CLICK, inviteGuest);
				btnGuestList.removeEventListener(MouseEvent.CLICK, guestList);
				btnRoomConfig.removeEventListener(MouseEvent.CLICK, roomConfig);
			}
			btnSwitchMenu.removeEventListener(MouseEvent.CLICK, switchMenu);
			switchBtn.removeEventListener(MouseEvent.CLICK, switchMenu);
			while(numChildren > 0)
			{
				removeChildAt(0);
			}
			if(_roomInviteView)
			{
				if(_roomInviteView.parent) _roomInviteView.parent.removeChild(_roomInviteView);
				_roomInviteView.dispose();
			}
			_roomInviteView=null;
		}
	}
}