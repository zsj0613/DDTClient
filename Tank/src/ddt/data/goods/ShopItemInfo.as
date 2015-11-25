package ddt.data.goods
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import ddt.data.ItemPrice;
	import ddt.data.Price;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	
	public class ShopItemInfo extends EventDispatcher
	{
		public static const DAY:String = LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
		public static const AMOUNT:String = LanguageMgr.GetTranslation("ge");
		public static const FOREVER:String = LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.forever");
		
		public var ShopID:int;//所属商店ID
		public var GoodsID:int;
		public var TemplateID:int;//模板ID
		public var BuyType:int;//购买类型，0为按日期购买，1为按数量购买
		public var Sort:int;
		public var IsBind:int;
		public var IsVouch:Boolean;
		public var Label:int;//商品标签1 新品 ，2 热门，3 推荐，4 特价，5 限时 , 6 限量
		public var IsCheap:Boolean;//是否是优惠
		public var Beat:Number;//折扣
		
		/**
		 * 以下属性均为第一种价格的属性
		 * */
		public var AUnit:int;
		public var APrice1:int;//价格种类
		public var AValue1:int;//价格
		public var APrice2:int;
		public var AValue2:int;
		public var APrice3:int;
		public var AValue3:int;
		
		/**
		 * 以下属性均为第二种价格的属性
		 * */
		public var BUnit:int;
		public var BPrice1:int;//价格种类
		public var BValue1:int;//价格
		public var BPrice2:int;
		public var BValue2:int;
		public var BPrice3:int;
		public var BValue3:int;
		
		/**
		 * 以下属性均为第三种价格的属性
		 * */
		public var CUnit:int;
		public var CPrice1:int;//价格种类
		public var CValue1:int;//价格
		public var CPrice2:int;
		public var CValue2:int;
		public var CPrice3:int;
		public var CValue3:int;
		
		private var _templateInfo:ItemTemplateInfo;
		private var _itemPrice:ItemPrice;
		
		private var _count:int = -1;
		
		public function ShopItemInfo($GoodsID:int,$TemplateID:int)
		{
			GoodsID = $GoodsID;
			TemplateID = $TemplateID;
		}
		
		public function set TemplateInfo(value:ItemTemplateInfo):void
		{
			_templateInfo = value;
		}
		
		public function get TemplateInfo():ItemTemplateInfo
		{
			if(_templateInfo == null)
			{
				return ItemManager.Instance.getTemplateById(this.TemplateID);
			}else
			{
				return _templateInfo;
			}
		}
		
		public function getItemPrice(index:int):ItemPrice
		{
			switch(index)
			{
				case 1:
					return new ItemPrice((AUnit == -1)?null:(new Price(AValue1*Beat,APrice1)),(AUnit == -1)?null:(new Price(AValue2*Beat,APrice2)),(AUnit == -1)?null:(new Price(AValue3*Beat,APrice3)));
				case 2:
					return new ItemPrice((BUnit == -1)?null:(new Price(BValue1*Beat,BPrice1)),(BUnit == -1)?null:(new Price(BValue2*Beat,BPrice2)),(BUnit == -1)?null:(new Price(BValue3*Beat,BPrice3)));
				case 3:
					return new ItemPrice((CUnit == -1)?null:(new Price(CValue1*Beat,CPrice1)),(CUnit == -1)?null:(new Price(CValue2*Beat,CPrice2)),(CUnit == -1)?null:(new Price(CValue3*Beat,CPrice3)));
				default:
					break;
			}
			return new ItemPrice(new Price(AValue1,APrice1),new Price(AValue2,APrice2),new Price(AValue3,APrice3));
		}
		
		public function isFreeShopItem():Boolean
		{
			if(getItemPrice(1).toString() == "" && getItemPrice(2).toString() == "" && getItemPrice(3).toString() == "")
			{
				return true;
			}
			return false;
		}
		
		public function getTimeToString(type:int):String
		{
			switch(type)
			{
				case 1:
					return AUnit == 0 ? FOREVER : (AUnit.toString() + buyTypeToString);
				case 2:
					return BUnit == 0 ? FOREVER : (BUnit.toString() + buyTypeToString);
				case 3:
					return CUnit == 0 ? FOREVER : (CUnit.toString() + buyTypeToString);
			}
			return "";
		}
		
		public function get buyTypeToString():String
		{
			if(BuyType == 0) return DAY;
			return AMOUNT;
		}

		/**
		 *每日限量 
		 */
		public function get count():int
		{
			return _count;
		}

		/**
		 * @private
		 */
		public function set count(value:int):void
		{
			if(_count == value) return;
			_count = value;
			dispatchEvent(new Event(Event.CHANGE));
		}


	}
}