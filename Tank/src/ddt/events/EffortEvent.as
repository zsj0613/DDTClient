package ddt.events
{
	import flash.events.Event;
	
	import ddt.data.effort.EffortInfo;
	
	public class EffortEvent extends Event
	{
		public static const INIT:String = "init";
		public static const CHANGED:String = "changed";
		public static const LIST_CHANGED:String = "listChanged";
		public static const TYPE_CHANGED:String = "typeChanged";
		public static const ADD:String = "add";
		public static const REMOVE:String = "remove";
		public static const FINISH:String = "finish";
		
		private var _info:EffortInfo;
		
		public function EffortEvent(type:String,info:EffortInfo = null)
		{
			_info = info;
			super(type, false, false);
		}

	}
}