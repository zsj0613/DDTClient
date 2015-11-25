package ddt.view.bagII.baglocked
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import game.crazyTank.view.bagII.TextBgAsset;
	import game.crazyTank.view.bagII.passwordProtectionAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.hframe.HFrame;
	import road.ui.manager.TipManager;
	
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.view.bagII.BagEvent;
	import ddt.view.bagII.bagStore.BagStore;
	/**
	 * author stork
	 * 01/11/2010
	 * 密码保护设置页面
	 * */
	public class PasswordProtectionFrame extends HFrame
	{
		private var _bgAsset:passwordProtectionAsset;
		private var _nextBtn:HLabelButton;
		private var _backBtn:HLabelButton;
		private var _passwordSimpleGrid:PasswordProtectionSimpleGrid;
		private var _passwordSimpleGirdTwo:PasswordProtectionSimpleGrid;
		private var _frame:PasswordProtectionaAffirmFrame;
		private var _value:String;
		private var _tempTextOne:String;
		private var _tempTextTwo:String;
		private var _setFrame:BagLockedSetPasswordFrame;
		private var _tempFlag:Boolean;
		
		public function PasswordProtectionFrame(value:String = "",setFrame:BagLockedSetPasswordFrame = null)
		{
			super();
			_value = value;
			_setFrame = setFrame;
			setContentSize(293,360);
			titleText = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.passwordSetting");
			blackGound = false;
			centerTitle = false;
			alphaGound = true;
			init();
			initEvents();
			_value == "complete" ? resetView() : null;
		}
		
		private function init():void{
			_bgAsset = new passwordProtectionAsset();
			_bgAsset.questionText.tabEnabled = false;
			_bgAsset.questionTextTwo.tabEnabled  = false;
			_bgAsset.answerText.tabIndex = -1;
			_bgAsset.answerTextTwo.tabIndex = 0;
			_bgAsset.questionText.maxChars = 40;
			_bgAsset.questionTextTwo.maxChars = 40;
			_bgAsset.answerText.maxChars = 40;
			_bgAsset.answerTextTwo.maxChars = 40;
			
			_tempTextOne = _bgAsset.questionText.text;
			_tempTextTwo = _bgAsset.questionTextTwo.text;
			_nextBtn = new HLabelButton();
			_nextBtn.label = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.next");
			_backBtn = new HLabelButton();
			_backBtn.label = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.preview");
			
			_nextBtn.x = _bgAsset.nextBtn.x;
			_nextBtn.y = _bgAsset.nextBtn.y;
			_nextBtn.enable = false;
			_backBtn.x = _bgAsset.backBtn.x;
			_backBtn.y = _bgAsset.backBtn.y;
			
			_bgAsset.nextBtn.visible = false;
			_bgAsset.backBtn.visible = false;
			_bgAsset.textChoose.buttonMode = true;
			_bgAsset.textChooseTwo.buttonMode = true;
			_bgAsset.arrowOne.buttonMode = true;
			_bgAsset.arrowTwo.buttonMode = true;
			
			_bgAsset.addChild(_nextBtn);
			_bgAsset.addChild(_backBtn);
			
			addContent(_bgAsset);
				
		}
		
		private function initEvents():void{
			_bgAsset.textChoose.addEventListener(MouseEvent.CLICK,questionTextClickHandler);
			_bgAsset.textChooseTwo.addEventListener(MouseEvent.CLICK,questionTextTwoClickHandler);
			_bgAsset.answerText.addEventListener(Event.CHANGE,textChangeHandler);
			_bgAsset.answerTextTwo.addEventListener(Event.CHANGE,textChangeHandler);
			_bgAsset.questionText.addEventListener(Event.CHANGE,textChangeHandler);
			_bgAsset.questionTextTwo.addEventListener(Event.CHANGE,textChangeHandler);
			_nextBtn.addEventListener(MouseEvent.CLICK,nextBtnClickHandler);
			_backBtn.addEventListener(MouseEvent.CLICK,backBtnClickHandler);
			_bgAsset.arrowOne.addEventListener(MouseEvent.CLICK,arrowOneClickHandler);
			_bgAsset.arrowTwo.addEventListener(MouseEvent.CLICK,arrowTwoClickHandler);
			addEventListener(Event.ADDED_TO_STAGE,addtoStageHandler);
		}
		
		private function addtoStageHandler(event:Event):void{
			stage ? stage.focus = _bgAsset.answerText : null;
			_bgAsset.answerText.tabIndex = 0;
			_bgAsset.answerTextTwo.tabIndex = 1;
			addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			BagStore.Instance.passwordOpen = false;
		}
		
		private function keyDownHandler(event:KeyboardEvent):void{
			event.stopImmediatePropagation();
			if(event.keyCode == Keyboard.ESCAPE){
				close();
			}else if(event.keyCode == Keyboard.ENTER)
			{
				nextBtnClickHandler(null);
			}
		}
		
		private function questionTextClickHandler(event:MouseEvent):void{
			if(!_passwordSimpleGrid){
				creatPasswordSimpleGrid();
				return;
			}
			_passwordSimpleGrid.visible = !_passwordSimpleGrid.visible;
		}
		
		private function questionTextTwoClickHandler(event:MouseEvent):void{
			if(!_passwordSimpleGirdTwo){
				creatPasswordSimpleGridTwo();
				return;
			}
			_passwordSimpleGirdTwo.visible = !_passwordSimpleGirdTwo.visible;
		}
		
		private function passwordQuestionArrayClickHandler(event:BagEvent):void{
			_passwordSimpleGrid.visible = false;
			if((event.data as TextBgAsset).bgtext.text == LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.customer")){
				_bgAsset.textChoose.visible = false;
				_bgAsset.questionText.text = "";
				_bgAsset.stage.focus = _bgAsset.questionText;
				_bgAsset.questionText.addEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);
				return;
			}
			_bgAsset.questionText.text = (event.data as TextBgAsset).bgtext.text;
		}
		
		private function passwordQuestionArrayClickHandlerTwo(event:BagEvent):void{
			_passwordSimpleGirdTwo.visible = false;
			if((event.data as TextBgAsset).bgtext.text == LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.customer")){
				_bgAsset.textChooseTwo.visible = false;
				_bgAsset.questionTextTwo.text = "";
				_bgAsset.stage.focus = _bgAsset.questionTextTwo;
				_bgAsset.questionTextTwo.addEventListener(FocusEvent.FOCUS_OUT,focusOutHandlerTwo);
				return;
			}
			_bgAsset.questionTextTwo.text = (event.data as TextBgAsset).bgtext.text;
		}
		
		private function creatPasswordSimpleGrid():void{
			_passwordSimpleGrid = new PasswordProtectionSimpleGrid();
			_passwordSimpleGrid.x = _bgAsset.questionText.x - 3 ;
			_passwordSimpleGrid.y = _bgAsset.questionText.y + _bgAsset.questionText.height + 2;
			_passwordSimpleGrid.addEventListener(BagEvent.PSDPRO,passwordQuestionArrayClickHandler);
			_bgAsset.addChild(_passwordSimpleGrid);
		}
		
		private function creatPasswordSimpleGridTwo():void{
			_passwordSimpleGirdTwo = new PasswordProtectionSimpleGrid();
			_passwordSimpleGirdTwo.x = _bgAsset.questionTextTwo.x - 3;
			_passwordSimpleGirdTwo.y = _bgAsset.questionTextTwo.y + _bgAsset.questionTextTwo.height + 2;
			_passwordSimpleGirdTwo.addEventListener(BagEvent.PSDPRO,passwordQuestionArrayClickHandlerTwo);
			_bgAsset.addChild(_passwordSimpleGirdTwo);
		}
		
		private function nextBtnClickHandler(event:MouseEvent):void{
			SoundManager.instance.play("008");
			if(_bgAsset.questionText.text == _tempTextOne || _bgAsset.questionTextTwo.text == _tempTextTwo){
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.selectQustion"));
				return;
			}
			if(_bgAsset.questionText.text == "" || _bgAsset.answerText.text == "" || _bgAsset.questionTextTwo.text == "" || _bgAsset.answerTextTwo.text == ""){
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.inputCompletely"));
				return;
			}
			if(_bgAsset.questionText.text == _bgAsset.questionTextTwo.text){
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.cantRepeat"));
				return;
			}
			if(_frame == null){
				_frame = new PasswordProtectionaAffirmFrame(_value,this);
				_frame.addEventListener(BagEvent.BACK_STEP,backStepClickHandler);
				_frame.show();
			}else{
				_frame.setVisible();
			}
			reflushData();
			this.visible = false;
		}
		
		private function backBtnClickHandler(event:MouseEvent):void{
			SoundManager.instance.play("008");
			dispatchEvent(new BagEvent(BagEvent.BACK_STEP,new Dictionary()));
			this.visible = false;
		}
		
		private function backStepClickHandler(event:BagEvent):void{
			this.visible = true;
			stage.focus = _bgAsset.answerText;
		}
		
		private function reflushData():void{
			var _data:Object = {passwordQuestion:_bgAsset.questionText.text,
			passwordAnswer:_bgAsset.answerText.text,
			passwordQuestionTwo:_bgAsset.questionTextTwo.text,
			passwordAnswerTwo:_bgAsset.answerTextTwo.text};
			_frame.data = _data;
		}
		
		private function focusOutHandler(event:FocusEvent):void{
			_bgAsset.textChoose.visible = true;
		}
		
		private function focusOutHandlerTwo(event:FocusEvent):void{
			_bgAsset.textChooseTwo.visible = true;
		}
		
		override protected function __closeClick(e:MouseEvent):void{
			close();	
		}
		
		override public function dispose():void{
			removeEventListener(Event.ADDED_TO_STAGE,addtoStageHandler);
			_bgAsset.textChoose.removeEventListener(MouseEvent.CLICK,questionTextClickHandler);
			_bgAsset.textChooseTwo.removeEventListener(MouseEvent.CLICK,questionTextTwoClickHandler);
			_nextBtn.removeEventListener(MouseEvent.CLICK,nextBtnClickHandler);
			_backBtn.removeEventListener(MouseEvent.CLICK,backBtnClickHandler);
			_bgAsset.answerText.removeEventListener(Event.CHANGE,textChangeHandler);
			_bgAsset.answerTextTwo.removeEventListener(Event.CHANGE,textChangeHandler);
			_bgAsset.questionText.removeEventListener(Event.CHANGE,textChangeHandler);
			_bgAsset.questionTextTwo.removeEventListener(Event.CHANGE,textChangeHandler);
			removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			SoundManager.instance.play("008");
			super.dispose();
			BagStore.Instance.passwordOpen = true;
			if(_passwordSimpleGrid){
				_passwordSimpleGrid.dispose();
				_passwordSimpleGrid = null;	
			}
			if(_passwordSimpleGirdTwo){
				_passwordSimpleGirdTwo.dispose();
				_passwordSimpleGirdTwo = null;
			}
		}
		
		override public function show():void
		{
			TipManager.AddTippanel(this,true);
		}
		
		override public function close():void{
			super.close();
			dispose();
			if(_setFrame){
				_setFrame.closeNoFrame();
			}
		}
		
		public function closeNoProtected():void{
			super.close();
			dispose();
			if(_setFrame){
				_setFrame.closeNoFrame();
			}
		}
		
		private function questionExsit(value:String):Boolean{
			var tempArray:Array = _passwordSimpleGrid.questionArray;
			tempArray.push(_tempTextOne);
			tempArray.push(_tempTextTwo);
			var tempFlag:Boolean = true;
			for each(var item:String in tempArray){
				if(item == value){
					tempFlag = false;
				}
			}
			return tempFlag;
		}
		
	   /**两个框输入事件监听 没内容则灰显下一步按钮**/
		
		private function checkInput():Boolean{
			_tempFlag = false;
			if(_bgAsset.answerText.text != "" && _bgAsset.answerTextTwo.text != ""){
				_tempFlag = true;
			}
			return _tempFlag;
		}
		
		private function textChangeHandler(event:Event):void{
			_nextBtn.enable = checkInput();
		}
		
		/**两个箭头点击事件**/
		
		private function arrowOneClickHandler(event:MouseEvent):void{
			if(!_passwordSimpleGrid){
				creatPasswordSimpleGrid();
				return;
			}
			_passwordSimpleGrid.visible = !_passwordSimpleGrid.visible;
			_bgAsset.stage.focus = _bgAsset.answerText;
		}
		
		private function arrowTwoClickHandler(event:MouseEvent):void{
			if(!_passwordSimpleGirdTwo){
				creatPasswordSimpleGridTwo();
				return;
			}
			_passwordSimpleGirdTwo.visible = !_passwordSimpleGirdTwo.visible;
			_bgAsset.stage.focus = _bgAsset.answerTextTwo;
		}
		
		/**
		 * 隐藏上一步,在没密保时调用
		 */
		 private function resetView():void{
		 	_backBtn.visible = false;
		 	_nextBtn.x -= 73;
		 }
		 
		 public function setVisible():void{
		 	visible = true;
		 	stage.focus = _bgAsset.answerText;
		 }
		
	}

	
}