package ddt.store.events
{
	import flash.events.Event;
	
	/**
	 * @author wicki LA
	 * @time 11/25/2009
	 * @description 镶嵌事件
	 * */

	public class EmbedEvent extends Event
	{
		public static const EMBED:String = "embed";
		
		private var _cellID:int;
		
		public function EmbedEvent(type:String, cellID:int,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_cellID = cellID;
		}
		
		public function get CellID():int
		{
			return _cellID;
		}
		
	}
}