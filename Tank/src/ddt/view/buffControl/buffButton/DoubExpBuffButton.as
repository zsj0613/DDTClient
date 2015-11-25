package ddt.view.buffControl.buffButton
{
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.GoodsTipBgAsset;
	import game.crazyTank.view.common.double_expAsset;
	
	import road.ui.controls.hframe.HConfirmDialog;
	
	import ddt.data.BuffInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.ShopManager;
	import ddt.utils.LeavePage;

	public class DoubExpBuffButton extends BuffButton
	{
		public function DoubExpBuffButton()
		{
			super(new double_expAsset());
			info = new BuffInfo(BuffInfo.DOUBEL_EXP);
		}
		
		override protected function clickHandler(evt:MouseEvent):void
		{
			super.clickHandler(evt);
			if(!CanClick) return;
			if(PlayerManager.Instance.Self.Money>=ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue)
		    {
		    	if(!checkBagLocked())return;
		    	if(!(_info&&_info.IsExist))
		    	{
		    		HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaTax.info"),LanguageMgr.GetTranslation("ddt.view.buff.doubleExp",ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue),true,buyBuff);
		    	}else
		    	{
		    		HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaTax.info"),LanguageMgr.GetTranslation("ddt.view.buff.addPrice",ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue),true,buyBuff);
		    	}
		    }else
		    {
		    	HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
		    }
		}
		
	}
}