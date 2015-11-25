package ddt.church.churchScene.frame
{
	import ddt.church.churchScene.SceneControler;
	
	import flash.events.FocusEvent;
	import flash.text.TextField;
	
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HConfirmFrame;
	
	import tank.church.PresentFrameAsset;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.utils.DisposeUtils; 
	
	public class PresentFrame extends HConfirmFrame
	{
		private var _bg:PresentFrameAsset;
		private var _controler:SceneControler;

		private var _moneyTF:TextField;
		
		public function PresentFrame(controler:SceneControler)
		{
			this._controler = controler;
			this.stopKeyEvent = true;
			this.buttonGape = 100;
			this.setContentSize(320,150);
			
			this.cancelFunction =__cancel;
			this.okFunction =__confirm ;
			
			init();
			addEvent();
		}
		
		private function init():void
		{
			moveEnable = false;
			_bg = new PresentFrameAsset();
			_moneyTF = _bg.money_txt;
			_moneyTF.maxChars = 8;
			_moneyTF.restrict = "0-9";
			
			addContent(_bg,true);
		}
		
		private function addEvent():void
		{
			_moneyTF.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,__focusOut);
		}
		private function removeEvent() : void
		{
			_moneyTF.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,__focusOut);
		}
		private function __focusOut(event:FocusEvent):void
		{
			checkMoney();
		}
		
		private function checkMoney():void
		{
			var total:uint = Math.floor(PlayerManager.Instance.Self.Money/100);
			var current:uint = Math.ceil(Number(_moneyTF.text)/100) == 0?1:Math.ceil(Number(_moneyTF.text)/100);
			
			if(current>=total)
			{
				current = total;
			}
			_moneyTF.text = String(current*100);
		}
		
		private function __confirm():void
		{			
			checkMoney();
			
			HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaTax.info"),LanguageMgr.GetTranslation("church.churchScene.frame.PresentFrame.confirm")+_moneyTF.text+LanguageMgr.GetTranslation("ddt.view.emailII.EmailIIDiamondView.money"),true,__ok);
		}
		
		private function __ok():void
		{
			SocketManager.Instance.out.sendChurchLargess(uint(_moneyTF.text));
			super.hide();
		}
		
		private function __cancel():void
		{
			super.hide();
		}
		override public function dispose():void
		{
			removeEvent();
			DisposeUtils.disposeDisplayObject(_bg);
			if(this.parent)this.parent.removeChild(this);
		}
	}
}