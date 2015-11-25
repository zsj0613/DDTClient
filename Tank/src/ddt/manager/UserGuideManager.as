package ddt.manager
{

	/**新手引导
	 * Singleton,Manager
	 */ 
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import game.tutorial.asset.TutorialStepAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HGlowButton;
	import road.ui.manager.TipManager;
	
	import ddt.data.player.PlayerPropertyEvent;
	
	public final class UserGuideManager
	{
		public static const BUTTON_GUIDE:int = 0;
		public static const CONTROL_GUIDE:int = 1;
		
		private var loadFromServer:Boolean = false;
		
		private var _userGuideContainer:Sprite;
		private var _blackSprite:Sprite;
		public static const guideMC:MovieClip = new TutorialStepAsset();
		private var _currentStep:int;
		private var _progress:int;
		private var _currentStepData:Object;
		private var _guideDataLib:Dictionary;
		private var _buttonParent:DisplayObjectContainer;
		
		private var _bmdata:BitmapData;
		private var _bmp:Bitmap;
		
		private var _statDict:Dictionary;
		private var _saveDict:Dictionary;
		
		
		
		
		//Initialize
		public function UserGuideManager()
		{
			initData();
			initView();
			
		}
		private function initData():void{
			/** 统计 */
			_statDict = new Dictionary();
			_statDict[13] = 'weapon';
			_statDict[17] = 'trainer2';
			_statDict[29] = 'trainer2Over';
			_statDict[38] = 'payment';
			_statDict[46] = 'strenthern';
			_statDict[53] = 'guideBeforeGame';
			_statDict[55] = "guideGameStart"
			
			/** 进度恢复 */
			_saveDict = new Dictionary();
			_saveDict[11] = 10;
			_saveDict[13] = 14;
			_saveDict[28] = 29;
			_saveDict[31] = 33;
			_saveDict[38] = 39;
			_saveDict[41] = 42;
			_saveDict[46] = 47;
			_saveDict[47] = 48;
			_saveDict[49] = 49;
			_saveDict[51] = 52;
			_saveDict[57] = 99;
			
		}
		
		private function initView():void
		{
			if(_userGuideContainer){
				_userGuideContainer = null;
			}
			_userGuideContainer = new Sprite();
			
			_blackSprite = new Sprite();
			_blackSprite.graphics.beginFill(0x000000,.6);
			_blackSprite.graphics.drawRect(-2000,-2000,4000,4000);
			_blackSprite.graphics.endFill();
			
			_userGuideContainer.addChild(_blackSprite);
			_userGuideContainer.addChild(guideMC);
		}
		
		private function abortUserGuide(e:MouseEvent):void{
			abort();
		}
		//Singleton
		private static var _instance:UserGuideManager;
		public static function get Instance():UserGuideManager
		{
			if(_instance == null)
			{
				_instance = new UserGuideManager();
			}
			return _instance;
		}
		
		
		public function get stage():Stage{
				return _userGuideContainer.stage;
		}
		public function set currentStep(value:int):void{
			PlayerManager.Instance.Self.TutorialProgress = value;
		}
		public function get currentStep():int
		{
			 if(!loadFromServer){
				if(_progress < PlayerManager.Instance.Self.TutorialProgress){
					_progress = PlayerManager.Instance.Self.TutorialProgress;
					modiferProgress();
				}
				loadFromServer = true;
			}
			return _progress;
		} 
		public function beginUserGuide():void{
			_progress = 10;
			ChatManager.Instance.view.visible = true;
		} 
		public function beginUserGuide2():void{
			if(_progress <= 26 && _progress >= 13)
				_progress = 27;
		} 
		public function beginUserGuide3():void{
			if(_progress == 57)
				_progress = 59;
		} 
		public function setup():void
		{
			//PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__stepChange);
			
			_progress = PlayerManager.Instance.Self.TutorialProgress;
			modiferProgress();
		}
		private function modiferProgress():void{
			
			var tempProgress:int = 0;
			for(var i:int=0;i<=_progress;i++){
				if(_saveDict[i]){
					tempProgress = _saveDict[i];/** 在预设的步骤恢复 */
				}
				if(_statDict[i]){
					delete _statDict[i];/** 不进行重复的统计 */
				}
			}
			_progress = tempProgress;
		}
		private function __stepChange(event:PlayerPropertyEvent):void
		{
			if(event.changedProperties["TutorialProgress"])
			{
				if(getIsFinishTutorial())
				{
					dispose();
				}else
				{
					gotoStep(currentStep);
				}
			}
		}
		
		public function gotoStep(step:int):void
		{
			if(step<=_progress){
				return;
			}
			if(_currentStepData && (step != _currentStep))
			{
				if(_currentStepData.source){
					_currentStepData.source.removeEventListener(MouseEvent.CLICK,__clickHandler);
					var pos:Point = new Point(_currentStepData.source.x,_currentStepData.source.y);
						pos = _buttonParent.globalToLocal(pos);
						_currentStepData.source.x = pos.x;
						_currentStepData.source.y = pos.y;
						
					_buttonParent.addChild(_currentStepData.source)
				}
				 delete _guideDataLib[_currentStep];
			}
			_currentStepData = _guideDataLib[step];
			if(_currentStepData == null) return;
			_currentStep = step;
			if(_currentStepData.before != null){
				_currentStepData.before();
			}
			 if(_currentStepData.type == BUTTON_GUIDE)
			{
				var button:DisplayObject = _currentStepData.source;
				_buttonParent = button.parent;
				button.addEventListener(MouseEvent.CLICK,__clickHandler);
				if(_currentStepData.useMask){
					hideBlackSprite();
				}else{
					var offset:Point = new Point(button.x,button.y);
					offset = button.parent.localToGlobal(offset);
					button.x = offset.x;
					button.y = offset.y;
					_userGuideContainer.addChild(button);
					
					if(button is HGlowButton){
						(button as HGlowButton).glow = true;
					}
					showBlackSprite();
				}
			}else if(_currentStepData.type == CONTROL_GUIDE)
			{
				hideBlackSprite();
				_userGuideContainer.addEventListener(Event.ENTER_FRAME,__checkFinishTutorial);
			} 
			
			showMainline();
		}
		
		
		private function __clickHandler(event:MouseEvent):void
		{
			nextStep();
		}
		
		private function __checkFinishTutorial(event:Event):void
		{
			if(_guideDataLib[_currentStep] != null)
			{
				if(_guideDataLib[_currentStep].callback())
				{
					_userGuideContainer.removeEventListener(Event.ENTER_FRAME,__checkFinishTutorial);
					
					nextStep();
				}
			}
		}
		
		private function nextStep():void
		{
			hide();
			if(!_currentStepData.autoProgress)
				delete _guideDataLib[_currentStep+1];
			gotoStep(currentStep+1);
		}
		
		
		public function setupStep($step:int,$type:int,$before:Function = null,$source:Object = null,$autoProgress:Boolean = true,$useMask:Boolean = false):void
		{
			if($step <= _currentStep) return;
			if(_guideDataLib == null) _guideDataLib = new Dictionary();
			
			if(BUTTON_GUIDE == $type)
			{
				_guideDataLib[$step] = {type:$type,source:$source,before:$before,autoProgress:$autoProgress,useMask:$useMask};
			}else if(CONTROL_GUIDE == $type)
			{
				_guideDataLib[$step] = {type:$type,callback:$source,before:$before,autoProgress:$autoProgress};
			}
			if($step == _progress+1)
			{
				gotoStep($step);
			}
		}
		
		private function hideBlackSprite():void
		{
			if(_blackSprite.parent)_userGuideContainer.removeChild(_blackSprite);
		}
		
		private function showBlackSprite():void
		{
			_userGuideContainer.addChildAt(_blackSprite,0);
		}
		
		public function getIsFinishTutorial(step:int = 99):Boolean
		{
			//return currentStep >= step;
			return (currentStep >= step || PlayerManager.Instance.Self.Grade>4);
			
		}
		private var keyBoardHolder:Stage;
		private var focusHolder:Sprite;
		public function showMainline():void{
			trace(_currentStep);
			showMask("s"+String(_currentStep))
		}
		public function showBattle(step:int):void{
			hideBlackSprite();
			showMask("battle"+String(step));
			(guideMC["doneBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK,__onBtnClicked);
		}
		public function showTrainer(step:int,focus:Sprite):void{
			focusHolder = focus;
			hideBlackSprite();
			showMask("trainer"+String(step));
			(guideMC["doneBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK,__onBtnClicked);
		}
		private function __onBtnClicked(e:Event):void{
			SoundManager.instance.play("008");
			hideMask();
		}
		private function showMask(pos:String):void{
			var allLabels:Array = guideMC.currentLabels;
			var targetLabel:String = "s0";
			for(var i:int = 0;i<allLabels.length;i++)
			{
				if(allLabels[i].name == pos) 
				{
					targetLabel = pos;
					break;
				}
			}
			guideMC.gotoAndStop(targetLabel);
			TipManager.AddTippanel(_userGuideContainer);
			addKeyboardBlock();
		}
		private function addKeyboardBlock():void{
			if(keyBoardHolder){
				removeKeyboardBlock();
			}
			keyBoardHolder = _userGuideContainer.stage;
			keyBoardHolder.addEventListener(KeyboardEvent.KEY_DOWN,__onKeyDown,true,100);
			keyBoardHolder.addEventListener(KeyboardEvent.KEY_DOWN,__onKeyDown,false,100);
			
		}
		private function removeKeyboardBlock():void{
			if(keyBoardHolder){
				keyBoardHolder.removeEventListener(KeyboardEvent.KEY_DOWN,__onKeyDown,true);
				keyBoardHolder.removeEventListener(KeyboardEvent.KEY_DOWN,__onKeyDown,false);
				//if(keyBoardHolder.focus is SimpleButton){
				if(focusHolder){
					keyBoardHolder.focus = focusHolder;
					focusHolder = null;
				}else{
					if(keyBoardHolder.focus is SimpleButton){
						keyBoardHolder.focus = null;
					}
				}
				//}
				keyBoardHolder = null;
			}
		}
	   	private function __onKeyDown(e:KeyboardEvent):void{
			if(guideMC.currentLabel.substr(0,6) == "battle" || guideMC.currentLabel.substr(0,7) == "trainer"){
				if(e.keyCode == 13){//回车
					__onBtnClicked(null);
					removeKeyboardBlock()
					e.stopImmediatePropagation();
					return;
				}
			}
			if(!_userGuideContainer.parent){
				removeKeyboardBlock();
				return;
			}
			e.stopImmediatePropagation();
		}
		private function hideMask():void{
			removeKeyboardBlock();
			guideMC.gotoAndStop("s0");
			TipManager.RemoveTippanel(_userGuideContainer);
			guideMC.dispatchEvent(new Event(Event.CLOSE));
		}
		public function hide():void
		{
			hideMask();
			initView();//clear source;
			_progress = _currentStep;
			if(!_currentStepData){
				return;
			}
			if(_currentStepData.source is HGlowButton){
				(_currentStepData.source as HGlowButton).glow = false;
			}
			handleStatistic();
			sendProgressToServer();
		}
		public function alterMask():void{
			if(guideMC.currentLabel.charAt(0) ==  "a"){
				return ;
			}
			guideMC.gotoAndStop("a"+String(_currentStep));
		}
		public function switchStartButton(value:Boolean):void{
			if(!value){//start
				if(guideMC.currentLabel ==  "s57"){
					guideMC.gotoAndStop("a57"); 
				}
			}else{//cancel
				if(guideMC.currentLabel ==  "a57"){
					guideMC.gotoAndStop("s57"); 
				}
			}
		}
		public function abort():void{
			TipManager.RemoveTippanel(_userGuideContainer);
		}
		
		private function sendProgressToServer():void{
			SocketManager.Instance.out.sendUserGuideProgress(_currentStep);
			return;
		}
		private function handleStatistic():void{
			if(_statDict[_progress]){
					StatisticManager.Instance().startAction(_statDict[_progress],"yes");
			}
		}
		public function dispose():void
		{
			hide();
		}
		
		public function get userGuideContainer():Sprite
		{
			return _userGuideContainer;
		}
		
		public function beginBattle(trainerAsset:MovieClip):void{
		//	trainerAsset.addEventListener();
		}

	}
}