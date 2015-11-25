package ddt.hotSpring.view.frame
{
	import fl.controls.Button;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.LabelField;
	import road.ui.controls.hframe.HTipFrame;
	import road.ui.manager.TipManager;
	
	import ddt.data.HotSpringRoomInfo;
	import ddt.data.SimpleRoomInfo;
	import ddt.manager.ChatManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.SocketManager;
	
	public class RoomEnterPasswordView extends HTipFrame
	{
		private var _roomVO:HotSpringRoomInfo;
		private var _callBack:Function;
		
		public function RoomEnterPasswordView(callBack:Function)
		{
			super();
			showCancel = true;
			alphaGound = false;
			blackGound = false;
			iconVisible = false;
			autoDispose = true;
			okFunction = okClick;
			cancelFunction = cancelClick;
			_callBack=callBack;
			
			setContentSize(260,80);
			titleText = LanguageMgr.GetTranslation("AlertDialog.Info");
			this.maxChar=6;
			tipTxt(LanguageMgr.GetTranslation("ddt.roomlist.RoomListIIPassInput.write"),"");
			getInputText.displayAsPassword = true;
			
			layou();
			
			okBtnEnable = false;
			buttonGape = 35;
			addEvent();
		}
		private function addEvent():void
		{
			getInputText.addEventListener(Event.CHANGE,__input);
		}
		private function removeEvent():void
		{
			getInputText.removeEventListener(Event.CHANGE,__input);
		}
		private function __input(e:Event):void
		{
			if(inputTxt != "")okBtnEnable = true;
			else okBtnEnable = false;
		}
		
		/**
		 *设置房间信息
		 */		
		public function set roomVO(value:HotSpringRoomInfo):void
		{
			_roomVO = value;
		}
		
		private function okClick(evt:Event = null):void
		{
			okBtnEnable = false;
			SoundManager.instance.play("008");
			if(inputTxt == "")
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.roomlist.RoomListIIPassInput.write"));
				return;
			}
			
			if(_callBack!=null) _callBack(inputTxt, _roomVO);
			
			close();
		}
		
		private function cancelClick(evt:MouseEvent = null):void
		{
			okBtnEnable = false;
			SoundManager.instance.play("008");
			close();
		}
		
		override public function show():void
		{
			TipManager.AddTippanel(this, true);
			blackGound = true;
		}
		
		override public function dispose():void
		{
			removeEvent();
			_roomVO = null;
			_callBack=null;
			super.dispose();
		}
	}
}