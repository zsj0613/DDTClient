package ddt.shop.view
{
	import fl.controls.ScrollPolicy;
	
	import flash.events.Event;
	
	import game.crazyTank.view.shopII.ShoppingCarAsset;
	
	import road.ui.controls.SimpleGrid;
	import road.ui.manager.UIManager;
	import road.utils.ComponentHelper;
	
	import ddt.shop.ShopController;
	import ddt.shop.ShopEvent;
	import ddt.shop.ShopModel;
	
	import ddt.data.goods.ShopIICarItemInfo;
	import ddt.data.goods.ShopItemInfo;
	import ddt.manager.ShopManager;
	public class ShopShoppingCar extends ShoppingCarAsset
	{
		private var _controller:ShopController;
		private var _model:ShopModel;
		private var _list:SimpleGrid;
		
		public function ShopShoppingCar(controller:ShopController,model:ShopModel)
		{
			_controller = controller;
			_model = model;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			_list = new SimpleGrid(357,66);
			_list.verticalScrollPolicy = ScrollPolicy.ON;
			_list.horizontalScrollPolicy = ScrollPolicy.OFF;
			_list.verticalLineScrollSize = _list.verticalPageScrollSize = 64;
			ComponentHelper.replaceChild(this,list_pos,_list);
			UIManager.setChildCenter(this);
		}
		
		private function initEvent():void
		{
			_model.addEventListener(ShopEvent.ADD_CAR_EQUIP,__addCarEquip);
			_model.addEventListener(ShopEvent.ADD_TEMP_EQUIP,__addCarEquip);
			
			_model.addEventListener(ShopEvent.REMOVE_CAR_EQUIP,__removeCarEquip);
			_model.addEventListener(ShopEvent.REMOVE_TEMP_EQUIP,__removeCarEquip);
			
			_model.addEventListener(ShopEvent.UPDATE_CAR,__updateCar);
		}
	
		private function __addCarEquip(evt:ShopEvent):void
		{
			addCarEquip(evt.param as ShopIICarItemInfo);
		}
		

		private function addCarEquip(info:ShopIICarItemInfo):void
		{
			var item:ShopShoppingCarItem = new ShopShoppingCarItem();
			item.shopItemInfo = info;
			
			_list.appendItem(item);
			item.addEventListener(ShopShoppingCarItem.DELETE_ITEM,__deleteItem);
			item.addEventListener(ShopShoppingCarItem.CONDITION_CHANGE,__conditionChange);
			_list.verticalScrollPosition = _list.maxVerticalScrollPosition;

		}
		
		private function __removeCarEquip(evt:ShopEvent):void
		{
			var item:ShopIICarItemInfo = evt.param as ShopIICarItemInfo;
			var si:ShopShoppingCarItem
			for each( si in _list.items)
			{
				if(si.shopItemInfo == item) break;
			}
			if(si)
			{
				si.removeEventListener(ShopShoppingCarItem.DELETE_ITEM,__deleteItem);
				si.removeEventListener(ShopShoppingCarItem.CONDITION_CHANGE,__conditionChange);
				_list.removeItem(si);
			}
		}
		
		private function __deleteItem(evt:Event):void
		{
			var item:ShopShoppingCarItem = evt.currentTarget as ShopShoppingCarItem;
			for each (var obj:Object in ShopManager.countLimitArray){
				if(obj["templateID"] == item.shopItemInfo.TemplateID)
					obj["currentCount"]--;
			}
			_controller.removeFromCar(item.shopItemInfo as ShopIICarItemInfo);
		}
		
		private function __updateCar(e:ShopEvent):void
		{
			_list.clearItems();
			var list:Array = _model.allItems;
			for(var i:int = 0; i < list.length; i++)
			{
				addCarEquip(list[i]);
			}
		}
		
		private function __conditionChange(evt:Event):void
		{
			_controller.updateCost();
		}
		
		public function removeView():void
		{
			if(parent)
				parent.removeChild(this);
		}
		
		public function dispose():void
		{
			_controller = null;
			_model = null;
			removeView();
			for each(var si:ShopShoppingCarItem in _list.items)
			{
				si.removeEventListener(ShopShoppingCarItem.DELETE_ITEM,__deleteItem);
				si.removeEventListener(ShopShoppingCarItem.CONDITION_CHANGE,__conditionChange);
				_list.removeItem(si);
				si.dispose();
			}
			_list.clearItems();
			if(_list.parent)_list.parent.removeChild(_list);
			_list = null;
		}
	}
}