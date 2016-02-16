package ddt.store.view.embed
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Dictionary;
	
	import game.crazyTank.view.storeII.EmbedHelpAsset;
	import game.crazyTank.view.storeII.StoreIIEmbedBgAsset;
	import game.crazyTank.view.storeII.embedAlert1Asset;
	import game.crazyTank.view.storeII.embedAlert2Asset;
	import game.crazyTank.view.storeII.embedBackoutAlert;
	import game.crazyTank.view.storeII.embedBackoutDownItem;
	import game.crazyTank.view.storeII.embedBackoutMouseIcon;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.utils.ComponentHelper;
	
	import ddt.store.IStoreViewBG;
	import ddt.store.StoneCell;
	import ddt.store.StoreCell;
	import ddt.store.StoreDragInArea;
	import ddt.store.events.EmbedBackoutEvent;
	import ddt.store.events.EmbedEvent;
	import ddt.store.events.StoreIIEvent;
	import ddt.store.view.embed.frame.EmbedAlert1;
	import ddt.store.view.embed.frame.EmbedBackoutAlert;
	
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.events.ShortcutBuyEvent;
	import ddt.manager.DragManager;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.utils.LeavePage;
	import ddt.view.HelpFrame;
	import ddt.view.bagII.bagStore.BagStore;
	import ddt.view.cells.BagCell;
	import ddt.view.cells.DragEffect;
	import ddt.view.common.FastPurchaseGoldBox;
	import ddt.view.common.QuickBuyFrame;
	
	/**
	 * @author wicki LA
	 * @time 11/25/2009
	 * @description 镶嵌面板
	 * */
	
	public class StoreEmbedBG extends StoreIIEmbedBgAsset implements IStoreViewBG
	{
		private var _items:Array;
		private var _area:StoreDragInArea;
		private var _stoneCells:Array;
		private var _embedItemCell:EmbedItemCell;
		private var lightingFilter:ColorMatrixFilter;
		public static const EMBED_MONEY:Number = 2000;
		public static const EMBED_BACKOUT_MONEY:Number = 500;//拆除所需点卷
		
		private var _help:HBaseButton;
		private var _embedBackoutBtn:EmbedBackoutButton;
		
		private var _currentHolePlace:int;
		private var _templateID:int;
		
		private var _quick:QuickBuyFrame;
		private var fastPurchaseGoldBox:FastPurchaseGoldBox;
		private var _frame:HConfirmFrame;
		private var _hcFrame:HConfirmFrame;
		private var _hcFrame2:HConfirmFrame;
		private var _embedBackoutDownItem:HBaseButton;
		private var _embedStoneCell:EmbedStoneCell;
		private var _embedBackoutMouseIcon:embedBackoutMouseIcon;
		
		public function StoreEmbedBG()
		{
			init();
			initEvents();
		}
		
		private function init():void
		{
			_help = new HBaseButton(descriptionBtn);
			_help.useBackgoundPos = true;
			addChild(_help);
			
			_embedBackoutBtn = new EmbedBackoutButton();
			removeChild(embedBackoutBtn);
			_embedBackoutBtn.x=embedBackoutBtn.x;
			_embedBackoutBtn.y=embedBackoutBtn.y;
			addChild(_embedBackoutBtn);
			
			_embedBackoutDownItem = new HBaseButton(new embedBackoutDownItem());
			_embedBackoutDownItem.useBackgoundPos=true;
			
			_items = [];
			_stoneCells = [];
			_embedItemCell = new EmbedItemCell(0);
			ComponentHelper.replaceChild(this,cell_0,_embedItemCell);
			_items.push(_embedItemCell);
			_area = new StoreDragInArea(_items);
			addChildAt(_area,0);
			for(var i:int=1;i<7;i++)
			{
				var stoneCell:EmbedStoneCell = new EmbedStoneCell(i,-1);
				stoneCell.x = this["cell_"+i].x;
				stoneCell.y = this["cell_"+i].y;
				addChild(stoneCell);
				stoneCell.mouseChildren=false;
				removeChild(this["cell_"+i]);
				stoneCell.addEventListener(EmbedEvent.EMBED,__embed);
				stoneCell.addEventListener(EmbedBackoutEvent.EMBED_BACKOUT,__EmbedBackout);
				stoneCell.addEventListener(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_OVER,__EmbedBackoutDownItemOver);
				stoneCell.addEventListener(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_OUT,__EmbedBackoutDownItemOut);
				stoneCell.addEventListener(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_DOWN,__EmbedBackoutDownItemDown);
				_stoneCells.push(stoneCell);
			}
			
			hide();
		}
		
		private function initEvents():void
		{
			_embedItemCell.addEventListener(Event.CHANGE,__itemInfoChange);
			_help.addEventListener(MouseEvent.CLICK,__openHelp);
			_embedBackoutBtn.addEventListener(MouseEvent.CLICK, __embedBackoutBtnClick);
		}
		
		private function __embedBackoutBtnClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			evt.stopImmediatePropagation();
			_embedBackoutBtn.mouseEnabled=false;
			_embedBackoutBtn.isAction=true;
			
			if(_embedBackoutMouseIcon==null)
			{
				_embedBackoutMouseIcon=new embedBackoutMouseIcon();
			}
			_embedBackoutMouseIcon.gotoAndStop(1);
			DragManager.startDrag(_embedBackoutBtn,_embedBackoutBtn,_embedBackoutMouseIcon,evt.stageX,evt.stageY,DragEffect.MOVE, false, true);
		}
		
		private function __itemInfoChange(evt:Event):void
		{
			for(var i:int=0;i<_stoneCells.length;i++)
			{
				_stoneCells[i].close();
			}
			if(_embedItemCell.info != null)
			{
				initHoleType();
				updateHoles();
				dispatchEvent(new StoreIIEvent(StoreIIEvent.EMBED_INFORCHANGE));
			}
		}
		
		private function initHoleType():void
		{
			var info:InventoryItemInfo = _embedItemCell.itemInfo;
			var arr:Array = info.Hole.split("|"); 
			for(var j:int=0;j<_stoneCells.length;j++)
			{
				_stoneCells[j].StoneType = arr[j].split(",")[1];
			}
		}
		
		private function updateHoles():void
		{
			var info:InventoryItemInfo = _embedItemCell.itemInfo;
			for(var i:int=0; i<_stoneCells.length; i++)
			{
				if(info["Hole"+(i+1)] == -1)
				{
					_stoneCells[i].close();
					_stoneCells[i].tipDerial = false;
				}else
				{
					_stoneCells[i].open();
					_stoneCells[i].tipDerial = true;  /**孔的tip开关 在空是开启并且未被镶嵌的时候开启tips**/
					if(info["Hole"+(i+1)] != 0)
					{
						_stoneCells[i].info = ItemManager.Instance.getTemplateById(info["Hole"+(i+1)]);
						_stoneCells[i].tipDerial = false;
					}
				}
			}
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
							if((ds as StoneCell).types.indexOf(info.Property1)>-1 && info.CategoryID == 11)
							{
								SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,1);
								DragManager.acceptDrag(ds,DragEffect.NONE);
								return;
							}
						}	
					}else if(ds is EmbedItemCell)
					{
						for(var i:int=1; i<7; i++)
						{
							if(info["Hole"+i]>=0)
							{
								SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,1);
								DragManager.acceptDrag(ds,DragEffect.NONE);
								return;
							}
						}
					}
				}		
			}
		}
		
		private function __embed(evt:EmbedEvent):void
		{
			evt.stopImmediatePropagation();
			_currentHolePlace = evt.CellID;
			
			//装备为未绑定状态，宝珠为绑定状态
			if(!_embedItemCell.itemInfo.IsBinds && _stoneCells[_currentHolePlace-1].itemInfo.IsBinds)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.StoreIIComposeBG.use"),true,sendEmbed,cancelEmbed1);
			}
			else
			{
				__embed2();
			}
		}
		
		private function cancelEmbed1():void
		{
			_stoneCells[_currentHolePlace-1].bagCell = null;
			updateHoles();
		}
		
		private function __embed2():void
		{
			if(_hcFrame2)
			{
				_hcFrame2.close();
			}
			
			if(_embedItemCell.itemInfo["Hole"+_currentHolePlace] == 0)
			{
				_frame = new EmbedAlert1(new embedAlert2Asset());
				
			}else
			{
				_frame = new EmbedAlert1(new embedAlert1Asset());
			}
			_frame.titleText=LanguageMgr.GetTranslation("AlertDialog.Info");
			_frame.autoDispose = true;
			_frame.okFunction = sendEmbed;
			_frame.cancelFunction = cancelEmbed;
			_frame.closeCallBack = cancelEmbed;
			_frame.moveEnable = false;
			_frame.show();
		}
		
		//拆除镶嵌
		private function __EmbedBackout(evt:EmbedBackoutEvent):void
		{
			_currentHolePlace = evt.CellID;
			_templateID = evt.TemplateID;
			
			__EmbedBackoutFrame(evt);
		}
		
		//拆除镶嵌
		private function __EmbedBackoutFrame(evt:Event):void
		{
			SoundManager.Instance.play("008");
			evt.stopImmediatePropagation();
			if(_embedStoneCell && evt.type==MouseEvent.CLICK)
			{
				_embedStoneCell.closeTip(evt as MouseEvent);
			}
			
			_hcFrame = new EmbedBackoutAlert(new embedBackoutAlert());
			_hcFrame.titleText=LanguageMgr.GetTranslation("AlertDialog.Info");
			_hcFrame.autoDispose = true;
			_hcFrame.okFunction = sendEmbedBackout;
			_hcFrame.cancelFunction = cancelEmbedBackout;
			_hcFrame.closeCallBack = cancelEmbedBackout;
			_hcFrame.show();
		}
		
		//拆除镶嵌（下拉方式）
		private function __EmbedBackoutDownItemOver(evt:EmbedBackoutEvent):void
		{
			evt.stopImmediatePropagation();
			_currentHolePlace = evt.CellID;
			_templateID = evt.TemplateID;
			
			if(!_embedBackoutBtn.isAction && !contains(_embedBackoutDownItem))
			{
				_embedStoneCell= evt.target as EmbedStoneCell;
				
				_embedBackoutDownItem.x=evt.target.x;
				_embedBackoutDownItem.y=evt.target.y+evt.target.height+14;
				
				addChild(_embedBackoutDownItem);
				
				_embedBackoutDownItem.addEventListener(MouseEvent.CLICK, __EmbedBackoutFrame);
				_embedBackoutDownItem.addEventListener(MouseEvent.MOUSE_OVER, __EmbedShowTip);
				_embedBackoutDownItem.addEventListener(MouseEvent.MOUSE_OUT, __EmbedBackoutDownItemOutGo);
			}
		}
		
		private function __EmbedShowTip(evt:MouseEvent):void
		{
			if(_embedStoneCell)
			{
				_embedStoneCell.showTip(evt);
			}
		}
		
		private function __EmbedBackoutDownItemDown(evt:EmbedBackoutEvent):void
		{
			if(_embedBackoutMouseIcon)
			{
				_embedBackoutMouseIcon.gotoAndStop(2);
			}
		}

		//拆除镶嵌（下拉方式）
		private function __EmbedBackoutDownItemOut(evt:EmbedBackoutEvent):void
		{
			if(_embedBackoutDownItem && ((mouseY>=_embedBackoutDownItem.y && mouseY<=_embedBackoutDownItem.y+_embedBackoutDownItem.height) && (mouseX>=_embedBackoutDownItem.x && mouseX<=_embedBackoutDownItem.x+_embedBackoutDownItem.width)))
			{
				return;
			}
			
			__EmbedBackoutDownItemOutGo(evt);
		}
		
		//拆除镶嵌（下拉方式）
		private function __EmbedBackoutDownItemOutGo(evt:Event):void
		{
			if(_embedBackoutBtn!=null && !_embedBackoutBtn.isAction && _embedBackoutDownItem && contains(_embedBackoutDownItem))
			{
				if(_embedStoneCell && evt!=null && evt.type==MouseEvent.MOUSE_OUT)
				{
					_embedStoneCell.closeTip(evt as MouseEvent);
				}
				
				_embedBackoutDownItem.removeEventListener(MouseEvent.MOUSE_OVER, __EmbedShowTip);
				_embedBackoutDownItem.removeEventListener(MouseEvent.CLICK, __EmbedBackoutFrame);
				_embedBackoutDownItem.removeEventListener(MouseEvent.MOUSE_OUT, __EmbedBackoutDownItemOutGo);
				removeChild(_embedBackoutDownItem);
			}
		}
		
		public function refreshData(items:Dictionary):void
		{
			_embedItemCell.info = PlayerManager.Instance.Self.StoreBag.items[0];
		}
		
		public function sendEmbed():void
		{
			if(_frame)
			{
				_frame.dispose();
				_frame.close();
			}
			if(_hcFrame2)
			{
				_hcFrame2.dispose();
				_hcFrame2.close();
			}
			
			if(PlayerManager.Instance.Self.Gold < 2000){
				fastPurchaseGoldBox=new FastPurchaseGoldBox(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("ddt.view.GoldInadequate"),EquipType.GOLD_BOX);
				fastPurchaseGoldBox.autoDispose=true;
				fastPurchaseGoldBox.okFunction=okFastPurchaseGold;
				fastPurchaseGoldBox.cancelFunction=cancelFastPurchaseGold;
				fastPurchaseGoldBox.closeCallBack=cancelFastPurchaseGold;
				fastPurchaseGoldBox.show();
				return;
			}
			
			SocketManager.Instance.out.sendItemEmbed(_embedItemCell.itemInfo.BagType,_embedItemCell.itemInfo.Place,_currentHolePlace,_stoneCells[_currentHolePlace-1].itemInfo.BagType,_stoneCells[_currentHolePlace-1].itemInfo.Place);
		}
		
		private function cancelEmbed():void
		{
			if(_frame)
			{
				_frame.dispose();
				_frame.close();
			}
			_stoneCells[_currentHolePlace-1].bagCell = null;
			updateHoles();
		}
		
		private function okFastPurchaseGold():void
		{
			if(fastPurchaseGoldBox)
			{
				fastPurchaseGoldBox.close();
			}

			_quick = new QuickBuyFrame(LanguageMgr.GetTranslation("ddt.view.store.matte.goldQuickBuy"),"");
			_quick.cancelFunction=_quick.closeCallBack=cancelQuickBuy;
			_quick.itemID = EquipType.GOLD_BOX;
			_quick.x = 350;
			_quick.y = 200;
			_quick.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY,__shortCutBuyHandler);
			_quick.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY_MONEY_OK,__shortCutBuyMoneyOkHandler);
			_quick.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY_MONEY_CANCEL,__shortCutBuyMoneyCancelHandler);
			_quick.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
			_quick.show();
		}
		
		private function cancelQuickBuy():void
		{
			if(_quick)
			{
				_quick.dispose();
				_quick.close();
			}
			if(_frame)
			{
				_frame.dispose();
				_frame.close();
			}
			
			_stoneCells[_currentHolePlace-1].bagCell = null;
			updateHoles();
		}
		
		private function removeFromStageHandler(event:Event):void{
			BagStore.Instance.reduceTipPanelNumber();
		}
		
		private function __shortCutBuyHandler(evt:ShortcutBuyEvent):void
		{
			evt.stopImmediatePropagation();
			if(_frame)
			{
				_frame.dispose();
				_frame.close();
			}
			__embed2();
		}
		
		private function __shortCutBuyMoneyOkHandler(evt:ShortcutBuyEvent):void
		{
			evt.stopImmediatePropagation();
			okFastPurchaseGold();
		}
		
		private function __shortCutBuyMoneyCancelHandler(evt:ShortcutBuyEvent):void
		{
			evt.stopImmediatePropagation();
			_stoneCells[_currentHolePlace-1].bagCell = null;
			updateHoles();
		}
		
		private function cancelFastPurchaseGold():void
		{
			if(fastPurchaseGoldBox)
			{
				fastPurchaseGoldBox.close();
			}
			if(_frame)
			{
				_frame.dispose();
				_frame.close();
			}
			
			_stoneCells[_currentHolePlace-1].bagCell = null;
			updateHoles();
		}
		
		public function sendEmbedBackout():void
		{
			if(PlayerManager.Instance.Self.Gift < EMBED_BACKOUT_MONEY){
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,cancelEmbedBackout);
				_hcFrame.close();
				return;
			}
			
			__EmbedBackoutDownItemOutGo(null);
			if(_hcFrame)
			{
				_hcFrame.dispose();
				_hcFrame.close();
			}
			SocketManager.Instance.out.sendItemEmbedBackout(_currentHolePlace, _templateID);
		}
		
		private function cancelEmbedBackout():void
		{
			if(_hcFrame)
			{
				_hcFrame.dispose();
				_hcFrame.close();
				_stoneCells[_currentHolePlace-1].bagCell = null;
				updateHoles();
				stage.focus = this;
			}
		}
		
		private function removeEvents():void
		{
			for(var i:int=1;i<7;i++)
			{
				_stoneCells[i-1].removeEventListener(EmbedEvent.EMBED,__embed);
			}
			_embedItemCell.removeEventListener(Event.CHANGE,__itemInfoChange);
			_help.removeEventListener(MouseEvent.CLICK,__openHelp);
		}
		
		public function updateData():void
		{
			
		}
		
		public function get area():Array
		{
			return _items;
		}
		
		public function startShine():void
		{
			_embedItemCell.startShine();
		}
		
		/**
		 * type 1:三角宝珠shine 2:方形宝珠shine 3:圆形宝珠shine
		 */
		public function stoneStartShine(type:int):void{	
			var info:InventoryItemInfo = _embedItemCell.itemInfo;
			for(var i:int = 0; i<_stoneCells.length; i++){
				if(info && (info["Hole"+(i+1)] != -1) && (_stoneCells[i] as EmbedStoneCell).StoneType == type){
					_stoneCells[i].startShine();
				}
			}	
		}
		
		public function stopShine():void
		{
			_embedItemCell.stopShine();
			for each(var item:EmbedStoneCell in _stoneCells){
				item.stopShine();
			}
		}
		
		public function show():void
		{
			this.visible = true;
			refreshData(null);
		}
		
		public function hide():void
		{
			this.visible = false;
			for(var i:int=1;i<7;i++)
			{
				_stoneCells[i-1].close;
			}
		}
		
		public function dispose():void
		{
			removeEvents();
			_items = null;
			_area.dispose();
			_area = null;
			_embedItemCell.dispose();
			_embedBackoutBtn.dispose();
			if(_embedBackoutBtn && _embedBackoutBtn.parent)
			{
				_embedBackoutBtn.parent.removeChild(_embedBackoutBtn);
			}
			_embedBackoutBtn = null;
			if(_embedBackoutDownItem)
			{
				_embedBackoutDownItem.removeEventListener(MouseEvent.MOUSE_OVER, __EmbedShowTip);
				_embedBackoutDownItem.removeEventListener(MouseEvent.CLICK, __EmbedBackoutFrame);
				_embedBackoutDownItem.removeEventListener(MouseEvent.MOUSE_OUT, __EmbedBackoutDownItemOutGo);
				if(_embedBackoutDownItem.parent)
				{
					_embedBackoutDownItem.parent.removeChild(_embedBackoutDownItem);
				}
			}
			_embedBackoutDownItem=null;
			if(_embedBackoutMouseIcon && _embedBackoutMouseIcon.parent)
			{
				_embedBackoutMouseIcon.parent.removeChild(_embedBackoutMouseIcon);
			}
			_embedBackoutMouseIcon=null;
			if(_quick)
			{
				if(_quick.parent)
				{
					_quick.parent.removeChild(_quick);
				}
				_quick.dispose();
				_quick.close();
			}
			_quick=null;
			
			for(var i:int=1;i<7;i++)
			{
				_stoneCells[i-1].dispose;
			}
			if(parent) parent.removeChild(this);
		}
		
		private var _helpPage : HelpFrame;
		private function initHelpPage() : void
		{
			var helpBd : BitmapData = new EmbedHelpAsset(0,0);
			var helpIma : Bitmap = new Bitmap(helpBd);
			_helpPage = new HelpFrame(helpIma);
			_helpPage.titleText = LanguageMgr.GetTranslation("ddt.view.store.matteHelp.title");
			
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