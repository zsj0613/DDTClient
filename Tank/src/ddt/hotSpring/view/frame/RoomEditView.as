package ddt.hotSpring.view.frame
{
	import fl.controls.TextInput;
	import fl.events.ComponentEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import road.ui.controls.HButton.HCheckBox;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	
	import ddt.data.HotSpringRoomInfo;
	import ddt.hotSpring.controller.HotSpringRoomController;
	import ddt.hotSpring.model.HotSpringRoomModel;
	import tank.hotSpring.roomEditAsset;
	import ddt.manager.FilterWordManager;
	import ddt.manager.HotSpringManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.utils.LeavePage;
	
	public class RoomEditView extends HConfirmFrame
	{
		private var _roomEditAsset:roomEditAsset;
		private var _controller:HotSpringRoomController;
		private var _model:HotSpringRoomModel;
		private var _chkIsPassword:HCheckBox;
		private var _txtRoomPassword:TextInput;
		private var _callBack:Function;
		
		public function RoomEditView(controller:HotSpringRoomController, model:HotSpringRoomModel, callBack:Function)
		{
			_controller=controller;
			_model=model;
			_callBack=callBack;
			initialize();
		}
		
		/**
		 * 初始化运行
		 */		
		protected function initialize():void
		{
			this.okFunction = confirmRoomEdit;
			this.cancelFunction=cancelRoomEdit;
			this.closeCallBack=cancelRoomEdit;
			
			if(!HotSpringManager.Instance.roomCurrently || HotSpringManager.Instance.roomCurrently.playerID!=PlayerManager.Instance.Self.ID)
			{
				dispose();
				super.close();
				return;
			}
			
			this.titleText=LanguageMgr.GetTranslation("ddt.hotSpring.room.config.title");
			this.centerTitle = true;
			this.blackGound = false;
			this.alphaGound = false;
			this.moveEnable = false;
			this.fireEvent = false;
			this.showBottom = true;
			this.showClose = true;
			this.buttonGape = 100;
			this.setContentSize(300,170);
			
			_roomEditAsset=new roomEditAsset();
			addContent(_roomEditAsset, true);
			
			_chkIsPassword = new HCheckBox("");
			_roomEditAsset.passwordLabel.buttonMode=true;
			_chkIsPassword.labelGape = 2;
			_chkIsPassword.fireAuto = true;
			_chkIsPassword.buttonMode = true;
			_chkIsPassword.x = _roomEditAsset.chkIsPasswordPos.x;
			_chkIsPassword.y = _roomEditAsset.chkIsPasswordPos.y;
			
			_roomEditAsset.removeChild(_roomEditAsset.txtRoomPasswordPos);
			_txtRoomPassword=new TextInput();
			_txtRoomPassword.maxChars=6;
			_txtRoomPassword.displayAsPassword=true;
			_txtRoomPassword.enabled=false;
			_txtRoomPassword.x=_roomEditAsset.txtRoomPasswordPos.x;
			_txtRoomPassword.y=_roomEditAsset.txtRoomPasswordPos.y;
			var textFormat:TextFormat=new TextFormat();
			textFormat.size=22;
			textFormat.color=0x000000;
			_txtRoomPassword.setStyle("textFormat",textFormat);
			_txtRoomPassword.width=_roomEditAsset.txtRoomPasswordPos.width;
			_txtRoomPassword.height=_roomEditAsset.txtRoomPasswordPos.height;
			_roomEditAsset.addChild(_txtRoomPassword);
			
			_roomEditAsset.addChild(_chkIsPassword);
			_roomEditAsset.removeChild(_roomEditAsset.chkIsPasswordPos);
			
			_roomEditAsset.txtRoomName.text=HotSpringManager.Instance.roomCurrently.roomName;
			
			setEvent();
		}
		
		private function setEvent():void
		{
			_chkIsPassword.addEventListener(Event.CHANGE, passCheckClick);
			_txtRoomPassword.addEventListener(ComponentEvent.ENTER,confirmRoomEdit);
			_roomEditAsset.passwordLabel.addEventListener(MouseEvent.CLICK, selectIsPassword);
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
				_roomEditAsset.RoomPasswordBg.gotoAndStop(2);
			}
			else
			{
				_roomEditAsset.RoomPasswordBg.gotoAndStop(1);
				_txtRoomPassword.text ="";
			}
		}
		
		/**
		 * 确认修改房间
		 */
		private function confirmRoomEdit(evt:Event=null):void
		{	
			if(FilterWordManager.IsNullorEmpty(_roomEditAsset.txtRoomName.text))
			{//房间名称不能为空
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreateRoomView.name"));
				return;
			}
			if(FilterWordManager.isGotForbiddenWords(_roomEditAsset.txtRoomName.text))
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
			roomVO.roomName = _roomEditAsset.txtRoomName.text;
			roomVO.roomPassword = _chkIsPassword.selected ? _txtRoomPassword.text : HotSpringManager.Instance.roomCurrently.roomPassword ? HotSpringManager.Instance.roomCurrently.roomPassword : "";
			roomVO.roomIntroduction="";

			if(_callBack!=null) _callBack();
			dispose();
			this.close();
			_controller.roomEdit(roomVO);
			
		}
		
		override public function show():void
		{
			TipManager.AddTippanel(this, true);
			blackGound = true;
		}
		
		private function cancelRoomEdit():void
		{
			if(_callBack!=null) _callBack();
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
			_chkIsPassword.removeEventListener(Event.CHANGE, passCheckClick);
			_txtRoomPassword.removeEventListener(ComponentEvent.ENTER,confirmRoomEdit);
			_roomEditAsset.passwordLabel.removeEventListener(MouseEvent.CLICK, selectIsPassword);

			if(_txtRoomPassword && _txtRoomPassword.parent) _txtRoomPassword.parent.removeChild(_txtRoomPassword);
			_txtRoomPassword=null;
			
			if(_roomEditAsset && _roomEditAsset.parent) _roomEditAsset.parent.removeChild(_roomEditAsset);
			_roomEditAsset=null;
			
			if(_chkIsPassword && _chkIsPassword.parent) _chkIsPassword.parent.removeChild(_chkIsPassword);
			_chkIsPassword=null;	
			
			_callBack=null;
			
			super.dispose();
		}
	}
}