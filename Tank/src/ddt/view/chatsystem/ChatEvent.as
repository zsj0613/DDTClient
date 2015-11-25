package ddt.view.chatsystem
{
	import flash.events.Event;
	public class ChatEvent extends Event
	{
		public static const ADD_CHAT:String = "addChat";
		public static const CAN_SHOW_BUGGLE:String = "canShowBuggle";
		public static const INPUT_CHANNEL_CHANNGED:String = "inputChannelChanged";
		public static const INPUT_TEXT_CHANGED:String = "inputTextChanged";
		public static const NICKNAME_CLICK_TO_OUTSIDE:String = "nicknameClickToOutside";
		public static const SCROLL_CHANG:String = "scrollChanged";
		public static const SHOW_FACE:String = "addFace";

		public function ChatEvent($type:String,data:Object = null)
		{
			this.data = data; 
			super($type);
		}

		public var data:Object;
	}
}