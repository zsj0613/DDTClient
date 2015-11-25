package ddt.fightLib
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.hframe.HFrame;
	
	import ddt.manager.FightLibManager;
	import ddt.manager.GameManager;
	import ddt.manager.LanguageMgr;
	import ddt.socket.GameInSocketOut;
	import tank.view.fightLib.FightLibQuestionAsset;
	
	public class FightLibQuestionFrame extends HFrame
	{
		private var _asset:FightLibQuestionAsset;
		private var _reAnswerBtn:HLabelButton;
		private var _viewTutorialBtn:HLabelButton;
		private var _answerBtn1:HBaseButton;
		private var _answerBtn2:HBaseButton;
		private var _answerBtn3:HBaseButton;
		
		private var _id:int;
		private var _title:String;
		private var _hasAnswered:int;
		private var _needAnswer:int;
		private var _totalQuestion:int;
		private var _question:String;
		private var _answer1:String;
		private var _answer2:String;
		private var _answer3:String;
		private var _timeLimit:int;
		
		private var _timer:Timer;
		
		public function FightLibQuestionFrame(id:int,title:String="",hasAnswered:int=0,needAnswer:int=0,totalQuestion:int=0,question:String="",answer1:String="",answer2:String="",answer3:String="",timeLimit:int=30)
		{
			super();
			_id = id;
			_title = title;
			_hasAnswered = hasAnswered;
			_needAnswer = needAnswer;
			_totalQuestion = totalQuestion;
			_question = question;
			_answer1 = answer1;
			_answer2 = answer2;
			_answer3 = answer3;
			_timeLimit = timeLimit;
			
			_timer = new Timer(1000,_timeLimit);
			initView();
			initEvents();
		}
		
		private function initView():void
		{
			titleText = _title;
			showBottom = false;
			showClose = false;
			autoDispose = true;
			blackGound = false;
			setSize(360,340);
			
			_asset = new FightLibQuestionAsset();
			_asset.timeTxt.text = String(_timeLimit);
			_asset.questionInfo.text = LanguageMgr.GetTranslation("ddt.fightLib.questionInfo",_totalQuestion,_needAnswer,_hasAnswered);
			_asset.question.text = _question;
			_asset.answer1.text = _answer1;
			_asset.answer2.text = _answer2;
			_asset.answer3.text = _answer3;
			_asset.answer1.mouseEnabled = _asset.answer2.mouseEnabled = _asset.answer3.mouseEnabled = false;
			_asset.x = 20;
			_asset.y = 40;
			
			_reAnswerBtn = new HLabelButton();
			_reAnswerBtn.label = LanguageMgr.GetTranslation("ddt.fightLib.FightLibQuestionFrame.reAnswer");
			_reAnswerBtn.x = 200;
			_reAnswerBtn.y = 190;
			_viewTutorialBtn = new HLabelButton();
			_viewTutorialBtn.label = LanguageMgr.GetTranslation("ddt.fightLib.FightLibQuestionFrame.viewTutorial");
			_viewTutorialBtn.x = 200;
			_viewTutorialBtn.y = 240;
			if(FightLibManager.Instance.reAnswerNum > 0)_asset.addChild(_reAnswerBtn);
			if(!FightLibManager.Instance.script.hasRestarted)_asset.addChild(_viewTutorialBtn);
			
			_answerBtn1 =new HBaseButton(_asset.answerBtn1);
			_answerBtn2 =new HBaseButton(_asset.answerBtn2);
			_answerBtn3 =new HBaseButton(_asset.answerBtn3);
			_answerBtn1.useBackgoundPos = _answerBtn2.useBackgoundPos = _answerBtn3.useBackgoundPos = true;
			_asset.addChild(_answerBtn1);
			_asset.addChild(_answerBtn2);
			_asset.addChild(_answerBtn3);
			_asset.addChild(_asset.answer1);
			_asset.addChild(_asset.answer2);
			_asset.addChild(_asset.answer3);
			_asset.addChild(_asset.titleTxt);
			_asset.titleTxt.mouseEnabled = _asset.titleTxt.mouseChildren = false;
			
			addContent(_asset);
		}
		
		private function initEvents():void
		{
			_answerBtn1.addEventListener(MouseEvent.CLICK,__selectAnswer);
			_answerBtn2.addEventListener(MouseEvent.CLICK,__selectAnswer);
			_answerBtn3.addEventListener(MouseEvent.CLICK,__selectAnswer);
			_reAnswerBtn.addEventListener(MouseEvent.CLICK,__reAnswer);
			_viewTutorialBtn.addEventListener(MouseEvent.CLICK,__viewTutorial);
			_timer.addEventListener(TimerEvent.TIMER,__timer);
			_timer.start();
		}
		
		private function removeEvents():void
		{
			_answerBtn1.removeEventListener(MouseEvent.CLICK,__selectAnswer);
			_answerBtn2.removeEventListener(MouseEvent.CLICK,__selectAnswer);
			_answerBtn3.removeEventListener(MouseEvent.CLICK,__selectAnswer);
			_reAnswerBtn.removeEventListener(MouseEvent.CLICK,__reAnswer);
			_viewTutorialBtn.removeEventListener(MouseEvent.CLICK,__viewTutorial);
			_timer.removeEventListener(TimerEvent.TIMER,__timer);
		}
		
		private function __selectAnswer(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(evt.currentTarget == _answerBtn1)
			{
				GameInSocketOut.sendFightLibAnswer(_id,0);
			}else if(evt.currentTarget == _answerBtn2)
			{
				GameInSocketOut.sendFightLibAnswer(_id,1);
			}else
			{
				GameInSocketOut.sendFightLibAnswer(_id,2);
			}
			GameInSocketOut.sendGameSkipNext(_timer.currentCount);
			_timer.removeEventListener(TimerEvent.TIMER,__timer);
			_timer.stop();
		}
		
		private function __reAnswer(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			GameInSocketOut.sendFightLibReanswer();
			FightLibManager.Instance.reAnswerNum --;
		}
		
		private function __viewTutorial(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			FightLibManager.Instance.script.restart();
			GameInSocketOut.sendClientScriptStart();
			close();
		}
		
		private function __timer(evt:TimerEvent):void
		{
			_asset.timeTxt.text = String(_timeLimit-_timer.currentCount);
			if(_timer.currentCount>=_timeLimit)
			{
				_timer.stop();
				GameInSocketOut.sendFightLibAnswer(_id,-1);
				GameInSocketOut.sendGameSkipNext(_timer.currentCount);
				close();
			}
		}
		
		override public function dispose():void
		{
			removeEvents();
			_reAnswerBtn.dispose();
			_viewTutorialBtn.dispose();
			_answerBtn1.dispose();
			_answerBtn2.dispose();
			_answerBtn3.dispose();
			_reAnswerBtn = null;
			_viewTutorialBtn = null;
			_answerBtn1 = null;
			_answerBtn2 = null;
			_answerBtn3 = null;
			_timer.stop();
			_timer = null;
			if(_asset)
			{
				if(_asset.parent)
				{
					_asset.parent.removeChild(_asset);
				}
				_asset = null;
			}
			super.dispose();
		}
	}
}