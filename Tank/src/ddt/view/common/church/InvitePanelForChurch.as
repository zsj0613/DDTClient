package ddt.view.common.church
{
	import fl.controls.Button;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	
	import tank.church.ChurchInviteResponseAsset;
	import ddt.manager.SocketManager;

	public class InvitePanelForChurch extends HConfirmFrame
	{
		private var _inviteName:String;
		private var _roomid:int;
		private var _password:String;
		private var _sceneIndex:int;

		private var _asset:ChurchInviteResponseAsset;
		
		private var _ok:Button;
		private var _cancel:Button;
		
		public function InvitePanelForChurch()
		{
			super();
			blackGound = false;
			alphaGound = false;
			fireEvent = false;
			showCancel = true;
			showClose = false;

			okFunction = __okClick;
			cancelFunction = __cancelClick;
			closeCallBack = __cancelClick;
		
			setContentSize(407,95);
			configUI();
		}
		private function configUI():void
		{
			addEventListener(Event.CLOSE,__close);
			
			_asset = new ChurchInviteResponseAsset();
			addContent(_asset);
		}
		
		override public function show():void
		{
			TipManager.AddTippanel(this,true,true);
		}
		
		public function set info(value:Object):void
		{	
			_inviteName = value["inviteName"];
			_roomid = value["roomID"];
			_password = value["pwd"];
			_sceneIndex = value["sceneIndex"];

            _asset.contextMc.x = 10;
			_asset.contextMc.name_txt.autoSize = TextFieldAutoSize.LEFT;
			_asset.contextMc.name_txt.text = _inviteName;
			_asset.contextMc.contextMc.x = _asset.contextMc.name_txt.textWidth + _asset.contextMc.name_txt.x+3;
			_asset.titleMc.x = (_asset.contextMc.width-_asset.titleMc.width)/2 + _asset.contextMc.x;
			var $width : int = _asset.width + 20;
			setContentSize($width,95);
			UIManager.setChildCenter(this);
			show();
		}
		
		private function __okClick(evt:MouseEvent = null):void
		{
			SoundManager.Instance.play("008");
			SocketManager.Instance.out.sendEnterRoom(_roomid,_password,_sceneIndex);
			dispose();
		}
		
		private function __close(evt:Event):void
		{
			SoundManager.Instance.play("008");
			dispose();
		}
		
		private function __cancelClick(evt:MouseEvent = null):void
		{
			SoundManager.Instance.play("008");
			dispose();
		}

		override public function dispose():void
		{
			removeEventListener(Event.CLOSE,__close);
			super.dispose();
			if(parent)parent.removeChild(this);
		}
	}
}