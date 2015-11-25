package ddt.shop.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	import game.crazyTank.view.shopII.ShopLeftBottomViewAsset;
	
	import road.manager.SoundManager;
	import road.utils.ComponentHelper;
	
	import ddt.shop.ShopController;
	import ddt.shop.ShopEvent;
	import ddt.shop.ShopModel;
	
	import ddt.data.EquipType;
	import ddt.data.goods.ShopIICarItemInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.view.bagII.BagEvent;
	import ddt.view.colorEditor.ColorEditor;
	
	import webGame.crazyTank.view.shopII.ShopIIPreloadCellAsset;
	
	/**
	 * @author WickiLA
	 * @time 0105/2010
	 * @description 商城左边视图的下部，包括购物车信息面板跟调色面板
	 * */
	
	public class ShopLeftBottomView extends ShopLeftBottomViewAsset
	{
		private var _model:ShopModel;
		private var _preLoader:ShopBodyCell;
		private var _colorEditor:ColorEditor;
		
		private var addedManNewEquip:int = 0;
		private var addedWomanNewEquip:int = 0;
		private var changeColorPanelClicked:Boolean = false;
		private var colorBtnEnable:Boolean = false;
		
		public function ShopLeftBottomView(model:ShopModel)
		{
			_model = model;
			init();
			initEvents();
		}
		
		private function init():void
		{
			_preLoader = new ShopBodyCell(new ShopIIPreloadCellAsset());
			pre_pos.visible = false;
			ComponentHelper.replaceChild(this,pre_pos,_preLoader);
			
			_colorEditor = new ColorEditor();
			_colorEditor.x = colorBG_pos.x;
			_colorEditor.y = colorBG_pos.y;
			removeChild(colorBG_pos);
			addChild(_colorEditor);
			
			btnShiner.mouseChildren = btnShiner.mouseEnabled = btnShiner.visible = false;
			
			shopCarBtn.buttonMode = true;
			colorBtn.buttonMode = true;
			ColorBtnEnable = false;
			
			shopCarPanel.madel_txt.text = _model.Self.getMedalNum().toString();
			shopCarPanel.money_txt.text = String(_model.Self.Money);
			shopCarPanel.gift_txt.text = String(_model.Self.Gift);
		}
		
		private function initEvents():void
		{
			_model.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__propertyChange);
			_model.Self.PropBag.addEventListener(BagEvent.UPDATE,__updateMedal);
			_model.Self.ConsortiaBag.addEventListener(BagEvent.UPDATE,__updateMedal);
			_model.addEventListener(ShopEvent.COST_UPDATE,__update);
			_model.addEventListener(ShopEvent.ADD_TEMP_EQUIP,__addTempEquip);
			_model.addEventListener(ShopEvent.REMOVE_TEMP_EQUIP,__removeTempEquip);
			_model.addEventListener(ShopEvent.SELECTEDEQUIP_CHANGE,__selectedEquipChange);
			_model.addEventListener(ShopEvent.FITTINGMODEL_CHANGE,__fittingSexChanged);
			_colorEditor.addEventListener(Event.CHANGE,__selectedColorChanged);
			_preLoader.addEventListener(ShopEvent.ITEMINFO_CHANGE,__itemInfoChange);
			
			shopCarBtn.addEventListener(MouseEvent.CLICK,__shopCarBtnClick);
			colorBtn.addEventListener(MouseEvent.CLICK,__colorBtnClick);
			
			addEventListener(Event.ENTER_FRAME,checkShiner);
		}
		
		private function removeEvents():void
		{
			_model.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__propertyChange);
			_model.Self.PropBag.removeEventListener(BagEvent.UPDATE,__updateMedal);
			_model.Self.ConsortiaBag.removeEventListener(BagEvent.UPDATE,__updateMedal);
			_model.removeEventListener(ShopEvent.COST_UPDATE,__update);
			_model.removeEventListener(ShopEvent.ADD_TEMP_EQUIP,__addTempEquip);
			_model.removeEventListener(ShopEvent.REMOVE_TEMP_EQUIP,__removeTempEquip);
			_model.removeEventListener(ShopEvent.SELECTEDEQUIP_CHANGE,__selectedEquipChange);
			_model.removeEventListener(ShopEvent.FITTINGMODEL_CHANGE,__fittingSexChanged);
			_colorEditor.removeEventListener(Event.CHANGE,__selectedColorChanged);
			_preLoader.removeEventListener(ShopEvent.ITEMINFO_CHANGE,__itemInfoChange);
			
			shopCarBtn.removeEventListener(MouseEvent.CLICK,__shopCarBtnClick);
			colorBtn.removeEventListener(MouseEvent.CLICK,__colorBtnClick);
			
			removeEventListener(Event.ENTER_FRAME,checkShiner);
		}
		
		private function __itemInfoChange(evt:Event):void
		{
			updateColorEditor();
		}
		
		private function __updateMedal(evt:BagEvent):void
		{
			shopCarPanel.madel_txt.text = _model.Self.getMedalNum().toString();
		}
		
		private function __propertyChange(evt:PlayerPropertyEvent):void
		{
			if(evt.changedProperties[PlayerInfo.MONEY] || evt.changedProperties[PlayerInfo.GIFT])
			{
				shopCarPanel.money_txt.text = String(_model.Self.Money);
				shopCarPanel.gift_txt.text = String(_model.Self.Gift);
			}
		}
		
		private function __update(evt:ShopEvent):void
		{
			shopCarPanel.needMadel_txt.textColor = shopCarPanel.needMoney_txt.textColor = shopCarPanel.needGift_txt.textColor = 0x000000;
			shopCarPanel.needMadel_txt.text = String(_model.totalMedal);
			shopCarPanel.needMoney_txt.text = String(_model.totalMoney);
			shopCarPanel.needGift_txt.text = String(_model.totalGift);
			shopCarPanel.count_txt.text = String(_model.allItemsCount);
			if(_model.totalMedal > _model.Self.getMedalNum()){
				shopCarPanel.needMadel_txt.textColor = 0xff0000;
			}
			if(_model.totalMoney > _model.Self.Money){
				shopCarPanel.needMoney_txt.textColor = 0xff0000;
			}
			if(_model.totalGift > _model.Self.Gift){
				shopCarPanel.needGift_txt.textColor = 0xff0000;
			}
		}
		
		private function __addTempEquip(evt:ShopEvent):void
		{
			var info:ShopIICarItemInfo = evt.param as ShopIICarItemInfo;
			if(EquipType.isProp(info.TemplateInfo))	return;
			
			_preLoader.shopItemInfo = info;
			updateColorEditor();
			if(!isChangeColorState)
			{
				if(info.TemplateInfo.NeedSex == 1)
				{
					addedManNewEquip++;
				}else if(info.TemplateInfo.NeedSex == 2)
				{
					addedWomanNewEquip++;
				}
			}
		}
		
		private function __removeTempEquip(evt:ShopEvent):void
		{
			var item:ShopIICarItemInfo = evt.param as ShopIICarItemInfo;
			if(_preLoader.shopItemInfo == item)
			{ 
				_preLoader.shopItemInfo = null;
			}
			updateColorEditor();
			if(item.TemplateInfo.NeedSex == 1)
			{
				addedManNewEquip > 0 ? addedManNewEquip-- : addedManNewEquip = 0;
			}else if(item.TemplateInfo.NeedSex == 2)
			{
				addedWomanNewEquip > 0 ? addedWomanNewEquip-- : addedWomanNewEquip = 0;
			}
		}
		
		private function __selectedEquipChange(evt:ShopEvent):void
		{
			_preLoader.shopItemInfo = evt.param as ShopIICarItemInfo;
			updateColorEditor();
		}
		
		private function __fittingSexChanged(evt:ShopEvent):void
		{
			var list:Array = _model.currentTempList;
			
			if(list.length > 0)
			{
				_preLoader.shopItemInfo = list[list.length-1];
			}
			else
			{
				_preLoader.shopItemInfo = null;
			}
		}
		
		private function __selectedColorChanged(event:Event):void
		{
			var obj:Object = new Object();
			if(_colorEditor.selectedType() == 1)
			{
				setColorLayer(_colorEditor.selectedColor);
				obj.color = _colorEditor.selectedColor;
			}else
			{
				setSkinColor(String(_colorEditor.selectedSkin));
				obj.color = _colorEditor.selectedSkin;
			}
			obj.item = _preLoader.shopItemInfo;
			obj.type = SelectedColorType;
			dispatchEvent(new ShopEvent(ShopEvent.COLOR_SELECTED,obj));
		}
		
		private function checkShiner(evt:Event):void
		{
			if((_model.fittingSex ? (addedManNewEquip>0):(addedWomanNewEquip>0)) && !isChangeColorState &&  colorBtnEnable)
			{
				btnShiner.visible = true;
			}else
			{
				btnShiner.visible = false;
			}
			
			if(_model.leftViewPanel == ShopController.TRYPANEL && (_colorEditor.colorEditable || _colorEditor.skinEditable) && _preLoader.info != null)
			{
				ColorBtnEnable = true;
			}else
			{
				ColorBtnEnable = false;
			}
		}
		
		public function get isChangeColorState():Boolean
		{
			return colorBtn.currentFrame == 1;
		}
		
		private function setColorLayer(color:int):void
		{
			var item:ShopIICarItemInfo = _preLoader.shopItemInfo;
			if(item && EquipType.isEditable(item.TemplateInfo) && int(item.colorValue) != color)
			{
				var editlayer:int = _preLoader.editLayer - 1;
				var place:int = EquipType.CategeryIdToPlace(item.CategoryID)[0];
				
				var temp:Array = item.Color.split("|");
				temp[editlayer] = String(color);
				item.Color = temp.join("|");
				
				_preLoader.setColor(item.Color);
				_model.currentModel.setPartColor(item.CategoryID,item.Color);
			}
		}

		private function setSkinColor(color:String):void
		{
			var _item:ShopIICarItemInfo = _preLoader.shopItemInfo;
			if(_item && _item.CategoryID == EquipType.FACE)
			{
				_item.skin = color;
			}
			_preLoader.setSkinColor(color);
			_model.currentModel.Skin = color;
		}
		
		private function updateColorEditor():void
		{
			_colorEditor.skinEditable = false;
			if(_model.canChangSkin())
			{
				if(_preLoader.shopItemInfo&&_preLoader.shopItemInfo.CategoryID == EquipType.FACE) _colorEditor.skinEditable = true;
				setSkinColor(_model.currentSkin);
				_colorEditor.editSkin(_colorEditor.selectedSkin);
			}else
			{
				_colorEditor.skinEditable = false;
				_colorEditor.resetSkin();
			}
			
			if(_preLoader.shopItemInfo && EquipType.isEditable(_preLoader.shopItemInfo.TemplateInfo))
			{
				_colorEditor.colorEditable = true;
				_colorEditor.editColor(int(_preLoader.shopItemInfo.colorValue));
			}else
			{
				_colorEditor.colorEditable = false;
			}	
		}
		
		public function set ColorBtnEnable(value:Boolean):void
		{
			colorBtnEnable = value;
			if(!value)
			{
				colorBtn.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
			}else
			{
				colorBtn.filters = null;
			}
			colorBtn.mouseChildren = colorBtn.mouseEnabled = value;
		}
		
		public function changeToColorView():void
		{
			shopCarBtn.gotoAndStop(2);
			colorBtn.gotoAndStop(1);
			shopCarPanel.visible = false;
			colorPanel.visible = true;
			_colorEditor.visible = true;
			btnShiner.visible = false;
		}
		
		public function changeToShopCarView():void
		{
			shopCarBtn.gotoAndStop(1);
			colorBtn.gotoAndStop(2);
			shopCarPanel.visible = true;
			colorPanel.visible = false;
			_colorEditor.visible = false;
			
			__update(null);
			__updateMedal(null);
		}
		
		public function get SelectedColorType():int
		{
			return _colorEditor.selectedType();
		}
		
		public function get TriedItem():ShopIICarItemInfo
		{
			return _preLoader.shopItemInfo as ShopIICarItemInfo;
		}
		
		private function __shopCarBtnClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			changeToShopCarView();
		}
		
		private function __colorBtnClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			changeToColorView();
			if(_model.fittingSex)
			{
				addedManNewEquip = 0;
			}else
			{
				addedWomanNewEquip = 0;
			}
		}
		
		public function dispose():void
		{
			removeEvents();
			_model = null;
		}

	}
}