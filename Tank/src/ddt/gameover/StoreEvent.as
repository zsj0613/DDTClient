package ddt.gameover
{
	import flash.events.Event;

	public class StoreEvent extends Event
	{
		public var param:Object;
		
		public static const OVER:String = "over";
		public static const Out:String = "out";
		public static const MOVE:String = "move";
		public static const CLICK:String = "storeClick";
		/**
		 * 修理 
		 */		
		public static const REPAIR:String = "repair";
		
		/**
		 * 全部修理 
		 */		
		public static const REPAIR_ALL:String = "repariAll";
		
		/**
		 * 升级 
		 */		
		public static const UPGRADE:String = "upgrade";
		
		/**
		 * 买卖 
		 */		
		public static const SOLD:String = "sold";
		public function StoreEvent(type:String,data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{

			super(type, bubbles, cancelable);
			param = data;
		}
		
	}
}