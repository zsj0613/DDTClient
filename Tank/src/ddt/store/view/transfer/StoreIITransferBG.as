package ddt.store.view.transfer
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Dictionary;
	
	import game.crazyTank.view.storeII.StoreIITransferBGAsset;
	import game.crazyTank.view.storeII.TransferHelpAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.utils.ComponentHelper;
	
	import ddt.store.IStoreViewBG;
	
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.manager.DragManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.HelpFrame;
	import ddt.view.cells.BagCell;
	import ddt.view.cells.DragEffect;
	import ddt.view.cells.LinkedBagCell;
	import ddt.view.common.FastPurchaseGoldBox;
	import ddt.view.infoandbag.CellEvent;


	public class StoreIITransferBG extends StoreIITransferBGAsset implements IStoreViewBG
	{
		private var _area: TransferDragInArea;
		private var _items:Array;
		private var _transferBtnAsset  : HBaseButton;
		private var _transferHelpAsset : HBaseButton;
		public function StoreIITransferBG()
		{
			super();
			init();
			initEvent();
		}
		private function init() : void
		{
			_transferBtnAsset = new HBaseButton(TransferBtnAsset);
			_transferBtnAsset.useBackgoundPos = true;
			addChild(_transferBtnAsset);
			_transferBtnAsset.enable = false;
			
			_transferHelpAsset = new HBaseButton(this.transferHelpBtnAsset);
			_transferHelpAsset.useBackgoundPos = true;
			addChild(_transferHelpAsset);
			_items = [];
			for(var i:int = 0; i < 2; i++)
			{
				var item:TransferItemCell = new TransferItemCell(i);
//				item.isComposeStrength = (i == 0 ? true : false);
				ComponentHelper.replaceChild(this,this["cell_" + i],item);
				item.addEventListener(Event.CHANGE,__itemInfoChange);
				
				_items.push(item);
			}
			_area = new TransferDragInArea(_items);
			addChildAt(_area,0);
			
			hideArr();
			hide();
		}
		
		private function __onLockChange(e:CellEvent):void
		{
			
		}
		
		private function initEvent() : void
		{
			_transferBtnAsset.addEventListener(MouseEvent.CLICK,   __transferHandler);
			_transferHelpAsset.addEventListener(MouseEvent.CLICK,  __openHelpHandler);
		}
		private function removeEvent() : void
		{
			_transferBtnAsset.removeEventListener(MouseEvent.CLICK,   __transferHandler);
			_transferHelpAsset.removeEventListener(MouseEvent.CLICK,  __openHelpHandler);
			
		}
		
		/**
		 *  格子发光
		 */
		public function startShine(cellId:int):void
		{
			_items[cellId].startShine();
		}
		
		public function stopShine():void
		{
			for(var i:int=0;i<2;i++)
			{
				_items[i].stopShine();
			}
		}
		
		/**
		 * 显示箭头
		 * */
		private function showArr():void
		{
			transArr.visible = true;
			transShine.play();
		}
		
		/**
		 * 隐藏箭头
		 * */
		private function hideArr():void
		{
			transArr.visible = false;
			transShine.gotoAndStop(1);
		}
		
		public function get area():Array
		{
			return _items;
		}
		
//		public function dragDrop(source:BagCell):void
//		{
//			if(source == null) return;
//			var info:InventoryItemInfo = source.info as InventoryItemInfo;
//			var ds:LinkedBagCell;
//			for each(ds in _items)
//			{
//				if(ds.info == info)
//				{
//					ds.bagCell = null;
//					source.locked = false;
//					return;
//				}
//			}
//			for each(ds in _items)
//			{				
//				if(ds)
//				{
//					if(ds is TransferItemCell)
//					{
//						var temp:InventoryItemInfo;
//						for each(var transCell:LinkedBagCell in _items)
//						{
//							if(transCell.bagCell!=null)
//							{
//								temp = transCell.bagCell.info as InventoryItemInfo;
//							}
//					    }
//						if((info.Level == 3)&& info.CanCompose)
//						{
//							if(ds.bagCell == null)
//							{
//								if(temp&&temp.CategoryID!=source.info.CategoryID)
//								{
//									MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.put"));	
//								}else if((ds as TransferItemCell).Refinery != -1 && (ds as TransferItemCell).Refinery != source.info.Refinery)
//								{
//									MessageTipManager.getInstance().show("请放入炼化等级相同的装备!");
//									return;
//								}else{
//							        SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,(ds as TransferItemCell).index,1);
//									DragManager.acceptDrag(ds,DragEffect.NONE);
//									return;
//								}
//							}
//						}
//					}
//				}		
//			}
//		}

		public function dragDrop(source:BagCell):void{
			if(source == null)return;
			var info:InventoryItemInfo = source.info as InventoryItemInfo;
			for each(var item:TransferItemCell in _items){
				if(item.info == null){
					if( ((_items[0] as TransferItemCell).info && ((_items[0] as TransferItemCell).info.CategoryID != info.CategoryID)) ||
						((_items[1] as TransferItemCell).info && ((_items[1] as TransferItemCell).info.CategoryID != info.CategoryID))){
						MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.put"));
						return;
					}
					SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,item.index,1);
					DragManager.acceptDrag(item,DragEffect.NONE);
					return;
				}
			}
		}
		
		/**
		 * 转移
		 */
		private function __transferHandler(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			evt.stopImmediatePropagation();
			var item1 : TransferItemCell = _items[0] as TransferItemCell;
			var item2 : TransferItemCell = _items[1] as TransferItemCell;
			if(item1.info && item2.info)
			{
				if(PlayerManager.Instance.Self.Gold < Number(this.gold_txt.text))
				{
					new FastPurchaseGoldBox(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("ddt.view.GoldInadequate"),EquipType.GOLD_BOX).show();
//					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIBtnPanel.lackGold"));
					//essageTipManager.getInstance().show("您的金币不足。");
					return;
				}
//				if(PlayerManager.Instance.Self.Money < Number(this.money_txt.text))
//				{
//					HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.point"),true,depositAction,null,true,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
//					//HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),"您的点券不足，是否立即充值？",true,depositAction,null,true,"确   定","取   消");
//					return;
//				}
				_transferBtnAsset.enable = false;
				hideArr();
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.sure"),true,sendSocket,cannel,true,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
				//HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),"是否将原装备的属性转移到目标装备上？\n<FONT SIZE='12' FACE='Arial' KERNING='2' COLOR='#FF0000'> 注：转移后目标装备属性将被覆盖，并和角色绑定。</FONT>",true,sendSocket,null,true,"确   定","取   消");
					
				
			}
		}
		private function cannel() : void
		{
			_transferBtnAsset.enable = true;
			showArr();
		}
		/**
		 * 充值页面
		 */
		private function depositAction() : void
		{
			navigateToURL(new URLRequest(PathManager.solveFillPage()),"_blank");
		}
		
		/**
		 * 是否有强化合成属性
		 */
		private function isComposeStrengthen(info : BagCell) : Boolean
		{
			if(info.itemInfo.StrengthenLevel >0)return true;
			if(info.itemInfo.AttackCompose > 0)return true;
			if(info.itemInfo.DefendCompose > 0)return true;
			if(info.itemInfo.LuckCompose > 0)return true;
			if(info.itemInfo.AgilityCompose > 0)return true;
			return false;
		}
		private function sendSocket() : void
		{
			var item1 : TransferItemCell = _items[0] as TransferItemCell;
			var item2 : TransferItemCell = _items[1] as TransferItemCell;
			SocketManager.Instance.out.sendItemTransfer();
		}
		
		
		private function __itemInfoChange(evt : Event) : void
		{
			this.gold_txt.text  = "0";
//			this.money_txt.text = "0";
			var item1 : TransferItemCell = _items[0] as TransferItemCell;
			var item2 : TransferItemCell = _items[1] as TransferItemCell;
			if(item1.info)
			{
				item1.categoryId = -1;
				if(item2.info)
				{
					item1.categoryId = item1.info.CategoryID;
				}
				item2.categoryId = item1.info.CategoryID;
			}
			else
			{
				item2.categoryId = -1;
				if(item2.info)item1.categoryId =item2.info.CategoryID;
				else item1.categoryId = -1;
			}
			
			if(item1.info)
			{
				item1.Refinery = item2.Refinery = item1.info.Refinery;
			}else if(item2.info)
			{
				item1.Refinery = item2.Refinery = item2.info.Refinery;
			}else
			{
				item1.Refinery = item2.Refinery = -1;
			}
			if(item1.info && item2.info && isComposeStrengthen(item1))
			{
				if(item1.info.CategoryID != item2.info.CategoryID)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.put"));
					//MessageTipManager.getInstance().show("请放入相同部位的装备。");
					return;
				}
				_transferBtnAsset.enable = true;
				showArr();
				goldMoney();
			}
			else
			{
				_transferBtnAsset.enable = false;
				hideArr();
			}
			
		}
		private function goldMoney() : void
		{
//			if(item.itemInfo.CategoryID == 7)
//			{
//				this.gold_txt.text = "0";
//				this.money_txt.text = "1000";
//			}
//			else
//			{
//				this.gold_txt.text = "5000";
//				this.money_txt.text = "0";
//			}
			this.gold_txt.text = "10000";
//			this.money_txt.text = "0";
		}
		
		public function show():void
		{
			initEvent();
			this.visible = true;
			updateData();
		}
		
		public function refreshData(items:Dictionary):void
		{
			for(var place:String in items)
			{
				var itemPlace:int = int(place);
				_items[itemPlace].info = PlayerManager.Instance.Self.StoreBag.items[itemPlace];
			}
		}
		
		public function updateData():void
		{
			for(var i:int = 0; i<2; i++){
				_items[i].info = PlayerManager.Instance.Self.StoreBag.items[i];
			}
		}
		
		public function hide():void
		{
			removeEvent();
			this.visible = false;
		}
		public function dispose():void
		{
			removeEvent();
			for(var i:int = 0; i < _items.length; i++)
			{
				_items[i].dispose();
			}
			if(_helpPage)_helpPage.dispose();
			if(parent)parent.removeChild(this);
		}
		
		
		/*帮助页面*/
		private var _helpPage : HelpFrame;
		private function initHelpPage() : void
		{
			var helpBd : BitmapData = new TransferHelpAsset(0,0);
			var helpIma : Bitmap = new Bitmap(helpBd);
		 	_helpPage = new HelpFrame(helpIma);
			_helpPage.titleText = LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.move");
			//_helpPage.titleText = "转移说明";
		 	
		 	helpBd = null;
		}
		private function __openHelpHandler(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			evt.stopImmediatePropagation();
			if(!_helpPage)initHelpPage();
			_helpPage.show();
		}
	}
}