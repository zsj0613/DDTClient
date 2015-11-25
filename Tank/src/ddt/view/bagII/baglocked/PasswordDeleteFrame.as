package ddt.view.bagII.baglocked
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import game.crazyTank.view.bagII.DeletePasswordAsset;
	
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

	public class PasswordDeleteFrame extends HFrame
	{
		private var _bgAsset:DeletePasswordAsset;
		private var _delBtn:HLabelButton;
		private var _cancelBtn:HLabelButton;
		private var _musicDerail:Boolean = true;
		
		public function PasswordDeleteFrame()
		{
			super();
			setContentSize(278,322);
			titleText = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.deletePassword"); 
			blackGound = false;
			alphaGound = true;
			init();
			initEvents();
		}
		
		private function init():void{
			_bgAsset = new DeletePasswordAsset();
			_cancelBtn = new HLabelButton();
			_cancelBtn.label = LanguageMgr.GetTranslation("ddt.view.DefyAfficheView.cancel");
			_delBtn = new HLabelButton();
			_delBtn.label = LanguageMgr.GetTranslation("ddt.view.im.IMFriendItem.delete");
			
			_cancelBtn.x = _bgAsset.cancelBtn.x;
			_cancelBtn.y = _bgAsset.cancelBtn.y;
			
			_delBtn.x = _bgAsset.delBtn.x;
			_delBtn.y = _bgAsset.delBtn.y;
			
			_delBtn.enable = false;
			
			_bgAsset.delBtn.visible = false;
			_bgAsset.cancelBtn.visible = false;
			_bgAsset.addChild(_cancelBtn);
			_bgAsset.addChild(_delBtn);
			addContent(_bgAsset);
			
			_bgAsset.delAnswer.tabIndex = 0;
			_bgAsset.delAnswerTwo.tabIndex = 1;
					
		}
		
		override public function show():void
		{
			TipManager.AddTippanel(this,true);
		}
		
		private function initEvents():void{
			_delBtn.addEventListener(MouseEvent.CLICK,delBtnClickHandler);
			_cancelBtn.addEventListener(MouseEvent.CLICK,cancelBtnClickHandler);
			PlayerManager.Instance.Self.addEventListener(BagEvent.AFTERDEL,delPasswordHandler);
			addEventListener(Event.ADDED_TO_STAGE,addtoStageHandler);
			_bgAsset.delAnswer.addEventListener(Event.CHANGE,eventChangeHandler);
			_bgAsset.delAnswerTwo.addEventListener(Event.CHANGE,eventChangeHandler);
		}
		
		private function eventChangeHandler(event:Event):void{
			_delBtn.enable = checkInput();
		}
		
		private function addtoStageHandler(event:Event):void{
			stage.focus = _bgAsset.delAnswer;
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			BagStore.Instance.passwordOpen = false;
		}
		
		private function keyDownHandler(event:KeyboardEvent):void{
			event.stopImmediatePropagation();
			if(event.keyCode == Keyboard.ESCAPE){
				close();
			}else if(event.keyCode == Keyboard.ENTER)
			{
				delBtnClickHandler(null);
			}
		}
		
		public function initText(str1:String,str2:String,value:int):void{
			_bgAsset.delQuestion.text = str1;
			_bgAsset.delQuestionTwo.text = str2;
			_bgAsset.leftTimes.text = String(value);
			checkLeftTimes();
		}
		
		private function checkLeftTimes():void{
			if(int(_bgAsset.leftTimes.text) == 0){
				_delBtn.enable = false;
			}	
		}
		
		private function delPasswordHandler(event:BagEvent):void{
			this.close();
		}
		
		private function delBtnClickHandler(event:MouseEvent):void{
			SoundManager.instance.play("008");
			_musicDerail = false;
			if(_bgAsset.delAnswer.text == "" || _bgAsset.delAnswerTwo.text == ""){
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.inputAnswer"));
				return;
			}
			if(PlayerManager.Instance.Self.leftTimes<=0)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.operationTimesOut"));
				return;
			}
			SocketManager.Instance.out.sendBagLocked("",4,"","",_bgAsset.delAnswer.text,"",_bgAsset.delAnswerTwo.text);
			PlayerManager.Instance.Self.leftTimes--;
			_bgAsset.leftTimes.text = PlayerManager.Instance.Self.leftTimes <= 0?"0":String(PlayerManager.Instance.Self.leftTimes);
			checkLeftTimes();
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

		
		override public function dispose():void{
			if(_musicDerail){
				SoundManager.instance.play("008");
			}
			removeEventListener(Event.ADDED_TO_STAGE,addtoStageHandler);
			_delBtn.removeEventListener(MouseEvent.CLICK,delBtnClickHandler);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,cancelBtnClickHandler);
			PlayerManager.Instance.Self.removeEventListener(BagEvent.AFTERDEL,delPasswordHandler);
			_bgAsset.delAnswer.removeEventListener(Event.CHANGE,eventChangeHandler);
			_bgAsset.delAnswerTwo.removeEventListener(Event.CHANGE,eventChangeHandler);
			super.dispose();
			BagStore.Instance.passwordOpen = true;
		}
		
		private function checkInput():Boolean{
			var tempFlag:Boolean = false;
			if(_bgAsset.delAnswer.text != "" && _bgAsset.delAnswerTwo.text != "" && PlayerManager.Instance.Self.leftTimes > 0){
				tempFlag = true;
			}
			return tempFlag;
		}
		
		
	}
}