package ddt.view.common.hotSpring
{
	import fl.controls.Button;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	
	import tank.hotSpring.HotSpringInviteFrameViewAsset;
	import ddt.manager.SocketManager;
	
	public class HotSpringRoomInviteView extends HConfirmFrame
	{
		private var _nickName:String;
		private var _roomid:int;
		private var _roomPassword:String;
		
		private var _asset:HotSpringInviteFrameViewAsset;
		
		private var _ok:Button;
		private var _cancel:Button;
		
		public function HotSpringRoomInviteView(info:Object)
		{
			super();
			blackGound = false;
			alphaGound = false;
			fireEvent = false;
			showCancel = true;
			showClose = false;
			this.titleText="盛情邀约";
			this.centerTitle = true;
			okFunction = __okClick;
			cancelFunction = __cancelClick;
			closeCallBack = __cancelClick;
			
			
			
			_nickName = info["nickName"];
			_roomid = info["roomID"];
			_roomPassword = info["roomPassword"];
			
			_asset = new HotSpringInviteFrameViewAsset();
			_asset.lblMsg.autoSize = TextFieldAutoSize.LEFT;
			_asset.lblMsg.text = _asset.lblMsg.text.replace("{0}", _nickName);
			setContentSize(_asset.lblMsg.textWidth+60,95);
			addContent(_asset, true);
			
			UIManager.setChildCenter(this);
			
			addEventListener(Event.CLOSE,__close);
		}
		
		override public function show():void
		{
			TipManager.AddTippanel(this,true,true);
		}
		
		private function __okClick(evt:MouseEvent = null):void
		{
			SoundManager.Instance.play("008");
			SocketManager.Instance.out.sendHotSpringRoomEnter(_roomid, _roomPassword);
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