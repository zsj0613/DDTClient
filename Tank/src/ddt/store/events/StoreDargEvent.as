package ddt.store.events
{
	import flash.events.Event;
	
	import ddt.data.goods.ItemTemplateInfo;

	public class StoreDargEvent extends Event
	{
		public static const START_DARG:String = "startDarg";
		public static const STOP_DARG:String = "stopDarg";
		
		public var sourceInfo:ItemTemplateInfo;
		public function StoreDargEvent(source:ItemTemplateInfo,type:String,bubbles:Boolean=false,cancelable:Boolean=false)
		{
			this.sourceInfo = source;
			super(type, bubbles, cancelable);
		}
		
	}
}