package ddt.store.view.fusion
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import game.crazyTank.view.storeII.FusionHelpAsset;
	import game.crazyTank.view.storeII.StoreIIFusionAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HConfirmDialog;
	
	import ddt.store.IStoreViewBG;
	import ddt.store.StoreCell;
	import ddt.store.StoreDragInArea;
	import ddt.store.data.PreviewInfoII;
	import ddt.store.events.StoreIIEvent;
	import ddt.store.view.shortcutBuy.ShortcutBuyFrame;
	
	import ddt.data.EquipType;
	import ddt.data.StoneType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.DragManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.HelpFrame;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.cells.BagCell;
	import ddt.view.cells.DragEffect;
	import ddt.view.common.FastPurchaseGoldBox;
	

	public class StoreIIFusionBG extends StoreIIFusionAsset implements IStoreViewBG
	{
		private static const ITEMS:Array = [11301,11302,11303,11304,11201,11202,11203,11204];
		
		private var _area           : StoreDragInArea;//节点显示容器
		private var _items          : Array;//节点集合
		private var _accessoryFrameII:AccessoryFrameII; //附加物品窗体
		private var _previewFrameII : PreviewFrameII;  //预览窗体
		
//		private var _accessoryBtn   : HBaseButton;
		private var _previewBtn     : HBaseButton;
		private var _fusion_btn     : HBaseButton;
		private var _fusionHelp     : HBaseButton;
		private var _buyBtn:HBaseButton;
		
		private var _gold : int = 400;
		private var _maxCell:int = 0;
		
		public function StoreIIFusionBG()
		{
			super();
			init();
			initEvent();
		}
		
		private function init() : void
		{
			_items       = [];
			for(var i:int = 0; i < 5; i++)
			{
				var item:StoreCell;
				if(i == 0)
				{
					item = new FusionItemCellII(i);//熔炼公式
				}
				else
				{
					item = new FusionItemCell(i);
				}
				item.x = this["cell_" + i].x;
				item.y = this["cell_" + i].y;
				addChild(item);
				item.addEventListener(Event.CHANGE,__itemInfoChange);
				_items.push(item);
			}
			_accessoryFrameII = new AccessoryFrameII();
			_previewFrameII = new PreviewFrameII();
			_previewFrameII.hide();
			_area           = new StoreDragInArea(_items);
			//previewBtn.visible = false;
			addChildAt(_area,0);
			
//			_accessoryBtn = new HBaseButton(accessoryBtn);
//			_accessoryBtn.useBackgoundPos = true;
//			addChild(_accessoryBtn);
//			this.removeChild(this.accessoryBtn);
			
			_previewBtn  = new HBaseButton(previewBtn);
			_previewBtn.useBackgoundPos = true;
			addChild(_previewBtn);
			_previewBtn.enable = false;
			
			_fusion_btn = new HBaseButton(fusion_btn);
			_fusion_btn.useBackgoundPos = true;
			addChild(_fusion_btn);
			_fusion_btn.enable = false;
			
			_fusionHelp = new HBaseButton(fusionHelp);
			_fusionHelp.useBackgoundPos = true;
			addChild(_fusionHelp);
			
			//_buyBtn = new HBaseButton(buyBtnAsset);
			//_buyBtn.useBackgoundPos = true;
			//addChild(_buyBtn);
			
			hideArr();
			
			hide();
		}
		private function initEvent() : void
		{
//			_accessoryBtn.addEventListener(MouseEvent.CLICK, __accessoryBtnClick);
			_previewBtn.addEventListener(MouseEvent.CLICK,   __previewBtnClick);
			_fusion_btn.addEventListener(MouseEvent.CLICK,   __fusionClick);
			_accessoryFrameII.addEventListener(StoreIIEvent.ITEM_CLICK, __accessoryItemClick);
			_fusionHelp.addEventListener(MouseEvent.CLICK,    __openHelp);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_FUSION_PREVIEW,  __upPreview);
			//_buyBtn.addEventListener(MouseEvent.CLICK,__buyBtnClickHandler);
		}
		
		private function removeEvents():void
		{
			for(var i:int = 0; i < _items.length; i++)
			{
				_items[i].removeEventListener(Event.CHANGE,__itemInfoChange);
				_items[i].dispose();
			}
//			_accessoryBtn.removeEventListener(MouseEvent.CLICK, __accessoryBtnClick);
			_previewBtn.removeEventListener(MouseEvent.CLICK,__previewBtnClick);
			_fusion_btn.removeEventListener(MouseEvent.CLICK,__fusionClick);
			_accessoryFrameII.addEventListener(StoreIIEvent.ITEM_CLICK,__accessoryItemClick);
			_fusionHelp.addEventListener(MouseEvent.CLICK,__openHelp);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_FUSION_PREVIEW, __upPreview);
			//_buyBtn.removeEventListener(MouseEvent.CLICK,__buyBtnClickHandler);
		}
		
		private function __buyBtnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			evt.stopImmediatePropagation();
			
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			new ShortcutBuyFrame(ITEMS,true,LanguageMgr.GetTranslation("store.view.fusion.buyFormula"),4).show();
		}
		
		public function dragDrop(source:BagCell):void
		{
			if(source == null) return;
			if(_accessoryFrameII.containsItem(source.itemInfo)) return;
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
					if(ds is FusionItemCell)
					{
						if(info.getRemainDate() <= 0)
			        	{
			        		MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
			        		//MessageTipManager.getInstance().show("此物品已过期");
			        	}else if(info.FusionType!=0)
						{
							if(ds.info==null){
							    SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,1);
							    DragManager.acceptDrag(ds,DragEffect.NONE);
							    __previewRequest();
							    return;
							}
						}
					}else if(ds is FusionItemCellII)
					{
						if(info.getRemainDate() <= 0)
			        	{
				        	MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
				        	//MessageTipManager.getInstance().show("此物品已过期");
				        }else if(info.Property1 == StoneType.FORMULA)
						{
							_fusion_btn.enable = false;
		    				hideArr();
		    				_previewBtn.enable = false;
					    	SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,1);
							DragManager.acceptDrag(ds,DragEffect.NONE);
							__previewRequest();
				    		return;
						}
					}
				}		
			}
			for each(ds in _items)
			{
				if((ds is FusionItemCell)&&source.info.FusionType!=0)
		    	{
		    		_fusion_btn.enable = false;
		    		hideArr();
		    		_previewBtn.enable = false;
					SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,1);
					DragManager.acceptDrag(ds,DragEffect.NONE);
					__previewRequest();
				    return;
		    	}
		    }
	  }
		
		private function showIt():void{
			_fusion_btn.enable         = true;
			showArr();
			_previewBtn.enable         = true;
		}
		
		public function get area():Array
		{
			return this._items;
		}
		
		public function refreshData(items:Dictionary):void
		{
			for(var place:String in items)
			{
				var itemPlace:int = int(place);
				if(itemPlace<5)
				{
					_items[itemPlace].info = PlayerManager.Instance.Self.StoreBag.items[itemPlace];
				}else
				{
					_accessoryFrameII.setItemInfo(itemPlace,PlayerManager.Instance.Self.StoreBag.items[itemPlace])
				}
			}
		}
		
		public function updateData():void
		{
			for(var i:int = 0; i<5; i++)
			{
				_items[i].info = PlayerManager.Instance.Self.StoreBag.items[i];
			}
			for(var j:int=5; j<11; j++)
			{
				_accessoryFrameII.setItemInfo(j,PlayerManager.Instance.Self.StoreBag.items[j+5]);
			}
		}
		
        public function startShine(cellId:int):void
		{
			_items[cellId].startShine();
		}
		
		public function stopShine():void
		{
			for(var i:int=0;i<5;i++)
			{
				_items[i].stopShine();
			}
		}
		
		/**
		 * 显示箭头
		 * */
		private function showArr():void
		{
			fusionArr.visible = true;
			fusionShine.play();
		}
		/**
		 * 隐藏箭头
		 * */
		private function hideArr():void
		{
			fusionArr.visible = false;
			fusionShine.gotoAndStop(1);
		}
		
		public function show():void
		{
			this.visible = true;
			updateData();
		}
		
		public function hide():void
		{
			this.visible  = false;
			_accessoryFrameII.hide();
			_previewFrameII.hide();
		}
		public function dispose():void
		{
			removeEvents();
			_area.dispose();
			_accessoryFrameII.dispose();
			if(_helpPage)_helpPage.dispose();
			if(parent)parent.removeChild(this);
		}
		
		/*******************************
		 *     更新熔炼预览数据
		 * 物品个数,两个ID,两个成功率
		 */
		private var _itemsPreview : Array;
		private function __upPreview(evt : CrazyTankSocketEvent) : void
		{
			_fusion_btn.enable        = false;
			hideArr();
			_previewBtn.enable        = false;
			
			_previewFrameII.clearList();
			var isBin : Boolean;
			var count : int = evt.pkg.readInt();
			_itemsPreview = new Array();
			for(var i:int=0;i<count;i++)
			{
				var info : PreviewInfoII = new PreviewInfoII();
			    info.data(evt.pkg.readInt(),evt.pkg.readInt());
				info.rate = evt.pkg.readInt();
				_itemsPreview.push(info);
			}
			isBin = evt.pkg.readBoolean();
			for(var j:int=0;j<_itemsPreview.length;j++)
			{
				var info1 : PreviewInfoII = _itemsPreview[j] as PreviewInfoII;
				info1.info.IsBinds = isBin;
			}
			this._previewFrameII.items = _itemsPreview;
			_fusion_btn.enable         = true;
			showArr();
			_previewBtn.enable         = true;
			
		}
		
		/******************************************
		 *         响应在附加列表中操作
		 * 实时控制显示所需金币数据
		 ******************************************/
		private function __accessoryItemClick(evt : StoreIIEvent) : void
		{
			gold_txt.text = String((checkItemEmpty() + _accessoryFrameII.getCount())*_gold);
		}
		
		private function __itemInfoChange(evt:Event) : void
		{
			var stones:int = 0;
			stones = checkItemEmpty();
			gold_txt.text = String((stones + _accessoryFrameII.getCount())*_gold);
			
			if(PlayerManager.Instance.Self.StoreBag.items[0] != null)stones ++;
			if(stones == 5)
			{
				_fusion_btn.enable = false;
				hideArr();
				_previewBtn.enable = false;
				__previewRequest();
				return;
			}
			_fusion_btn.enable = false;
			hideArr();
			stones = 0;
			_previewBtn.enable        = false;
		}
		private function checkItemEmpty() : int
		{
			var stones:int     = 0;
			if(PlayerManager.Instance.Self.StoreBag.items[1] != null)stones ++;
			if(PlayerManager.Instance.Self.StoreBag.items[2] != null)stones ++;
			if(PlayerManager.Instance.Self.StoreBag.items[3] != null)stones ++;
			if(PlayerManager.Instance.Self.StoreBag.items[4] != null)stones ++;
			
			return stones;
		}
		private function isAllBinds() : int{
			var stones:int     = 0;
			if(_items[0].info != null && _items[0].info.IsBinds)stones ++;
			if(_items[1].info != null && _items[1].info.IsBinds)stones ++;
			if(_items[2].info != null && _items[2].info.IsBinds)stones ++;
			if(_items[3].info != null && _items[3].info.IsBinds)stones ++;
			if(_items[4].info != null && _items[4].info.IsBinds)stones ++;
			return stones;
		}
		
		private function __fusionClick(evt : MouseEvent) : void
		{
			evt.stopImmediatePropagation();
			SoundManager.instance.play("008");
			if(PlayerManager.Instance.Self.Gold < (_accessoryFrameII.getCount() + 4) * _gold)
			{
				new FastPurchaseGoldBox(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("ddt.view.GoldInadequate"),EquipType.GOLD_BOX).show();
//				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIBtnPanel.lackGold"));
				return;
			}
//			else if(testingSXJ())
//			{
//				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.view.fusion.StoreIIFusionBG.useNoExtends"),true,sendFusionRequest);
//				return ;
//			}
			else if(isAllBinds() != 0 && isAllBinds() != 5)
			{
				
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.view.fusion.StoreIIFusionBG.use"),true,sendFusionRequest);
				//HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),"使用绑定的道具将会使您的宝石\n成为绑定状态，是否继续操作？",true,sendFusionRequest);
				return ;
			}
			else if(this._accessoryFrameII.isBinds && isAllBinds() != 5)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.view.fusion.StoreIIFusionBG.use"),true,sendFusionRequest);
				return ;
			}
			sendFusionRequest();
		}
		/**
		 * 测试 手镯 项连 戒指
		 * **/
		private function testingSXJ():Boolean
		{
			var b:Boolean = false;
			for(var i:int=0;i<_items.length;i++)
			{
				if(EquipType.isRongLing(_items[i].info))
				{
					b= true;
					break;
				}
			}
			return b;
		}
		private function sendFusionRequest() : void
		{
			SocketManager.Instance.out.sendItemFusion(1);
		}

