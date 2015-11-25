package ddt.view.infoandbag
{
	import flash.events.Event;

	public class CellEvent extends Event
	{
		public static const ITEM_CLICK:String = "itemclick";
		public static const DOUBLE_CLICK:String = "doubleclick";
		public static const LOCK_CHANGED:String = "lockChanged";
		public static const DRAGSTART:String = "dragStart";
		public static const DRAGSTOP:String = "dragStop";
		
		public var data:Object;
		public var ctrlKey:Boolean;
		
		public function CellEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false,ctrlKey:Boolean=false)
		{
			data = obj;
			this.ctrlKey=ctrlKey;
			super(type, bubbles, cancelable);
		}
		
	}
}