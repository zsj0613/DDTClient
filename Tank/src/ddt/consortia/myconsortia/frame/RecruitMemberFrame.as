package ddt.consortia.myconsortia.frame
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.ui.controls.hframe.HTipFrame;
	import road.utils.StringHelper;
	
	import ddt.consortia.ConsortiaModel;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;

	public class RecruitMemberFrame extends HTipFrame
	{
		private var _model : ConsortiaModel;
		public function RecruitMemberFrame(model : ConsortiaModel)
		{
			this._model = model;
			super();
			init();
			addEvent();
		}
	
		private function init() : void
		{
			setContentSize(311,63);
			buttonGape = 20;
			okLabel     = LanguageMgr.GetTranslation("ok");
			//okLabel     = "确 定";
			cancelLabel = LanguageMgr.GetTranslation("cancel");
			//cancelLabel = "取 消";
			titleText = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.RecruitMemberFrame.titleText");
			//titleText = "招收成员";
			tipTxt(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.RecruitMemberFrame.tipTxt"));
			//tipTxt("请输入玩家昵称:");
            iconVisible = false;
            okBtnEnable = false;
            super.maxChar = 14;
            
            getInputText.restrict = "^ ";
            
			layou();
		}
		
		public function addEvent() : void
		{
			okFunction = __okClick;
			this.cancelFunction = __cancel;
//			addEventListener(Event.ADDED_TO_STAGE,__limitInput);
//			getInputText.addEventListener(TextEvent.TEXT_INPUT,__limitInput);
			getInputText.addEventListener(Event.CHANGE,__input);
		}
		public function removeEvent() : void
		{
			okFunction = null;
			this.cancelFunction = null;
//			removeEventListener(Event.ADDED_TO_STAGE,__limitInput);
//			getInputText.removeEventListener(TextEvent.TEXT_INPUT,__limitInput);
			getInputText.removeEventListener(Event.CHANGE,__input);
		}
		
//		private function __limitInput(e:Event):void
//		{
//			getInputText.text = StringHelper.trim(getInputText.text);
//		}
		
		private function __input(e:Event):void
		{
			if(inputTxt!="")okBtnEnable = true;
			else okBtnEnable = false;
		}
		private function __okClick():void
		{
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			if(inputTxt!="")
			{
				SocketManager.Instance.out.sendConsortiaInvate(StringHelper.trim(this.inputTxt));
				this.dispose();
			}
			
		}
		private function __cancel():void
		{
			removeEvent();
			okFunction = null;
			if(parent)parent.removeChild(this);
			dispose();
		}
		
		public function errorTip(msg : String) : void
		{
			tipTxt(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.RecruitMemberFrame.tipTxt"),msg);
			//tipTxt("请输入玩家昵称:",msg);
			this.okBtnEnable = false;
		}
		override protected function __closeClick(e: MouseEvent):void
		{
			super.__closeClick(e);
			dispose();
		}
		override public function hide ():void
		{
			super.hide();
			dispose();
		}
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			if(this.parent)this.parent.removeChild(this);
			
		}
		
		
	}
}