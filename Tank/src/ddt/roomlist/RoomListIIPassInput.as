package ddt.roomlist
{
	import fl.controls.Button;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.LabelField;
	import road.ui.controls.hframe.HTipFrame;
	
	import ddt.data.SimpleRoomInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StateManager;
	import ddt.states.StateType;

	public class RoomListIIPassInput extends HTipFrame
	{
		private var _info:SimpleRoomInfo;
		private var _id:int;
		public function RoomListIIPassInput()
		{
			super();
			showCancel = true;
			alphaGound = true;
			blackGound = false;
			iconVisible = false;
			autoDispose = true;
			okFunction = __okClick;
			cancelFunction = __cancelClick;
			
			setContentSize(260,80);
			titleText = LanguageMgr.GetTranslation("AlertDialog.Info");
			tipTxt(LanguageMgr.GetTranslation("ddt.roomlist.RoomListIIPassInput.write"),"");
			//tipTxt("请输入密码","");
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
		
		public function get info():SimpleRoomInfo
		{
			return _info;
		}
		
		public function set info(value:SimpleRoomInfo):void
		{
			_info = value;
		}
		
		public function get ID():int
		{
			return _id;
		}
		
		public function set ID(value:int):void
		{
			_id = value;
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
			if(_info && _info.roomType <= 2)
			{
				SocketManager.Instance.out.sendGameLogin(1,-1,_info.ID,inputTxt);
			}else if(_info)
			{
				SocketManager.Instance.out.sendGameLogin(2,-1,_info.ID,inputTxt);
			}else
			{
				if(StateManager.currentStateType == StateType.ROOM_LIST)
				SocketManager.Instance.out.sendGameLogin(1,-1,_id,inputTxt);
				else
				SocketManager.Instance.out.sendGameLogin(2,-1,_id,inputTxt);
			}
			close();
		}

		
		private function __cancelClick(evt:MouseEvent = null):void
		{
			okBtnEnable = false;
			SoundManager.Instance.play("008");
			close();
		}
		

		override public function dispose():void
		{
			removeEvent();
//			okBtnEnable = false;
			_info = null;
			super.dispose();
		}
	}
}