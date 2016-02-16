package ddt.store.view.strength
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import game.crazyTank.view.storeII.StoreIIStrengthBGAsset;
	import game.crazyTank.view.storeII.StrengthHelpAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HAlertDialog;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.utils.ComponentHelper;
	
	import ddt.store.IStoreViewBG;
	import ddt.store.StoneCell;
	import ddt.store.StoreCell;
	import ddt.store.StoreDragInArea;
	
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
	import ddt.manager.SocketManager;
	import ddt.manager.UserGuideManager;
	import ddt.request.LoadStrengthenLevelII;
	import ddt.view.HelpFrame;
	import ddt.view.cells.BagCell;
	import ddt.view.cells.DragEffect;
	import ddt.view.common.BuyGiftBagButton;
	import ddt.view.common.BuyItemButton;
	import ddt.view.common.FastPurchaseGoldBox;
	
	public class StoreIIStrengthBG extends StoreIIStrengthBGAsset implements IStoreViewBG
	{	
		public static const STRENGTH_MAX_LEVEL:int = 19;
		
		private var _area:StoreDragInArea;
		private var _items:Array;
		private var _rateList1 : Dictionary;
		private var _rateList2 : Dictionary;
		private var _rateList3 : Dictionary;
		private var _rateList4 : Dictionary;
		private var _strength_btn : HBaseButton;
		private var _strengHelp   : HBaseButton;
		private var _sBuyLucky    : BuyItemButton;
		private var _sBuyHierogram: BuyItemButton;
		private var _sBuyStrengthStoneCell:BuyItemButton;
		private var _sBuyGiftBag:BuyGiftBagButton;
		
		public function StoreIIStrengthBG()
		{
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			_items = [];
			for(var i:int = 0; i < 6; i++)
			{
				var item:StoreCell;
				if(i == 0 || i == 1 || i == 2)item = new StrengthStone([StoneType.STRENGTH,StoneType.STRENGTH_1],i);
				else if(i == 4)item = new StoneCell([StoneType.LUCKY],i);
				else if(i == 3)item = new StoneCell([StoneType.SOULSYMBOL],i);
				else if(i == 5)item = new StreangthItemCell(i);
				ComponentHelper.replaceChild(this,this["cell_" + i],item);
				item.addEventListener(Event.CHANGE,__itemInfoChange);
				_items.push(item);
			}
			_area = new StoreDragInArea(_items);
			addChildAt(_area,0);
			
			_strength_btn = new HBaseButton(strength_btn);
			_strength_btn.useBackgoundPos = true;
			addChild(_strength_btn);
			_strength_btn.enable = false;
			
			_strengHelp = new HBaseButton(strengHelp);
			_strengHelp.useBackgoundPos = true;
			addChild(_strengHelp);
			
			_sBuyLucky = new BuyItemButton(sbuylucky,EquipType.LUCKY,1,true);
			_sBuyLucky.useBackgoundPos = true;
			addChild(_sBuyLucky);
			
			_sBuyHierogram = new BuyItemButton(sbuyhierogram,EquipType.SYMBLE,1,true);
			_sBuyHierogram.useBackgoundPos = true;
			addChild(_sBuyHierogram);
			
			//_sBuyStrengthStoneCell = new BuyItemButton(sBuyStrengthStoneBtn,EquipType.STRENGTH_STONE4,1,true);
			//_sBuyStrengthStoneCell.useBackgoundPos = true;
			//addChild(_sBuyStrengthStoneCell);
			
			//_sBuyGiftBag = new BuyGiftBagButton(giftBag,EquipType.STRENGTH_STONE4,1,true);
			//_sBuyGiftBag.useBackgoundPos = true;
			//addChild(_sBuyGiftBag);
			
			hide();
			gold_txt.text = String(SharedManager.Instance.StrengthMoney);
			percentage_txt.text = "0%";
			hideArr();
			//if(_rateList1 == null)
			//new LoadStrengthenLevelII().loadSync(__searchResult);
			consortiaRate();
		}
		
		private function initEvent():void
		{
			_strength_btn.addEventListener(MouseEvent.CLICK,__strengthClick);
			_strengHelp.addEventListener(MouseEvent.CLICK,  __openHelp);
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,  __playerPropertyChange);
			//addEventListener(Event.ADDED_TO_STAGE,userGuide);
		}
		
		private function removeEvents():void
		{
			_strength_btn.removeEventListener(MouseEvent.CLICK,__strengthClick);
			_strengHelp.removeEventListener(MouseEvent.CLICK,  __openHelp);
			PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,  __playerPropertyChange);
			//removeEventListener(Event.ADDED_TO_STAGE,userGuide);
			
			for(var i:int = 0; i < 6; i++)
			{
				_items[i].removeEventListener(Event.CHANGE,__itemInfoChange);
			}
		}
		
			

		
		private function checkUserGuideTask46():Boolean{
			if((_items[5] as StreangthItemCell).itemInfo.StrengthenLevel>0){
				return true;
			}
			return false;
		}
		
		private function __playerPropertyChange(evt : PlayerPropertyEvent) : void
		{
			if(evt.changedProperties["SmithLevel"])
			{
				consortiaRate();
			}
		}
		private function __searchResult(action : LoadStrengthenLevelII) : void
		{
			//_rateList1 = action.LevelItems1;			
			//_rateList2 = action.LevelItems2;			
			//_rateList3 = action.LevelItems3;			
			//_rateList4 = action.LevelItems4;			
		}
		
		public function get area():Array
		{
		    return _items;
		}
		
		private function isAdaptToItem(info:InventoryItemInfo):Boolean
		{
			if(info.Property1 == StoneType.SOULSYMBOL || info.Property1 == StoneType.LUCKY) return true;
			if(_items[5].info == null)
			{
				return true;
			}else if(_items[5].info.Refinery > 0)
			{
				if(info.Property1 == "35") return true;
				return false;
			}else
			{
				if(info.Property1 == "35") return false;
				return true;
			}
			return false;
		}
		
		private function isAdaptToStone(info:InventoryItemInfo):Boolean
		{
			if(info.Property1 == StoneType.SOULSYMBOL || info.Property1 == StoneType.LUCKY) return true;
			if(_items[0].info != null && _items[0].info.Property1 != info.Property1) return false;
			if(_items[1].info != null && _items[1].info.Property1 != info.Property1) return false;
			if(_items[2].info != null && _items[2].info.Property1 != info.Property1) return false;
			return true;   
		}
		
		private function itemIsAdaptToStone(info:InventoryItemInfo):Boolean
		{
			if(info.Refinery>0)
			{
				if(_items[0].info != null && _items[0].info.Property1 != "35") return false;
				if(_items[1].info != null && _items[1].info.Property1 != "35") return false;
				if(_items[2].info != null && _items[2].info.Property1 != "35") return false;
				return true;
			}else
			{
				if(_items[0].info != null && _items[0].info.Property1 == "35") return false;
				if(_items[1].info != null && _items[1].info.Property1 == "35") return false;
				if(_items[2].info != null && _items[2].info.Property1 == "35") return false;
				return true;
			}
			return false;
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
						    	if(isAdaptToStone(info))
						    	{
							    	SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,1);
									DragManager.acceptDrag(ds,DragEffect.NONE);
						    		return;
							    }else
							    {
							    	MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
							    }
					    	}
						}	
					}else if((ds is StreangthItemCell))
					{
				  	    if(info.getRemainDate() <= 0)
		            	{
			            	MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
				            //MessageTipManager.getInstance().show("此物品已过期");
		            	}else if(info.StrengthenLevel == STRENGTH_MAX_LEVEL)
				        {						
				            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.ComposeItemCell.up"));
				    	    //MessageTipManager.getInstance().show("该装备已经升级到最高级.");
				           	return;
			         	}else if(source.info.CanStrengthen)
				    	{
							//if(info.StrengthenLevel == 9 && !SharedManager.Instance.isAffirm)
							//{
							//	SharedManager.Instance.isAffirm = true;
							//	SharedManager.Instance.save();
							//	HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.game.GameViewBase.HintTitle"),LanguageMgr.GetTranslation("store.view.strength.clew"),true,null,null,true,"确定",null,0,true,false);
							//}
//				    		if(itemIsAdaptToStone(info))
//				    		{
					 	        SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,1);
								DragManager.acceptDrag(ds,DragEffect.NONE);
						    	return;
//					    	}else
//					    	{
//					    		MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.unpare"));
//					    	}
				    	}
					}
				}		
			}
			if(EquipType.isStrengthStone(info)||(info.CategoryID == 11&&info.Property1==StoneType.SOULSYMBOL)||(info.CategoryID == 11&&info.Property1==StoneType.LUCKY))
			{
				for each(ds in _items)
				{
					if((ds is StoneCell) && (ds as StoneCell).types.indexOf(info.Property1)>-1 && info.CategoryID == 11)
				    {
				    	if(isAdaptToStone(info))
				    	{
					    	SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,1);
							DragManager.acceptDrag(ds,DragEffect.NONE);
					    	return;
					    }else
					    {
					    	MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
					    }
			    	}
				}
			}
		}
        /**
        * 显示箭头
        * */
        private function showArr():void
        {
        	strArr.visible = true;
        	strthShine.play();
        }
        
        private function hideArr():void
        {
        	strArr.visible = false;
        	strthShine.gotoAndStop(1);
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
			for(var i:int = 0; i<6; i++)
			{
				_items[i].info = PlayerManager.Instance.Self.StoreBag.items[i];
			}
		}
		
		public function startShine(cellId:int):void
		{
			_items[cellId].startShine();
		}
		
		public function stopShine():void
		{
			for(var i:int=0;i<6;i++)
			{
				_items[i].stopShine();
			}
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
			removeEvents();
			if(_helpPage)_helpPage.dispose();
			_area.dispose();
			for(var i:int = 0; i < _items.length; i++)
			{
				_items[i].dispose();
			}
			_items = null;
			_sBuyLucky.dispose();
			_sBuyHierogram.dispose();
			//_sBuyStrengthStoneCell.dispose();
			if(parent)parent.removeChild(this);
		}
		
		
		private function __strengthClick(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			SoundManager.Instance.play("008");
			if(PlayerManager.Instance.Self.Gold >= SharedManager.Instance.StrengthMoney)
			{
				if(_items[5].info != null && _items[5].itemInfo.StrengthenLevel >=4 && _items[3].info == null)
				{
					HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.view.strength.noneSymble"),true,sendSocket);
					return;
				}
				if(checkTipBindType())
				{
					HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.StoreIIStrengthBG.use"),true,sendSocket,null);
				}
				else
				{
					sendSocket();
//					_strength_btn.enable = false;
				}
				
			}
			else
			{
				new FastPurchaseGoldBox(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("ddt.view.GoldInadequate"),EquipType.GOLD_BOX).show();
//				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIBtnPanel.lackGold"));
				//MessageTipManager.getInstance().show("金币不足");
			}
		}
		private function sendSocket() : void
		{
			if(!checkLevel())return;
			var consortiaState : Boolean  = false;
			if(StoreState.storeState == StoreState.CONSORTIASTORE || StoreState.storeState == StoreState.CONSORTIAIISTORE)consortiaState = true;
//			SocketManager.Instance.out.sendItemStrength([_items[2].place,_items[1].place,_items[5].place,_items[0].place,_items[3].place,_items[4].place],consortiaState);
			SocketManager.Instance.out.sendItemStrength(consortiaState);
		}
		private function checkTipBindType() : Boolean
		{
			if(_items[5].itemInfo && _items[5].itemInfo.IsBinds)return false;
			if(_items[0].itemInfo && _items[0].itemInfo.IsBinds)return true;
			if(_items[3].itemInfo && _items[3].itemInfo.IsBinds)return true;
			if(_items[4].itemInfo && _items[4].itemInfo.IsBinds)return true;
			if(_items[1].itemInfo && _items[1].itemInfo.IsBinds)return true;
			if(_items[2].itemInfo && _items[2].itemInfo.IsBinds)return true;
			return false;
		}
		
		/**当升到最高级,继续放入石头强化时出现**/
		private function checkLevel() : Boolean
		{
			var item : StreangthItemCell = _items[5] as StreangthItemCell;
			var info : InventoryItemInfo = item.info as InventoryItemInfo;
			if(info && info.StrengthenLevel == STRENGTH_MAX_LEVEL)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.ComposeItemCell.up"));
				return false;
			}
			return true;
		}
		

		
		private function __itemInfoChange(evt:Event):void
		{
			if(evt.currentTarget is StreangthItemCell)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
			percentage_txt.text = String(getCountRate()) + "%";	
			var stones:int = 0;
			if(_items[0].info != null)
			{
				stones ++;
				_items[1].stoneType = _items[0].stoneType;
				_items[2].stoneType = _items[0].stoneType;
				_items[5].stoneType = _items[0].stoneType;
			}
			if(_items[1].info != null)
			{
				stones ++;
				_items[0].stoneType = _items[1].stoneType;
				_items[2].stoneType = _items[1].stoneType;
				_items[5].stoneType = _items[1].stoneType;
			}if(_items[2].info != null)
			{
				stones ++;
				_items[0].stoneType = _items[2].stoneType;
				_items[1].stoneType = _items[2].stoneType;
				_items[5].stoneType = _items[2].stoneType;
			}
			if(stones == 0) _items[0].stoneType = _items[1].stoneType = _items[2].stoneType = _items[5].stoneType = "";
			if(_items[5].info == null)
			{
				_items[0].itemType = _items[1].itemType = _items[2].itemType = -1;
			}else
			{
				_items[0].itemType = _items[1].itemType = _items[2].itemType = _items[5].info.Refinery
			}
			
			if(_items[5].info == null || stones == 0)
			{
				_strength_btn.enable = false;
				hideArr();
				return;
			}
			_strength_btn.enable = true;
			showArr();
			stones == 0;
			//disablestrength_btn.visible = stones == 0;
			
		}
		private var rateItems : Array = [.75,3,12,48,240,768];
		private function getCountRate() : Number
		{
			var tempRate : Number = 0;
			
			if(_items[5] == null || _items[5].info == null || _rateList1 == null)
			{
				return tempRate;			
			}
			
			if(_items[0].info != null)
			{
				tempRate += rateItems[(_items[0].info.Level-1)];
			}
			if(_items[1].info != null)
			{
				tempRate += rateItems[(_items[1].info.Level-1)];
			}
			if(_items[2].info != null)
			{
				tempRate += rateItems[(_items[2].info.Level-1)];
			}
			if(_items[4].info != null)
			{
				tempRate += tempRate * _items[4].info.Property2/100;
			}
			tempRate = tempRate*100/getNeedRate();
			if(StoreState.storeState == StoreState.CONSORTIASTORE || StoreState.storeState == StoreState.CONSORTIAIISTORE)
				tempRate = tempRate *(1+0.1*PlayerManager.Instance.Self.SmithLevel);
			tempRate = (Math.floor(tempRate*10))/10;
			tempRate = tempRate > 100 ? 100 : tempRate;
			return tempRate;
		}
		
		private function getNeedRate():Number
		{
			var type:int = (_items[5].info as InventoryItemInfo).CategoryID;
			switch(type)
			{
				case EquipType.ARM:
					return Number(_rateList1[(_items[5].info.StrengthenLevel+1)])*15/13;
					return Number(_rateList1[(_items[5].info.StrengthenLevel+1)]);
				case EquipType.HEAD:
					return Number(_rateList2[(_items[5].info.StrengthenLevel+1)]);
				case EquipType.CLOTH:
					return Number(_rateList3[(_items[5].info.StrengthenLevel+1)]);
				case EquipType.OFFHAND:
					return Number(_rateList4[(_items[5].info.StrengthenLevel+1)]);
			}
			return 0;
			
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
		
		public function getStrengthItemCellInfo():InventoryItemInfo{
			return (_items[5] as StreangthItemCell).itemInfo;
		}
		
				
		/*帮助页面*/
		private var _helpPage : HelpFrame;
		private function initHelpPage() : void
		{
			var helpBd : BitmapData = new StrengthHelpAsset(0,0);
			var helpIma : Bitmap = new Bitmap(helpBd);
		 	_helpPage = new HelpFrame(helpIma);
			_helpPage.titleText = LanguageMgr.GetTranslation("store.StoreIIStrengthBG.say");
		 	
		 	helpBd = null;
		}
		private function __openHelp(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			evt.stopImmediatePropagation();
			if(!_helpPage)initHelpPage();
			_helpPage.show();
		}
	}
}