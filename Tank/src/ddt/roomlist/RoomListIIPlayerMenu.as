package ddt.roomlist
{
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.roomlistII.RoomListIIPlayerMenuAsset;
	
	import ddt.data.player.PlayerInfo;
	import ddt.manager.ChatManager;
	import ddt.manager.PersonalInfoManager;
	import ddt.manager.PlayerManager;
	import ddt.view.im.IMController;

	public class RoomListIIPlayerMenu extends RoomListIIPlayerMenuAsset
	{
		private var _info:PlayerInfo;
		
		public function RoomListIIPlayerMenu()
		{
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
//			graphics.beginFill(0x000000,0);
//			graphics.drawRect(-3000,-3000,6000,6000);
//			graphics.endFill();
		}
		
		public function set info(value:PlayerInfo):void
		{
			_info = value;
		}
		
		private function initEvent():void
		{
			privatechat_btn.addEventListener(MouseEvent.CLICK,__privateChatClick);
			viewinfo_btn.addEventListener(MouseEvent.CLICK,__viewInfoClick);
			addfriend_btn.addEventListener(MouseEvent.CLICK,__addFriendClick);
//			addEventListener(MouseEvent.CLICK,__mouseClick);
		}
		
		private function __privateChatClick(evt:MouseEvent):void
		{
			ChatManager.Instance.privateChatTo(_info.NickName);
			hide();
		}
		
		private function __viewInfoClick(evt:MouseEvent):void
		{
			PersonalInfoManager.instance.addPersonalInfo(_info.ID,PlayerManager.Instance.Self.ZoneID);
			hide();
		}
		
		private function __addFriendClick(evt:MouseEvent):void
		{
			IMController.Instance.addFriend(_info.NickName);
			hide();
		}
		
		private function __mouseClick(evt:MouseEvent):void
		{
			hide();
		}
		
		public function show():void
		{
			this.visible = true;
		}
		
		public function hide():void
		{
			this.visible = false;
		}
		
		public function dispose():void
		{
			privatechat_btn.removeEventListener(MouseEvent.CLICK,__privateChatClick);
			viewinfo_btn.removeEventListener(MouseEvent.CLICK,__viewInfoClick);
			addfriend_btn.removeEventListener(MouseEvent.CLICK,__addFriendClick);
			_info = null;
			if(parent)parent.removeChild(this);
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
	}
}