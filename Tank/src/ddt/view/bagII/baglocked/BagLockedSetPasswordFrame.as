package ddt.view.bagII.baglocked
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import game.crazyTank.view.bagII.setpswAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.hframe.HFrame;
	import road.ui.manager.TipManager;
	
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.bagII.BagEvent;
	import ddt.view.bagII.bagStore.BagStore;
	/**
	 * Author stork
	 * 01/9/2010
	 * 二级密码密码设置页面
	 * */
	public class BagLockedSetPasswordFrame extends HFrame
	{
		private var _bgAsset:setpswAsset;
		private var _nextStepBtn:HLabelButton;
		private var _frame:PasswordProtectionFrame;
		private var _musicDerail:Boolean = true;    /**声音开关**/
		private var _tempFlag:Boolean;              /**按钮灰显开关**/
		
		public function BagLockedSetPasswordFrame()
		{
			super();
			setContentSize(310,222);
			titleText = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.guide");
			blackGound = false;
			centerTitle = false;
			alphaGound = true;
			init();
			initEvents();
		}
		
		private function init():void{
			_bgAsset = new setpswAsset();
			_nextStepBtn = new HLabelButton();
			_nextStepBtn.label = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.next");
			
			_nextStepBtn.x = _bgAsset.newStepBtn.x;
			_nextStepBtn.y = _bgAsset.newStepBtn.y;
			_bgAsset.newStepBtn.visible = false;
			_bgAsset.addChild(_nextStepBtn);
			_nextStepBtn.enable = false;
			_bgAsset.psw.maxChars = 40;
			_bgAsset.repsw.maxChars = 40;
			_bgAsset.newStepBtn.enabled = false;
			_bgAsset.psw.restrict = _bgAsset.repsw.restrict = "a-z A-Z 0-9";
			 
			addContent(_bgAsset);
			_bgAsset.addEventListener(Event.ADDED_TO_STAGE,onAddHandler);
		}
		
		private function initEvents():void{
			_nextStepBtn.addEventListener(MouseEvent.CLICK,onNextStepBtnClickHandler);
			PlayerManager.Instance.Self.addEventListener(BagEvent.CHANGEPSW,changePasswordHandler);
			addEventListener(Event.ADDED_TO_STAGE,addtoStageHandler);
			_bgAsset.psw.addEventListener(Event.CHANGE,textChangeHandler);
			_bgAsset.repsw.addEventListener(Event.CHANGE,textChangeHandler);
		}
		
		public function setVisible():void{
			visible = true;
			stage.focus = _bgAsset.psw;
		}
		
		private function onAddHandler(event:Event):void{
			_bgAsset.stage.focus = _bgAsset.psw;
			_bgAsset.psw.tabIndex = 0;
			_bgAsset.repsw.tabIndex = 1;
		}
		
		private function onNextStepBtnClickHandler(event:MouseEvent):void{
			SoundManager.Instance.play("008");
			_musicDerail = false;
			if(_bgAsset.psw.text != _bgAsset.repsw.text){
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.diffrent"));
				clearTextInput();
				return;
			}
			if(_bgAsset.psw.text.length < 6 || _bgAsset.psw.length > 14){
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.alertInfo"));
				clearTextInput();
				return;	
			}
			if(PlayerManager.Instance.Self.questionOne == ""){
				if(_frame == null){
				_frame = new PasswordProtectionFrame(_bgAsset.psw.text,this);
				_frame.addEventListener(BagEvent.BACK_STEP,backstepHandler);
				_frame.show();	
				}else{
					_frame.setVisible();
				}
				this.visible = false;	
			}else{
				SocketManager.Instance.out.sendBagLocked(_bgAsset.psw.text,1);
			}	
		}
		
		private function changePasswordHandler(event:BagEvent):void{
			close();
		}
		
		private function clearTextInput():void{
			_bgAsset.psw.text = _bgAsset.repsw.text = "";
			_bgAsset.stage.focus = _bgAsset.psw;
		}
		
		private function backstepHandler(event:BagEvent):void{
			visible = true;
			stage.focus = _bgAsset.psw;
		}
		
		override protected function __closeClick(e:MouseEvent):void{
			close();
		}
		
		override public function close():void{
			removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			super.close();
			dispose();
		}
		
		public function closeNoFrame():void{
			super.close();
			dispose();
		}
	
		override public function dispose():void{
			if(_musicDerail){
				SoundManager.Instance.play("008");
			}
			BagStore.Instance.passwordOpen = true;
			removeEventListener(Event.ADDED_TO_STAGE,addtoStageHandler);
			PlayerManager.Instance.Self.removeEventListener(BagEvent.CHANGEPSW,changePasswordHandler);
			_bgAsset.psw.removeEventListener(Event.CHANGE,textChangeHandler);
			_bgAsset.repsw.removeEventListener(Event.CHANGE,textChangeHandler);
			super.dispose();
		}
		
		override public function show():void
		{
			TipManager.AddTippanel(this,true);
		}
		
		private function addtoStageHandler(event:Event):void{
			addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			BagStore.Instance.passwordOpen = false;
		}
		
		private function keyDownHandler(event:KeyboardEvent):void{
			event.stopImmediatePropagation();
			if(event.keyCode == Keyboard.ESCAPE){				
				close();
			}else if(event.keyCode == Keyboard.ENTER)
			{
				onNextStepBtnClickHandler(null);
			}
		}
		
		public function changeView():void{
			_bgAsset.titleText.text = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.setted");
			_nextStepBtn.label = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.sure");
			_nextStepBtn.x += 8;
			titleText = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.BagLockedSetFrame.titleText");
		}
		
		/**两个密码框输入事件监听 没内容则灰显下一步按钮**/
		
		private function checkInput():Boolean{
			_tempFlag = false;
			if(_bgAsset.psw.text != "" && _bgAsset.repsw.text != ""){
				_tempFlag = true;
			}
			return _tempFlag;
		}
		
		private function textChangeHandler(event:Event):void{
			_nextStepBtn.enable = checkInput();
		}
		
	}
}