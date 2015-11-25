package ddt.view.bagII.baglocked
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import game.crazyTank.view.bagII.UpdataPasswordAsset;
	
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

	public class PasswordUpdateFrame extends HFrame
	{
		private var _bgAsset:UpdataPasswordAsset;
		private var _updateBtn:HLabelButton;
		private var _cancelBtn:HLabelButton;
		private var _musicDerail:Boolean = true;
		
		public function PasswordUpdateFrame()
		{
			super();
			titleText = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.modifyTitle");
			setContentSize(280,292);
			blackGound = false;
			centerTitle = false;
			alphaGound = true;
			init();
			initEvents();
		}
		
		private function init():void{
			
			_bgAsset = new UpdataPasswordAsset();
			_bgAsset.yuanText.tabEnabled = true;
			_bgAsset.newText.tabEnabled = true;
			_bgAsset.newTextAgain.tabEnabled = true;
			_bgAsset.yuanText.tabIndex = 1;
			_bgAsset.newText.tabIndex = 2;
			_bgAsset.newTextAgain.tabIndex = 3;
			
			_bgAsset.leftTimes.text = PlayerManager.Instance.Self.leftTimes <= 0?"0":String(PlayerManager.Instance.Self.leftTimes);
			_cancelBtn = new HLabelButton();
			_cancelBtn.label = LanguageMgr.GetTranslation("ddt.view.DefyAfficheView.cancel");
			_updateBtn = new HLabelButton();
			_updateBtn.label = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.modifyBtn");
			
			_cancelBtn.x = _bgAsset.cancelBtn.x;
			_cancelBtn.y = _bgAsset.cancelBtn.y;
			
			_updateBtn.x = _bgAsset.delBtn.x;
			_updateBtn.y = _bgAsset.delBtn.y;
			
			_updateBtn.enable = false;
			
			_bgAsset.delBtn.visible = false;
			_bgAsset.cancelBtn.visible = false;
			_bgAsset.addChild(_cancelBtn);
			_bgAsset.addChild(_updateBtn);
			_bgAsset.addEventListener(Event.ADDED_TO_STAGE,addtoStageHandler);
			addContent(_bgAsset);
			isPasswordProtection();
			checkLeftTimes();
		}
		
		/**
		 * 检查用户是否有密码保护
		 */
		 
		 private function isPasswordProtection():void{
		 	if(PlayerManager.Instance.Self.questionOne == ""){
		 		_bgAsset.textLeft.visible = _bgAsset.textRight.visible = _bgAsset.leftTimes.visible = false;
		 	}
		 }
		
		private function checkLeftTimes():void{
			if(int(_bgAsset.leftTimes.text) == 0){
				_updateBtn.enable = false;
			}	
		}
		
		private function addtoStageHandler(event:Event):void{
			_bgAsset.stage.focus = _bgAsset.yuanText;
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			BagStore.Instance.passwordOpen = false;
		}
		
		private function initEvents():void{
			_updateBtn.addEventListener(MouseEvent.CLICK,updateBtnClickHandler);
			_cancelBtn.addEventListener(MouseEvent.CLICK,cancelBtnClickHandler);
			PlayerManager.Instance.Self.addEventListener(BagEvent.UPDATE_SUCCESS,updateSuccessHandler);
//			_bgAsset.newTextAgain.addEventListener(FocusEvent.FOCUS_OUT,naFocusOutHandler);
			addEventListener(Event.ADDED_TO_STAGE,addtoStageHandler);
			_bgAsset.yuanText.addEventListener(Event.CHANGE,eventChangeHandler);
			_bgAsset.newText.addEventListener(Event.CHANGE,eventChangeHandler);
			_bgAsset.newTextAgain.addEventListener(Event.CHANGE,eventChangeHandler);
		}
		
		private function naFocusOutHandler(event:FocusEvent):void{
			stage ? stage.focus = _bgAsset.yuanText : null;
		}
		
		
		private function updateBtnClickHandler(event:MouseEvent):void{
			SoundManager.instance.play("008");
			_musicDerail = false;
			if(_bgAsset.yuanText.text == ""){
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.originalNull"));
				stage.focus = _bgAsset.yuanText;
				return;
			}
			if(_bgAsset.newText.text == "" || _bgAsset.newTextAgain.text == ""){
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.newNull"));
				stage.focus = _bgAsset.newText;
				return;
			}
			if(_bgAsset.newText.text != _bgAsset.newTextAgain.text){
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.newDiffer"));
				_bgAsset.newText.text = "";
				_bgAsset.newTextAgain.text = "";
				stage.focus = _bgAsset.newText;
				return; 
			}
			if(_bgAsset.newText.text.length > 14){
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.newTooLong"));
				_bgAsset.newText.text = "";
				_bgAsset.newTextAgain.text = "";
				stage.focus = _bgAsset.newText;
				return;
			}
			if(_bgAsset.newText.text.length < 6){
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.newTooShort"));
				_bgAsset.newText.text = "";
				_bgAsset.newTextAgain.text = "";
				stage.focus = _bgAsset.newText;
				return;
			}
			if(PlayerManager.Instance.Self.leftTimes <= 0)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.operationTimesOut"));
				return;
			}
			SocketManager.Instance.out.sendBagLocked(_bgAsset.yuanText.text,3,_bgAsset.newText.text);
			if(PlayerManager.Instance.Self.questionOne == "") return;
			PlayerManager.Instance.Self.leftTimes--;
			_bgAsset.leftTimes.text = PlayerManager.Instance.Self.leftTimes <= 0?"0":String(PlayerManager.Instance.Self.leftTimes);
			checkLeftTimes();
		}
		
		private function updateSuccessHandler(event:BagEvent):void{
			if(PlayerManager.Instance.Self.questionOne == ""){
				new PasswordCompleteFrame().show();
			}
			this.close();
		}
		
		private function cancelBtnClickHandler(event:MouseEvent):void{
			SoundManager.instance.play("008");
			_musicDerail = false;
			close();
		}
		
		override public function close():void{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			super.close();
			dispose();
		}
		
		override public function show():void
		{
			TipManager.AddTippanel(this,true);
		}
		
		override public function dispose():void{
			if(_musicDerail){
				SoundManager.instance.play("008");
			}
			removeEventListener(Event.ADDED_TO_STAGE,addtoStageHandler);
//			_bgAsset.newTextAgain.removeEventListener(FocusEvent.FOCUS_OUT,naFocusOutHandler);
			_bgAsset.removeEventListener(Event.ADDED_TO_STAGE,addtoStageHandler);
			_updateBtn.removeEventListener(MouseEvent.CLICK,updateBtnClickHandler);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,cancelBtnClickHandler);
			PlayerManager.Instance.Self.removeEventListener(BagEvent.UPDATE_SUCCESS,updateSuccessHandler);
			_bgAsset.yuanText.removeEventListener(Event.CHANGE,eventChangeHandler);
			_bgAsset.newText.removeEventListener(Event.CHANGE,eventChangeHandler);
			_bgAsset.newTextAgain.removeEventListener(Event.CHANGE,eventChangeHandler);
			super.dispose();
			BagStore.Instance.passwordOpen = true;
		}	
		
		private function keyDownHandler(event:KeyboardEvent):void{
			event.stopImmediatePropagation();
			if(event.keyCode == Keyboard.ESCAPE){
				close();
			}else if(event.keyCode == Keyboard.ENTER)
			{
				updateBtnClickHandler(null);
			}
		}
		
		private function eventChangeHandler(event:Event):void{
			_updateBtn.enable = checkInput();
		}
		
		private function checkInput():Boolean{
			var tempFlag:Boolean = false;
			if(_bgAsset.yuanText.text != "" && _bgAsset.newText.text != "" && _bgAsset.newTextAgain.text != "" && PlayerManager.Instance.Self.leftTimes > 0){
				tempFlag = true;
			}
			return tempFlag;
		}
		
	}
}