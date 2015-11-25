package ddt.view.buffControl.buffButton
{
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.common.prevent_kickAsset;
	
	import road.ui.controls.hframe.HConfirmDialog;
	
	import ddt.data.BuffInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.ShopManager;
	import ddt.utils.LeavePage;

	public class PreventKickBuffButton extends BuffButton
	{
		public function PreventKickBuffButton()
		{
			super(new prevent_kickAsset());
			info = new BuffInfo(BuffInfo.PREVENT_KICK);
		}
		
		override protected function clickHandler(evt:MouseEvent):void
		{
			super.clickHandler(evt);
			if(PlayerManager.Instance.Self.Money>=ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue)
		    {
		    	if(!checkBagLocked())return;
		    	if(!(_info&&_info.IsExist))
		    	{
		    		HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaTax.info"),LanguageMgr.GetTranslation("ddt.view.buff.preventKick",ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue),true,buyBuff);
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