//		private function __accessoryBtnClick(evt : MouseEvent) : void
//		{
//			evt.stopImmediatePropagation();
//			SoundManager.instance.play("008");
//			_accessoryFrameII.show();
//		}

		
		 /******************************************************
		 *            打开预览窗口
		 * 
		 * data1 四个物品的包类型,包位置
		 * data2 熔炼公式
		 * _accessoryFrame.getCount() 附加物品数
		 * _accessoryFrame.getAllAccessory() 附加品的包类型和包中位置
		 * 0 熔炼预览请求
		 * 4 主熔物为四个
		 ***************************************/
		private function __previewBtnClick(evt : MouseEvent) : void
		{
			SoundManager.instance.play("008");
			evt.stopImmediatePropagation();
			var stones:int     = checkItemEmpty();
			if(_items[0].info != null)stones ++;
			if(stones < 5)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.StoreIIFusionBG.put"));
				//MessageTipManager.getInstance().show("请放满主熔炼物品及熔炼公式");
				return ;
			}
			__previewRequest();
			_previewFrameII.show();

		}
		
		
		private function __previewRequest() : void
		{
			global.traceStr("OnPreviewRequest");
			SocketManager.Instance.out.sendItemFusion(0);
		}
		
		/**************************
		 * 打开帮助窗口
		 * "**********************/
		 private var _helpPage : HelpFrame;
		 private function initHelpPage() : void
		 {
		 	var helpBd : BitmapData = new FusionHelpAsset(0,0);
			var helpIma : Bitmap = new Bitmap(helpBd);
		 	_helpPage = new HelpFrame(helpIma);
			_helpPage.titleText = LanguageMgr.GetTranslation("store.view.fusion.StoreIIFusionBG.say");
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