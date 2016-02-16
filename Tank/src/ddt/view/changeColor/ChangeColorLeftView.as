package ddt.view.changeColor
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import game.crazyTank.view.common.changeColorCellAsset;
	import game.crazyTank.view.common.changeColorLeftViewAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HCheckBox;
	
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.view.cells.BagCell;
	import ddt.view.characterII.CharactoryFactory;
	import ddt.view.characterII.ICharacter;
	import ddt.view.colorEditor.ColorEditor;
	
	public class ChangeColorLeftView extends changeColorLeftViewAsset
	{
		private var _charater:ICharacter;
		private var _cell:ColorEditCell;
		private var _model:ChangeColorModel;
		private var _colorEditor:ColorEditor;
		private var _hideHat:HCheckBox;
		private var _hideGlass:HCheckBox;
		private var _hideSuit:HCheckBox;
		
		public function ChangeColorLeftView(model:ChangeColorModel)
		{
			_model = model;
			initView();
			initEvents();
		}
		
		private function initView():void
		{
			_cell = new ColorEditCell(new changeColorCellAsset());
			addChild(_cell);
			_cell.x = cell_pos.x;
			_cell.y = cell_pos.y;
			cell_pos.visible = false;
			
			_charater = CharactoryFactory.createCharacter(_model.self);
			character_pos.addChild(_charater as DisplayObject);
			_charater.show(false,-1);
			_charater.showGun = false;
			
			_hideHat = new HCheckBox(LanguageMgr.GetTranslation("shop.ShopIITryDressView.hideHat"));
			_hideHat.labelGape = 2;
			_hideHat.fireAuto = true;
			addChild(_hideHat);
			_hideHat.x = hideHat_pos.x;
			_hideHat.y = hideHat_pos.y;
			_hideHat.selected = _model.self.getHatHide();
			removeChild(hideHat_pos);
			
			
			_hideGlass = new HCheckBox(LanguageMgr.GetTranslation("ddt.view.changeColor.ChangeColorLeftView.glass"));
			//_hideGlass = new HCheckBox("隐藏眼镜");
			_hideGlass.labelGape = 2;
			_hideGlass.fireAuto = true;
			addChild(_hideGlass);
			_hideGlass.x = hideGlass_pos.x;
			_hideGlass.y = hideGlass_pos.y;
			_hideGlass.selected = _model.self.getGlassHide();
			removeChild(hideGlass_pos);
			
			_hideSuit = new HCheckBox(LanguageMgr.GetTranslation("ddt.view.changeColor.ChangeColorLeftView.suit"));
			//_hideSuit = new HCheckBox("隐藏套装");
			_hideSuit.labelGape = 2;
			_hideSuit.fireAuto = true;
			addChild(_hideSuit);
			_hideSuit.x = hideSuit_pos.x;
			_hideSuit.y = hideSuit_pos.y;
			_hideSuit.selected = _model.self.getSuitesHide();
			removeChild(hideSuit_pos);
			
			_colorEditor = new ColorEditor();
			addChild(_colorEditor);
			_colorEditor.x = colorPanel_pos.x;
			_colorEditor.y = colorPanel_pos.y;
			colorPanel_pos.visible = false;
			updateColorPanel();
		}
		
		private function initEvents():void
		{
			_cell.addEventListener(Event.CHANGE,__cellChangedHandler);
			_colorEditor.addEventListener(Event.CHANGE,__setColor);
			_hideHat.addEventListener(Event.CHANGE,__hideHatChange);
			_hideGlass.addEventListener(Event.CHANGE,__hideGalssChange);
			_hideSuit.addEventListener(Event.CHANGE,__hideSuitChange);
		}
		
		private function removeEvents():void
		{
			_cell.removeEventListener(Event.CHANGE,__cellChangedHandler);
			_colorEditor.removeEventListener(Event.CHANGE,__setColor);
			_hideHat.removeEventListener(Event.CHANGE,__hideHatChange);
			_hideGlass.removeEventListener(Event.CHANGE,__hideGalssChange);
			_hideSuit.removeEventListener(Event.CHANGE,__hideSuitChange);
		}
		
		private function __cellChangedHandler(evt:Event):void
		{
			if((evt.target as BagCell).info&&_model.currentItem==null)
			{
				_model.currentItem = _cell.bagCell.itemInfo;
				savaItemInfo();
				
				updateCharator();
			}else if((evt.target as BagCell).info==null)
			{
				reset();
			}
			updateColorPanel();
		}
		
		private function __setColor(evt:Event):void
		{
			if(_model.currentItem)
			{
				if(_colorEditor.selectedType()==2)
				{
                    setItemSkin(_model.currentItem,_colorEditor.selectedSkin.toString());
				}else
				{
					setItemColor(_model.currentItem,_colorEditor.selectedColor.toString());
				}
				_model.changed = true;
			}
		}
		
		private function setItemSkin(item:InventoryItemInfo,color:String):void
		{
			if(item.Color == "")
            {
            	item.Color = "||";
            }
			var temp:Array = item.Color.split("|");
			if(temp.length>2)
			{
				temp[1] = color;
			}
			var tempColor:String = temp.join("|");
			
			item.Color = tempColor;
			item.Skin = color;
			
			_cell.setColor(tempColor);
			_model.self.setSkinColor(color);
		}
		
		private function setItemColor(item:InventoryItemInfo,color:String):void
		{
			var _temp:Array = item.Color.split("|");
			_temp[_cell.editLayer-1] = String(color);
			var tempColor_1:String = _temp.join("|");
			
			item.Color = tempColor_1;
			_cell.setColor(tempColor_1);
			_model.self.setPartColor(_model.currentItem.CategoryID,tempColor_1);
			_model.self.setSkinColor(_model.self.getSkinColor());
		}
		
		private function __hideHatChange(evt:Event):void
		{
			SoundManager.Instance.play("008");
			_model.self.setHatHide(_hideHat.selected);
		}
		
		private function __hideGalssChange(evt:Event):void
		{
			SoundManager.Instance.play("008");
			_model.self.setGlassHide(_hideGlass.selected);
		}
		
		private function __hideSuitChange(evt:Event):void
		{
			SoundManager.Instance.play("008");
			_model.self.setSuiteHide(_hideSuit.selected);
		}
		
		private function updateColorPanel():void
		{
			if(_cell.info == null)
			{
				_colorEditor.skinEditable = false;
				_colorEditor.colorEditable = false;
			}else
			{
			    if(_cell.info.CategoryID == EquipType.FACE)
			    {
			    	if(EquipType.isEditable(_cell.info))
			    	{
			    		_colorEditor.colorEditable = true;
			    	}
			    	_colorEditor.skinEditable = true;
			    }else
			    {
			        _colorEditor.colorEditable = true;
			    }
			    _colorEditor.editSkin(_colorEditor.selectedSkin);
		    	_colorEditor.editColor(_colorEditor.selectedColor);
			}
		}
		
		public function reset():void
		{
			if(_model.currentItem == null) return;
			
			restoreItem();
			restoreCharacter();
			
            _model.changed = false;
            _model.currentItem = null;
		}
		
		private function updateCharator():void
		{
			_model.self.setPartStyle(_model.currentItem.CategoryID,_model.currentItem.NeedSex,_model.currentItem.TemplateID, _model.currentItem.Color);
			if(_model.currentItem.CategoryID==EquipType.FACE||_model.currentItem.Skin!="")
			{
				_model.self.setSkinColor(_cell.bagCell.itemInfo.Skin);
			}else
			{
				_model.self.setSkinColor(_model.self.getSkinColor());
			}
		}
		
		private function restoreItem():void
		{
			_model.restoreItem();
		}
		
		private function restoreCharacter():void
		{
			_model.self.setPartStyle(_model.currentItem.CategoryID,(_model.self.Sex?1:2),PlayerManager.Instance.Self.getPartStyle(_model.currentItem.CategoryID),PlayerManager.Instance.Self.getPartColor(_model.currentItem.CategoryID),true)
            _model.self.setPartColor(_model.currentItem.CategoryID,PlayerManager.Instance.Self.getPartColor(_model.currentItem.CategoryID));
            _model.self.setSkinColor(PlayerManager.Instance.Self.Skin);
		}
		
		private function savaItemInfo():void
		{
			_model.savaItemInfo();
		}
		
		public function setCurrentItem(cell:BagCell):void
		{
			SoundManager.Instance.play("008");
			if(_cell.bagCell==null&&cell.info!=null)
			{
				_cell.bagCell = cell;
			    cell.locked = true;
			}else
			{
				_cell.bagCell.locked = false;
				_cell.bagCell = cell;
				cell.locked = true;
			}
		}
		
		public function dispose():void
		{
			removeEvents();
			reset();
		    if(_hideHat && _hideHat.parent) _hideHat.parent.removeChild(_hideHat);
//			if(_hideHat) _hideHat.dispose();
			_hideHat = null;
			if(_hideGlass && _hideGlass.parent) _hideGlass.parent.removeChild(_hideGlass);
//			if(_hideGlass) _hideGlass.dispose();
			_hideHat = null;
			if(_hideSuit && _hideSuit.parent) _hideSuit.parent.removeChild(_hideSuit);
//			if(_hideSuit) _hideSuit.dispose();
			_hideSuit = null;
			
			_colorEditor.dispose();
			_colorEditor = null;
			_model = null;
			_cell.dispose();
			_cell = null;
			_charater.dispose();
			_charater = null;
		}

	}
}