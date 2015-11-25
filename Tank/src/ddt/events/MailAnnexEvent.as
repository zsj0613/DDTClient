package ddt.events
{
	import flash.events.Event;
	
	import ddt.data.goods.InventoryItemInfo;

	public class MailAnnexEvent extends Event
	{
		public static var SEND_ANNEX:String = "sendAnnex";
		public var annex:InventoryItemInfo;
		public function MailAnnexEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}