package ddt.view.common
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import road.ui.controls.hframe.HConfirmFrame;
	
	import ddt.manager.SocketManager;
	import com.trainer.asset.UserGuideIIAsset;
	import ddt.manager.UserGuideManager;
	

	public class UserGuideIIEnterAlarm extends HConfirmFrame
	{
		private var bg:UserGuideIIAsset;
		override public function UserGuideIIEnterAlarm()
		{
			bg = new UserGuideIIAsset();
			bg.x = 8;
			bg.y = 6;
			this.addChild(bg);
			this.moveEnable = false;
			this.fireEvent = false;
			this.showBottom = false;
			this.showClose = false;
			this.autoDispose = true;
			this.showCancel = false
			this.setContentSize(334,128);
			
			this.okFunction =__confirm ;
			this.addEventListener(Event.ADDED_TO_STAGE,userGuide);
			this.addChild(okBtn);
			okBtn.x = 150;
			okBtn.y = 140;
			SocketManager.Instance.out.TrainerAnswer(13);
		}
		private function userGuide(e:Event):void{
			
		}
		override protected function __onKeyDownd(e:KeyboardEvent):void{
			
		} 
		private function __confirm():void{
			SocketManager.Instance.out.createUserGuide();
			//SocketManager.Instance.out.userGuideStart();
			UserGuideManager.Instance.showMainline();
			super.close();
		}
		
	}
}