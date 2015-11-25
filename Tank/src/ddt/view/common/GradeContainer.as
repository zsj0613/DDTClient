package ddt.view.common
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.crazyTank.view.LevelUpFaileMC;
	
	public class GradeContainer extends Sprite
	{
		private var _timer:Timer
		private var _grade:MovieClip;
		private var _topLayer:Boolean;
		
		public function GradeContainer(topLayer:Boolean = false)
		{
			super();
			_topLayer = topLayer;
			init();
		}
		
		private function init():void
		{
			_timer = new Timer(6000,1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
		}
		
		private function __timerComplete(evt:TimerEvent):void
		{
			clearGrade();
		}
		
		public function clearGrade():void
		{
			if(_grade != null)
			{
				if(_grade.parent)
				{
					_grade.stop();
					_grade["lv_mc"]["lv_mc_init"]["video"].clear();
					_grade.parent.removeChild(_grade);
				}
				_grade = null;
			}
			
			if(_timer)
				_timer.stop();
		}
		
		public function setGrade(grade:MovieClip):void
		{
			clearGrade();
			
			_grade = grade;
			
			if(_grade != null)
			{
				_timer.reset();
				_timer.start();
				
				addChild(_grade);
			}
		}
		
		public function dispose():void
		{
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
			_timer = null;
			clearGrade();
			if(parent)
				parent.removeChild(this);
		}
	}
}













