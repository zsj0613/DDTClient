package ddt.manager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import road.comm.PackageIn;
	import road.data.DictionaryData;
	import road.ui.controls.hframe.HAlertDialog;
	
	import ddt.data.EquipType;
	import ddt.data.ItemPrice;
	import ddt.data.goods.ShopIICarItemInfo;
	import ddt.data.goods.ShopItemInfo;
	import ddt.data.player.SelfInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.request.store.LoadShopItems;
	import ddt.utils.LeavePage;
	
	/**
	 * @author wicki LA
	 * */
	public class ShopManager extends EventDispatcher
	{
		public static const HAT:int = 1;
		public static const GLASS:int = 2;
		public static const HAIR:int = 3;
		public static const FACE_ORNAMENTS:int = 4;
		public static const CLOTH:int = 5;
		public static const EYES:int = 6;
		public static const WEAPON:int = 7;
		public static const ARMLET:int = 8;
		public static const RING:int = 9;
		public static const FIGHT_PROP:int = 10;
		public static const UNFIGHT_PROP:int = 11;
		public static const SUITS:int = 13;
		public static const NAKELACE:int = 14;
		public static const WING:int = 15;
		public static const PAOPAO:int = 16;
		
		public static const COMMON_SHOP:int = 1;
		public static const PROP_SHOP:int = 2;
		public static const GIFT_SHOP:int = 3;
		public static const GESTE_SHOP:int = 4;
		public static const CONSORTIA_SHOP_1:int = 11;
		public static const CONSORTIA_SHOP_2:int = 12;
		public static const CONSORTIA_SHOP_3:int = 13;
		public static const CONSORTIA_SHOP_4:int = 14;
		public static const CONSORTIA_SHOP_5:int = 15;
		
		public var initialized:Boolean = false;
		
		private var _shopGoods:DictionaryData;//所有商品
		private var _categeryTemplates:DictionaryData;//普通商店整理过的数据
		private var _withoutSortTemplatesArr:Array;//普通商店未整理过的数据
		private var _giftTemplates:DictionaryData;//礼券商店
		private var _gesteTemplates:DictionaryData;//功勋商店
		private var _propTemplates:DictionaryData;//战斗道具商店（房间中）
		private var _currentResult:Array;
		private var _consortiaShop:Array;//公会商店物品
		
		private var _giftEquipTypeArr:Array; //礼券商店    分类为 武器  服饰  美容 道具
		private var _gesteEquipTypeArr:Array; //礼券商店    分类为 武器  服饰  美容 道具
		
		private var _discountTemplates:DictionaryData;//优惠商品
		
		//限量商品条件之一, 统计单击商品放入购物车的 商品
		public static var countLimitArray:Array = new Array();
		
		
		//商城推荐排序
		private var _listwithoutSort:Array;
		private var _currentIds:*;
		private var _currentSex:int;
		
		public function ShopManager(singleton : SingletonEnfocer)
		{
			initGiftGesteArr();
		}
		
		public function setUp():void
		{
			new LoadShopItems().loadSync(__sortInfo,3);
		}
		
		private function __sortInfo(loader:LoadShopItems):void
		{
			if(loader.isSuccess)
			{
				_shopGoods = loader.shopinfolist;
				_categeryTemplates = loader.categeryList;
				_propTemplates = loader.propList;
				_giftTemplates = loader.giftList;
				_gesteTemplates= loader.gesteList;
				_withoutSortTemplatesArr = loader.withoutSortTemplatesArr;
				setConsortiaShopTemplates(loader.consortiaShopList1,loader.consortiaShopList2,loader.consortiaShopList3,loader.consortiaShopList4,loader.consortiaShopList5);
				initialized = true;
				dispatchEvent(new Event("shopManagerReady"));
				
				_sortGiftInfo(_giftTemplates,_giftEquipTypeArr);
				_sortGiftInfo(_gesteTemplates,_gesteEquipTypeArr);
				sortDiscountInfo();
			}else
			{
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Error"),LanguageMgr.GetTranslation("ddt.manager.loadShopItemsFailed"),true,callSolveLogin,"stage",HAlertDialog.OK_LABEL,callSolveLogin);
			}
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GOODS_COUNT,__updateGoodsCount);
		}
		
		private function sortDiscountInfo():void
		{
			_discountTemplates = new DictionaryData();
			for each(var item:ShopItemInfo in _shopGoods)
			{
				if(item.IsCheap)
				{
					_discountTemplates.add(item.GoodsID,item);
				}
			}
		}
		
		private function __updateGoodsCount(evt:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = evt.pkg;
			var len:int = pkg.readInt();
			for(var i:int=0;i<len;i++)
			{
				var goodsID:int = pkg.readInt();
				var count:int = pkg.readInt();
				var item:ShopItemInfo = getShopItemByGoodsID(goodsID);
				if(item && item.count){
					item.count = count;
				}
			}
		}
		
		private function initGiftGesteArr():void
		{
			_giftEquipTypeArr = [new DictionaryData(),new DictionaryData(),new DictionaryData(),new DictionaryData(),new DictionaryData()];
			_gesteEquipTypeArr = [new DictionaryData(),new DictionaryData(),new DictionaryData(),new DictionaryData(),new DictionaryData()];
		}
		
		private function _sortGiftInfo(_gift:DictionaryData, arr:Array):void
		{
			arr[0] = _gift;
			for each(var i:ShopItemInfo in _gift)
			{
				switch(i.TemplateInfo.CategoryID)
				{
					case EquipType.ARM:
						arr[2].add(i.TemplateID,i);
						break;
					case EquipType.CLOTH:
					case EquipType.HEAD:
					case EquipType.GLASS:
					case EquipType.ARMLET:
					case EquipType.RING:
					case EquipType.SUITS:
						arr[1].add(i.TemplateID,i);
						break;
					case EquipType.HAIR:
					case EquipType.WING:
					case EquipType.FACE:
					case EquipType.EFF:
						arr[3].add(i.TemplateID,i);
						break;
					case EquipType.UNFRIGHTPROP:
					case EquipType.CHATBALL:
						arr[4].add(i.TemplateID,i);
						break;
					default:
						break;
				}
			}
		}
		
		private function callSolveLogin():void
		{
			LeavePage.LeavePageTo(PathManager.solveLogin(),"_self");
		}
		
		/**
		 * 获取商城单页物品数据
		 */		
		public function getTemplatesByCategeryId(page:int,ids:*,count:int,sex:int,vouch:Boolean):Array
		{
			if(page < 1)page = 1;
			var totalPage:int = getTemplatePage(ids,sex,vouch,count);
			if(page > totalPage)page = totalPage;
			var startIndex:int = (page - 1) * count;
			var endIndex:int = (startIndex + count) > _shopGoods.length ? _shopGoods.length : (startIndex + count);
			return getTemplateByCategeryids(ids,sex,vouch).slice(startIndex,endIndex);
		}
		public function getResultPages(count:int):int
		{
			var page:int = Math.ceil(_currentResult.length / count);
			return page == 0 ? 1 : page;
		}
		//获取所有物品页数
		public function getTemplatePage(ids:*,sex:int,vouch:Boolean,count:int):int
		{
			return Math.ceil(getTemplateByCategeryids(ids,sex,vouch).length / count);
		}
		//获取商城种类模版数据
		public function getTemplateByCategeryids(ids:*,sex:int = 0,vouch:Boolean = false):Array
		{
			if(_currentIds == ids && _currentSex == sex && _currentResult != null)return _currentResult;
			var id_arr:Array;
			if(ids == "")
			{
				id_arr = ["1","2","3","4","5","6","7","8","9","10","13","14","15","16"];
			}else if(ids is Array)
			{
				if((ids as Array).length == 0)
				{
					ids = ["1","2","3","4","5","6","7","8","9","10","13","14","15","16"];
				}
				id_arr = ids;
			}else
			{
				id_arr = [ids];
			}
			var result:Array = [];
			var i:int = 0;
			if(id_arr.length > 9)
			{
				result = new Array().concat(_withoutSortTemplatesArr);
			}
			else
			{
				for(i = 0; i < id_arr.length; i++)
				{
					if(id_arr[i] is Array)
					{
						result = result.concat(getTemplateByCategeryids(id_arr[i],sex,vouch));
					}else
					{
						if(_categeryTemplates[id_arr[i]] != null)result = result.concat(_categeryTemplates[id_arr[i]].list);
					}
				}
			}
			if(sex != 0)
			{
				for(i = result.length - 1; i >= 0 ; i--)
				{
					if(result[i].TemplateInfo.NeedSex != sex && result[i].TemplateInfo.NeedSex != 0)result.splice(i,1);
				}
			}
			if(vouch)
			{
				for(i = result.length - 1; i >= 0 ; i--)
				{
					if(!result[i].IsVouch)result.splice(i,1);
				}
				
			}
			
			
			_currentIds = ids;
			_currentSex = sex;
			_currentResult = result;
			result.sortOn("Sort",Array.NUMERIC | Array.DESCENDING);
			return result;
		}
		
		/**保存公会商城五个级别的数据**/
		public function setConsortiaShopTemplates(arr1 : Array,arr2:Array,arr3:Array,arr4:Array,arr5:Array) : void
		{
			if(!_consortiaShop)_consortiaShop = [[],arr1,arr2,arr3,arr4,arr5];
		}
		
		/**取不同级别的数据,最高级应为五**/
		public function consortiaShopLevelTemplates(level : int) : Array
		{
			if(_consortiaShop.length <= level)return new Array();
			return _consortiaShop[level];
		}
		
		public function getPropShopTemplate():Array
		{
			return _propTemplates.list;
		}
		
		public function canAddPrice(templateID:int):Boolean
		{
			return getShopItemByTemplateId(templateID).length > 0;
		}
		
		public function getGiftShopTemplates(page:int,secondType:int,sex:int):Array
		{
			return getResult(_giftTemplates,page,secondType,sex);
		}
		
		public function getGesteShopTemplates(page:int,sex:int,secondType:int=-1):Array
		{
			return getResult(_gesteTemplates,page,secondType,sex);
		}
		
		public function getGiftShopTemplatesByEquipType(page:int,secondType:int,sex:int,equip:int=0):Array
		{
			return getResult(_giftEquipTypeArr[equip],page,secondType,sex);
		}
		
		public function getGesteShopTemplatesByEquipType(page:int,sex:int,secondType:int=-1,equip:int=0):Array
		{
			return getResult(_gesteEquipTypeArr[equip],page,secondType,sex);
		}
		
		public function getDiscountShopTemplates(page:int,sex:int):Array
		{
			return getResult(_discountTemplates,page,-1,sex);
		}
		
		private function getResult(list:DictionaryData,page:int,secondType:int,sex:int):Array
		{
			var result:Array = [];
			for each(var i:ShopItemInfo in list)
			{
				if(i.TemplateInfo.NeedSex != 0 && i.TemplateInfo.NeedSex != sex) continue;
				if(secondType == -1)
				{
					result.push(i);
				}else if(secondType == 1)
				{
					if(i.TemplateInfo.CanEquip)result.push(i);
				}else
				{
					if(!i.TemplateInfo.CanEquip)result.push(i);
				}
			}
			_currentIds = [-1,-1];
			_currentResult = result;
			
			var count:int = 8;
			if(page < 1)page = 1;
			var totalPage:int = Math.ceil(result.length / count);
			if(page > totalPage)page = totalPage;
			var startIndex:int = (page - 1) * count;
			var endIndex:int = (startIndex + count) > result.length ? result.length : (startIndex + count);
			result.sortOn("Sort",Array.NUMERIC | Array.DESCENDING);
			result = result.slice(startIndex,endIndex);
			return result;
		}
		
		public function getShopItemByTemplateId(id:int,shopID:int=-1):Array
		{
			var _goods:DictionaryData = getShopGoods(shopID);
			var result:Array = [];
			for each(var item:ShopItemInfo in _goods)
			{
				if(item.TemplateID == id)
				result.push(item);
			}
			return result;
		}
		
		private function getShopGoods(shopID:int):DictionaryData
		{
			switch(shopID)
			{
				case -1:
					return _shopGoods;
					break;
				case 2:
					return _propTemplates;
					break;
				case 3:
					return _giftTemplates;
					break;
				default:
					return null;
			}
		}
		
		public function getShopItemByGoodsID(id:int):ShopItemInfo
		{
			for each(var item:ShopItemInfo in _shopGoods)
			{
				if(item.GoodsID == id)
				{
					return item;
				}
			}
			return null;
		}
		
		public function getMoneyShopItemByTemplateID(id:int):ShopItemInfo
		{
			var result:Array = getShopItemByTemplateId(id);
			for(var i:int=0;i<result.length;i++)
			{
				if(result[i].getItemPrice(1).moneyValue > 0 && result[i].ShopID!=22)
				{
					return result[i] as ShopItemInfo;
				}
			}
			return null;
		}
		
		public function getGoldShopItemByTemplateID(id:int,shopID:int = -1):ShopItemInfo
		{
			var result:Array = getShopItemByTemplateId(id,shopID);
			for(var i:int=0;i<result.length;i++)
			{
				if(result[i].getItemPrice(1).goldValue > 0)
				{
					return result[i] as ShopItemInfo;
				}
			}
			return null;
		}
		
		/**
		 * 能够赠送的物品
		 */
		 public function giveGift(list:Array,self:SelfInfo):Array{
		 	var giftArray:Array = [];
		 	var money:int = self.Money;
		 	var itemPrice:ItemPrice;
		 	for each(var item:ShopIICarItemInfo in list){
		 		itemPrice = item.getItemPrice(item.currentBuyType); 
		 		if(money >= itemPrice.moneyValue && itemPrice.giftValue == 0 && itemPrice.goldValue == 0 && itemPrice.getOtherValue(EquipType.MEDAL) == 0){
		 			money -= itemPrice.moneyValue;
		 			giftArray.push(item);
		 		}
		 	}
		 	return giftArray;
		 }
		
		/**
		 * 购物车中的点券物品
		 */
		 public function moneyGoods(list:Array,self:SelfInfo):Array{
		 	var moneyGoods:Array = [];
		 	var itemPrice:ItemPrice;
		 	for each(var item:ShopIICarItemInfo in list){
		 		itemPrice = item.getItemPrice(item.currentBuyType);
		 		if(itemPrice.moneyValue > 0){
		 			moneyGoods.push(item);
		 		}
		 	}
		 	return moneyGoods;
		 }
		
		/**
		 *  是否能够购买购物车中至少一样物品
		 */
		 public function buyLeastGood(list:Array,self:SelfInfo):Boolean{
		 	for each(var item:ShopIICarItemInfo in list){
		 		if(self.Gold >= item.getItemPrice(item.currentBuyType).goldValue &&
		 		   self.Money >= item.getItemPrice(item.currentBuyType).moneyValue &&
		 		   self.Gift >= item.getItemPrice(item.currentBuyType).giftValue &&
		 		   self.getMedalNum() >= item.getItemPrice(item.currentBuyType).getOtherValue(EquipType.MEDAL)){
					   return true;		 		   	
		 		   }
		 	}
		 	return false;
		 }
		 
		 /**
		 *  遍历购物车或者试衣间中的物品，分包购买
		 * @return arr买了哪些
		 */
		public function buyIt(list:Array,self:SelfInfo):Array{
			var buyedArr:Array = [];     //可以买的
			var selfGold:int = self.Gold;
			var selfMoney:int = self.Money;
			var selfGift:int = self.Gift;
			var selfModel:int = self.getMedalNum();
			
			for each(var item:ShopIICarItemInfo in list){
	 		if(selfGold >= item.getItemPrice(item.currentBuyType).goldValue &&
	 		   selfMoney >= item.getItemPrice(item.currentBuyType).moneyValue &&
	 		   selfGift >= item.getItemPrice(item.currentBuyType).giftValue &&
	 		   selfModel >= item.getItemPrice(item.currentBuyType).getOtherValue(EquipType.MEDAL)){
				   	selfGold -= item.getItemPrice(item.currentBuyType).goldValue;
				   	selfMoney -= item.getItemPrice(item.currentBuyType).moneyValue;
				   	selfGift -= item.getItemPrice(item.currentBuyType).giftValue;
				   	selfModel -= item.getItemPrice(item.currentBuyType).getOtherValue(EquipType.MEDAL);
				   	buyedArr.push(item); 	
	 		   }
		 	}
		 	return buyedArr;
		}
		 		
		public function getShopItemByTemplateIDAndShopID(id:int,shopID:int):ShopItemInfo
		{
			var result:Array = getShopItemByTemplateId(id,shopID);
			return result[0];
		}

		private static var _instance:ShopManager;
		public static function get Instance():ShopManager
		{
			if(_instance == null) _instance = new ShopManager(new SingletonEnfocer());
			return _instance;
		}
	}
}

class SingletonEnfocer {}