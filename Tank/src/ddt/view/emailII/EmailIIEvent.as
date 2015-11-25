package ddt.view.emailII
{
	import flash.events.Event;
	
	import ddt.data.EmailInfo;
	import ddt.data.goods.ItemTemplateInfo;

	public class EmailIIEvent extends Event
	{
		private var _info:EmailInfo;
		public function get info():EmailInfo
		{
			return _info;
		}
		
		private var _item:ItemTemplateInfo;
		public function get item():ItemTemplateInfo
		{
			return _item;
		}
		
		public static const ADD_EMAIL:String = "addEmail";
		public static const REMOVE_EMAIL:String = "removeEmail";
		public static const INIT_EMAIL:String = "initEmail";
		public static const CHANGE_EMAIL:String = "changeEmail";
		public static const CLEAR_EMAIL:String = "clearEmail";
		public static const SELECT_EMAIL:String = "selectEmail";
		public static const CHANE_STATE:String = "changeState";
		public static const CHANE_PAGE:String = "changePage";
		public static const SHOW_BAGFRAME:String = "showBagframe";
		public static const HIDE_BAGFRAME:String = "hideBagframe";
		public static const CHANG_MODEL:String = "changeModel";
		/* 邮件类别改变时调度 */
		public static const CHANGE_TYPE:String = "changeType";
		/* 邮件标记为已读时调度 */
		public static const SIGN_MAIL_READ:String = "sign mail to read";
		
		public static const DRAGIN_BAG:String = "draginBag";
		
		public static const DRAGOUT_BAG:String = "dragoutBag";
		
		public static const DRAGIN_ANNIEX:String = "draginAnniex";
		public static const DRAGOUT_ANNIEX:String = "dragoutAnniex";
		public static const ESCAPE_KEY : String = "escapeKey";
		
		public function EmailIIEvent(type:String,info:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type,bubbles, cancelable);
			_info = info as EmailInfo;
			_item = info as ItemTemplateInfo;
		}
		
	}
}