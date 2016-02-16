package ddt.game
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import game.crazyTank.view.InfoMovieAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	
	import ddt.manager.GameManager;

	public class DungeonHelpView extends InfoMovieAsset
	{
		private var _isFirst  : Boolean;
		private var _closeBtn : HBaseButton;
        private var _time     : Timer;
		public function DungeonHelpView()
		{
			super();
			_isFirst                                                   = true;
			this.buttonMode                                            = false;
			this.mouseEnabled                      = false;
			this.Mc.winTxt1.selectable = this.Mc.lostTxt1.selectable     = false;
			this.Mc.winTxt2.selectable = this.Mc.lostTxt2.selectable     = false;
			this.Mc.winTxt1.mouseEnabled = this.Mc.lostTxt1.mouseEnabled = false;
			this.Mc.winTxt2.mouseEnabled = this.Mc.lostTxt2.mouseEnabled = false;
			this.visible                                               = false;
			
			Mc.clostBtn.mouseEnabled = Mc.clostBtn.mouseChildren       = true;
			Mc.clostBtn.buttonMode = true;
			
			_closeBtn = new HBaseButton(Mc.clostBtn);
			_closeBtn.useBackgoundPos = true;
			Mc.addChild(_closeBtn);
			Mc.winTxt1.text = "";
			Mc.lostTxt1.text = "";
			Mc.winTxt2.text = "";
			Mc.lostTxt2.text = "";
			Mc.arrow1.visible    = false;
			Mc.arrow2.visible    = false;
			Mc.arrow3.visible    = false;
			Mc.arrow4.visible    = false;
			
			_closeBtn.addEventListener(MouseEvent.CLICK, __closeHandler);
			addFrameScript(1,__displayer,9,__setText,38,__sleepOrStop);
			addEventListener(MouseEvent.CLICK,          __closeHandler);
		}
		public function switchVisible() : void
		{
			if(currentFrame > 10 && currentFrame <= 39)
			{
				gotoAndPlay("out");
			}
			else if(currentFrame > 50)
			{
				gotoAndPlay("in");
			}
		}
		
		private function __closeHandler(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			if(this.currentLabel != "out")this.gotoAndPlay("out");
		}
		private function __setText() : void
		{
			if(Mc)
			{
				var winArr : Array = GameManager.Instance.Current.missionInfo.success.split("<br>");
				var lostArr : Array = GameManager.Instance.Current.missionInfo.failure.split("<br>");
				Mc.winTxt1.htmlText  = winArr[0];
				Mc.arrow1.y = Mc.winTxt1.y + 5;
				Mc.arrow1.visible    = true;
				if(winArr.length >= 2)
				{
					Mc.winTxt2.htmlText  = winArr[1];
					Mc.winTxt2.y         = Mc.winTxt1.y + Mc.winTxt1.textHeight + 11;
					Mc.arrow2.y          = Mc.winTxt2.y + 5;
					Mc.arrow2.visible    = true;
				}
				else
				{
					Mc.arrow2.visible    = false;
				}
				
				Mc.lostTxt1.htmlText = lostArr[0];
				Mc.arrow3.y = Mc.lostTxt1.y + 5;
				Mc.arrow3.visible = true;
				if(lostArr.length >= 2)
				{
					Mc.lostTxt2.htmlText = lostArr[1];
					Mc.lostTxt2.y        = Mc.lostTxt1.y + Mc.lostTxt1.textHeight + 11;
					Mc.arrow4.y = Mc.lostTxt2.y + 5;
					Mc.arrow4.visible = true;
				}
				else
				{
					Mc.arrow4.visible = false;
				}
			}
		}
		private function __displayer() : void
		{
			this.visible = true;
		}
		private function __sleepOrStop() : void
		{
			stop();
			if(_isFirst)
			{
				_time = new Timer(2000,1);
				_time.addEventListener(TimerEvent.TIMER_COMPLETE, __timerComplete);
				_time.start();
				_isFirst = false;
			}
		}
		private function __timerComplete(evt : TimerEvent) : void
		{
			if(currentFrame < 42)gotoAndPlay("out");
			clearTime();
		}
		private function clearTime() : void
		{
			if(_time)
			{
				_time.removeEventListener(TimerEvent.TIMER_COMPLETE, __timerComplete);
				_time.stop();
			}
			_time = null;
		}
		
		
		public function dispose() : void
		{
			clearTime();
			if(_closeBtn)
			{
				_closeBtn.removeEventListener(MouseEvent.CLICK, __closeHandler);
				_closeBtn.dispose();
			}
			removeEventListener(MouseEvent.CLICK,          __closeHandler);
			_closeBtn = null;
			addFrameScript(1,null,9,null,38,null);
			if(this.parent)this.parent.removeChild(this);
		}
		
	}
}