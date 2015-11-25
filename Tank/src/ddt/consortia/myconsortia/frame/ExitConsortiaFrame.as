package ddt.consortia.myconsortia.frame
{
	import flash.events.Event;
	
	import road.ui.controls.hframe.HTipFrame;
	
	import ddt.consortia.ConsortiaModel;
	import tank.consortia.accect.ExitConsortiaAsset;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;

	public class ExitConsortiaFrame extends HTipFrame
	{
		private var _model:ConsortiaModel;
		
		public function ExitConsortiaFrame($model:ConsortiaModel)
		{
			_model = $model;
			super();
			init();
			addEvent();
		}
		private function init() : void
		{
			setContentSize(341,148);
			buttonGape = 20;
			okLabel = LanguageMgr.GetTranslation("ok");
			cancelLabel = LanguageMgr.GetTranslation("cancel");
			titleText = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.ExitConsortiaFrame.titleText");
			//titleText = "退出公会";
			tipTxt(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.ExitConsortiaFrame.quit"));
			//tipTxt("请在输入框中输入“Quit”以确认。");
            iconVisible = true;
            this.okBtnEnable = false;
			this.moveEnable = false;
           
            var mc : ExitConsortiaAsset = new ExitConsortiaAsset();
            
            tipIma = mc;
			layou();
		}
		public function addEvent() : void
		{
			super.maxChar = 14;
			okFunction = onOkClick;
			cancelFunction = __cancel;
			this.addEventListener(Event.CHANGE,  __upInputTextHandler);
			addEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
		}
		public function removeEvent() : void
		{
			 okFunction = null;
			 cancelFunction = null;
			this.removeEventListener(Event.CHANGE,  __upInputTextHandler);
			removeEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
		}
		private function __addToStageHandler(evt : Event) : void
		{
			okBtnEnable = false;
		}
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			if(this.parent)this.parent.removeChild(this);
		}
		private function __upInputTextHandler(evt : Event) : void
		{
			if(this.inputTxt.toLowerCase() == "quit")okBtnEnable = true;
			else this.okBtnEnable = false;
		}
		public function errorTip(msg : String) : void
		{
			tipTxt(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.ExitConsortiaFrame.quit"),msg);
			//tipTxt("请在输入框中输入“Quit”以确认。",msg);
			this.okBtnEnable = false;
		}
		
		
		private function onOkClick():void
		{
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			
			SocketManager.Instance.out.sendConsortiaOut(PlayerManager.Instance.Self.ID);
			if(this.parent)this.parent.removeChild(this);
		}
		
		private function __cancel():void
		{
			inputTxt = "";
			okBtnEnable = false;
			if(this.parent)this.parent.removeChild(this);
		}
		
		private function __onExitConsortia(e:CrazyTankSocketEvent):void
		{
			var id:int = e.pkg.readInt();
			var isSuccess:Boolean = e.pkg.readBoolean();
			var msg:String = e.pkg.readUTF();
			MessageTipManager.getInstance().show(msg);
		}
	}
}