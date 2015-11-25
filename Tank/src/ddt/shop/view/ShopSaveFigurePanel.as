package ddt.shop.view
{
	import fl.controls.ScrollPolicy;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HFrame;
	import road.ui.manager.TipManager;
	import road.utils.ComponentHelper;
	
	import ddt.shop.ShopController;
	import ddt.shop.ShopEvent;
	import ddt.shop.ShopModel;
	
	import ddt.data.goods.ShopIICarItemInfo;
	import ddt.data.goods.ShopItemInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ShopManager;
	import ddt.manager.SocketManager;
	import ddt.manager.UserGuideManager;
	import ddt.utils.LeavePage;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	
	import webGame.crazyTank.view.shopII.ShopIISaveFigureAsset;

	public class ShopSaveFigurePanel extends ShopIISaveFigureAsset
	{
		private var _controller:ShopController;
		private var _model:ShopModel;
		private var _bg:HFrame;
		private var _list:SimpleGrid;
		private var okBtn:HLabelButton;
		private var cancelBtn:HLabelButton;
		private var _tempList:Array;
		private var _type:int;
		private var buyArray:Array = [];
		private var giveArray:Array = [];
		private var tempCurrentList:Array = [];
		
		public static const SAVA_PANEL:int = 1;
		public static const BUY_PANEL:int = 2;	
		public static const PRESENT_PANEL:int = 3;
		
		public function ShopSaveFigurePanel(controller:ShopController,model:ShopModel,list:Array,type:int)
		{
			_controller = controller;
			_model = model;
			_tempList = list;
			_type = type;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			_bg = new HFrame();
			_bg.setSize(468,550);
			_bg.moveEnable = false;
			_bg.showClose = false;
			addChildAt(_bg,0);
			saveTitle.gotoAndStop(1);
			
			_list = new SimpleGrid(380,66);
			ComponentHelper.replaceChild(this,list_pos,_list);
			_list.horizontalScrollPolicy = ScrollPolicy.OFF;
			_list.verticalScrollPolicy = ScrollPolicy.ON;
			_list.verticalLineScrollSize = 64;
			noM_txt.text = noG_txt.text = noMD_txt.text = "";
			
			okBtn = new HLabelButton();
			okBtn.x = 215;
			okBtn.y = 507;
			addChild(okBtn);
			cancelBtn = new HLabelButton();
			cancelBtn.x = 330;
			cancelBtn.y = 507;
			addChild(cancelBtn);
			if(_type == PRESENT_PANEL)
			{
				okBtn.label = LanguageMgr.GetTranslation("shop.view.present");//赠送
		 		cancelBtn.label = LanguageMgr.GetTranslation("ddt.view.DefyAfficheView.cancel");//取消
			}else
			{
				okBtn.label = LanguageMgr.GetTranslation("shop.ShopIISaveFigurePanel.okBtn.label");//支付
				cancelBtn.label = LanguageMgr.GetTranslation("shop.ShopIISaveFigurePanel.cancelBtn.label");//不支付
			}
			
			payBtnAccect.visible = false;
			noPayBtnAccect.visible = false;
			
			updateTxt();
			switchTypeAndChangeView();
		}
		
		private function initEvent():void
		{
			addEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			okBtn.addEventListener(MouseEvent.CLICK,__payClick);
			cancelBtn.addEventListener(MouseEvent.CLICK,__nopayClick);
			_model.addEventListener(ShopEvent.REMOVE_TEMP_EQUIP,__removeCarEquip);
			_model.addEventListener(ShopEvent.CLEAR_TEMP,__clearTemp);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUG_GOODS,onBuyedGoods);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GOODS_PRESENT,onPresent);
			addEventListener(Event.ADDED_TO_STAGE,userGuide);
		}
		
		private function switchTypeAndChangeView():void{
		 	switch(_type){
		 		case SAVA_PANEL:
		 			saveTitle.gotoAndStop(1);
		 			break;
		 		case PRESENT_PANEL:
		 			saveTitle.gotoAndStop(3);
		 			break;
		 		default:
		 			break;
		 	}
		}
		
		private function removeEvent():void
		{
			this.removeEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			okBtn.removeEventListener(MouseEvent.CLICK,__payClick);
			cancelBtn.removeEventListener(MouseEvent.CLICK,__nopayClick);
			_model.removeEventListener(ShopEvent.REMOVE_TEMP_EQUIP,__removeCarEquip);
			_model.removeEventListener(ShopEvent.CLEAR_TEMP,__clearTemp);
			_model.removeEventListener(ShopEvent.UPDATE_CAR,__updateCost);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BUG_GOODS,onBuyedGoods);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GOODS_PRESENT,onPresent);
			for each(var item:ShopShoppingCarItem in _list.items){
				item.removeEventListener(ShopShoppingCarItem.DELETE_ITEM,__deleteItem);
				item.removeEventListener(ShopShoppingCarItem.CONDITION_CHANGE,__conditionChange);
			}
			
		}
		
		private function userGuide(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,userGuide);
			if(!UserGuideManager.Instance.getIsFinishTutorial(38)){//购买
				UserGuideManager.Instance.setupStep(38,UserGuideManager.BUTTON_GUIDE,null,okBtn);
			}
		}
		
		private function __payClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			if(_type == SAVA_PANEL){
				if(_model.canBuyLeastOneGood(_model.currentTempList))
				{
					saveFigureCheckOut();
					_model.clearCurrentTempList((_model.fittingSex) ? 1 : 2);
//					dispose();
				}else if(_model.currentTempList.some(isMoneyGoods))
				{
					HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
				}else
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.lackCoin"));
				}
			}else if(_type == BUY_PANEL){
				if(_model.canBuyLeastOneGood(_model.allItems))
				{
					shopCarCheckOut();
					
//					_model.clearAllitems();
//					dispose();
				}else if(_model.allItems.some(isMoneyGoods))
				{
					HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
				}else
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.lackCoin"));
				}
				return;
			}else if(_type == PRESENT_PANEL){
				presentCheckOut();
				dispose();
			}
		}
		
		private function isMoneyGoods(item:*, index:int, array:Array):Boolean
		{
			if(item is ShopItemInfo)
			{
				return ShopItemInfo(item).getItemPrice(1).IsMoneyType;
			}
			return false;
		}
		
		private function saveFigureCheckOut():void{
	 		buyArray = ShopManager.Instance.buyIt(_model.currentTempList,_model.Self);
	 		_model.pickOutLeftItems(buyArray);
			_controller.buyItems(_model.currentTempList,true,_model.currentModel.Skin);
		}
		
		private function shopCarCheckOut():void{
	 		buyArray = ShopManager.Instance.buyIt(_model.allItems,_model.Self);
	 		_model.pickOutLeftItems(buyArray);
			_controller.buyItems(_model.allItems,false);
		}
		 
		 /**
		 * 赠送支付点击事件
		 */
		 private function presentCheckOut():void{
		 	giveArray = ShopManager.Instance.giveGift(_model.allItems,_model.Self);
		 	_model.pickOutLeftItems(giveArray);
			if(giveArray.length > 0){
				var shopPresent:ShopPresentView = new ShopPresentView(_controller);
				TipManager.AddTippanel(shopPresent,true);
			}else{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
			}
		 }	 
		
		/**
		 * 购买返回处理函数
		 * @params 0是部分成功 其他是全部成功
		 */
		private function onBuyedGoods(event:CrazyTankSocketEvent):void{
			event.pkg.position = SocketManager.PACKAGE_CONTENT_START_INDEX;
			var success:int = event.pkg.readInt();
			if(success != 0){
				if(_type == SAVA_PANEL){
					_model.clearCurrentTempList((_model.fittingSex) ? 1 : 2);
				}else if(_type == BUY_PANEL){
					_model.clearAllitems();
				}
			}else{
				if(_type == SAVA_PANEL){
					_model.clearCurrentTempList((_model.fittingSex) ? 1 : 2);
					for each(var item:ShopIICarItemInfo in _model.currentLeftList)
					{
						_model.addTempEquip(item);	
					}
					setList(_model.currentTempList);
				}else if(_type == BUY_PANEL){
					for(var j:int = 0; j<buyArray.length; j++){
						_model.removeFromShoppingCar(buyArray[j] as ShopIICarItemInfo);
					}
					setList(_model.allItems);
				}
			}
			_model.clearLeftList();
//			_model.clearAllitems();
			if(success!=0) 
				dispose();
		}
		
		/**
		 * 赠送返回
		 */
		private function onPresent(event:CrazyTankSocketEvent):void{
			var boo:Boolean = event.pkg.readBoolean();
			if(boo){
				_model.clearAllitems();
				dispose();		
			}else{
				for(var k:int = 0; k<giveArray.length; k++){
					_model.removeFromShoppingCar(giveArray[k] as ShopIICarItemInfo);
					_tempList.splice(_tempList.indexOf((giveArray[k] as ShopIICarItemInfo)),1);
				}
				if(_tempList.length == 0){
					dispose();
				}else{
					setList(notPresentGoods());			
					return;
				}
			}
		}
		
		/**
		 * 未赠送的物品
		 */
		 private function notPresentGoods():Array{
		 	var notPresent:Array = [];
		 	for each(var item:ShopIICarItemInfo in _tempList){
		 		if(giveArray.indexOf(item) == -1){
		 			notPresent.push(item);
		 		}
		 	}
		 	return notPresent;
		 }
		
		/**
		 * 检查是否包含点券类物品
		 */
		 private function checkMoneyGoods():Boolean{
		 	if(_type == 1){
		 		for each(var itemTwo:ShopIICarItemInfo in _model.currentTempList){
		 			if(itemTwo.getItemPrice(itemTwo.currentBuyType).moneyValue != 0){
		 				return true;
		 			}
		 		}
		 	}else{
		 		for each(var itemOne:ShopIICarItemInfo in _model.allItems){
			 		if(itemOne.getItemPrice(itemOne.currentBuyType).moneyValue != 0){
			 			return true;
			 		}
			 	}	
		 	}
		 	return false;
		 }
		
		private function __nopayClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			dispose();
		}
		
		private function __keyDown(evt:KeyboardEvent):void
		{
			if(evt.keyCode == Keyboard.ESCAPE)
			{
				__nopayClick(null);
			}
		}
		
		public function setList(arr:Array):void
		{
			for each(var shopItem:ShopShoppingCarItem in _list.items){
				shopItem.removeEventListener(ShopShoppingCarItem.DELETE_ITEM,__deleteItem);
				shopItem.removeEventListener(ShopShoppingCarItem.CONDITION_CHANGE,__conditionChange);
			}
			_list.clearItems();
			for each(var i:ShopIICarItemInfo in arr)
			{
				var item:ShopShoppingCarItem = new ShopShoppingCarItem();
				item.shopItemInfo = i;
				item.setColor(i.Color);
				
				
				_list.appendItem(item);
				item.addEventListener(ShopShoppingCarItem.DELETE_ITEM,__deleteItem);
				item.addEventListener(ShopShoppingCarItem.CONDITION_CHANGE,__conditionChange);
			}
				updateTxt();	
		}
		
		private function __deleteItem(evt:Event):void
		{
			var item:ShopShoppingCarItem = evt.currentTarget as ShopShoppingCarItem;
			var shopItemInfo:ShopIICarItemInfo = item.shopItemInfo;
			item.removeEventListener(ShopShoppingCarItem.DELETE_ITEM,__deleteItem);
			item.removeEventListener(ShopShoppingCarItem.CONDITION_CHANGE,__conditionChange);
			_list.removeItem(item);
			item.dispose();
			if(_type == SAVA_PANEL){
				_controller.removeTempEquip(shopItemInfo);
				setList(_model.currentTempList);
				if(_model.currentTempList.length == 0){
					dispose();
				}
			}
			if(_type == BUY_PANEL){
				_controller.removeFromCar(shopItemInfo);
				setList(_model.allItems);
				if(_model.allItems.length == 0){
					dispose();
				}
			}
			if(_type == PRESENT_PANEL){
				_controller.removeFromCar(shopItemInfo);
				_tempList.splice(_tempList.indexOf(shopItemInfo),1);
				setList(_tempList);
				if(_tempList.length == 0){
					dispose();
				}
			}
		}
		
		private function __clearTemp(evt:Event):void
		{
			_list.clearItems();
		}
		
		private function __conditionChange(evt:Event):void
		{
			updateTxt();
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
				si.dispose();
			}
			updateTxt();
		}
		
		private function __updateCost(evt:ShopEvent):void
		{
			updateTxt();
		}
		
		private function updateTxt():void
		{
			noG_txt.textColor = noM_txt.textColor = noMD_txt.textColor = 0x000000;
			var tempArray:Array = (_type == 1) ? _model.currentTempList : _model.allItems;
			if(_type == 3){
				tempArray = _tempList;
			}
			var prices:Array = _model.calcPrices(tempArray);
			gift_txt.text = String(prices[2]);
			money_txt.text = String(prices[1]);
			madel_txt.text = String(prices[3]);
			count_txt.text = String(tempArray.length);
			noM_txt.text = noG_txt.text = noMD_txt.text = "";
			
			if(prices[2] > _model.Self.Gift)	
				noG_txt.text = LanguageMgr.GetTranslation("shop.ShopIISaveFigurePanel.gift",_model.Self.Gift - prices[2]);
				noG_txt.textColor = 0xff0000;
			if(prices[1] > _model.Self.Money)	
				noM_txt.text = LanguageMgr.GetTranslation("shop.ShopIISaveFigurePanel.stipple",_model.Self.Money - prices[1]);
				noM_txt.textColor = 0xff0000;
			if(prices[3] > _model.Self.getMedalNum())
				noMD_txt.text = LanguageMgr.GetTranslation("shop.view.madelLack") + (prices[3] - _model.Self.getMedalNum()) + LanguageMgr.GetTranslation("ge");
				noMD_txt.textColor = 0xff0000;
		}
		
		public function setPanelVisible(b:Boolean,type:int = 0):void
		{
			visible = b;
			if(b)
			{
				if(stage)
				{
					stage.focus = this;
				}
				if(type == SAVA_PANEL){
					setList(_model.currentTempList);
				}
				if(type == BUY_PANEL){
					setList(_model.allItems);
				}
			}
		}
		
		private function disposeBtn():void
		{
			okBtn.dispose();
			okBtn = null;
			cancelBtn.dispose();
			cancelBtn = null;
		}
		
		public function dispose():void
		{
			for each(var obj:Object in ShopManager.countLimitArray){
				obj["currentCount"]=0;
			}
			
			removeEvent();
			disposeBtn();
			
			for each(var si:ShopShoppingCarItem in _list.items)
			{
				si.removeEventListener(ShopShoppingCarItem.DELETE_ITEM,__deleteItem);
				si.removeEventListener(ShopShoppingCarItem.CONDITION_CHANGE,__conditionChange);
				_list.removeItem(si);
				si.dispose();
			}
			_list.clearItems();
			if(_list.parent) _list.parent.removeChild(_list);
			_list = null;
			_model = null;
			giveArray = null;
			_controller = null;
			_tempList = null;
			buyArray = null;
			_bg.dispose();
			_bg = null;
			if(parent) parent.removeChild(this);
		}
	}
}