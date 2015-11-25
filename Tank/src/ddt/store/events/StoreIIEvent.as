package ddt.store.events
{
	import flash.events.Event;

	public class StoreIIEvent extends Event
	{
		public static const ITEM_CLICK:String = "itemclick";
		public static const UPPREVIEW :String = "upPreview";
		public static const EMBED_CLICK:String = "embedClick";   //镶嵌按钮单击事件 做蒙板时候用
		public static const EMBED_INFORCHANGE:String = "embedInfoChange" //镶嵌物品infoChange事件 做蒙板时候用
		
		public var data:Object;
		
		public function StoreIIEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
		
	}
}