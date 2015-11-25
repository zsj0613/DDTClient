package ddt.consortia.myconsortia.frame
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import road.ui.controls.hframe.HTipFrame;
	
	import tank.consortia.accect.DisbandConsortiaAsset;
	import ddt.manager.LanguageMgr;
	import ddt.manager.SocketManager;

	public class DisbandConsortiaFrame extends HTipFrame
	{
		public function DisbandConsortiaFrame()
		{
			super();
			init();
			addEvent();
		}
		private function init() : void
		{
			setContentSize(411,148);
			buttonGape = 20;
			titleText = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.DisbandConsortiaFrame.titleText");
			//titleText = "解散公会";
			var mc : DisbandConsortiaAsset = new DisbandConsortiaAsset();
			tipTxt(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.DisbandConsortiaFrame.sure"));
			//tipTxt("请在输入框中输入“Disband”以确认。");
			this.moveEnable = false;
			
			okLabel = LanguageMgr.GetTranslation("ok");
			cancelLabel = LanguageMgr.GetTranslation("cancel");
            iconVisible = true;
            this.okBtnEnable = false;
           
           
            tipIma = mc;
			layou();
		}
		public function addEvent() : void
		{
			super.maxChar = 8;
			this.okFunction = __okClick;
			this.cancelFunction = __cancel;
			this.addEventListener(Event.CHANGE,  __inputTextHandler);
			this.addEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			this.addEventListener(Event.ADDED_TO_STAGE,  __addToStageHandler);
		}
		public function removeEvent() : void
		{
			this.okFunction = null;
			this.cancelFunction = null;
			this.removeEventListener(Event.CHANGE,  __inputTextHandler);
			this.removeEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			this.removeEventListener(Event.ADDED_TO_STAGE,  __addToStageHandler);
		}
		private function __addToStageHandler(evt : Event) : void
		{
			this.okBtnEnable = false;
		}
		private function __inputTextHandler(evt : Event) : void
		{
			if(this.inputTxt.toLowerCase() == "disband") this.okBtnEnable = true;
			else this.okBtnEnable = false;
		}
		private function __keyDown(e:KeyboardEvent):void
		{
			if(okBtnEnable)
			{
				if(e.keyCode == Keyboard.ENTER)
			    {
		    		__okClick();
		    	}
			}
			
		}
		private function __okClick():void
		{
			SocketManager.Instance.out.sendConsortiaDismiss();
		}
		private function __cancel():void
		{
			inputTxt = "";
			okBtnEnable = false;
			if(this.parent)this.parent.removeChild(this);
		}
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			if(this.parent)this.parent.removeChild(this);
			
		}
		
	}
}