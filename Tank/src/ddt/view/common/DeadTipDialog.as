package ddt.view.common
{
	import game.crazyTank.view.common.DeadTipAsset;
	
	import road.ui.controls.hframe.HConfirmFrame;
	
	import ddt.manager.LanguageMgr;
	
	public class DeadTipDialog extends HConfirmFrame
	{
		private var bg:DeadTipAsset;
		override public function DeadTipDialog()
		{
			bg = new DeadTipAsset();
			bg.x = 4;
			bg.y = 6;
			this.addChild(bg);
			this.moveEnable = false;
			this.fireEvent = false;
			this.showBottom = false;
			this.showClose = true;
			this.autoDispose = true;
			this.showCancel = false
			this.setContentSize(535,180);
			
			this.titleText = LanguageMgr.GetTranslation("ddt.view.common.DeadTipDialog.title");
//			this.titleText = "灵魂参与战斗";
			this.okBtn.label = LanguageMgr.GetTranslation("ddt.view.common.DeadTipDialog.btn");
//			this.okBtn.label = "我知道了";
			this.okFunction =__confirm ;
			this.addChild(okBtn);
			okBtn.x = 240;
			okBtn.y = 190;
			
		}
		private function __confirm():void{
			super.close();
		}
		
	}
}