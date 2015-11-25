package ddt.events
{
	import flash.events.Event;
	
	import ddt.view.cells.BagCell;

	public class ChangeColorCellEvent extends Event
	{
		public static const CLICK:String = "changeColorCellClickEvent";
		public static const SETCOLOR:String = "setColor";
		private var _data:BagCell;
		
		public function ChangeColorCellEvent(type:String, data:BagCell, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		public function get data():BagCell
		{
			return _data;
		}
		
	}
}