package ddt.store.view.lianhua
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import game.crazyTank.view.storeII.LianhuaHelpAsset;
	import game.crazyTank.view.storeII.StoreIILianhuabgAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.utils.ComponentHelper;
	
	import ddt.store.IStoreViewBG;
	import ddt.store.StoneCell;
	import ddt.store.StoreCell;
	import ddt.store.StoreController;
	import ddt.store.StoreDragInArea;
	import ddt.store.data.PreviewInfoII;
	import ddt.store.states.BaseStoreView;
	import ddt.store.view.fusion.AccessoryFrameII;
	import ddt.store.view.fusion.PreviewFrameII;
	
	import ddt.data.EquipType;
	import ddt.data.StoneType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.events.ShortcutBuyEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.SocketManager;
	import ddt.view.HelpFrame;
	import ddt.view.cells.BagCell;
	import ddt.view.cells.LinkedBagCell;
	import ddt.view.common.BuyItemButton;
	
	/**
	 * @author wicki LA
	 * @time 11/24/2009
	 * @description 炼化面板
	 * */
	
	public class StoreLianhuaBG extends StoreIILianhuabgAsset implements IStoreViewBG
	{
		
		private var _area:StoreDragInArea;
		private var _items:Array;
		
		private var _accessoryFrameII:AccessoryFrameII;
		private var _previewFrameII : PreviewFrameII;
		private var _lianhuaHelp:HBaseButton;
		
		private var _lianhuaBtn:HBaseButton;
		private var _previewBtn:HBaseButton;
		private var _buyLucky:BuyItemButton;
		
		public function StoreLianhuaBG()
		{
			init();
		}
		
		private function init():void
		{
			_previewFrameII = new PreviewFrameII();
			_lianhuaBtn = new HBaseButton(lianhuaBtn);
			_previewBtn = new HBaseButton(previewBtn);
			_lianhuaHelp= new HBaseButton(descriptionBtn);
			_buyLucky   = new BuyItemButton(luckyBtn,EquipType.LUCKY,5,true);
			
			_lianhuaBtn.useBackgoundPos = true;
			_previewBtn.useBackgoundPos = true;
			_buyLucky.useBackgoundPos   = true;
			_lianhuaHelp.useBackgoundPos= true;
			_lianhuaBtn.enable = _previewBtn.enable = false;
			addChildAt(_lianhuaBtn,0);
			addChild(_previewBtn);
			addChild(_buyLucky);
			addChild(_lianhuaHelp);
			
			_items = new Array();
			for(var i:int=0; i<6; i++)
			{
				var item:StoreCell;
				if(i == 0)
				{
					item = new LianhuaItemCell(i);
				}else if(i == 1)
				{
					item = new LianhuaMainMaterialCell(i);
				}else if(i<5)
				{
					item = new LianhuaAidedMatieriaCell(i);
				}else
				{
					item = new StoneCell([StoneType.LUCKY],i);
				}
				ComponentHelper.replaceChild(this,this["cell_" + i],item);
				item.addEventListener(Event.CHANGE,__itemInfoChange);
				_items.push(item);
			}
			_area = new StoreDragInArea(_items);
			addChildAt(_area,0);
			gold_txt.text = "0";
			percentage_txt.text = "0%";
			btnShine.visible  = btnShine.mouseChildren = btnShine.mouseEnabled = false;
			lianhuaArrow.visible = false;
			initEvents();
			hide();
		}
		
		private function initEvents():void
		{
			_lianhuaBtn.addEventListener(MouseEvent.CLICK,__lianhua);
			_previewBtn.addEventListener(MouseEvent.CLICK,__lianhua);
			_lianhuaHelp.addEventListener(MouseEvent.CLICK,__openHelp);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_REFINERY_PREVIEW,__showPreview);
		}
		
		private function removeEvents():void
		{
			_lianhuaBtn.removeEventListener(MouseEvent.CLICK,__lianhua);
			_previewBtn.removeEventListener(MouseEvent.CLICK,__lianhua);
			_lianhuaHelp.removeEventListener(MouseEvent.CLICK,__openHelp);
			for each(var item:StoreCell in _items)
			{
				item.removeEventListener(Event.CHANGE,__itemInfoChange);
			}
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_REFINERY_PREVIEW,__showPreview);
		}
		
		private function __itemInfoChange(evt:Event):void
		{
			var flag:Boolean = true;
			for(var i:int=0; i<5; i++)
			{
				if(_items[i].itemInfo == null)
				{
					flag = false;
					break;
				}
				if(i == 2 || i == 3 || i == 4)
				{
					if(_items[i].itemInfo.Count < 3)
					{
						flag = false;
						break;
					}
				}
			}
			if(flag)
			{
				_lianhuaBtn.enable = _previewBtn.enable = true;
				gold_txt.text = "10000";
				percentage_txt.text = getRate();
				btnShine.visible = true;
				lianhuaArrow.visible = true;
			}else
			{
				_lianhuaBtn.enable = _previewBtn.enable = false;
				gold_txt.text = "0";
				percentage_txt.text = "0%";
				btnShine.visible = false;
				lianhuaArrow.visible = false;
			}
		}
		
		private function getRate():String
		{
			if(_items[5].itemInfo == null) return "25%";
			if(_items[5].itemInfo.TemplateID == "11017") return "28%";
			return "31%";
		}
		
		private function __lianhua(evt:Event):void
		{
			SoundManager.instance.play("008");
			if(!checkAidedMatieria())
			{
				MessageTipManager.getInstance().show("应该放三种不同的辅助材料!");
				return;
			}
			if(evt.currentTarget == _lianhuaBtn)
			{
				if(checkBind())
				{
					HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.StoreIIStrengthBG.use"),true,sendSocket,null);
				}else
				{
					sendSocket();
				}
				
			}else if(evt.currentTarget == _previewBtn)
			{
				sendSocket(0);
			}
		}
		
		private function getItemsInfo():Array
		{
			var matieria:Array = [];
			var equipBagType:int;
			var equipPlace:int;
			var luckyBagType:int;
			var luckyPlace:int;
			
			for(var i:int=2; i<5; i++)
			{
				matieria.push((_items[i] as LinkedBagCell).itemInfo.BagType);
				matieria.push((_items[i] as LinkedBagCell).itemInfo.Place);
			}
			matieria.push((_items[1] as LinkedBagCell).itemInfo.BagType);
			matieria.push((_items[1] as LinkedBagCell).itemInfo.Place);
			
			equipBagType = (_items[0] as LinkedBagCell).itemInfo.BagType;
			equipPlace   = (_items[0] as LinkedBagCell).itemInfo.Place;
			if((_items[5] as LinkedBagCell).itemInfo)
			{
				luckyBagType = (_items[5] as LinkedBagCell).itemInfo.BagType;
				luckyPlace   = (_items[5] as LinkedBagCell).itemInfo.Place;
			}
			return [matieria,equipBagType,equipPlace,luckyBagType,luckyPlace];
		}
		
		private function sendSocket(type:int=1):void
		{
			SocketManager.Instance.out.sendItemLianhua(type,4,getItemsInfo()[0],getItemsInfo()[1],getItemsInfo()[2],getItemsInfo()[3],getItemsInfo()[4]);
		}
		
		private function checkBind():Boolean
		{
			if(_items[0].itemInfo && _items[0].itemInfo.IsBinds)return false;
			if(_items[2].itemInfo && _items[2].itemInfo.IsBinds)return true;
			if(_items[3].itemInfo && _items[3].itemInfo.IsBinds)return true;
			if(_items[4].itemInfo && _items[4].itemInfo.IsBinds)return true;
			if(_items[1].itemInfo && _items[1].itemInfo.IsBinds)return true;
			return false;
		}
		
		private function checkAidedMatieria():Boolean
		{
			if((_items[2] as LinkedBagCell).itemInfo.TemplateID == (_items[3] as LinkedBagCell).itemInfo.TemplateID) return false;
			if((_items[2] as LinkedBagCell).itemInfo.TemplateID == (_items[4] as LinkedBagCell).itemInfo.TemplateID) return false;
			if((_items[3] as LinkedBagCell).itemInfo.TemplateID == (_items[4] as LinkedBagCell).itemInfo.TemplateID) return false;
			return true;
		}
		
		private function __showPreview(evt:CrazyTankSocketEvent):void
		{
			_previewFrameII.clearList();
			var isBin : Boolean;
			var itemsPreview:Array = new Array();
			var info : PreviewInfoII = new PreviewInfoII();
			info.data(evt.pkg.readInt(),evt.pkg.readInt());
			isBin = evt.pkg.readBoolean();
			info.setComposeProperty(evt.pkg.readInt(),evt.pkg.readInt(),evt.pkg.readInt(),evt.pkg.readInt());
			info.rate = _items[5].info == null ? 25 : 25*1.25;
			itemsPreview.push(info);
			for(var j:int=0;j<itemsPreview.length;j++)
			{
				var info1 : PreviewInfoII = itemsPreview[j] as PreviewInfoII;
				info1.info.IsBinds = isBin;
			}
			this._previewFrameII.items = itemsPreview;
			_previewFrameII.show();
		}
		
		public function dragDrop(source:BagCell):void
		{
			if(source == null) return;
			var info:InventoryItemInfo = source.info as InventoryItemInfo;
			var ds:LinkedBagCell;
			for each(ds in _items)
			{
				if(ds.info == info)
				{
					ds.bagCell = null;
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
					    if((ds as StoneCell).types.indexOf(info.Property1)>-1 && info.CategoryID == 11)
					    {
					    	ds.bagCell = source;
					    	source.locked = true;
				    	return;
				    	}
					}else if(ds is LianhuaItemCell)
					{
						if(info.getRemainDate() <= 0)
			        	{
				        	MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
				        	//MessageTipManager.getInstance().show("此物品已过期");
				        }else if(info.CanEquip && info.Refinery >= 0 && info.StrengthenLevel >= 7)
				        {
				        	ds.bagCell = source;
				    		source.locked = true;
					    	return;
				        }
					}else if(ds is LianhuaMainMaterialCell)
					{
						if(info.CategoryID == 11 && info.Property1 == "32")
						{
							ds.bagCell = source;
				    		source.locked = true;
					    	return;
						}
					}else if(ds is LianhuaAidedMatieriaCell)
					{
						if(info.CategoryID == 11 && info.Property1 == "33" && ds.info == null)
						{
							ds.bagCell = source;
				    		source.locked = true;
					    	return;
						}
					}
				}		
			}
			for each(ds in _items)
			{
				if((ds is LianhuaAidedMatieriaCell)&&(info.TemplateID == 11005))
		    	{
		    		ds.bagCell = source;
				    source.locked = true;
				    break;
		    	}
			}
		}
		
		public function refreshData(items:Dictionary):void
		{
			
		}
		
		public function updateData():void
		{
			
		}
		
		public function show():void
		{
			this.visible = true;
		}
		
		public function hide():void
		{
			this.visible = false;
		}
		
		public function startShine(index:int):void
		{
			_items[index].startShine();
		}
		
		public function stopShine():void
		{
			for(var i:int=0; i<_items.length; i++)
			{
				_items[i].stopShine();
			}
		}
		
		public function get area():Array
		{
			return _items;
		}
		
		public function dispose():void
		{
			removeEvents();
			_area.dispose();
			_lianhuaBtn.dispose();
			_previewBtn.dispose();
			_buyLucky.dispose();
			for(var i:int=0; i<_items.length; i++)
			{
				_items[i].dispose();
			}
			_items = null;
			if(_accessoryFrameII) _accessoryFrameII.dispose();
			if(parent) parent.removeChild(this);
		}
		
		private var _helpPage : HelpFrame;
		private function initHelpPage() : void
		{
			var helpBd : BitmapData = new LianhuaHelpAsset(0,0);
			var helpIma : Bitmap = new Bitmap(helpBd);
		 	_helpPage = new HelpFrame(helpIma);
			_helpPage.titleText = "炼化说明";
		 	
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