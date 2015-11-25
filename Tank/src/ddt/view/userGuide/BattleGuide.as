package ddt.view.userGuide
{
	import flash.events.MouseEvent;
	
	import ddt.manager.SharedManager;
	
	import userGuide.accect.BattleTip;
	public class BattleGuide extends BattleTip
	{
		
		public function BattleGuide()
		{
			showBtn.addEventListener(MouseEvent.CLICK,__show);
			hideBtn.addEventListener(MouseEvent.CLICK,__hide);
			if(SharedManager.Instance.ShowBattleGuide){
				hideBtn.visible = true;
				showBtn.visible = false;
			}else
			{
				wordMC.visible = false;
				back.visible = false;
				hideBtn.visible = false;
				showBtn.visible = true;
			}
		}
		
		
		
		private function __hide(e:MouseEvent):void
		{
			SharedManager.Instance.ShowBattleGuide = false;
			SharedManager.Instance.save();
			wordMC.visible = back.visible = false;
			showBtn.visible = true;
			hideBtn.visible = false;
		}
		
		
		private function __show(e:MouseEvent):void
		{
			SharedManager.Instance.ShowBattleGuide = true;
			SharedManager.Instance.save();
			wordMC.visible = back.visible = true;
			hideBtn.visible = true;
			showBtn.visible = false;
		}

	}
}