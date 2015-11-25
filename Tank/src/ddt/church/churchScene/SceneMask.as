package ddt.church.churchScene
{
	import Tank.church.ChurchCountDownAsset;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import road.manager.SoundManager;
	import road.ui.manager.TipManager;
	
	import ddt.manager.ChatManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.view.chatsystem.ChatData;
	import ddt.view.chatsystem.ChatInputView;
	
	public class SceneMask extends Sprite
	{
		private var _controler:SceneControler;
		
		private var _timer:Timer;
		private var _totalTimes:int = 10;
		
		private var countDownMovie:MovieClip;
		private var switchMovie:SwitchMovie;
		
		public function SceneMask(controler:SceneControler)
		{
			this._controler = controler;
			
			init()
		}
		
		private function init():void
		{
			countDownMovie = new ChurchCountDownAsset();
			countDownMovie.gotoAndStop(1);
			TipManager.AddTippanel(countDownMovie,true);
			
			_timer = new Timer(1000,11);
			_timer.addEventListener(TimerEvent.TIMER,__timerAlarm);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
			_timer.start();
		}
		
		private function __timerAlarm(event:TimerEvent):void
		{
			_totalTimes--;
			if(_totalTimes%2&&_totalTimes>=0)
			{
				SoundManager.instance.play("050");
			}
			
			countDownMovie.nextFrame();
			
			if(_totalTimes>=0)
			{
//				showAlarm(_totalTimes);
			}
		}
		
		private function __timerComplete(event:TimerEvent):void
		{
			SoundManager.instance.playMusic("3001");
			_timer.removeEventListener(TimerEvent.TIMER,__timerAlarm);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
			
			switchMovie = new SwitchMovie(false);
			switchMovie.addEventListener(MouseEvent.CLICK,__click);
			switchMovie.addEventListener(SwitchMovie.SWITCH_COMPLETE,__switchComplete);
			addChild(switchMovie);
			switchMovie.playMovie();
			
			if(countDownMovie &&countDownMovie.parent)
			{
				countDownMovie.parent.removeChild(countDownMovie);
			}
		}
		
		public function showMaskMovie():void
		{
			switchMovie.playMovie();
		}
		
		private function showAlarm(value:uint):void
		{
			var chatMsg:ChatData = new ChatData();
			chatMsg.channel = ChatInputView.SYS_NOTICE;
			chatMsg.msg = LanguageMgr.GetTranslation("church.churchScene.SceneMask.chatMsg.msg")+value;
			ChatManager.Instance.chat(chatMsg);
		}

		private function __click(event:MouseEvent):void
		{
			MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.SceneMask.click"));
			//MessageTipManager.getInstance().show("仪式进行中，无法移动");
		}
		
		private function __switchComplete(event:Event):void
		{
			dispatchEvent(new Event(SwitchMovie.SWITCH_COMPLETE));
		}
		
		public function dispose():void
		{
			if(switchMovie)
			{
				switchMovie.removeEventListener(MouseEvent.CLICK,__click);
				switchMovie.removeEventListener(SwitchMovie.SWITCH_COMPLETE,__switchComplete);
				switchMovie.dispose();
			}
			removeEventListener(MouseEvent.CLICK,__click);
			if(parent)parent.removeChild(this);
		}
	}
}