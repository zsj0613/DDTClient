package ddt.events
{
	import flash.events.Event;

	public class ShortcutBuyEvent extends Event
	{
		public static const SHORTCUT_BUY:String = "shortcutBuy";
		public static const SHORTCUT_BUY_MONEY_OK:String = "shortcutBuyMoneyOk";//当点卷不足时,点击确定充值
		public static const SHORTCUT_BUY_MONEY_CANCEL:String = "shortcutBuyMoneyCancel";//当点卷不足时,点击取消(关闭)充值
		
		private var _itemID:int;
		private var _itemNum:int;
		public function ShortcutBuyEvent(itemID:int, itemNum:int, bubbles:Boolean=false, cancelable:Boolean=false, eventName:String=SHORTCUT_BUY)
		{
			super(eventName, bubbles, cancelable);
			_itemID = itemID;
			_itemNum = itemNum;
		}
		
		public function get ItemID():int
		{
			return _itemID;
		}
		
		public function get ItemNum():int
		{
			return _itemNum;
		}
		
	}
}