package ddt.store.view.storeBag
{
	import fl.controls.ScrollPolicy;
	
	import flash.events.Event;
	import flash.ui.Keyboard;
	
	import game.crazyTank.view.storeII.StoreBagAsset;
	
	import org.aswing.KeyboardManager;
	
	import road.data.DictionaryData;
	import road.manager.SoundManager;
	import road.ui.manager.TipManager;
	
	import ddt.store.data.StoreModel;
	import ddt.store.events.StoreBagEvent;
	
	import tank.assets.ScaleBMP_1;
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.view.bagII.BreakGoodsView;
	import ddt.view.cells.BagCell;
	import ddt.view.common.AddPricePanel;
	import ddt.view.common.CellMenu;
	import ddt.view.infoandbag.CellEvent;

	public class StoreBagView extends StoreBagAsset
	{		
		private var _controller:StoreBagController;
		private var _model:StoreModel;

		private var _equipmentView:StoreBagListView;
		private var _propView:StoreBagListView;
		private var _bitmapBg:StoreBagbgbmp;    /**背景位图**/
		
		public function StoreBagView(controller:StoreBagController)
		{
			this._controller = controller;
			_model = _controller.model;
//			this._model = model;
			super();
			init();
			initEvents();
		}
		
		private function init():void
		{
			_bitmapBg = new StoreBagbgbmp();
			addChildAt(_bitmapBg,0);
			msg_txt.gotoAndStop(1);
			bagBg.gotoAndStop(1);
			_equipmentView = new StoreBagListView(0,_controller);
			_propView = new StoreBagListView(1,_controller);			
			addView();
			
			updateMoney();						
		}
		
		private function initEvents():void
		{
			_equipmentView.addEventListener(CellEvent.ITEM_CLICK,__cellClick);
			_propView.addEventListener(CellEvent.ITEM_CLICK,__cellClick);
			
			CellMenu.instance.addEventListener(CellMenu.ADDPRICE,__cellAddPrice);
			CellMenu.instance.addEventListener(CellMenu.MOVE,__cellMove);

            _model.info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__propertyChange);
		}
		
		private function removeEvents():void
		{
			_equipmentView.removeEventListener(CellEvent.ITEM_CLICK,__cellClick);
			_propView.removeEventListener(CellEvent.ITEM_CLICK,__cellClick);
			
			CellMenu.instance.removeEventListener(CellMenu.ADDPRICE,__cellAddPrice);
			CellMenu.instance.removeEventListener(CellMenu.MOVE,__cellMove);

            _model.info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__propertyChange);
		}
		
		private function addView():void
		{
			_equipmentView.x = equip_pos.x;
			_equipmentView.y = equip_pos.y;
			removeChild(equip_pos);
			addChild(_equipmentView);
			_propView.x = prop_pos.x;
			_propView.y = prop_pos.y;
			removeChild(prop_pos);
			removeChild(bag_pos);
			addChild(_propView);
		}
		
		public function setData(storeModel:StoreModel):void
		{
			if(_controller.currentPanel==0)
			{
				_equipmentView.setData(_model.canStrthEqpmtList);
				_propView.setData(_model.strthAndANchList);
				
				bagBg.gotoAndStop(1);
				changeToDoubleBagView();
				_propView.x = prop_pos.x;
		    	_propView.y = prop_pos.y;
			}else if(_controller.currentPanel==1)
			{
				_equipmentView.setData(_model.canCpsEquipmentList);
				_propView.setData(_model.cpsAndANchList);
				
				bagBg.gotoAndStop(1);
				changeToDoubleBagView();
			}else if(_controller.currentPanel==2)
			{
				_equipmentView.setData(_model.canRongLiangEquipmengtList);
				_propView.setData(_model.cpsAndStrthAndformula);
				bagBg.gotoAndStop(1);
				changeToDoubleBagView();
			}else if(_controller.currentPanel==3)
			{
				_equipmentView.setData(_model.canEmbedEquipList);
				_propView.setData(_model.canEmbedPropList);
				
				bagBg.gotoAndStop(1);
				changeToDoubleBagView();
				
			}else if(_controller.currentPanel==4)
			{
				_equipmentView.setData(_model.canLianhuaEquipList);
				_propView.setData(_model.canLianhuaPropList);
				
				bagBg.gotoAndStop(1);
				changeToDoubleBagView();
			}else
			{			
				_equipmentView.setData(_model.canTransEquipmengtList);
				_propView.setData(new DictionaryData);
				
				bagBg.gotoAndStop(3);
				changeToSingleBagView();							
			}			
		}
		
		private function changeToSingleBagView():void
		{
			_equipmentView.visible = true;
			_propView.visible = false;
			_equipmentView.verticalScrollPolicy = ScrollPolicy.ON;
			_equipmentView.setSize(345,320);
			_propView.setSize(345,138);
			_equipmentView.x = bag_pos.x;
			_equipmentView.y = bag_pos.y;
		}
		
		private function changeToDoubleBagView():void
		{
			_equipmentView.visible = true;
			_propView.visible = true;
			_equipmentView.verticalScrollPolicy = ScrollPolicy.ON;
			_propView.verticalScrollPolicy = ScrollPolicy.ON;
			_equipmentView.setSize(345,138);
			_propView.setSize(345,138);
			_equipmentView.x = equip_pos.x;
	    	_equipmentView.y = equip_pos.y;
			_propView.x = prop_pos.x;
	    	_propView.y = prop_pos.y;
		}
		
		private function __cellClick(evt:CellEvent):void
		{
			evt.stopImmediatePropagation();
			var cell:BagCell = evt.data as BagCell;
			if(cell)
			{
				var info:InventoryItemInfo = cell.info as InventoryItemInfo;
			}
			if(info == null) { return; }
			if(!cell.locked)
			{
				SoundManager.Instance.play("008");
				/* if(KeyboardManager.isDown(Keyboard.SHIFT) && info.Count > 1 && info.MaxCount > 1)
				{
					createBreakWin(cell);
				} 
				else */if((info.getRemainDate() <= 0 && !(EquipType.isProp(info))) || EquipType.isPackage(info))
					{
						//CellMenu.instance.show(cell,stage.mouseX,stage.mouseY);
					}
				else
					cell.dragStart();
			}
		}
		
		private function createBreakWin(cell:BagCell):void
		{
			SoundManager.Instance.play("008");
			var win:BreakGoodsView = new BreakGoodsView(cell);
			win.show();
		}
		
		private function __cellAddPrice(evt:Event):void
		{
			var cell:BagCell = CellMenu.instance.cell;
			if(cell)
			{
				AddPricePanel.Instance.setInfo(cell.itemInfo,false);
				TipManager.AddTippanel(AddPricePanel.Instance,true);
			}
		}
		
		private function __cellMove(evt:Event):void
		{
			SoundManager.Instance.play("008");
			var cell:BagCell = CellMenu.instance.cell;
			if(cell)
				cell.dragStart();
		}
		
		public function getPropCell(pos:int):BagCell
		{
			return _propView.getCellByPos(pos);
		}
		
		public function getEquipCell(pos:int):BagCell
		{
			return _equipmentView.getCellByPos(pos);
		}
		
		public function get EquipList():StoreBagListView
		{
			return _equipmentView;
		}
		
		public function get PropList():StoreBagListView
		{
			return _propView;
		}
		
		public function __propertyChange(evt:PlayerPropertyEvent):void
		{
			if(evt.changedProperties["Money"] || evt.changedProperties["Gold"] || evt.changedProperties[PlayerInfo.GIFT])
			{
				updateMoney();
			}
		}
		
		private function updateMoney():void
		{
			goldTxt.text = String(_model.info.Gold);
			moneyTxt.text = String(_model.info.Money);
			giftTxt.text = String(_model.info.Gift);
		}
		
		public function dispose():void
		{
			if(parent) parent.removeChild(this);
			removeEvents();
            
            _controller = null;
            _equipmentView.dispose();
		    _propView.dispose();
            _model = null;
		}
	}	
}