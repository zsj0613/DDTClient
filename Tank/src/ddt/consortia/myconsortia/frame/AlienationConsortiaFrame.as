package ddt.consortia.myconsortia.frame
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HTipFrame;
	
	import ddt.consortia.ConsortiaModel;
	import ddt.data.player.ConsortiaPlayerInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;

	public class AlienationConsortiaFrame extends HTipFrame
	{
		private var _model : ConsortiaModel;
		public function AlienationConsortiaFrame(model : ConsortiaModel)
		{
			this._model = model;
			super();
			init();
			addEvent();

		}
		private function init() : void
		{
			this.setContentSize(311,80);
			this.buttonGape = 20;
			this.titleText = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.AlienationConsortiaFrame.titleText");
			//this.titleText = "转让公会";
			this.tipTxt(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.AlienationConsortiaFrame.inputName"),LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.AlienationConsortiaFrame.info"));
			//this.tipTxt("请输入玩家昵称:","提示:只能转让给本公会玩家");
			this.moveEnable = false;
			okLabel = LanguageMgr.GetTranslation("ok");
			cancelLabel = LanguageMgr.GetTranslation("cancel");
			
            this.iconVisible = false;
            this.okBtnEnable = false;
			this.layou();
			
		}
		public function addEvent() : void
		{
			okFunction = sendTransConsortia;
			cancelFunction = __cancel;
			this.addEventListener(Event.CHANGE, __upInputTextHandler);
			this.addEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			super.maxChar = 14;
		}
		public function removeEvent() : void
		{
			okFunction = null;
			this.removeEventListener(Event.CHANGE, __upInputTextHandler);
			this.removeEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
		}
		private function __upInputTextHandler(evt : Event) : void
		{
			if(inputTxt != "")
			{
				if(PlayerManager.Instance.Self.NickName  == inputTxt)
	    		{
	    			okBtnEnable = false;
	    			return;
	    		}
				for(var i:int=0;i<_model.consortiaMemberList.length;i++)
			    {
	    			var info : ConsortiaPlayerInfo = _model.consortiaMemberList[i];
	    			if(info.NickName == inputTxt)
	    			{
	    				okBtnEnable = true;
	    				return;
	    			
	    			}
		    	}
			}
			okBtnEnable = false;
			
		}
		
		public function sendTransConsortia():void
		{
			this.okBtnEnable = false;
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			
			for(var i:int=0;i<_model.consortiaMemberList.length;i++)
			{
				var info : ConsortiaPlayerInfo = _model.consortiaMemberList[i];
				if(info.NickName == inputTxt)
				{
					if(inputTxt == PlayerManager.Instance.Self.NickName)
					{
						MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.AlienationConsortiaFrame.NickName"));
						//MessageTipManager.getInstance().show("您不能将公会转让给自己!");
						okBtnEnable = false;
						clearInputText();
						return;
					}
					if(info.Grade < 5)
					{
						MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.AlienationConsortiaFrame.Grade"));
						//MessageTipManager.getInstance().show("接受转让的成员等级要求\"10级\"以上!");
						okBtnEnable = false;
						clearInputText();
						return;
					}

					SocketManager.Instance.out.sendConsortiaChangeChairman(this.inputTxt);
					this.clearInputText();
					if(this.parent)this.parent.removeChild(this);
					return;
				}
			}
//			MessageTipManager.getInstance().show("您所输入的玩家角色不存在或不在本公会！");
//			okBtnEnable = false;
		}
		
		private function __cancel():void
		{
			clearInputText();
			okBtnEnable = false;
			if(this.parent)this.parent.removeChild(this);
		}
		private function __keyDown(e:KeyboardEvent):void
		{	
			if(e.keyCode == Keyboard.ENTER)
			{
				if(okBtnEnable)
				{
					sendTransConsortia();
			        inputTxt = "";
			        okBtnEnable = false;
				}
			}
		}
		
		override protected function __closeClick(e:MouseEvent):void
		{
			SoundManager.instance.play("008");
			
			__cancel();
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			if(this.parent)this.parent.removeChild(this);
		}
		
		
	}
}