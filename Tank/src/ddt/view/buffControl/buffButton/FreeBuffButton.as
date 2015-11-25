package ddt.view.buffControl.buffButton
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.GoodsTipBgAsset;
	import game.crazyTank.view.common.free_propAsset;
	import game.crazyTank.view.common.hasBuffTipAsset;
	
	import road.utils.ComponentHelper;
	
	import ddt.data.BuffInfo;
	import ddt.manager.LanguageMgr;

	public class FreeBuffButton extends BuffButton
	{
		public function FreeBuffButton()
		{
			super(new free_propAsset());
			info = new BuffInfo(BuffInfo.FREE);
		}
		
		override protected function init():void
		{
			super.init();
			_format.setEnable(this);;
		}
		
		override protected function clickHandler(evt:MouseEvent):void
		{
//			super.clickHandler(evt);
//			if(!CanClick) return;
//			if(PlayerManager.Instance.Self.Money>=ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue)
//		    {
//		    	if(!checkBagLocked())return;
//		    	if(!(_info&&_info.IsExist))
//		    	{
//		    		HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaTax.info"),LanguageMgr.GetTranslation("ddt.view.buff.freeCard",ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue),true,buyBuff);
//		    	}else
//		    	{
//		    		HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaTax.info"),LanguageMgr.GetTranslation("ddt.view.buff.addPrice",ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue),true,buyBuff);
//		    	}
//		    }else
//		    {
//		    	HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
//		    }
//		    evt.updateAfterEvent();
		}
		
		override public function set info(value:BuffInfo):void
		{
			_format.setEnable(this);
		}
		
		override protected function createTipRender():Sprite
		{
			var hasBuffTip:hasBuffTipAsset = new hasBuffTipAsset();
			hasBuffTip.name_tex.text = LanguageMgr.GetTranslation("ddt.view.buffControl.buffButton.freeCard");
	    	hasBuffTip.day_txt.text  = LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.forever");
	    	hasBuffTip.removeChild(hasBuffTip.day);
	    	hasBuffTip.removeChild(hasBuffTip.hour);
	    	hasBuffTip.removeChild(hasBuffTip.minite);
	    	hasBuffTip.removeChild(hasBuffTip.hour_txt);
	    	hasBuffTip.removeChild(hasBuffTip.min_txt);
	    	hasBuffTip.bg.width = 150;
	    	hasBuffTip.day_txt.x += 22;
			ComponentHelper.replaceChild(hasBuffTip,hasBuffTip.bg,new GoodsTipBgAsset());
	    	return hasBuffTip;
		}
	}
}