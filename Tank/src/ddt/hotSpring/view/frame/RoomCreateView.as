package ddt.hotSpring.view.frame
{
	import fl.controls.TextInput;
	import fl.events.ComponentEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HCheckBox;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	
	import ddt.data.HotSpringRoomInfo;
	import ddt.hotSpring.controller.HotSpringRoomListController;
	import ddt.hotSpring.model.HotSpringRoomListModel;
	import tank.hotSpring.roomCreateAsset;
	import ddt.manager.FilterWordManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.utils.LeavePage;
	
	public class RoomCreateView extends HConfirmFrame
	{
		private var _roomCreateAsset:roomCreateAsset;
		private var _controller:HotSpringRoomListController;
		private var _model:HotSpringRoomListModel;
		private var _effectiveTime:int=120;//房间有效分钟时间(默认为120分钟)
		private var _useMoney:Number=200;//需要的点卷
		private var _chkIsPassword:HCheckBox;
		private var _maxCount:int=4;//最大人数
		private var _txtRoomPassword:TextInput;
		
		public function RoomCreateView(controller:HotSpringRoomListController, model:HotSpringRoomListModel)
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
			this.okFunction = confirmRoomCreate;
			this.cancelFunction=cancelRoomCreate;
			this.closeCallBack=cancelRoomCreate;
			
			this.titleText=LanguageMgr.GetTranslation("ddt.hotSpring.room.create.title");
			this.centerTitle = true;
			this.blackGound = false;
			this.alphaGound = false;
			this.moveEnable = false;
			this.fireEvent = false;
			this.showBottom = true;
			this.showClose = true;
			this.buttonGape = 100;
			this.setContentSize(300,395);
			
			_roomCreateAsset=new roomCreateAsset();
			addContent(_roomCreateAsset, true);
			_chkIsPassword = new HCheckBox("");
			_roomCreateAsset.passwordLabel.buttonMode=true;
			_chkIsPassword.labelGape = 2;
			_chkIsPassword.fireAuto = true;
			_chkIsPassword.buttonMode = true;
			_chkIsPassword.x = _roomCreateAsset.chkIsPasswordPos.x;
			_chkIsPassword.y = _roomCreateAsset.chkIsPasswordPos.y;
			_roomCreateAsset.addChild(_chkIsPassword);
			_roomCreateAsset.removeChild(_roomCreateAsset.chkIsPasswordPos);
			
			_roomCreateAsset.removeChild(_roomCreateAsset.txtRoomPasswordPos);
			_txtRoomPassword=new TextInput();
			_txtRoomPassword.displayAsPassword=true;
			_txtRoomPassword.maxChars=6;
			var textFormat:TextFormat=new TextFormat();
			textFormat.size=22;
			textFormat.color=0x000000;
			_txtRoomPassword.setStyle("textFormat",textFormat);
			_txtRoomPassword.enabled=false;
			_txtRoomPassword.x=_roomCreateAsset.txtRoomPasswordPos.x;
			_txtRoomPassword.y=_roomCreateAsset.txtRoomPasswordPos.y;
			_txtRoomPassword.width=_roomCreateAsset.txtRoomPasswordPos.width;
			_txtRoomPassword.height=_roomCreateAsset.txtRoomPasswordPos.height;
			_roomCreateAsset.addChild(_txtRoomPassword);
			
			_roomCreateAsset.txtRoomName.text=LanguageMgr.GetTranslation("ddt.hotSpring.room.defaultName");
			_roomCreateAsset.btnRoom1.buttonMode=true;
			_roomCreateAsset.btnRoom2.buttonMode=true;
			_roomCreateAsset.btnRoom1.gotoAndStop(2);
			_roomCreateAsset.btnRoom2.gotoAndStop(1);
			
			setEvent();
		}
		
		private function setEvent():void
		{
			_roomCreateAsset.btnRoom1.addEventListener(MouseEvent.CLICK, selectRoom);
			_roomCreateAsset.btnRoom2.addEventListener(MouseEvent.CLICK, selectRoom);
			_chkIsPassword.addEventListener(Event.CHANGE, passCheckClick);
			_txtRoomPassword.addEventListener(ComponentEvent.ENTER,confirmRoomCreate);
			_roomCreateAsset.passwordLabel.addEventListener(MouseEvent.CLICK, selectIsPassword);
		}
		
		private function selectIsPassword(event:MouseEvent):void
		{
			_chkIsPassword.selected=!_chkIsPassword.selected;
		}
		
		private function passCheckClick(event:Event):void
		{
			_txtRoomPassword.enabled = _chkIsPassword.selected;
			if(_chkIsPassword.selected)
			{
				_txtRoomPassword.setFocus();
				_roomCreateAsset.RoomPasswordBg.gotoAndStop(2);
			}
			else
			{
				_roomCreateAsset.RoomPasswordBg.gotoAndStop(1);
				_txtRoomPassword.text ="";
			}
		}
		
		/**
		 * 选择房间人数
		 */		
		private function selectRoom(evt:MouseEvent):void
		{
			restRoomSelect();
			switch(evt.target)
			{
				case _roomCreateAsset.btnRoom1://4人房
					SoundManager.instance.play("008");
					_maxCount=4;
					_roomCreateAsset.btnRoom1.gotoAndStop(2);
					break;
				case _roomCreateAsset.btnRoom2://8人房
					SoundManager.instance.play("008");
					_maxCount=8;
					_roomCreateAsset.btnRoom2.gotoAndStop(2);
					break;
			}
		}
		
		/**
		 * 确认创建房间
		 */		
		private function confirmRoomCreate(evt:Event=null):void
		{
			if(PlayerManager.Instance.Self.Money < _useMoney)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
				return;
			}
			
			if(FilterWordManager.IsNullorEmpty(_roomCreateAsset.txtRoomName.text))
			{//房间名称不能为空
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreateRoomView.name"));
				return;
			}
			if(FilterWordManager.isGotForbiddenWords(_roomCreateAsset.txtRoomName.text))
			{//房间名称不能有非法词
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreateRoomView.string"));
				return;
			}
			if(_chkIsPassword.selected && FilterWordManager.IsNullorEmpty(_txtRoomPassword.text))
			{//密码未输入
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreateRoomView.set"));
				return;
			}
			
			var roomVO:HotSpringRoomInfo = new HotSpringRoomInfo();
			roomVO.roomName = _roomCreateAsset.txtRoomName.text;
			roomVO.roomPassword = _txtRoomPassword.text;
			roomVO.roomIntroduction="";
			roomVO.maxCount=_maxCount;
			
			dispose();
			this.close();
			
			_controller.roomCreate(roomVO);
		}
		
		/**
		 * 复位房间创建人数选择
		 */		
		private function restRoomSelect():void
		{
			_roomCreateAsset.btnRoom1.gotoAndStop(1);
			_roomCreateAsset.btnRoom2.gotoAndStop(1);
		}
		
		override public function show():void
		{
			TipManager.AddTippanel(this, true);
			blackGound = true;
		}
		
		private function cancelRoomCreate():void
		{
			dispose();
			super.close();
		}
		
		override protected function __closeClick(e:MouseEvent):void
		{
			if(this.cancelFunction != null) this.cancelFunction();
			super.__closeClick(e);
		}
		
		override protected function __addToStage(e:Event):void
		{
			super.__addToStage(e);
		}
		
		override public function dispose():void
		{
			_roomCreateAsset.btnRoom1.removeEventListener(MouseEvent.CLICK, selectRoom);
			_roomCreateAsset.btnRoom2.removeEventListener(MouseEvent.CLICK, selectRoom);
			_chkIsPassword.removeEventListener(Event.CHANGE, passCheckClick);
			_txtRoomPassword.removeEventListener(ComponentEvent.ENTER,confirmRoomCreate);
			_roomCreateAsset.passwordLabel.removeEventListener(MouseEvent.CLICK, selectIsPassword);
			
			if(_txtRoomPassword && _txtRoomPassword.parent) _txtRoomPassword.parent.removeChild(_txtRoomPassword);
			_txtRoomPassword=null;
			
			if(_roomCreateAsset && _roomCreateAsset.parent) _roomCreateAsset.parent.removeChild(_roomCreateAsset);
			_roomCreateAsset=null;
			
			if(_chkIsPassword && _chkIsPassword.parent) _chkIsPassword.parent.removeChild(_chkIsPassword);
			_chkIsPassword=null;
			
			super.dispose();
		}
	}
}