package ddt.store.view.shortcutBuy
{
	import flash.events.Event;
	
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HConfirmFrame;
	
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.utils.LeavePage;

	public class ShortcutBuyFrame extends HConfirmFrame
	{
		private var _view:ShortCutBuyView;
		private var _panelIndex:int;
		private var _showRadioBtn:Boolean;
		public function ShortcutBuyFrame(templateIDList:Array,showRadioBtn:Boolean,title:String,panelIndex:int)
		{
			super();
			this.titleText = title;
			_showRadioBtn = showRadioBtn;
			_panelIndex = panelIndex;
			_view = new ShortCutBuyView(templateIDList,showRadioBtn);
			init();
		}

		private function init():void
		{
			_view.addEventListener(Event.CHANGE,changeHandler);
			addContent(_view);
			if(!_showRadioBtn)
			{
				_view.x += 5;
			}
			
			setContentSize(_view.width+10,_view.height+60);
			okLabel = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
			showCancel = false;
			fireEvent = true;
			autoDispose = true;
			moveEnable = false;
			okFunction = okFun;
		}
		
		private function changeHandler(evt:Event):void
		{
			//okBtn.enable = (_view.totalGift != 0 || _view.totalMoney != 0);
		}
		
		private function okFun():void
		{
			if(_view.currentShopItem == null)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionSellView.Choose"));
				_view.List.shine();
				return;
			}
			if(_view.totalMoney > PlayerManager.Instance.Self.Money)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
				//您的点券不足，是否立即充值
				close();
			}else if(_view.totalGift > PlayerManager.Instance.Self.Gift)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.giftLack"));//礼金不足
			}else
			{
				buyGoods();
				_view.save();
				close();
			}
		}
		
		private function buyGoods():void
		{
			var items:Array = [];
		    var types:Array = [];
		    var colors:Array = [];
		    var dresses:Array = [];
		    var skins:Array = [];
		    var places : Array =[];
		    
		    var goodsID:int = _view.currentShopItem.GoodsID;
		    var num:int = _view.totalNum;
		    for(var i:int = 0;i < num;i++)
		    {
		    	items.push(goodsID);
		    	types.push(1);
		    	colors.push("");
		    	dresses.push(false);
		    	skins.push("");
		    	places.push(-1);
		    }
		    SocketManager.Instance.out.sendBuyGoods(items,types,colors,dresses,skins,places,_panelIndex);
		}
		
		override public function dispose():void
		{
			_view.removeEventListener(Event.CHANGE,changeHandler);
			_view.dispose();
			super.dispose();
		}
		
	}
}