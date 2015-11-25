package ddt.data
{
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	
	/**
	 * @author wicki LA
	 * 价格类，包括数值Value与单位unit。
	 * 一个典型的价格是：5金币
	 * 5为数值Value，“金币”是单位unit；
	 * 
	 * 包括五种单位——MONEY：点券，GOLD：金币，GESTE：功勋，GIFT：礼券.
	 * 此外还有一种特殊的单位：物品ID，如果一个石头的物品ID是1000,
	 * 那Price（5，1000）就是5个石头。
	 * */
	public class Price
	{
		public static const MONEY:int = -1;
		public static const GOLD:int = -2;
		public static const GESTE:int = -3;
		public static const GIFT:int = -4;
		
		public static const MONEYTOSTRING:String = LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionBrowseView.stipple");
		public static const GOLDTOSTRING:String = LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.gold");
		public static const GESTETOSTRING:String = LanguageMgr.GetTranslation("gongxun");
		public static const GIFTTOSTRING:String = LanguageMgr.GetTranslation("ddt.gameover.takecard.gifttoken");
		
		private var _value:int;
		private var _unit:int;
		public function Price(value:int,unit:int)
		{
			_value = value;
			_unit = unit;
		}
		
		public function clone():Price
		{
			return new Price(_value,_unit);
		}
		
		public function get Value():int
		{
			return _value;
		}
		
		public function get Unit():int
		{
			return _unit;
		}
		
		public function get UnitToString():String
		{
			if(_unit == MONEY) return MONEYTOSTRING;
			if(_unit == GOLD) return GOLDTOSTRING;
			if(_unit == GESTE) return GESTETOSTRING;
			if(_unit == GIFT) return GIFTTOSTRING;
			if(ItemManager.Instance.getTemplateById(_unit)) return ItemManager.Instance.getTemplateById(_unit).Name;
			return "错误单位";
		}

	}
}