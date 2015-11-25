package ddt.view.transferProp
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.utils.ComponentHelper;
	
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ShopItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.events.ChangeColorCellEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ShopManager;
	import ddt.manager.SocketManager;
	import ddt.utils.LeavePage;
	import ddt.view.cells.BagCell;
	import ddt.view.changeColor.ColorEditCell;
	import tank.view.transferProp.TransferBgAsset;
	import tank.view.transferProp.TransferItemCellAsset;
	
	/**
	 * @author wicki LA
	 * @time 11/26/2009
	 * @description 转化面板背景
	 * */
	public class PropTransferBG extends TransferBgAsset
	{
		private var _itemCell:ColorEditCell;
		private var _bagView:TransferBagView;
		private var _transferBtn:HBaseButton;
		
		private var _currentType:int = -1;
		private var _propPlace:int;
		
		public function PropTransferBG(propPlace:int)
		{
			_propPlace = propPlace;
			init();
			initEvents();
		}
		
		private function init():void
		{
			_itemCell = new ColorEditCell(new TransferItemCellAsset);
			ComponentHelper.replaceChild(this,itemCell,_itemCell);
			_bagView = new TransferBagView();
			_bagView.x = bagPos.x;
			_bagView.y = bagPos.y;
			addChild(_bagView);
			
			_transferBtn = new HBaseButton(transferBtn);
			_transferBtn.useBackgoundPos = true;
			_transferBtn.enable = false;
			addChild(_transferBtn);
			
			birdBtn.buttonMode = dragonBtn.buttonMode = snakeBtn.buttonMode = tigerBtn.buttonMode = true;
			updateState();
		}
		
		private function initEvents():void
		{
			_bagView.BagList.addEventListener(ChangeColorCellEvent.CLICK,__cellClick);
			_itemCell.addEventListener(Event.CHANGE,__itemCellChange);
			
			birdBtn.addEventListener(MouseEvent.CLICK,__chooseBird);
			dragonBtn.addEventListener(MouseEvent.CLICK,__chooseDragon);
			snakeBtn.addEventListener(MouseEvent.CLICK,__chooseSnake);
			tigerBtn.addEventListener(MouseEvent.CLICK,__chooseTiger);
			
			_transferBtn.addEventListener(MouseEvent.CLICK,__transfer);
		}
		
		private function removeEvents():void
		{
			_bagView.BagList.removeEventListener(ChangeColorCellEvent.CLICK,__cellClick);
			_itemCell.removeEventListener(Event.CHANGE,__itemCellChange);
			
			birdBtn.removeEventListener(MouseEvent.CLICK,__chooseBird);
			dragonBtn.removeEventListener(MouseEvent.CLICK,__chooseDragon);
			snakeBtn.removeEventListener(MouseEvent.CLICK,__chooseSnake);
			tigerBtn.removeEventListener(MouseEvent.CLICK,__chooseTiger);
			
			_transferBtn.removeEventListener(MouseEvent.CLICK,__transfer);
		}
		
		private function __cellClick(evt:ChangeColorCellEvent):void
		{
			_itemCell.bagCell = evt.data;
			(evt.data as BagCell).locked = true;
			SoundManager.instance.play("008");
		}
		
		private function __itemCellChange(evt:Event):void
		{
			if(_itemCell.info == null) _currentType = -1;
			updateState();
		}
		
		private function __chooseBird(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			_currentType = 1;
			updateState();
		}
		
		private function __chooseDragon(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			_currentType = 3;
			updateState();
		}
		
		private function __chooseSnake(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			_currentType = 2;
			updateState();
		}
		
		private function __chooseTiger(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			_currentType = 4;
			updateState();
		}
		
		private function __transfer(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(_currentType<0)
			{
				MessageTipManager.getInstance().show("请选择你要转换的类型");
				return;
			}
			if(_propPlace != -1)
			{
				sendTrend(_propPlace);
				_propPlace = -1;
			}else
			{
				var prop:InventoryItemInfo = PlayerManager.Instance.Self.PropBag.findFistItemByTemplateId(EquipType.TRANSFER_PROP);
				if(prop)
				{
					sendTrend(prop.Place);
				}else
				{
					var shopitem:ShopItemInfo = ShopManager.Instance.getShopItemByTemplateId(EquipType.TRANSFER_PROP)[0];
					if(PlayerManager.Instance.Self.Money < shopitem.getItemPrice(1).moneyValue)
					{
						HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
					}else
					{
						HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaTax.info"),LanguageMgr.GetTranslation("ddt.view.changeColor.lackCard1",ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.TRANSFER_PROP).getItemPrice(1).moneyValue),true,sendTrend);
					}
				}
			}
		}
		
		private function sendTrend(propPlace:int = -1):void
		{
			SocketManager.Instance.out.sendItemTrend(_itemCell.itemInfo.BagType,_itemCell.itemInfo.Place,BagInfo.PROPBAG,propPlace,_currentType);
			_currentType = -1;
			updateState();
		}
		
		private function updateState():void
		{
			birdBtn.gotoAndStop((_currentType == 1)?2:1);
			dragonBtn.gotoAndStop((_currentType == 3)?2:1);
			snakeBtn.gotoAndStop((_currentType == 2)?2:1);
			tigerBtn.gotoAndStop((_currentType == 4)?2:1);
			_transferBtn.enable = (_itemCell.info == null || _currentType == -1) ? false : true;
		}
		
		public function dispose():void
		{
			removeEvents();
			_itemCell.dispose();
			_bagView.dispose();
			_transferBtn.dispose();
			
			_itemCell = null;
			_bagView = null;
			_transferBtn = null;
		}

	}
}