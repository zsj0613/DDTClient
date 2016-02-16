package ddt.church.weddingRoom.frame
{
	import fl.controls.Button;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.LabelField;
	import road.ui.controls.hframe.HTipFrame;
	import road.ui.manager.TipManager;
	
	import ddt.data.ChurchRoomInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.SocketManager;

	public class ChurchRoomPassInput extends HTipFrame
	{
		private var _ok:Button;
		private var _cancel:Button;
		private var _input:LabelField;
		private var _info:ChurchRoomInfo;
		
		public function ChurchRoomPassInput()
		{
			super();
			showCancel = true;
			
			blackGound = false;
			iconVisible = false;
			okFunction = __okClick;
			cancelFunction = __cancelClick;
			okLabel = LanguageMgr.GetTranslation("ok");
			cancelLabel =  LanguageMgr.GetTranslation("cancel");
			
			setContentSize(260,80);
			titleText = LanguageMgr.GetTranslation("AlertDialog.Info");
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
		
		public function get info():ChurchRoomInfo
		{
			return _info;
		}
		
		public function set info(value:ChurchRoomInfo):void
		{
			_info = value;
		}

		private function __okClick(evt:Event = null):void
		{
			okBtnEnable = false;
			SoundManager.Instance.play("008");
			if(inputTxt == "")
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.roomlist.RoomListIIPassInput.write"));
				return;
			}
			SocketManager.Instance.out.sendEnterRoom(_info.id,inputTxt);
			dispose();
		}
		
		private function __cancelClick(evt:MouseEvent = null):void
		{
			okBtnEnable = false;
			SoundManager.Instance.play("008");
			dispose();
		}
		override public function show():void
		{
			alphaGound = false;
			TipManager.AddTippanel(this,true);
			alphaGound = true;
		}

		override public function dispose():void
		{
			okBtnEnable = false;
			_ok = null;
			_cancel = null;
			_input = null;
			_info = null;
			super.dispose();
			close();
			removeEvent();
		}
	}
}