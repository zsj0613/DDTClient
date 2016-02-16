package ddt.consortia.consortiashop
{
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	import game.crazyTank.view.AuctionHouse.CellBgAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.utils.ComponentHelper;
	import road.utils.TextFieldUtils;
	
	import tank.consortia.accect.ConsortiaShopItemAsset;
	import ddt.data.EquipType;
	import ddt.data.goods.ShopItemInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.utils.LeavePage;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.cells.BaseCell;
	import ddt.view.common.FastPurchaseGoldBox;

	public class ConsortiaShopItem extends ConsortiaShopItemAsset
	{
		private var _shopBtn7   : HBaseButton;
		private var _shopBtn15  : HBaseButton;
		private var _shopBtn30  : HBaseButton;
		private var _info       : ShopItemInfo;
		private var _enable     : Boolean;
		private var _cell       : BaseCell;
		private var myElements_array     : Array = [0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0];
		private var myColorMatrix_filter : ColorMatrixFilter;
		public function ConsortiaShopItem($enable : Boolean)
		{
			super();
			_enable = $enable;
			init();
			addEvent();
		}
		private function init() : void
		{
			_shopBtn7 = new HBaseButton(shop7_mc);
			_shopBtn7.useBackgoundPos = true;
			addChildAt(_shopBtn7,2);
			
			_shopBtn15 = new HBaseButton(shop15_mc);
			_shopBtn15.useBackgoundPos = true;
			addChildAt(_shopBtn15,2);
			
			_shopBtn30 = new HBaseButton(shop30_mc);
			_shopBtn30.useBackgoundPos = true;
			addChildAt(_shopBtn30,2);
			
			myColorMatrix_filter = new ColorMatrixFilter(myElements_array);
//			_shopBtn7.enable = _shopBtn15.enable = _shopBtn30.enable = false;
			setFilters = _enable;
			itemBg = _enable;
			
			TextFieldUtils.enabledTextField(moneyTxt1);
			TextFieldUtils.enabledTextField(moneyTxt2);
			TextFieldUtils.enabledTextField(moneyTxt3);
			TextFieldUtils.enabledTextField(nameTxt);
			TextFieldUtils.enabledTextField(dateTxt1);
			TextFieldUtils.enabledTextField(dateTxt2);
			TextFieldUtils.enabledTextField(dateTxt3);
		}
		
		private function addEvent() : void
		{
			_shopBtn7.addEventListener(MouseEvent.CLICK,     __consortiaShopHandler);
			_shopBtn15.addEventListener(MouseEvent.CLICK,    __consortiaShopHandler);
			_shopBtn30.addEventListener(MouseEvent.CLICK,    __consortiaShopHandler);
		}
		/**set 数据**/
		public function set info($info : ShopItemInfo) : void
		{
			if(_info == $info || !$info)return;
			_info = $info;
			upView();
		}
		/**更新显示**/
		private function upView() : void
		{
			addEvent();
			_cell = new BaseCell(new CellBgAsset());
			ComponentHelper.replaceChild(this,goodPos_mc,_cell);
			ShopItemAsset.addChild(_cell);
			_cell.info = _info.TemplateInfo;
			
			_shopBtn7.visible = moneyTxt1.visible = dateTxt1.visible = _info.getItemPrice(1).IsValid;
			_shopBtn15.visible = moneyTxt2.visible = dateTxt2.visible = _info.getItemPrice(2).IsValid;
			_shopBtn30.visible = moneyTxt3.visible = dateTxt3.visible = _info.getItemPrice(3).IsValid;
			
			nameTxt.text = _info.TemplateInfo.Name;

			moneyTxt1.text = _info.getItemPrice(1).toString();
			moneyTxt2.text = _info.getItemPrice(2).toString();
			moneyTxt3.text = _info.getItemPrice(3).toString();
			
			dateTxt1.text = _info.getTimeToString(1);
			dateTxt2.text = _info.getTimeToString(2);
			dateTxt3.text = _info.getTimeToString(3);
		}
		
		private var time : int = 0;
		private function __consortiaShopHandler(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			switch(evt.target.name)
			{
				case "shop7_mc":
				time = 1;
				break;
				case "shop15_mc":
				time = 2;
				break;
				case "shop30_mc":
				time = 3;
				break;
			}
			if(checkMoney())
			{
//				sendConsortiaShop();
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.common.AddPricePanel.pay"),true,sendConsortiaShop,cannel);
			}
			
			//HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),"确认支付?",true,sendConsortiaShop,cannel);
			
		}
		private function sendConsortiaShop() : void
		{
			SoundManager.Instance.play("008");
			var items:Array = [_info.GoodsID];
			var types:Array = [time];
			var colors:Array = [""];
			var dresses:Array = [false];
			var skins:Array = [""];
			var places : Array = [-1];
		    SocketManager.Instance.out.sendBuyGoods(items,types,colors,places,dresses,skins);
		}
		private function cannel() : void
		{
			SoundManager.Instance.play("008");
		}
		/**检查财富是否足够**/
		private function checkMoney() : Boolean
		{
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return false;
			}
			if(!_enable)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.consortiashop.ConsortiaShopItem.checkMoney"));
				//MessageTipManager.getInstance().show("公会商城等级不够");
				return false;
			}
			if(PlayerManager.Instance.Self.Gold < _info.getItemPrice(time).goldValue)
			{
				new FastPurchaseGoldBox(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("ddt.view.GoldInadequate"),EquipType.GOLD_BOX).show();
//				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIBtnPanel.gold"));
				//MessageTipManager.getInstance().show("金币不足");
				return false;
			}
			if(PlayerManager.Instance.Self.Money < _info.getItemPrice(time).moneyValue)
			{
//				MessageTipManager.getInstance().show("点券不足");
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortia.consortiashop.ConsortiaShopItem.Money"),true,LeavePage.leaveToFill,cannel);
				//HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),"您的点券不足,是否立即充值?",true,fillClick,cannel);
				return false;
			}
			if(PlayerManager.Instance.Self.Offer < _info.getItemPrice(time).gesteValue)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ConsortiaShopItem.gongXunbuzu"));
				//MessageTipManager.getInstance().show("功勋不足");
				return false;
			}
			return true;
		}
		
		private var _shopId : int;
		public function set shopId(id : int): void
		{
			_shopId = id;
		} 
		public function set setFilters(b : Boolean) : void
		{
//			b ? filters = null : filters = [myColorMatrix_filter];
			b ? ShopItemAsset.filters = null : ShopItemAsset.filters = [myColorMatrix_filter];
			
		}
        
        /**设置背景**/
		private function set itemBg(b : Boolean) : void
		{
//			this.ShopItemAsset.visible = b;
			this.ShopItemIIAsset.visible = false;
		}
        
        /**是否显示按钮**/
		public function set btnVisible(b : Boolean) : void
		{
			_shopBtn7.visible = _shopBtn15.visible = _shopBtn30.visible = b;
		}
		private function removeEvent() : void
		{
			_shopBtn7.removeEventListener(MouseEvent.CLICK,     __consortiaShopHandler);
			_shopBtn15.removeEventListener(MouseEvent.CLICK,    __consortiaShopHandler);
			_shopBtn30.removeEventListener(MouseEvent.CLICK,    __consortiaShopHandler);
		}
		public function dispose() : void
		{
			removeEvent();
			filters = null;
			if(_shopBtn7)
			{
				if(_shopBtn7.parent)_shopBtn7.parent.removeChild(_shopBtn7);
				_shopBtn7.dispose();
			}
			_shopBtn7 = null;
			if(_shopBtn15)
			{
				if(_shopBtn15.parent)_shopBtn15.parent.removeChild(_shopBtn15);
				_shopBtn15.dispose();
			}
			_shopBtn15 = null;
			if(_shopBtn30)
			{
				if(_shopBtn30.parent)_shopBtn30.parent.removeChild(_shopBtn30);
				_shopBtn30.dispose();
			}
			_shopBtn30 = null;
			_info =  null;
			myElements_array = null;
			myColorMatrix_filter = null;
			if(parent)parent.removeChild(this);
			
		}
		
	}
}