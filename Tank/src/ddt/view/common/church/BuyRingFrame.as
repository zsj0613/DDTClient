package ddt.view.common.church
{
	import flash.events.KeyboardEvent;
	
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HConfirmFrame;
	
	import tank.church.BugRingAsset;
	import ddt.data.goods.ShopItemInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.ShopManager;
	import ddt.manager.SocketManager;
	import ddt.utils.LeavePage;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	
	/**
	 * 购买婚礼戒指 
	 * @author Administrator
	 * 
	 */	
	public class BuyRingFrame extends HConfirmFrame
	{
		private var _bg:BugRingAsset;
		private var _ringInfo: ShopItemInfo;
		
		private var spouseID:int;
		private var proposeStr:String;
		private var useBugle:Boolean;
		
		public function BuyRingFrame(spouseID:int,proposeStr:String,useBugle:Boolean)
		{
			this.spouseID = spouseID;
			this.proposeStr = proposeStr;
			this.useBugle = useBugle;
			
			showBottom = true;
			showClose = true;
			buttonGape = 100;
			moveEnable = false;
			
			cancelFunction =__cancel; 
			okFunction =__confirm ;
			
			setContentSize(325,110);
			
			init();
		}

		private function init():void
		{
			_bg = new BugRingAsset();
			
//			_ringInfo = ItemManager.Instance.getTemplateById(11103);
			_ringInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(11103);
			addContent(_bg,true);
		}
		
		private function __confirm():void
		{
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			
			if(_ringInfo && PlayerManager.Instance.Self.Money < _ringInfo.getItemPrice(1).moneyValue)
			{
//				MessageTipManager.getInstance().show("您的点劵不足"+_ringInfo.Price1+",无法购买求婚戒指");
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
			}else
			{
				SocketManager.Instance.out.sendPropose(spouseID,proposeStr,useBugle);
				
//				var items:Array = [_ringInfo.TemplateID];
//				var types:Array = [1];
//				var colors:Array = [""];
//				var dresses:Array = [false];
//				var shopID:int = 1;
//				var skins:Array = [""];
//			    var places: Array = [-1];
//				
//				SocketManager.Instance.out.sendBuyGoods(items,types,colors,places,dresses,shopID,skins);
			}
			
			super.hide();
		}
		
		override protected function __onKeyDownd(e:KeyboardEvent):void
		{
			e.stopImmediatePropagation();
			super.__onKeyDownd(e);
		}
		
		private function __cancel():void
		{
			super.hide();
		}
	}
}