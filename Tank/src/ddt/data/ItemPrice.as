package ddt.data
{
	import flash.utils.Dictionary;
	
	import ddt.manager.ItemManager;
	
	/**
	 * @author wicki LA
	 * 
	 * 可以用这个类来描述一个物品的价格，比如一个物品的价格是50金币，60点券；
	 * */
	public class ItemPrice
	{
		private var _prices:Dictionary;
		private var _pricesArr:Array;
		public function ItemPrice(price1:Price,price2:Price,price3:Price)
		{
			_pricesArr = [];
			_prices = new Dictionary();
			addPrice(price1);
			addPrice(price2);
			addPrice(price3);
		}
		
		public function addPrice(price:Price):void
		{
			if(price == null) return;
			_pricesArr.push(price);
			if(_prices[price.UnitToString] == null)
			{
				_prices[price.UnitToString] = price.Value;
			}else
			{
				_prices[price.UnitToString] = _prices[price.UnitToString] + price.Value;
			}
		}
		
		public function addItemPrice(itemPrice:ItemPrice):void
		{
			for each(var price:Price in itemPrice.pricesArr)
			{
				addPrice(price);
			}
		}
		
		public function multiply(value:int):ItemPrice
		{
			if(value<=0)
			{
				throw new Error("Multiply Invalide value!");
			}
			var result:ItemPrice = this.clone();
			for(var i:int=0; i<value-1; i++)
			{
				result.addItemPrice(result.clone());
			}
			return result;
		}
		
		public function clone():ItemPrice
		{
			return new ItemPrice(_pricesArr[0],_pricesArr[1],_pricesArr[2]);
		}
		
		public function get pricesArr():Array
		{
			return _pricesArr;
		}
		
		public function get moneyValue():int
		{
			if(_prices[Price.MONEYTOSTRING] == null)
			{
				return 0;
			}
			return _prices[Price.MONEYTOSTRING];
		}
		
		public function get goldValue():int
		{
			if(_prices[Price.GOLDTOSTRING] == null)
			{
				return 0;
			}
			return _prices[Price.GOLDTOSTRING];
		}
		
		public function get gesteValue():int
		{
			if(_prices[Price.GESTETOSTRING] == null)
			{
				return 0;
			}
			return _prices[Price.GESTETOSTRING];
		}
		
		public function get giftValue():int
		{
			if(_prices[Price.GIFTTOSTRING] == null)
			{
				return 0;
			}
			return _prices[Price.GIFTTOSTRING];
		}
		
		public function getOtherValue(unit:int):int
		{
			var name:String = ItemManager.Instance.getTemplateById(unit).Name;
			if(_prices[name] == null)
			{
				return 0;
			}
			return _prices[name];
		}
		
		/**
		 * 判断此价格是不是合法价格
		 * */
		public function get IsValid():Boolean
		{
			return _pricesArr.length>0;
		}
		
		/**
		 * IsMixed 判断该价格是单类价格还是复合价格
		 * */
		public function get IsMixed():Boolean
		{
			var result:int=0;
			for(var i:String in _prices)
			{
				if(_prices[i]>0) result++;
			}
			return result>1;
		}
		
		public function get PriceType():int
		{
			if(!IsMixed)
			{
				if(moneyValue>0)
				{
					return Price.MONEY;
				}else if(goldValue>0)
				{
					return Price.GOLD;
				}else if(gesteValue>0)
				{
					return Price.GESTE;
				}else if(giftValue>0)
				{
					return Price.GIFT;
				}
				return -5;
			}
			return 0;
		}
		
		public function get IsMoneyType():Boolean
		{
			return (!IsMixed)&&(moneyValue>0);
		}
		
		public function get IsGoldType():Boolean
		{
			return (!IsMixed)&&(goldValue>0);
		}
		
		public function get IsGesteType():Boolean
		{
			return (!IsMixed)&&(gesteValue>0);
		}
		
		public function get IsGiftType():Boolean
		{
			return (!IsMixed)&&(giftValue>0);
		}
		
		public function get IsMedalType():Boolean
		{
			return (!IsMixed)&&(!IsMoneyType)&&(!IsGoldType)&&(!IsGesteType)&&(!IsGiftType);
		}
		
		public function toString():String
		{
			var result:String = "";
			if(moneyValue>0)
			{
				result += moneyValue.toString() + Price.MONEYTOSTRING;
			}
			if(goldValue>0)
			{
				result += goldValue.toString() + Price.GOLDTOSTRING;
			}
			if(gesteValue>0)
			{
				result += gesteValue.toString() + Price.GESTETOSTRING;
			}
			if(giftValue>0)
			{
				result += giftValue.toString() + Price.GIFTTOSTRING;
			}
			
			for(var i:String in _prices)
			{
				if(i!=Price.MONEYTOSTRING && i!=Price.GOLDTOSTRING && i!= Price.GESTETOSTRING && i!=Price.GIFTTOSTRING)
				{
					result += _prices[i].toString() + i;
				}
			}
			return result;
		}

	}
}