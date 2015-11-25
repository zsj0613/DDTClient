package ddt.view.common
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.manager.TipManager;
	
	import ddt.data.EquipType;
	import ddt.data.goods.ShopItemInfo;
	import ddt.events.ShortcutBuyEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ShopManager;
	import ddt.manager.SocketManager;
	import ddt.utils.LeavePage;

	public class QuickBuyFrame extends HConfirmDialog
	{
		private var _view:QuickBuyFrameView;
		private var _shopItemInfo:ShopItemInfo;
		private var _unitPrice:Number;
		
		private var _storeTab:int;
		
		override public function QuickBuyFrame(title:String, msg:String, model:Boolean=true, callback:Function=null, cancelback:Function=null, confirmLabel:String=null, cancelLabels:String=null, frameWidth:Number=0)
		{
			super(title, msg, model, callback, cancelback, confirmLabel, cancelLabels, frameWidth);
			init();
		}
		
		private function init():void{
			setSize(300,190);
			showCancel = false;
			okLabel = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
			okFunction = doPay;
			okBtn.center();
			blackGound = true;
			this.moveEnable = false;
			_view = new QuickBuyFrameView();
			_view.x = 9;
			_view.y = 30;
			addContent(_view);
		}
		
		public function set itemID(value:int):void
		{
			_view.ItemID = value;
			_shopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(_view._itemID);
			perPrice();
		}
		
		public function set stoneNumber(value:int):void
		{
			_view.stoneNumber = value;
		}
		
		override protected function __closeClick(e:MouseEvent):void
		{
			if(cancelFunction!=null) cancelFunction();
			super.__closeClick(e);
		}
		
		public function set storeTab(value:int):void
		{
			_storeTab = value;
		}
		
		public function get storeTab():int
		{
			return _storeTab;
		}
		
		private function perPrice():void{
			_unitPrice = ShopManager.Instance.getMoneyShopItemByTemplateID(_view.ItemID).getItemPrice(1).moneyValue;
		}
		private var hConfirmDialog:HConfirmDialog;
		private function doPay():void
		{
			if(PlayerManager.Instance.Self.Money < _view.stoneNumber * _unitPrice){
				hConfirmDialog = new HConfirmDialog(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,doMoney, cancelMoney);
				this.addEventListener(KeyboardEvent.KEY_DOWN ,__escKeyDown);
				TipManager.AddTippanel(hConfirmDialog,true);
//				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,doMoney, cancelMoney);
				super.close();
				if(parent) parent.removeChild(this);
				return;
			}
			
			super.close();
			
			if(_view.ItemID==EquipType.GOLD_BOX)
			{//如果物品是金币箱(会直接打开金币箱)
				SocketManager.Instance.out.sendQuickBuyGoldBox(_view.stoneNumber);	
			}
			else
			{
	        	var items:Array = [];
			    var types:Array = [];
			    var colors:Array = [];
			    var dresses:Array = [];
			    var skins:Array = [];
			    var places : Array =[];
			    for(var i:int = 0;i < _view.stoneNumber ;i++)
			    {
			    	items.push(_shopItemInfo.GoodsID);
			    	types.push(1);
			    	colors.push("");
			    	dresses.push(false);
			    	skins.push("");
			    	places.push(-1);
			    }
			    SocketManager.Instance.out.sendBuyGoods(items,types,colors,places,dresses,skins,_storeTab);	
			}
			dispatchEvent(new ShortcutBuyEvent(_view._itemID,_view.stoneNumber));
		}
		
		private function __escKeyDown(evt:KeyboardEvent):void
		{
			if(hConfirmDialog && evt.keyCode == Keyboard.ESCAPE)
			{
				SoundManager.instance.play("008");
				this.removeEventListener(KeyboardEvent.KEY_DOWN ,__escKeyDown);
				hConfirmDialog.hide();
			}
		}
		
		private function doMoney():void
		{
			LeavePage.leaveToFill();
			dispatchEvent(new ShortcutBuyEvent(_view._itemID,_view.stoneNumber, false, false, ShortcutBuyEvent.SHORTCUT_BUY_MONEY_OK));
			close();
		}
		
		private function cancelMoney():void
		{
			dispatchEvent(new ShortcutBuyEvent(_view._itemID,_view.stoneNumber, false, false, ShortcutBuyEvent.SHORTCUT_BUY_MONEY_CANCEL));
			close();
		}
		
		override public function show():void
		{
			alphaGound = false;
			TipManager.AddTippanel(this,false);
			alphaGound = true;
		}
		
		override public function close():void{
			super.close();
			this.dispose();
		}
		
		override public function dispose():void
		{
			if(_view)
			{
				_view.dispose();
				_view = null;
			}
			if(parent) parent.removeChild(this);
			if(hConfirmDialog)
			{
				hConfirmDialog.removeEventListener(KeyboardEvent.KEY_DOWN ,__escKeyDown);
				hConfirmDialog.dispose();
			}
			hConfirmDialog = null;
			super.dispose();
		}
		
		private function _fillClick():void{
			SoundManager.instance.play("008");
			navigateToURL(new URLRequest(PathManager.solveFillPage()),"_blank");
		}
	}
}