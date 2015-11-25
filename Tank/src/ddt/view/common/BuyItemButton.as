package ddt.view.common
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.manager.TipManager;
	
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.goods.ShopItemInfo;
	import ddt.events.ShortcutBuyEvent;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ShopManager;
	import ddt.utils.LeavePage;
	import ddt.view.bagII.GoodsTipPanel;
	import ddt.view.bagII.bagStore.BagStore;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	/**
	 * @author WickiLA
	 * @time 12/23/2009
	 * @description 购买物品的按钮的父类。比如铁匠铺中的快速购买按钮
	 * */
	
	public class BuyItemButton extends HBaseButton
	{
		protected var _itemID:int;
		protected var _itemInfo:ItemTemplateInfo;
		protected var _tip:GoodsTipPanel;
		protected var _shopItemInfo:ShopItemInfo;
		private var _needDispatchEvent:Boolean;
		private var _quick:QuickBuyFrame;
		private var _storeTab:int;//1：强化，2合成，3：熔炼 4：镶嵌
		
		public function BuyItemButton($bg:DisplayObject,itemID:int,storeTab:int,needDispacthEvent:Boolean = false)
		{
			_itemID = itemID;
			_storeTab = storeTab;
			_needDispatchEvent = needDispacthEvent;
			super($bg);
		}
		
		override protected function init():void
		{
			super.init();
			initliziItemTemplate();
		}
		
		protected function initliziItemTemplate():void{
			_itemInfo = ItemManager.Instance.getTemplateById(_itemID);
			_shopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(_itemID);
			_tip = new GoodsTipPanel(_itemInfo);	
		}
		
		override protected function overHandler(evt:MouseEvent):void
		{
			super.overHandler(null);
			TipManager.setCurrentTarget(this,_tip);
		}
		
		override protected function outHandler(evt:MouseEvent):void
		{
			super.outHandler(null);
			TipManager.setCurrentTarget(null,null);
		}
		
		override protected function clickHandler(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			SoundManager.instance.play("008");
			super.clickHandler(null);
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			if(PlayerManager.Instance.Self.Money<_shopItemInfo.getItemPrice(1).moneyValue)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
			}else{
		    	_quick = new QuickBuyFrame(LanguageMgr.GetTranslation("ddt.view.store.matte.goldQuickBuy"),"");
		    	_quick.itemID = _itemID;
				_quick.x = 350;
				_quick.y = 200;
				_quick.storeTab = _storeTab;
				_quick.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY,__shortCutBuyHandler);
				_quick.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
			    TipManager.AddTippanel(_quick,false);
			}
		}
		
//		private function addToStageHandler():void{
//			
//		}
//		
//		private function keyDownHandler(event:KeyEvent):void{
//			if(event.keyCode == Keyboard.ESCAPE){
//				_quick.close();
//				_quick.dispose();
//			}
//		}
		
		private function removeFromStageHandler(event:Event):void{
			BagStore.Instance.reduceTipPanelNumber();
		}
		
		private function __shortCutBuyHandler(evt:ShortcutBuyEvent):void
		{
			evt.stopImmediatePropagation();
			if(_needDispatchEvent)  dispatchEvent(new ShortcutBuyEvent(evt.ItemID,evt.ItemNum));
		}
		
		override public function dispose():void
		{
			if(_quick)
			{
				_quick.removeEventListener(ShortcutBuyEvent.SHORTCUT_BUY,__shortCutBuyHandler);
				_quick.removeEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
			}
			_tip.dispose();
			_itemInfo = null;
			_shopItemInfo = null;
			super.dispose();
		}
		
	}
}