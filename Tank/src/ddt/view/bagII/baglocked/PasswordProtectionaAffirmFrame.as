package ddt.view.bagII.baglocked
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import game.crazyTank.view.bagII.PasswordAffirmAsset;
	
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

	public class PasswordProtectionaAffirmFrame extends HFrame
	{
		private var _bgAsset:PasswordAffirmAsset;
		private var _nextBtn:HLabelButton;
		private var _backBtn:HLabelButton;
		private var _data:Object = {passwordQuestion:"",passwordAnswer:"",passwordQuestionTwo:"",answerTwo:""};
		private var _value:String;
		private var _pswFrame:PasswordProtectionFrame;
		
		public function PasswordProtectionaAffirmFrame(value:String = "",pwsFrame:PasswordProtectionFrame = null)
		{
			super();
			_value = value;
			_pswFrame = pwsFrame;
			setContentSize(294,362);
			titleText = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.sureInfo");
			blackGound = false;
			centerTitle = false;
			alphaGound = true;
			init();
			initEvents();
		}
	
		private function init():void{
			_bgAsset = new PasswordAffirmAsset();
			_nextBtn = new HLabelButton();
			_nextBtn.label = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.complete");
			_backBtn = new HLabelButton();
			_backBtn.label = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.preview");
			_nextBtn.width = _backBtn.width;
			
			_nextBtn.x = _bgAsset.nextBtn.x;
			_nextBtn.y = _bgAsset.nextBtn.y;
			
			_backBtn.x = _bgAsset.backBtn.x;
			_backBtn.y = _bgAsset.backBtn.y;
			
			_bgAsset.nextBtn.visible = false;
			_bgAsset.backBtn.visible = false;
			_nextBtn.enable = false;
//			_bgAsset.banzi.buttonMode = true;     //设置问题为buttonMode
//			_bgAsset.banziTwo.buttonMode = true;
			
			_bgAsset.addChild(_nextBtn);
			_bgAsset.addChild(_backBtn);
			addContent(_bgAsset);
			
		}
		
		private function initEvents():void{
			_backBtn.addEventListener(MouseEvent.CLICK,backBtnClickHandler);
			_nextBtn.addEventListener(MouseEvent.CLICK,finishClickHandler);
			_bgAsset.aText.addEventListener(Event.CHANGE,textChangeHandler);
			_bgAsset.aTextTwo.addEventListener(Event.CHANGE,textChangeHandler);
			addEventListener(Event.ADDED_TO_STAGE,addtoStageHandler);
		}
		
		private function addtoStageHandler(event:Event):void{
			stage.focus = _bgAsset.aText;
			_bgAsset.aText.tabIndex = 0;
			_bgAsset.aTextTwo.tabIndex = 1;
			addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			BagStore.Instance.passwordOpen = false;
		}
		
		private function keyDownHandler(event:KeyboardEvent):void{
			event.stopImmediatePropagation();
			if(event.keyCode == Keyboard.ESCAPE){
				SoundManager.instance.play("008");
				close();
			}else if(event.keyCode == Keyboard.ENTER)
			{
				finishClickHandler(null);
			}
		}
		
		private function backBtnClickHandler(event:MouseEvent):void{
			SoundManager.instance.play("008");
			dispatchEvent(new BagEvent(BagEvent.BACK_STEP,new Dictionary()));
			this.visible = false;
		}
		
		private function finishClickHandler(event:MouseEvent):void{
			SoundManager.instance.play("008");
			if(_bgAsset.aText.text != _data.passwordAnswer || _bgAsset.aTextTwo.text != _data.passwordAnswerTwo){
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.answerDiffer"));
				return;
			}
			if(_value == "complete"){
				SocketManager.Instance.out.sendBagLocked("",5,"",_bgAsset.qText.text,_bgAsset.aText.text,_bgAsset.qTextTwo.text,_bgAsset.aTextTwo.text);
			}else{
				SocketManager.Instance.out.sendBagLocked(_value,1,"",_bgAsset.qText.text,_bgAsset.aText.text,_bgAsset.qTextTwo.text,_bgAsset.aTextTwo.text);
			}
			PlayerManager.Instance.Self.questionOne = _bgAsset.qText.text;
			PlayerManager.Instance.Self.questionTwo = _bgAsset.qTextTwo.text;
			PlayerManager.Instance.Self.leftTimes = 5;
			close();
		}
		
		private function checkInput():Boolean{
			var tempFlag:Boolean = false;
			if(_bgAsset.aText.text != "" && _bgAsset.qText.text != "" && _bgAsset.aTextTwo.text != "" && _bgAsset.qTextTwo.text != "" ){
				tempFlag = true;
			}
			return tempFlag;
		}
		
		private function textChangeHandler(event:Event):void{
			_nextBtn.enable = checkInput();
		}
		
		public function get bgAsset():PasswordAffirmAsset{
			return _bgAsset;
		}
		
		public function set bgAsset(value:PasswordAffirmAsset):void{
			_bgAsset = value;
		}
		
		public function get data():Object{
			return _data;
		}
		
		override public function show():void
		{
			TipManager.AddTippanel(this,true);
		}
		
		public function set data(value:Object):void{
			_data = value;
			_bgAsset.qText.text = _data.passwordQuestion;
			_bgAsset.qTextTwo.text = _data.passwordQuestionTwo;
		}
		
		override protected function __closeClick(e:MouseEvent):void{
			close();
		}
		
		override public function close():void{
//			stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			super.close();
			if(_pswFrame){
				_pswFrame.closeNoProtected();
			}
			dispose();
		}
		
		public function setVisible():void{
			visible = true;
			stage.focus = _bgAsset.aText;
		}
		
		override public function dispose():void{
			_backBtn.removeEventListener(MouseEvent.CLICK,backBtnClickHandler);
			_nextBtn.removeEventListener(MouseEvent.CLICK,finishClickHandler);
			_bgAsset.aText.removeEventListener(Event.CHANGE,textChangeHandler);
			_bgAsset.aTextTwo.removeEventListener(Event.CHANGE,textChangeHandler);
			removeEventListener(Event.ADDED_TO_STAGE,addtoStageHandler);
			super.dispose();
			BagStore.Instance.passwordOpen = true;
		}
			
	}
}