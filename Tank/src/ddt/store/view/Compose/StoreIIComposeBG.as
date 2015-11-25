package ddt.store.view.Compose
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import game.crazyTank.view.storeII.ComposeHelpAsset;
	import game.crazyTank.view.storeII.StoreIIComposeBGAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.utils.ComponentHelper;
	
	import ddt.store.IStoreViewBG;
	import ddt.store.StoneCell;
	import ddt.store.StoreCell;
	import ddt.store.StoreDragInArea;
	import ddt.store.view.shortcutBuy.ShortcutBuyFrame;
	
	import ddt.data.EquipType;
	import ddt.data.StoneType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.data.store.StoreState;
	import ddt.manager.DragManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SharedManager;
	import ddt.manager.ShopManager;
	import ddt.manager.SocketManager;
	import ddt.utils.LeavePage;
	import ddt.view.HelpFrame;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.cells.BagCell;
	import ddt.view.cells.DragEffect;
	import ddt.view.common.BuyItemButton;
	import ddt.view.common.FastPurchaseGoldBox;

	public class StoreIIComposeBG extends StoreIIComposeBGAsset implements IStoreViewBG
	{
		
		private var _area:StoreDragInArea;
		private var _items:Array;
		
		private var _compose_btn : HBaseButton ;
		private var _composeHelp : HBaseButton ;
		private var _cBuyluckyBtn : BuyItemButton ;
		private var _buyStoneBtn: HBaseButton;
		//朱雀，玄武，青龙，白虎
		private static const ITEMS:Array = [11003,11007,11011,11015];
		
		public function StoreIIComposeBG()
		{
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			_items = new Array();
			for(var i:int = 0; i < 4; i++)
			{
				var item:StoreCell;
				if(i == 0)item = new StoneCell([StoneType.LUCKY],i);
				else if(i == 1)item = new ComposeItemCell(i);
				else if(i == 2)item = new StoneCell([StoneType.COMPOSE],i);
				if(i!=3)
				{
					ComponentHelper.replaceChild(this,this["cell_"+ i],item);
					item.addEventListener(Event.CHANGE,__itemInfoChange);
					_items.push(item);
				}
			}
			_area = new StoreDragInArea(_items);
			addChildAt(_area,0);
			
			_compose_btn = new HBaseButton(compose_btn);
			_compose_btn.useBackgoundPos = true;
			addChild(_compose_btn);
			_compose_btn.enable = false;
			
			_composeHelp = new HBaseButton(composeHelp);
			_composeHelp.useBackgoundPos = true;
			addChild(_composeHelp);
			
			//_buyStoneBtn = new HBaseButton(buyStoneBtnAsset);
			//_buyStoneBtn.useBackgoundPos = true;
			//addChild(_buyStoneBtn);
			
			_cBuyluckyBtn = new BuyItemButton(cbuylucky,EquipType.LUCKY,2,true);
			_cBuyluckyBtn.useBackgoundPos = true;
			addChild(_cBuyluckyBtn);
			
			hide();
			gold_txt.text = String(SharedManager.Instance.ComposeMoney);
			percentage_txt.text = "0%";
			
			hideArr();
			consortiaRate();
		}
        
        public function dragDrop(source:BagCell):void
		{
			if(source == null) return; 
			var info:InventoryItemInfo = source.info as InventoryItemInfo;
			var ds:StoreCell;
			for each(ds in _items)
			{
				if(ds.info == info)
				{
					ds.info = null;
					source.locked = false;
					return;
				}
			}
			for each(ds in _items)
			{				
				if(ds)
				{
					if(ds is StoneCell)
					{
						if(ds.info==null){
						    if((ds as StoneCell).types.indexOf(info.Property1) > -1 && info.CategoryID == 11)
						    {
						    	SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,1);
								DragManager.acceptDrag(ds,DragEffect.NONE);
						    	return;
					    	}
						}	
					}else if(ds is ComposeItemCell)
					{
				    	if(info.getRemainDate() <= 0)
		            	{
		             		MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
		             		//MessageTipManager.getInstance().show("此物品已过期");
		            	}else if(info.AgilityCompose == 40 && info.DefendCompose == 40 && info.AttackCompose == 40 && info.LuckCompose == 40)
                        {
                        	MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.ComposeItemCell.up"));
				        	return;
                        }else if(source.info.CanCompose)
					    {
						   	SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,1);
							DragManager.acceptDrag(ds,DragEffect.NONE);
					    	return;
				    	}
					}
				}		
			}
			if(EquipType.isComposeStone(info)||(info.CategoryID == 11&&info.Property1==StoneType.SOULSYMBOL)||(info.CategoryID == 11&&info.Property1==StoneType.LUCKY))
			{
				for each(ds in _items)
				{
					if((ds is StoneCell) && (ds as StoneCell).types.indexOf(info.Property1)>-1 && info.CategoryID == 11)
				    {
				    	SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,1);
						DragManager.acceptDrag(ds,DragEffect.NONE);
				    	return;
			    	}
				}
			}
		}
        
        public function startShine(cellId:int):void
		{	
			if(cellId != 3){
				_items[cellId].startShine();	
			}
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
			for(var i:int = 0; i<3; i++)
			{
				_items[i].info = PlayerManager.Instance.Self.StoreBag.items[i];
			}
		}
		
		public function stopShine():void
		{
			for(var i:int=0;i<3;i++)
			{
				_items[i].stopShine();
			}
		}
		
		private function initEvent():void
		{
			_compose_btn.addEventListener(MouseEvent.CLICK,__composeClick);
			_composeHelp.addEventListener(MouseEvent.CLICK,__openHelp);
			//_buyStoneBtn.addEventListener(MouseEvent.CLICK,__buyStone);
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,  __playerPropertyChange);
		}
		
		private function __buyStone(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			evt.stopImmediatePropagation();
			
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			if(ShopManager.Instance.getMoneyShopItemByTemplateID(ITEMS[0]).getItemPrice(1).moneyValue > PlayerManager.Instance.Self.Money)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
				return;
			}
			new ShortcutBuyFrame(ITEMS,false,LanguageMgr.GetTranslation("store.view.Compose.buyCompose"),2).show();
		}
		
		private function __playerPropertyChange(evt : PlayerPropertyEvent) : void
		{
			if(evt.changedProperties["SmithLevel"])
			{
				consortiaRate();
			}
		}
		
		/**
		 * 显示箭头
		 * */
		private function showArr():void
		{
			cpsArr.visible = true;
			cpsShine.play();
		}
		
		/**
		 * 隐藏箭头
		 * */
		private function hideArr():void
		{
			cpsArr.visible = false;
			cpsShine.gotoAndStop(1);
		}
		
		public function get area():Array
		{
		    return this._items;
		}
		
		private function __composeClick(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			SoundManager.instance.play("008");
			if(PlayerManager.Instance.Self.Gold < SharedManager.Instance.ComposeMoney)
			{
				new FastPurchaseGoldBox(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("ddt.view.GoldInadequate"),EquipType.GOLD_BOX).show();	
//				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIBtnPanel.lackGold"));
				//MessageTipManager.getInstance().show("金币不足");
			}
			else
			{
				if(checkTipBindType())
				{
					HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.StoreIIComposeBG.use"),true,sendSocket,null);
				}
				else
				{
					_compose_btn.enable = false;
					hideArr();
					sendSocket();
				}
				
			}
		}
		private function sendSocket() : void
		{
			var consortiaState : Boolean  = false;
			if(StoreState.storeState == StoreState.CONSORTIASTORE || StoreState.storeState == StoreState.CONSORTIAIISTORE)consortiaState = true;
			SocketManager.Instance.out.sendItemCompose(consortiaState);
		}
		private function checkTipBindType() : Boolean
		{
			if(_items[1].itemInfo && _items[1].itemInfo.IsBinds)return false;
			if(_items[0].itemInfo && _items[0].itemInfo.IsBinds)return true;
			if(_items[2].itemInfo && _items[2].itemInfo.IsBinds)return true;
			return false;
		}
		
		
		
		private function __itemInfoChange(evt:Event):void
		{
			if(getCountRate() > 0)
			{
				percentage_txt.text = String(getCountRate()) + "%";
			}
			else
			{
				percentage_txt.text = "0%";
			}
			if(_items[1].info == null || _items[2].info == null)
			{
				_compose_btn.enable = false;
				hideArr();
			}
			else
			{
				_compose_btn.enable = true;
				showArr();
			}
		}
		
		
		public var composeRate:Array = [0.8,0.5,0.3,0.1];
		private function getCountRate() : Number
		{
			var rate :Number = 0;
			if(_items[1] == null || _items[1].info == null)
			{
				return rate;
			}
			if(_items[2] != null && _items[2].info != null)
			{
				rate = Number((_items[2] as StoneCell).info.Property2);
				//percentage_txt.text = String(ComposeRate.composeRate[_items[2].info.Quality-1]*100) + "%";
			}
			if(rate > 0 && _items[0] != null && _items[0].info != null)
			{
				rate = (1+ _items[0].info.Property2 / 100) * rate;
			}
			if(StoreState.storeState == StoreState.CONSORTIASTORE || StoreState.storeState == StoreState.CONSORTIAIISTORE)
			rate = rate *(1+0.1*PlayerManager.Instance.Self.SmithLevel);
			rate = (Math.floor(rate * 10))/10;
			rate = rate > 100 ? 100 : rate;
			return rate;
		}
		public function consortiaRate() : void
		{
			if(StoreState.storeState == StoreState.CONSORTIASTORE || StoreState.storeState == StoreState.CONSORTIAIISTORE)
			{
				consortiaRate_txt.text = LanguageMgr.GetTranslation("store.StoreIIComposeBG.consortiaRate_txt")+(PlayerManager.Instance.Self.SmithLevel*10)+"%";
				//consortiaRate_txt.text = "公会加成 "+(PlayerManager.Instance.Self.SmithLevel*10)+"%";
			}
			else
			{
				this.consortiaRate_txt.text = "";
			}
			this.consortiaRate_txt.selectable = false;
			this.consortiaRate_txt.mouseEnabled = false;
		}
		
		public function show():void
		{
			this.visible = true;
			consortiaRate();
			updateData();
		}
		
		public function hide():void
		{
			this.visible = false;
			percentage_txt.text = "0%";
		}
		
		public function dispose():void
		{
			_area.dispose();
			for(var i:int = 0; i < _items.length; i++)
			{
				_items[i].removeEventListener(Event.CHANGE,__itemInfoChange);
				_items[i].dispose();
				_items[i] = null;
			}
			if(_helpPage)_helpPage.dispose();
			_compose_btn.removeEventListener(MouseEvent.CLICK,__composeClick);
			_composeHelp.removeEventListener(MouseEvent.CLICK,__openHelp);
			PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,  __playerPropertyChange);
			if(parent)parent.removeChild(this);
		}
		
		/*帮助页面*/
		private var _helpPage : HelpFrame;
		private function initHelpPage() : void
		{
			var helpBd : BitmapData = new ComposeHelpAsset(0,0);
			var helpIma : Bitmap = new Bitmap(helpBd);
		 	_helpPage = new HelpFrame(helpIma);
			_helpPage.titleText = LanguageMgr.GetTranslation("store.StoreIIComposeBG.say");
		 	
		 	helpBd = null;
		}
		private function __openHelp(evt : MouseEvent) : void
		{
			SoundManager.instance.play("008");
			evt.stopImmediatePropagation();
			if(!_helpPage)initHelpPage();
			_helpPage.show();
		}						
	}
}