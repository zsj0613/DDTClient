package ddt.store.events
{
	import flash.events.Event;
	
	import ddt.data.goods.InventoryItemInfo;

	public class UpdateItemEvent extends Event
	{
		public static const UPDATEITEMEVENT:String = "updateItemEvent";
		public var pos:int;
		public var item:InventoryItemInfo;
		public function UpdateItemEvent(type:String, place:int, item:InventoryItemInfo, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.pos = place;
			this.item = item;
		}
		
	}
}