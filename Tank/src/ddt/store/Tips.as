package ddt.store
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.crazyTank.view.storeII.StoreIIFailAsset;
	import game.crazyTank.view.storeII.StoreIISuccessAsset;
	
	import road.manager.SoundManager;

	public class Tips extends Sprite
	{
		private var _successTip:StoreIISuccessAsset;
		private var _failTip:StoreIIFailAsset;
		private var _timer:Timer;
		public var isDisplayerTip : Boolean = true;
		
		public function Tips()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_successTip = new StoreIISuccessAsset();
			_failTip = new StoreIIFailAsset();
			
			_successTip.addFrameScript(41,tipsOver);
			_failTip.addFrameScript(41,tipsOver);
			
			_timer = new Timer(7500,1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
		}
		
		public function showSuccess():void
		{
			if(isDisplayerTip)
			{
				addChild(_successTip);
				_successTip.play();
			}
			SoundManager.Instance.pauseMusic();
			SoundManager.Instance.play("063");
			_timer.start();
		}
		
		public function showFail():void
		{
			if(isDisplayerTip)
			{
				addChild(_failTip);
				_failTip.play();
			}
			SoundManager.Instance.pauseMusic();
			SoundManager.Instance.play("064");
			_timer.start();
		}
		
		private function tipsOver():void
		{
			removeTips();
		}
		
		private function __timerComplete(evt:TimerEvent):void
		{
			_timer.reset();
			SoundManager.Instance.resumeMusic();
			SoundManager.Instance.stop("063");
			SoundManager.Instance.stop("064");
		}
		
		private function removeTips():void
		{
			_successTip.stop();
			_failTip.stop();
			if(_successTip.parent)_successTip.parent.removeChild(_successTip);
			if(_failTip.parent)_failTip.parent.removeChild(_failTip);
		}
		
		public function dispose():void
		{
			_successTip.addFrameScript(41,null);
			_failTip.addFrameScript(41,null);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
			_timer = null;
			SoundManager.Instance.resumeMusic();
			SoundManager.Instance.stop("063");
			SoundManager.Instance.stop("064");
			removeTips();
			if(parent)parent.removeChild(this);
		}
	}
}