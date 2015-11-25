package ddt.view.taskII
{
	import flash.events.Event;

	public class AwardSelectedEvent extends Event
	{
		public static var ITEM_SELECTED:String = "ItemSelected";
		private var _itemCell:TaskAwardCell
		public function AwardSelectedEvent(itemCell:TaskAwardCell,type:String="ItemSelected" , bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_itemCell = itemCell;
		}
		public function get itemCell():TaskAwardCell{
			return _itemCell;
		}
	}
}