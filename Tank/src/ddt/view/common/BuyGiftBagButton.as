package ddt.view.common
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmDialog;
	
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.events.ShortcutBuyEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.utils.LeavePage;
	import ddt.view.bagII.GoodsTipPanel;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
		
	public class BuyGiftBagButton extends BuyItemButton
	{
		public function BuyGiftBagButton($bg:DisplayObject, itemID:int,$storeTab:int, needDispacthEvent:Boolean=false)
		{
			super($bg, itemID, $storeTab, needDispacthEvent);
		}
		
		override protected function initliziItemTemplate():void{
			_itemInfo = new ItemTemplateInfo();
			_itemInfo.Name = LanguageMgr.GetTranslation("ddt.view.common.BuyGiftBagButton.initliziItemTemplate.excellent");
			_itemInfo.Quality = 4;
			_itemInfo.TemplateID = 2;
			_itemInfo.CategoryID = 11;
			_itemInfo.Description = LanguageMgr.GetTranslation("ddt.view.common.BuyGiftBagButton.initliziItemTemplate.info");
			_tip = new GoodsTipPanel(_itemInfo);	
		}
		
		override protected function clickHandler(evt:MouseEvent):void{
			SoundManager.Instance.play("008");
			evt.stopImmediatePropagation();
			if(PlayerManager.Instance.Self.bagLocked){
				new BagLockedGetFrame().show();
				return;
			}
			if(PlayerManager.Instance.Self.Money < 4599){
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
				return;
			}
			HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.view.strength.buyGift"),true,doBuy,null);
		}
		
		private function doBuy():void{
//			var items:Array = [];
//		    var types:Array = [];
//		    var colors:Array = [];
//		    var dresses:Array = [];
//		    var skins:Array = [];
//		    var places : Array =[];
//			_shopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.STRENGTH_STONE4);
//			for(var i:int = 0 ;i < 3;i++){
//				items.push(_shopItemInfo.GoodsID);
//		    	types.push(1);
//		    	colors.push("");
//		    	dresses.push(false);
//		    	skins.push("");
//		    	places.push(-1);
//			}
//			_shopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.LUCKY);
//				items.push(_shopItemInfo.GoodsID);
//		    	types.push(1);
//		    	colors.push("");
//		    	dresses.push(false);
//		    	skins.push("");
//		    	places.push(-1);
//		    _shopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.SYMBLE);
//		    	items.push(_shopItemInfo.GoodsID);
//		    	types.push(1);
//		    	colors.push("");
//		    	dresses.push(false);
//		    	skins.push("");
//		    	places.push(-1);
//		    SocketManager.Instance.out.sendBuyGoods(items,types,colors,places,dresses,skins);
			SocketManager.Instance.out.sendBuyGiftBag(1);
		    dispatchEvent(new ShortcutBuyEvent(2,5));
		}		
		
	}
}