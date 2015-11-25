package ddt.gameover.torphy
{
	import flash.events.Event;
	
	import ddt.game.CountDownView;

	import webgame.crazytank.game.view.TrophyCountDownAsset;

	public class TrophyCountDownView extends TrophyCountDownAsset
	{
		
		private static const TIME:int = 11;
//		private var _timer:Timer;
		private var _countDown:CountDownView;
		private var _controller:ITropyController;

		
		public function TrophyCountDownView(controller:ITropyController)
		{
			_controller = controller;
			init();
		}
		
		private function init():void
		{
			_countDown = new CountDownView(TIME,false);
			addChild(_countDown);
			countDown_txt.visible = false;
			_countDown.x = countDown_txt.x;
			_countDown.y = countDown_txt.y;
		}
		
		
		public function startCountDown():void
		{
			//_countDown.addEventListener(Event.COMPLETE,__timerComplete);
			//_countDown.startCountDown();
		}
		
		private function stopCountDown():void
		{
			_countDown.stopCountDown();
		}
		
		public function dispose():void
		{
			stopCountDown();
			_countDown.dispose();
			if(_countDown.parent)
			{
				removeChild(_countDown);
			}	
			_countDown = null;
			_controller = null;
			
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		
		
		private function __timerComplete(event:Event):void
		{
			//_controller.dispose();
		}
		
	}
}