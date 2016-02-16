package ddt.store.view.shortcutBuy
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.ToggleButtonGroup;
	import road.ui.controls.HButton.TogleButton;
	import road.ui.controls.HButton.togleButtonAsset;
	
	import ddt.data.ItemPrice;
	import ddt.data.goods.ShopItemInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.SharedManager;
	import ddt.manager.ShopManager;
	import ddt.view.common.NumberSelecter;
	
	import webgame.crazytank.game.view.task.BgAsset;
	import store.view.shortcutBuy.ShortcutBuyViewAsset;
	
	/**
	 * @author wickila
	 * @time 0401/2010
	 * @description 快速购买物品的面板，可以通过设置一个array来设置这个面板的商品列表
	 * */
	
	public class ShortCutBuyView extends ShortcutBuyViewAsset
	{
		private var _templateItemIDList:Array;
		private var _dianquanRadioBtn:TogleButton;
		private var _liquanRadioBtn:TogleButton;
		private var _btnGroup:ToggleButtonGroup;
		private var _list:ShortcutBuyList;
		private var _num:NumberSelecter;
		private var priceStr:String;
		
		private var _showRadioBtn:Boolean = true;
		
		private var _memoryItemID:int;
		private var _firstShow:Boolean = true;
		
		public function ShortCutBuyView(templateItemIDList:Array,showRadioBtn:Boolean)
		{
			super();
			_templateItemIDList = templateItemIDList;
			_showRadioBtn = showRadioBtn;
			payBgAsset.visible = showRadioBtn;
			init();
			initEvents();
		}
		
		private function init():void
		{
			_btnGroup = new ToggleButtonGroup();
			_dianquanRadioBtn = new TogleButton(new togleButtonAsset(),LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionBrowseView.stipple"));
			addChild(_dianquanRadioBtn);
			_dianquanRadioBtn.x = payBgAsset.dianquanPos.x;
			_dianquanRadioBtn.y = payBgAsset.dianquanPos.y;
			payBgAsset.removeChild(payBgAsset.dianquanPos);
			_dianquanRadioBtn.textGape = 21;
			_dianquanRadioBtn.addIcon(payBgAsset.dianquanAsset,25,3);
			_btnGroup.addItem(_dianquanRadioBtn);
			_dianquanRadioBtn.selected = true;
			_liquanRadioBtn = new TogleButton(new togleButtonAsset(),LanguageMgr.GetTranslation("ddt.gameover.takecard.gifttoken"));
			addChild(_liquanRadioBtn);
			_liquanRadioBtn.x = payBgAsset.liquanPos.x;
			_liquanRadioBtn.y = payBgAsset.liquanPos.y;
			payBgAsset.removeChild(payBgAsset.liquanPos);
			_liquanRadioBtn.textGape = 21;
			_liquanRadioBtn.addIcon(payBgAsset.liquanAsset,25,3);
			_btnGroup.addItem(_liquanRadioBtn);
			
			
			_dianquanRadioBtn.enableTextFormat = new TextFormat(LanguageMgr.GetTranslation("heiti"),15,0xf95f1b,true);
			_liquanRadioBtn.enableTextFormat = new TextFormat(LanguageMgr.GetTranslation("heiti"),15,0x0393dd,true);;
			_dianquanRadioBtn.unableTextFormat = _liquanRadioBtn.unableTextFormat = new TextFormat(LanguageMgr.GetTranslation("heiti"),18,0x515151,true);
			
			
			var filter:Array = [new GlowFilter(0xc0c1c3,1,5,5,100)];
			_dianquanRadioBtn.unableFilter = _liquanRadioBtn.unableFilter = filter;
			_dianquanRadioBtn.enable = _liquanRadioBtn.enable = true;

			_dianquanRadioBtn.visible = _liquanRadioBtn.visible = payBgAsset.typeMc.visible = _showRadioBtn;
			
			_list = new ShortcutBuyList(_templateItemIDList);
			_memoryItemID = SharedManager.Instance.StoreBuyInfo[PlayerManager.Instance.Self.ID.toString()];
			var item:ShopItemInfo = ShopManager.Instance.getShopItemByGoodsID(_memoryItemID);
			if(item && _templateItemIDList.indexOf(item.TemplateID)>-1)
			{
				_list.selectedItemID = item.TemplateID;
			}else
			{
				//_list.selectedItemID = _templateItemIDList[0];
			}
			if(item && item.getItemPrice(1).IsGiftType && _templateItemIDList.indexOf(item.TemplateID)>-1)
			{
				_liquanRadioBtn.selected = true;
			} 
			if(!_showRadioBtn)
			{
				_list.y = listPos.y - 35;
			}else{
				_list.x = listPos.x + 5;
				_list.y = listPos.y + 15;
			}
			removeChild(listPos);
			addChild(_list);
			
			_num = new NumberSelecter(1,99);
			_num.x = numPos.x + 10;
			removeChild(numPos);
			_num.y = _list.y + _list.height + 10;
			addChild(_num);
			totalText.y = _num.y + _num.height + 10;
			msg.y = totalText.y+2;
			updateCost();
		}
		
		private function initEvents():void
		{
			_list.addEventListener(Event.SELECT,selectHandler);
			_dianquanRadioBtn.addEventListener(Event.SELECT,selectHandler);
			_dianquanRadioBtn.addEventListener(MouseEvent.CLICK,clickHandlerDian);
			_liquanRadioBtn.addEventListener(Event.SELECT,selectHandler);
			_liquanRadioBtn.addEventListener(MouseEvent.CLICK,clickHandlerLi);
			_num.addEventListener(Event.CHANGE,selectHandler);
		}
		
		private function removeEvents():void
		{
			_list.removeEventListener(Event.SELECT,selectHandler);
			_dianquanRadioBtn.removeEventListener(Event.SELECT,selectHandler);
			_dianquanRadioBtn.removeEventListener(MouseEvent.CLICK,clickHandlerDian);
			_liquanRadioBtn.removeEventListener(Event.SELECT,selectHandler);
			_liquanRadioBtn.removeEventListener(MouseEvent.CLICK,clickHandlerLi);
			_num.removeEventListener(Event.CHANGE,selectHandler);
		}
		
		
		private function clickHandlerDian(e:MouseEvent):void {
			SoundManager.Instance.play("008");
			priceStr = "0" + LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionBrowseView.stipple");
			_firstShow = false;
			updateCost();
		}
		
		private function clickHandlerLi(e:MouseEvent):void {
			SoundManager.Instance.play("008");
			priceStr = "0" + LanguageMgr.GetTranslation("ddt.gameover.takecard.gifttoken");
			_firstShow = false;
			updateCost();
		}
		
		private function selectHandler(evt:Event):void
		{
			evt.stopImmediatePropagation();
			updateCost();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function updateCost():void
		{
			if(_firstShow)
				priceStr = "0" + LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionBrowseView.stipple");
			if(currentShopItem != null)
			{
				priceStr = totalPrice.toString();
			}
			totalText.text = priceStr;
		}
		
		public function get List():ShortcutBuyList {
			return _list;
		}
		
		public function get currentShopItem():ShopItemInfo
		{
			var resultShopItem:ShopItemInfo;
			if(_dianquanRadioBtn.selected)
			{
				resultShopItem = ShopManager.Instance.getMoneyShopItemByTemplateID(_list.selectedItemID);
			}else
			{
				resultShopItem = ShopManager.Instance.getShopItemByTemplateIDAndShopID(_list.selectedItemID,ShopManager.GIFT_SHOP);
			}
			return resultShopItem;
		}
		
		public function get currentNum():int
		{
			return _num.number;
		}
		
		public function get totalPrice():ItemPrice
		{
			var price:ItemPrice = new ItemPrice(null,null,null);
			if(currentShopItem)
			{
				price = currentShopItem.getItemPrice(1).multiply(_num.number);
			}
			return price;
		}
		
		public function get totalMoney():int
		{
			return totalPrice.moneyValue;
		}
		
		public function get totalGift():int
		{
			return totalPrice.giftValue;
		}
		
		public function get totalNum():int
		{
			return _num.number;
		}
		
		public function save():void
		{
			SharedManager.Instance.StoreBuyInfo[PlayerManager.Instance.Self.ID] = currentShopItem.GoodsID;
			SharedManager.Instance.save();
		}
		
		public function dispose():void
		{
			removeEvents();
			_dianquanRadioBtn.dispose();
			_liquanRadioBtn.dispose();
			_btnGroup.dispose();
			_list.dispose();
			_num.dispose();
			
			_templateItemIDList = null;
			_liquanRadioBtn = null;
			_btnGroup = null
			_list = null
			_num = null;
			
			if(parent) parent.removeChild(this);
		}
		
	}
}