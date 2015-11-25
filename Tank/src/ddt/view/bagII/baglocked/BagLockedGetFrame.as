package ddt.view.bagII.baglocked
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import game.crazyTank.view.bagII.GetBagPwdAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.bagII.BagEvent;

	public class BagLockedGetFrame extends HConfirmFrame
	{
		private var _bgAsset : GetBagPwdAsset;
		private var _type    : int;/**2,获得密码,4,删去密码***/
		public function BagLockedGetFrame($type : int=2)
		{
			super();
			_type = $type;
			blackGound = false;
			alphaGound = false;
			buttonGape = 30;
			stopKeyEvent = true;
			
			
			centerTitle = true;
//			showBottom = false;
			setContentSize(340,172);
			init();
			addEvent();
		}
		private function init() : void
		{
			_bgAsset = new GetBagPwdAsset();
			this.addContent(_bgAsset);
			if(_type == 2)
			{
				_bgAsset.lockedTip.visible  = true;
				titleText = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.BagLockedGetFrame.titleText"); 
				//titleText = "解除锁定"; 
			}
			else if(_type == 4)
			{
				_bgAsset.lockedTip.visible  = false;
				titleText = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.BagLockedGetFrame.titleText2"); 
				//titleText = "清除二级密码"; 
			}
			this.okFunction = __okFunction;
			this.cancelFunction = dispose;
			this.closeCallBack  = dispose;
		}
		private function addEvent() : void
		{
			addEventListener(Event.ADDED_TO_STAGE,  __addToStageInitHandler);
			PlayerManager.Instance.Self.addEventListener(BagEvent.CLEAR,clearSuccessHandler);
		}
		
		private function removeEvent() : void
		{
			removeEventListener(Event.ADDED_TO_STAGE,  __addToStageInitHandler);
			PlayerManager.Instance.Self.removeEventListener(BagEvent.CLEAR,clearSuccessHandler);
		}
		private function __addToStageInitHandler(evt : Event) : void
		{
			_bgAsset.pwdTxt.text = "";
			_bgAsset.pwdTxt.stage.focus = _bgAsset.pwdTxt;
		}
		
		private function pwdFocusOutHandler(event:FocusEvent):void{
			if(stage){
				_bgAsset.pwdTxt.stage.focus = _bgAsset.pwdTxt;
			}
		}
		
		private function __okFunction() : void
		{
			if(checkInputText())
			{
				if(_type == 2)
				{
					SocketManager.Instance.out.sendBagLocked(_bgAsset.pwdTxt.text,2);
				}
				else if(_type == 4)
				{
					SocketManager.Instance.out.sendBagLocked(_bgAsset.pwdTxt.text,4);
				}
			}
		}
		
		//解锁成功后请求是否弹出密保
		private function clearSuccessHandler(event:BagEvent):void{
			if(PlayerManager.Instance.Self.questionOne == ""){
				new PasswordCompleteFrame().show();
			}
			this.dispose();
		}
		
		private function checkInputText() : Boolean
		{
			if(_bgAsset.pwdTxt.text == "")
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.BagLockedGetFrame.input"));
				//MessageTipManager.getInstance().show("请输入您的二级密码");
				return false;
			}
			return true;
		}
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			if(_bgAsset && _bgAsset.parent)_bgAsset.parent.removeChild(_bgAsset);
			_bgAsset = null;
			while(this.numChildren != 0)
			{
				var mc : DisplayObject = this.getChildAt(0) as DisplayObject;
				if(mc)this.removeChild(mc);
				mc = null;
			}
			if(this.parent)this.parent.removeChild(this);
		}
		
		override public function show():void
		{
			alphaGound = false;
			TipManager.AddTippanel(this,true);
			alphaGound = true;
		}
		
		override public function close():void{
			dispose();
		}
		
	}
	
}