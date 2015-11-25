package ddt.data.goods
{
	import flash.events.Event;
	
	import ddt.data.ItemPrice;

	public class ShopIICarItemInfo extends ShopItemInfo
	{
		private var _currentBuyType:int = 1;
		
		public function ShopIICarItemInfo(goodsID:int,templateID:int)
		{
			super(goodsID,templateID);
			currentBuyType = 1;
			dressing = false;
		}
		
		//public function set Property8(value:String):void
		//{
		//	super.TemplateInfo.Property8 = value;
		//	for(var i:int = 0; i < value.length - 1; i++)
		//	{
		//		_color += "|";
		//	}
		//}
		
		public function get Property8():String
		{
			return super.TemplateInfo.Property8;
		}
		
		public function get CategoryID():int
		{
			return TemplateInfo.CategoryID;
		}
		
		//颜色层次，一层颜色|二层颜色|三层。。。
		private var _color:String = "";
		public function get Color():String
		{
			return _color;
		}
		public function set Color(value:String):void
		{
			if(_color != value)
			{
				_color = value;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function set currentBuyType(value:int):void
		{
			_currentBuyType = value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get currentBuyType():int
		{
			return _currentBuyType;
		}
		
		public function getCurrentPrice():ItemPrice
		{
			return getItemPrice(_currentBuyType);
		}
		
		public var dressing:Boolean;
		
		public var ModelSex:Boolean;
		
		public var colorValue:String = "";
		
		public var place:int;
		
		public var skin:String = "";
	}
}