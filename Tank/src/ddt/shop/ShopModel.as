package ddt.shop
{
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import road.data.DictionaryData;
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.utils.ClassFactory;
	
	import ddt.data.EquipType;
	import ddt.data.ItemPrice;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ShopIICarItemInfo;
	import ddt.data.goods.ShopItemInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.data.player.SelfInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ShopManager;
	import ddt.utils.LeavePage;
	import ddt.view.bagII.BagEvent;
	import ddt.view.common.FastPurchaseGoldBox;

	public class ShopModel extends EventDispatcher
	{
		private static var DEFAULT_MAN_STYLE:String = "1101,2101,3101,4101,5101,6101,7001,13101,15001";
		private static var DEFAULT_WOMAN_STYLE:String = "1201,2201,3201,4201,5201,6201,7002,13201,15001";
		
		private var _totalGold:int;
		private var _totalMoney:int;
		private var _totalGift:int;
		private var _totalMadel:int;
		
		private var _carList:Array; //购物车
		private var _womanTempList:Array; //女人物模型试穿装备
		private var _manTempList:Array;  //男人物模型试穿装备
		
		public var leftCarList:Array = [];
		public var leftManList:Array = []; 
		public var leftWomanList:Array = [];
		
		private var _manMemoryList:Array;
		private var _womanMemoryList:Array; //点去除装备后用来存储试穿数据的列表
	
		private var _womanModel:PlayerInfo;
		private var _manModel:PlayerInfo;
		
		private var _bodyThings:DictionaryData;
		
		private var _self:SelfInfo;
		
		private var _defaultModel:int; // 0 自己形象 1 原始人物形象(拔掉所有衣服了的形象）
		
		public var leftViewPanel:String = ShopController.TRYPANEL;

		public function ShopModel()
		{
			_self = PlayerManager.Instance.Self;
			
			_womanModel = new PlayerInfo();
			_manModel = new PlayerInfo();
			_womanTempList = [];
			_manTempList = [];
			_carList = [];
			_manMemoryList = [];
			_womanMemoryList = [];
			_totalGold = 0;
			_totalMoney = 0;
			_totalGift = 0;
			_totalMadel = 0;
			
			_defaultModel = 1;
			init();
			fittingSex = _self.Sex;
			
			_self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__styleChange);
			_self.Bag.addEventListener(BagEvent.UPDATE,__bagChange);
		}
		
		private function init():void
		{
			initBodyThing();
			if(_self.Sex)
			{
				if(_defaultModel == 1)
				{
					_manModel.updateStyle(_self.Sex,_self.Hide,_self.getPrivateStyle(),_self.Colors,_self.getSkinColor());
					_manModel.Bag.items = _bodyThings;
				}
				else
				{
					_manModel.updateStyle(true,2222222222,DEFAULT_MAN_STYLE,",,,,,,","");
					_manModel.Bag.items = new DictionaryData();
				}
				_womanModel.updateStyle(false,2222222222,DEFAULT_WOMAN_STYLE,",,,,,,","");
			}
			else
			{
				
				_manModel.updateStyle(true,2222222222,DEFAULT_MAN_STYLE,",,,,,,","");
				if(_defaultModel == 1)
				{
					_womanModel.updateStyle(_self.Sex,_self.Hide,_self.getPrivateStyle(),_self.Colors,_self.getSkinColor());
					_womanModel.Bag.items = _bodyThings;
				}
				else
				{
					_womanModel.updateStyle(false,2222222222,DEFAULT_WOMAN_STYLE,",,,,,,","");
					_womanModel.Bag.items = new DictionaryData();
				}
			}
			
			dispatchEvent(new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE));
		}
		
		public function revertToDefalt():void
		{
			clearAllItemsOnBody();
			dispatchEvent(new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE));
			
			updateCost();
			dispatchEvent(new ShopEvent(ShopEvent.UPDATE_CAR));
		}
		
		private function clearAllItemsOnBody():void
		{
			saveTriedList();
			currentModel.Bag.items = new DictionaryData();
			currentTempList.splice(0,currentTempList.length);
			if(currentModel.Sex)
			{
				currentModel.updateStyle(true,2222222222,DEFAULT_MAN_STYLE,",,,,,,","");
			}
			else
			{
				currentModel.updateStyle(false,2222222222,DEFAULT_WOMAN_STYLE,",,,,,,","");;
			}
		}
		
		public function restoreAllItemsOnBody():void
		{
			if((currentModel.Sex == _self.Sex && currentTempList.length>0)||currentModel.Bag.items != _bodyThings)
			{
				currentTempList.splice(0,currentTempList.length);
				init();
			
				dispatchEvent(new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE));
				
				updateCost();
				dispatchEvent(new ShopEvent(ShopEvent.UPDATE_CAR));
			}
		}
		
		private function saveTriedList():void
		{
			if(currentModel.Sex)
			{
				_manMemoryList = currentTempList.concat();
			}else
			{
				_womanMemoryList = currentTempList.concat();
			}
		}
		
		private function __styleChange(evt:PlayerPropertyEvent):void
		{
			if(currentModel && evt.changedProperties[PlayerInfo.STYLE])
			{
				_defaultModel = 1;
				var model:PlayerInfo = _self.Sex ? _manModel : _womanModel;
				if(_self.Sex)
				{
					_manModel.updateStyle(_self.Sex,_self.Hide,_self.getPrivateStyle(),_self.Colors,_self.getSkinColor());
					_womanModel.updateStyle(false,2222222222,DEFAULT_WOMAN_STYLE,",,,,,,","");
					_manModel.Bag.items = _self.Bag.items;
				}else
				{
					_manModel.updateStyle(true,2222222222,DEFAULT_MAN_STYLE,",,,,,,","");
					_womanModel.updateStyle(_self.Sex,_self.Hide,_self.getPrivateStyle(),_self.Colors,_self.getSkinColor());
					_womanModel.Bag.items = _self.Bag.items;
				}
				clearCurrentTempList(1);
				clearCurrentTempList(2);
				dispatchEvent(new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE));
			}
		}
		
		private function __bagChange(evt:BagEvent):void
		{
			var shouldUpdate:Boolean = false;
			var items:Dictionary = evt.changedSlots;
			for each(var item:InventoryItemInfo in items)
			{
				if(item.Place <=30)
				{
					shouldUpdate = true;
					break;
				}
			}
			if(!shouldUpdate) return;
			var model:PlayerInfo = _self.Sex ? _manModel : _womanModel;
			if(_self.Sex)
			{
				_manModel.Bag.items = _self.Bag.items;
			}else
			{
				_womanModel.Bag.items = _self.Bag.items;
			}
			dispatchEvent(new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE));
		}
		
		private var _sex:Boolean;
		public function get fittingSex():Boolean
		{
			return _sex;
		}
		public function set fittingSex(value:Boolean):void
		{
			if(_sex != value)
			{
				_sex = value;
				var shopEvt:ShopEvent = new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE,"sexChange");
				dispatchEvent(shopEvt);
			}
		}
		
		public function get currentModel():PlayerInfo
		{
			return _sex ? _manModel : _womanModel;
		}
		
		public function get isSelfModel():Boolean
		{
			return _sex == _self.Sex;
		}
		
		public function get manModelInfo():PlayerInfo
		{
			return _manModel;
		}
		
		public function get womanModelInfo():PlayerInfo
		{
			return _womanModel;
		}
		
		public function get currentTempList():Array
		{
			return _sex ? _manTempList : _womanTempList;
		}
		
		public function get currentSkin():String
		{
			var list:Array = currentTempList;
			for(var i:int = 0;i< list.length;i++)
			{
				if(list[i].CategoryID ==  EquipType.FACE)
					return list[i].skin;
			}
			return "";
		}

		public function get allItems():Array
		{
			return _carList.concat(_manTempList).concat(_womanTempList);
		}
		
		public function get allItemsCount():int
		{
			return _carList.length + _manTempList.length + _womanTempList.length;
		}
		
		public function get totalGold():int
		{
			return _totalGold;
		}
		
		public function removeItem(item:ShopIICarItemInfo):void
		{
			if(_carList.indexOf(item) != -1){
				_carList.splice(_carList.indexOf(item),1);
				return;
			}
			if(_manTempList.indexOf(item) != -1){
				_manTempList.splice(_manTempList.indexOf(item),1);
				return;
			}
			if(_womanTempList.indexOf(item) != -1){
				_womanTempList.splice(_womanTempList.indexOf(item),1);
				return;
			}
		}
		
		public function pickOutLeftItems(buyedArr:Array):void
		{
		 	leftCarList = _carList.concat();
		 	leftManList = _manTempList.concat();
		 	leftWomanList = _womanTempList.concat();
		 	
		 	for each(var item:ShopIICarItemInfo in buyedArr)
		 	{
		 		if(leftCarList.indexOf(item) > -1)
		 		{
		 			leftCarList.splice(leftCarList.indexOf(item),1);
		 		}
		 		if(leftManList.indexOf(item) > -1)
		 		{
		 			leftManList.splice(leftManList.indexOf(item),1);
		 		}
		 		if(leftWomanList.indexOf(item) > -1)
		 		{
		 			leftWomanList.splice(leftWomanList.indexOf(item),1);
		 		}
		 	}
		}
		
		public function clearLeftList():void
		{
			leftCarList = [];
			leftManList = [];
			leftWomanList = [];
		}
		
		public function get currentLeftList():Array
		{
			return _sex ? leftManList : leftWomanList;
		}
		
		public function get totalMedal():int
		{
			return _totalMadel;
		}
		
		private var _currentMoney : int;
		private var _currentGold  : int;
		private var _currentGift  : int;
		private var _currentMedal : int;
		/**当前购买商品的总价钱和总金币
		 * 在人试穿时,保存形象会用到**/
		public function get currentMoney() : int
		{
			var temp:Array =  calcPrices(currentTempList);
			_currentMoney = temp[1];
			return _currentMoney;
		}
		public function get currentGold() : int
		{
			var temp:Array =  calcPrices(currentTempList);
			_currentGold = temp[0];
			return _currentGold;
		}
		public function get currentGift():int
		{
			var temp:Array =  calcPrices(currentTempList);
			_currentGift = temp[2];
			return _currentGift;
		}
		
		public function get currentMedal():int
		{
			var temp:Array = calcPrices(currentTempList);
			_currentMedal = temp[3];
			return _currentMedal;
		}
		
		public function get totalMoney():int
		{
			return _totalMoney;
		}
		
		public function get totalGift():int
		{
			return _totalGift;
		}
		
		public function get Self():SelfInfo
		{
			return _self;
		}
		
		public function checkMoney(needMoney:int,needGold:int,needGift:int,needMedal:int):Boolean
		{
			if(needMoney > 0 && needMoney > _self.Money)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
				//MessageTipManager.getInstance().show("点券不足");
				return false;
			}
			if(needGold > 0 && needGold > _self.Gold)
			{
				new FastPurchaseGoldBox(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("ddt.view.GoldInadequate"),EquipType.GOLD_BOX).show();
//				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIBtnPanel.gold"));
				//MessageTipManager.getInstance().show("金币不足");
				return false;
			}
			if(needGift > 0 && needGift > _self.Gift)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.giftLack"));
				return false;
			}
			if(needMedal > 0 && needMedal > _self.getMedalNum())
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.madelLack"));
				return false;
			}
			return true;
		}
		/**
		 *判断是否有免费物品 
		 * 
		 */
		public function hasFreeItems():Boolean
		{
			for(var i:uint =0;i<allItems.length;i++)
			{
				if(ShopIICarItemInfo(allItems[i]).isFreeShopItem())
				{
					return true;
				}
			}
			return false;
		}		
		
		
		public function clearAllitems():void
		{
			_carList = [];
			_defaultModel = 1;
			_manTempList = [];
			_womanTempList = [];
			updateCost();
			dispatchEvent(new ShopEvent(ShopEvent.UPDATE_CAR));
			init();
		}
		
		public function clearCurrentTempList(sex:int = 0):void
		{
			if(sex == 0)
			{
				currentTempList.splice(0,currentTempList.length);
			}else if(sex == 1)
			{
				_manTempList.splice(0,_manTempList.length);
			}else if(sex == 2)
			{
				 _womanTempList.splice(0,_womanTempList.length);
			}
			updateCost();
			dispatchEvent(new ShopEvent(ShopEvent.UPDATE_CAR));
			init();
		}

		
		public function addToShoppingCar(item:ShopIICarItemInfo):void
		{

			// 限量购买处理 add by Freeman <start>
			
			for each (var obj:Object in ShopManager.countLimitArray){
				if(obj["templateID"]==item.TemplateID){
					if(obj["currentCount"]<=item.count){
						obj["currentCount"]++;
					}
					if(obj["currentCount"]>item.count && item.count!=-1)
					{
						obj["currentCount"]--;
						MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.GoodsNumberLimit"));
						return;
					}
				}
			}

			// 限量购买处理 add by Freeman <end>
			
			
			if(_carList.length + _manTempList.length + _womanTempList.length >= 20)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.car"));
				return;
			}
			_carList.push(item);
			updateCost();
			dispatchEvent(new ShopEvent(ShopEvent.ADD_CAR_EQUIP,item));
		}
		
		public function addToCurrentList(item:ShopIICarItemInfo):void{
			currentTempList.push(item);
			updateCost();
			dispatchEvent(new ShopEvent(ShopEvent.ADD_CAR_EQUIP,item));
		}
		
		public function removeFromShoppingCar(item:ShopIICarItemInfo):void
		{
			//从试穿列表里面移除
			removeTempEquip(item);
			var index:int = _carList.indexOf(item);
			if(index != -1)
			{
				_carList.splice(index,1);
				updateCost();
				dispatchEvent(new ShopEvent(ShopEvent.REMOVE_CAR_EQUIP,item));
			}		
		}
		
		public function addTempEquip(item:ShopItemInfo):void
		{
			if(_carList.length + _manTempList.length + _womanTempList.length >= 20)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.car"));
				return;
			}
			var t:Array = findSame(item);
			var canAdd:Boolean = false;
			if(t.length > 1 || (EquipType.dressAble(item.TemplateInfo) && t.length > 0))
			{
				if(t[0].TemplateID == item.TemplateID)
				{
					setSelectedEquip(t[0]);
				}
				else if( t.length == 2 && t[1].TemplateID == item.TemplateID)
				{
					setSelectedEquip(t[1]);
				}
				else
				{
					removeTempEquip(t[0]);
					canAdd = true;
				}
			}
			else
			{	
				canAdd = true;
			}
			if(canAdd)
			{
				var tt:ShopIICarItemInfo = fillToShopCarInfo(item);
				tt.dressing = true;
				tt.ModelSex = currentModel.Sex;
				currentTempList.push(tt);
				dispatchEvent(new ShopEvent(ShopEvent.ADD_TEMP_EQUIP,tt));
				updateCost();
			}
		}
				
		public function removeTempEquip(item:ShopIICarItemInfo):void
		{
			var index:int = _manTempList.indexOf(item);
			var model:PlayerInfo;
			if(index != -1)
			{
				_manTempList.splice(index,1);
				model = _manModel;
			}
			else
			{
				index = _womanTempList.indexOf(item);
				if(index != -1)
				{
					_womanTempList.splice(index,1);
					model = _womanModel;
				}
			}
			if(model)
			{
				var oldItem:InventoryItemInfo = model.Bag.items[item.place];
				if(oldItem)
				{
					//还原
					if(EquipType.isEditable(oldItem) || item.CategoryID ==  13)
						model.setPartStyle(item.CategoryID,item.TemplateInfo.NeedSex,oldItem.TemplateID,oldItem.Color);
					if(item.CategoryID == EquipType.FACE)
					{
						model.Skin = _self.Skin;
					}
				}
				else
				{
					//清除
					if(EquipType.dressAble(item.TemplateInfo))
					{
						model.setPartStyle(item.CategoryID,item.TemplateInfo.NeedSex);
						if(item.CategoryID == EquipType.FACE)
						{
							model.Skin = "";
						}
					}
				}
				dispatchEvent(new ShopEvent(ShopEvent.REMOVE_TEMP_EQUIP,item,model));
			}
			updateCost();
			if(currentTempList.length > 0)
			{
				setSelectedEquip(currentTempList[currentTempList.length -1]);
			}
		}
		
		public function restoreAllTredItems():void
		{
			if(currentModel.Bag.items != _bodyThings || currentModel.Hide != Self.Hide) 
			{
				if(currentModel.Sex == _self.Sex)
				{
					initBodyThing();
					currentModel.updateStyle(_self.Sex,_self.Hide,_self.getPrivateStyle(),_self.Colors,_self.getSkinColor());
					currentModel.Bag.items = _bodyThings;
				}else
				{
					currentModel.updateStyle(currentModel.Sex,2222222222,(currentModel.Sex ? DEFAULT_MAN_STYLE : DEFAULT_WOMAN_STYLE),",,,,,,","");
					currentModel.Bag.items = new DictionaryData();
				}
				dispatchEvent(new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE));
				while(currentMemoryList.length>0)
				{
					addTempEquip(currentMemoryList.shift());
				}
			}
		}
		
		public function get currentMemoryList():Array
		{
			return currentModel.Sex ? _manMemoryList : _womanMemoryList;
		}
		
		
		private function fillToShopCarInfo(item:ShopItemInfo):ShopIICarItemInfo
		{
			var t:ShopIICarItemInfo = new ShopIICarItemInfo(item.GoodsID,item.TemplateID);
			ClassFactory.copyProperties(item,t);
			return t;
		}
		
		public function setSelectedEquip(item:ShopIICarItemInfo):void
		{
			if(item is ShopIICarItemInfo)
			{
				var i:int = currentTempList.indexOf(item);
				if(i != -1)	currentTempList.splice(i,1);
				currentTempList.push(item);
				dispatchEvent(new ShopEvent(ShopEvent.SELECTEDEQUIP_CHANGE,item));
			}
		}
		
		public function updateCost():void
		{
			_totalGold = 0;
			_totalMoney = 0;
			_totalGift = 0;
			_totalMadel = 0;
			
			var temp:Array =  calcPrices(_carList);
			_totalGold += temp[0];
			_totalMoney += temp[1];
			_totalGift += temp[2];
			_totalMadel += temp[3];
			
			temp = calcPrices(_womanTempList);
			_totalGold += temp[0];
			_totalMoney += temp[1];
			_totalGift += temp[2];
			_totalMadel += temp[3];
			
			temp = calcPrices(_manTempList);
			_totalGold += temp[0];
			_totalMoney += temp[1];
			_totalGift += temp[2];
			_totalMadel += temp[3];
			dispatchEvent(new ShopEvent(ShopEvent.COST_UPDATE));
		}
		
		/**
		 * 计算列表中的物品价格 
		 * @param list
		 * @return arr[0] 金币 arr[1]点券 arr[2]礼券 arr[3]勋章
		 * 
		 */		
		public function calcPrices(list:Array):Array
		{
			
			var totalPrice:ItemPrice = new ItemPrice(null,null,null);
			var g:int = 0;
			var m:int = 0;
			var l:int = 0;
			var md:int = 0;
			
			
			for(var i:int = 0; i < list.length; i++)
			{
				totalPrice.addItemPrice(list[i].getCurrentPrice());
			}
			g = totalPrice.goldValue;
			m = totalPrice.moneyValue;
			l = totalPrice.giftValue;
			md = totalPrice.getOtherValue(EquipType.MEDAL);

			return [g,m,l,md];
		}
			
		/**
		 * 能否购买购物车中至少一样物品
		 */
		public function canBuyLeastOneGood(array:Array):Boolean{
			return ShopManager.Instance.buyLeastGood(array,_self);
		}
		
		private function findSame(item:ShopItemInfo):Array
		{
			var temp:Array = new Array();
			for(var i:int = 0; i < currentTempList.length; i++)
			{
				if((currentTempList[i] as ShopIICarItemInfo).CategoryID == item.TemplateInfo.CategoryID)
				{
					temp.push(currentTempList[i]);
				}
			}
			return temp;
		}
		
		
			
		private function findEquip(id:Number,list:Array):int
		{
			for(var i:int = 0; i < list.length; i++)
			{
				if(list[i].TemplateID == id)
				{
					return i;
				}
			}
			return -1;
		}
		
		public function canChangSkin():Boolean
		{
			var list:Array = currentTempList;
			for(var i:int = 0;i< list.length;i++)
			{
				if(list[i].CategoryID ==  EquipType.FACE)
					return true;
			}
			return false;
		}
		
		private function initBodyThing():void
		{
			_bodyThings = new DictionaryData();
			for each(var item:InventoryItemInfo in _self.Bag.items)
			{
				if(item.Place <=30)
				_bodyThings.add(item.Place,item);
			}
		}
			
		public function dispose():void
		{
			_self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__styleChange);
			_self.Bag.removeEventListener(BagEvent.UPDATE,__bagChange);
			_womanModel = null;
			_manModel = null;
			_carList = null;
			leftCarList = null;
			leftManList = null;
			leftWomanList = null;
		}
	}
}