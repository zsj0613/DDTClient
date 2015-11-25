package ddt.game
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmDialog;
	
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.socket.GameInSocketOut;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	
	public class PropShortCutView extends ShortcutAsset
	{
		public function PropShortCutView()
		{
			addEvent();
			setPropCloseVisible(0,false);
			setPropCloseVisible(1,false);
			setPropCloseVisible(2,false);
		}
		
		public function setPropCloseVisible(index:uint,b:Boolean):void
		{
			this["close" + index.toString() + "_btn"].alpha = b ? 1 : 0;
		}
		
		public function setPropCloseEnabled(index:uint,b:Boolean):void
		{
			this["close" + index.toString() + "_btn"].mouseEnabled = b;
		}
		
		private function addEvent():void
		{
			close0_btn.addEventListener(MouseEvent.CLICK,__throw);
			close1_btn.addEventListener(MouseEvent.CLICK,__throw);
			close2_btn.addEventListener(MouseEvent.CLICK,__throw);
			close0_btn.addEventListener(MouseEvent.MOUSE_OVER,__over);
			close1_btn.addEventListener(MouseEvent.MOUSE_OVER,__over);
			close2_btn.addEventListener(MouseEvent.MOUSE_OVER,__over);
			close0_btn.addEventListener(MouseEvent.MOUSE_OUT,__out);
			close1_btn.addEventListener(MouseEvent.MOUSE_OUT,__out);
			close2_btn.addEventListener(MouseEvent.MOUSE_OUT,__out);
		}
		
		private function removeEvent():void
		{
			close0_btn.removeEventListener(MouseEvent.CLICK,__throw);
			close1_btn.removeEventListener(MouseEvent.CLICK,__throw);
			close2_btn.removeEventListener(MouseEvent.CLICK,__throw);
			close0_btn.removeEventListener(MouseEvent.MOUSE_OVER,__over);
			close1_btn.removeEventListener(MouseEvent.MOUSE_OVER,__over);
			close2_btn.removeEventListener(MouseEvent.MOUSE_OVER,__over);
			close0_btn.removeEventListener(MouseEvent.MOUSE_OUT,__out);
			close1_btn.removeEventListener(MouseEvent.MOUSE_OUT,__out);
			close2_btn.removeEventListener(MouseEvent.MOUSE_OUT,__out);
		}
		
		private var _index:int;
		private function __throw(event:MouseEvent):void
		{
			if((event.target as SimpleButton).alpha == 0)return;
			_index = int((event.target as SimpleButton).name.slice(5,6));
			SoundManager.instance.play("008");
			deleteProp();
//			HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.game.PropShortCutView.prop"),true,deleteProp,null);
			
			
			//ConfirmDialog.show("提示","是否要删除该道具?",true,deleteProp);
		}
		
		
		
		private function deleteProp():void
		{
			GameInSocketOut.sendThrowProp(_index);
			SoundManager.instance.play("008");
			stage.focus = null;
		}
		
		private function __over(event:MouseEvent):void
		{
			(event.target as SimpleButton).alpha = 1;
		}
		
		private function __out(event:MouseEvent):void
		{
			(event.target as SimpleButton).alpha = 0;
		}
		
		public function dispose ():void
		{
			removeEvent();
		}
	}
}