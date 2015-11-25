package ddt.view.items
{
	import flash.events.Event;
	
	public class ItemEvent extends Event
	{
		public static const ITEM_CLICK:String = "itemClick";
		public static const ITEM_OVER:String = "itemOver";
		public static const ITEM_OUT:String = "itemOut";
		public static const ITEM_MOVE:String = "itemMove";
		
		private var _item:Object;
		
		private var _index:uint;
		
		public function get item():Object
		{
			return _item;
		}
		
		public function get index():uint
		{
			return _index;
		}
		
		public function ItemEvent(type:String,item:Object,index:uint)
		{
			super(type);
			_item = item;
			_index = index;
		}

	}
}