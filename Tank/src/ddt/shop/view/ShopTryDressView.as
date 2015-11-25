package ddt.shop.view
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.shopII.ShopIIBodyCellAsset;
	import game.crazyTank.view.shopII.ShopIITryShopAsset;
	
	import road.data.DictionaryData;
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HCheckBox;
	import road.ui.controls.HButton.HMovieClipButton;
	import road.ui.controls.HButton.HTipButton;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	import road.utils.ComponentHelper;
	
	import ddt.shop.ShopController;
	import ddt.shop.ShopEvent;
	import ddt.shop.ShopModel;
	
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ShopIICarItemInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ShopManager;
	import ddt.manager.UserGuideManager;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.characterII.CharactoryFactory;
	import ddt.view.characterII.ICharacter;
	import ddt.view.common.Repute;

	public class ShopTryDressView extends ShopIITryShopAsset
	{
		private var _controller:ShopController;
		private var _model:ShopModel;
		
		private var _manplayer:ICharacter;
		private var _womanplayer:ICharacter;
		private var _items:Array;
		private var _hidehat:HCheckBox;
		private var _hideGlass:HCheckBox;
		private var _hideSuites:HCheckBox;
		private var _repute:Repute;
		
		private var buyBtn:HMovieClipButton;
		private var fill_btn:HBaseButton;
		
		//true:buy  false:present
		private var _payOrPressent:Boolean;
		
		private var _presentBtn:HBaseButton;
		
		private var repeal_btn:HTipButton;
		private var save_btn:HMovieClipButton;
		
		private var _bottomView:ShopLeftBottomView;
		private var returnToBeginBtn:HTipButton;
		private var _restoreBtn:HTipButton;
		private var _buyPanel:ShopSaveFigurePanel; /**购物车**/
		private var _savepanel:ShopSaveFigurePanel; /**试衣间**/
		private var _givePanel:ShopSaveFigurePanel; /**赠送面板**/
		
		public function ShopTryDressView(controller:ShopController,model:ShopModel)
		{
			_controller = controller;
			_model = model;
			super();
			init();
			initEvent();
		}
		private function init():void
		{
			repeal_btn = new HTipButton(personBody.repealBtnAccect,"",LanguageMgr.GetTranslation("shop.ShopIITryDressView.repeal"));
			repeal_btn.useBackgoundPos = true;
			personBody.addChild(repeal_btn);
			repeal_btn.enable = true;
			
			save_btn = new HMovieClipButton(saveBtnAsset);
			save_btn.useBackgoundPos = true;
			personBody.addChild(save_btn);
			save_btn.enable = false;
			
			returnToBeginBtn = new HTipButton(personBody.returnToBeginBtnAccect,"",LanguageMgr.GetTranslation("shop.ShopIITryDressView.returnToBegin1")+"\n"+LanguageMgr.GetTranslation("shop.ShopIITryDressView.returnToBegin2"));
			returnToBeginBtn.useBackgoundPos = true;
			personBody.addChild(returnToBeginBtn);
			
			_restoreBtn = new HTipButton(personBody.restoreBtn,"",LanguageMgr.GetTranslation("shop.view.restore"));
			_restoreBtn.useBackgoundPos = true;
			personBody.addChild(_restoreBtn);
			
			_bottomView = new ShopLeftBottomView(_model);
			_bottomView.x = leftBottomView_mc.x;
			_bottomView.y = leftBottomView_mc.y;
			removeChild(leftBottomView_mc);
			addChild(_bottomView);
	
			_hidehat = new HCheckBox(LanguageMgr.GetTranslation("shop.ShopIITryDressView.hideHat"));
			//_hidehat = new HCheckBox("隐藏帽子");
			_hidehat.labelGape = 2;
			_hidehat.fireAuto = true;
			personBody.removeChild(personBody.hidehat_pos);
			_hidehat.x = personBody.hidehat_pos.x;
			_hidehat.y = personBody.hidehat_pos.y;
			personBody.addChild(_hidehat);

			_hideGlass = new HCheckBox(LanguageMgr.GetTranslation("ddt.view.changeColor.ChangeColorLeftView.glass"));
			//_hideGlass = new HCheckBox("隐藏眼镜");
			_hideGlass.labelGape = 2;
			_hideGlass.fireAuto = true;
			personBody.removeChild(personBody.hideglass_pos);
			_hideGlass.x = personBody.hideglass_pos.x;
			_hideGlass.y = personBody.hideglass_pos.y;
			personBody.addChild(_hideGlass);
			
			_hideSuites = new HCheckBox(LanguageMgr.GetTranslation("ddt.view.changeColor.ChangeColorLeftView.suit"));
			//_hideSuites = new HCheckBox("隐藏套装");
			_hideSuites.labelGape = 2;
			_hideSuites.fireAuto = true;
			personBody.removeChild(personBody.hideSuits_pos);
			_hideSuites.x = personBody.hideSuits_pos.x;
			_hideSuites.y = personBody.hideSuits_pos.y;
			personBody.addChild(_hideSuites);
			muteLock = true;
			_hidehat.selected = PlayerManager.Instance.Self.getHatHide();
			_hideGlass.selected = PlayerManager.Instance.Self.getGlassHide();
			_hideSuites.selected = PlayerManager.Instance.Self.getSuitesHide();
			muteLock = false;
			personBody.nick_txt.text = String(_model.Self.NickName);
			
			buyBtn = new HMovieClipButton(buyBtnAsset);
			buyBtn.useBackgoundPos = true;
			addChild(buyBtn);
			
			_presentBtn = new HBaseButton(presentBtnAccect);
			_presentBtn.useBackgoundPos = true;
			addChild(_presentBtn);
	
			_items = [];
			for(var i:int = 0; i < 17; i++)
			{
				var item:ShopBodyCell = new ShopBodyCell(new ShopIIBodyCellAsset());
				ComponentHelper.replaceChild(this.personBody,this.personBody["cell_" + i],item);
				_items.push(item);
			}
			
			_repute = new Repute(PlayerManager.Instance.Self.Repute,PlayerManager.Instance.Self.Grade);
			_repute.x = personBody.repute_pos.x;
			_repute.y = personBody.repute_pos.y;
			personBody.removeChild(personBody.repute_pos);
			personBody.addChild(_repute);
			
			refreshCharater();
			
			__update(null);
			changeToShopCarView();
		}
	
		private function initEvent():void
		{
			
			buyBtn.addEventListener(MouseEvent.CLICK,__buyClick);
			
			repeal_btn.addEventListener(MouseEvent.CLICK,__repealClick);
			save_btn.addEventListener(MouseEvent.CLICK,__saveClick);
			returnToBeginBtn.addEventListener(MouseEvent.CLICK,__revert);
			_restoreBtn.addEventListener(MouseEvent.CLICK,__restoreClick);
			_presentBtn.addEventListener(MouseEvent.CLICK,__presentClick);
			for(var i:int = 0; i < _items.length; i++)
			{
				if(_items[i] is ShopBodyCell)
				{
					_items[i].addEventListener(MouseEvent.CLICK,__itemClick);
				}
			}
			_model.addEventListener(ShopEvent.COST_UPDATE,__update);
			_model.addEventListener(ShopEvent.ADD_TEMP_EQUIP,__addTempEquip);
			_model.addEventListener(ShopEvent.REMOVE_TEMP_EQUIP,__removeTempEquip);
			_model.addEventListener(ShopEvent.SELECTEDEQUIP_CHANGE,__selectedEquipChange);
			_model.addEventListener(ShopEvent.FITTINGMODEL_CHANGE,__fittingSexChanged);
			_hidehat.addEventListener(Event.CHANGE,__hideHatChange);
			_hideGlass.addEventListener(Event.CHANGE,__hideGlassChange);
			_hideSuites.addEventListener(Event.CHANGE,__hideSuitesChange);
			_bottomView.addEventListener(ShopEvent.COLOR_SELECTED,__selectedColorChanged);
			
			addEventListener(Event.ADDED_TO_STAGE,userGuide);
		}
		private function userGuide(e:Event):void{
			if(!UserGuideManager.Instance.getIsFinishTutorial(36)){//试穿一件衣服
				UserGuideManager.Instance.setupStep(36,UserGuideManager.CONTROL_GUIDE,null,checkUserGuideTask36);
			}
			if(!UserGuideManager.Instance.getIsFinishTutorial(37)){//保存形象
				UserGuideManager.Instance.setupStep(37,UserGuideManager.BUTTON_GUIDE,null,save_btn);
			}
		}
		private function checkUserGuideTask36():Boolean{
			if(save_btn.enable){
				return true;
			}
			return false;
		}
		
		private function doPresent(msg:String,nick:String):void
		{
			_controller.presentItems(_model.allItems,msg,nick);
			_model.clearAllitems();
		}
		
		private function doPay():void
		{
			if(_payOrPressent)
			{
				_controller.buyItems(_model.allItems,false);
				_model.clearAllitems();
			}
			else
			{
				var present:ShopPresentView = new ShopPresentView(_controller);
				UIManager.AddDialog(present);
			}
		}
		
		private function __update(evt:ShopEvent):void
		{
			buyBtn.enable = _model.allItemsCount != 0;
			_presentBtn.enable = _model.allItemsCount != 0;
		}
		
		private function __presentClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			
			if(_model.hasFreeItems())
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIBtnPanel.message.free"));
				//MessageTipManager.getInstance().show("免费物品不可赠送");
				return;
			}
			var giveList:Array = ShopManager.Instance.moneyGoods(_model.allItems,_model.Self);
			if(giveList.length > 0){
				_givePanel = new ShopSaveFigurePanel(_controller,_model,giveList,ShopSaveFigurePanel.PRESENT_PANEL);
				UIManager.setChildCenter(_givePanel);
				TipManager.AddTippanel(_givePanel);
				_givePanel.setList(giveList);	
			}else{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.cantPresent"));	
			}
		}
		
		private function __buyClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if((_model.totalMoney > 0 || _model.totalGift > 0 || _model.totalMedal > 0) && PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			_buyPanel = new ShopSaveFigurePanel(_controller,_model,_model.allItems,ShopSaveFigurePanel.BUY_PANEL);
			UIManager.setChildCenter(_buyPanel);
			_buyPanel.setPanelVisible(true,2);
			TipManager.AddTippanel(_buyPanel);
		}
		
		public function changeToShopCarView():void
		{
			_bottomView.changeToShopCarView();
		}
	
		private function refreshCharater():void
		{
			if(_manplayer)
			{
				_manplayer.dispose();
				_manplayer = null;
			}
			if(_womanplayer) 
			{
				_womanplayer.dispose();
				_womanplayer = null;
			}
			_manplayer = CharactoryFactory.createCharacter(_model.manModelInfo);
			personBody.figure1_pos.addChild(_manplayer as DisplayObject);
			_manplayer.show(false,-1);
		
			_womanplayer = CharactoryFactory.createCharacter(_model.womanModelInfo);
			personBody.figure2_pos.addChild(_womanplayer as DisplayObject);
			_womanplayer.show(false,-1);
			_manplayer.showGun = _womanplayer.showGun = false;
	
			__fittingSexChanged(null);
		}
		
		private function __fittingSexChanged(event:ShopEvent):void
		{
			_womanplayer.visible = _model.fittingSex ? false : true;
			_manplayer.visible = _model.fittingSex ? true : false;
			muteLock = true;
			_hideGlass.selected =_model.currentModel.getGlassHide();
			_hidehat.selected = _model.currentModel.getHatHide();
			_hideSuites.selected = _model.currentModel.getSuitesHide();
			muteLock = false;
			for(var i:int = 0; i< _items.length;i++)
			{
				if(_model.currentModel.Bag.items[i])
				{
					_items[i].info = _model.currentModel.Bag.items[i];
					_items[i].locked = true;
				}else
				{
					_items[i].shopItemInfo = null;
				}
			}
			
			for each(var item:ShopIICarItemInfo in _model.currentTempList)
			{
				var evt:ShopEvent = new ShopEvent("shop",item);
				__addTempEquip(evt);		
			}
			
			updateButtons();
		}
		
		private function __selectedEquipChange(evt:ShopEvent):void
		{
			updateButtons();
		}
		
		private function __itemClick(evt:MouseEvent):void
		{
			if((evt.currentTarget as ShopBodyCell).locked) return;
			var info:ShopIICarItemInfo = (evt.currentTarget as ShopBodyCell).shopItemInfo;
			_controller.setSelectedEquip(info);
		}
		
		private function __repealClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(_bottomView.TriedItem)
			{
				_controller.removeTempEquip(_bottomView.TriedItem);
			}else
			{
				_controller.restoreAllTredItems();
			}
		}
		
		private function updateButtons():void
		{
			save_btn.enable =   _model.isSelfModel && _model.currentTempList.length != 0;
			_restoreBtn.enable = _model.Self.Sex == _model.fittingSex;
		}
		
		private function __selectedColorChanged(event:ShopEvent):void
		{
			var obj:Object = event.param;
			var item:ShopIICarItemInfo = obj["item"] as ShopIICarItemInfo;
			if(obj["type"] == 1)
			{
				setColorLayer(obj["color"],item);
			}
			else
			{
				setSkinColor(obj["color"],item);
			}
		}
		
		private function setColorLayer(color:int,item:ShopIICarItemInfo):void
		{
			if(item && EquipType.isEditable(item.TemplateInfo) && int(item.colorValue) != color)
			{
				_items[item.place].setColor(item.Color);
			}
		}

		private function setSkinColor(color:String,item:ShopIICarItemInfo):void
		{
			for each(var cell:* in _items)
			{
				if(cell is ShopBodyCell)
				{
					cell.setSkinColor(color);
				}
			}
			if(item && item.CategoryID == EquipType.FACE)
			{
				item.skin = color;
			}
		}
		/**
		 * mutelocked than  do not play the sound
		 */		
		private var muteLock:Boolean = false;
		private function __hideHatChange(evt:Event):void
		{
			if(!muteLock)
			{
				SoundManager.instance.play("008");
			}
			_model.currentModel.setHatHide(_hidehat.selected);
		}
		
		private function __hideGlassChange(evt:Event):void
		{
			if(!muteLock)
			{
				SoundManager.instance.play("008");
			}
			_model.currentModel.setGlassHide(_hideGlass.selected);
		}
		
		private function __hideSuitesChange(evt:Event):void
		{
			if(!muteLock)
			{
				SoundManager.instance.play("008");
			}
			_model.currentModel.setSuiteHide(_hideSuites.selected);
		}
		
		
		
		private function __addTempEquip(evt:ShopEvent):void
		{
			var info:ShopIICarItemInfo = evt.param as ShopIICarItemInfo;
			
			if(EquipType.isProp(info.TemplateInfo))	return;
			if(EquipType.dressAble(info.TemplateInfo)&&info.CategoryID!=EquipType.CHATBALL)
			{
				var place:int = EquipType.CategeryIdToPlace(info.CategoryID)[0];
				_items[place].shopItemInfo = info;
				info.place = place;
				_model.currentModel.setPartStyle(info.CategoryID,info.TemplateInfo.NeedSex,info.TemplateID,info.Color);
			}
			else
			{
				var replace : Boolean = false;
				var ps:Array = EquipType.CategeryIdToPlace(info.CategoryID);
				for each(var i:int in ps)
				{
					//locked == true,标示此格子为原始物品。
					if(_items[i].info == null || _items[i].locked == true)
					{
						_items[i].shopItemInfo = info;
						info.place = i;
						replace = true;
						break;
					}
				}
				if(!replace)
				{
					_items[ps[0]].shopItemInfo = info;
					info.place = ps[0];
				}
			}
			
			updateButtons();
		}
		
		private function __removeTempEquip(evt:ShopEvent):void
		{
			if(evt.model == _model.currentModel)
			{
				var item:ShopIICarItemInfo = evt.param as ShopIICarItemInfo;
				var place:int = item.place;
				var orientItem:InventoryItemInfo = _model.currentModel.Bag.items[place];
				_items[place].shopItemInfo = null;
				if(orientItem)
				{
					//还原
					_items[place].info  = orientItem;
					_items[place].locked = true;
				}
				else
				{
					//清除
					_items[place].info = null;
				}
				
				updateButtons();
			}
		}
	
		private function __saveClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			_savepanel = new ShopSaveFigurePanel(_controller,_model,_model.currentTempList,1);
			UIManager.setChildCenter(_savepanel);
		    _savepanel.setPanelVisible(true,1);
			TipManager.AddTippanel(_savepanel);	
		}
		
		private function __revert(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			_controller.revertToDefault();
		}
		
		private function __restoreClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			_controller.restoreAllItemsOnBody();
		}
		
		public function dispose():void
		{
			buyBtn.removeEventListener(MouseEvent.CLICK,__buyClick);
			repeal_btn.removeEventListener(MouseEvent.CLICK,__repealClick);
			save_btn.removeEventListener(MouseEvent.CLICK,__saveClick);
			returnToBeginBtn.removeEventListener(MouseEvent.CLICK,__revert);
			_restoreBtn.removeEventListener(MouseEvent.CLICK,__restoreClick);
			
			_model.removeEventListener(ShopEvent.COST_UPDATE,__update);
			_model.removeEventListener(ShopEvent.ADD_TEMP_EQUIP,__addTempEquip);
			_model.removeEventListener(ShopEvent.REMOVE_TEMP_EQUIP,__removeTempEquip);
			_model.removeEventListener(ShopEvent.SELECTEDEQUIP_CHANGE,__selectedEquipChange);
			_model.removeEventListener(ShopEvent.FITTINGMODEL_CHANGE,__fittingSexChanged);
			_presentBtn.removeEventListener(MouseEvent.CLICK,__presentClick);
			
			_bottomView.removeEventListener(ShopEvent.COLOR_SELECTED,__selectedColorChanged);
			
			_bottomView.dispose();
			_controller = null;
			_model = null;
			
			var bodyThing:DictionaryData = PlayerManager.Instance.Self.Bag.items;
			
			for(var i:int = 0; i < _items.length; i++)
			{
				_items[i].dispose();
				if(bodyThing[i.toString()])
				bodyThing[i.toString()].lock = false;
			}
			_manplayer.dispose();
			_womanplayer.dispose();
			if(parent)
				parent.removeChild(this);
		}
	}
}