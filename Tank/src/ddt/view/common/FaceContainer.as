package ddt.view.common
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import road.ui.manager.TipManager;

	public class FaceContainer extends Sprite
	{
		private var _timer:Timer
		private var _face:MovieClip;
		private var _topLayer:Boolean;
		
		public function FaceContainer(topLayer:Boolean = false)
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
			clearFace();
		}
		
		public function clearFace():void
		{
			if(_face != null)
			{
				if(_face.parent)
				{
					_face.stop();
					_face.parent.removeChild(_face);
				}
				_face = null;
			}
			if(_timer)_timer.stop();
		}
		
		public function setFace(id:int):void
		{
			clearFace();
			_face =	FaceSource.getFaceById(id);
			if(_face != null)
			{
				_timer.reset();
				_timer.start();
				
				if(_topLayer)
				{
					if(id == 42)
						_face.scaleX = this.scaleX = 1;
					addChild(_face);
				}
				else
				{
					if(id == 42)
						_face.scaleX = this.scaleX = 1;
					else
						_face.scaleX = this.scaleX;
					
					addChild(_face);
				}
			}
		}
		
		public function dispose():void
		{
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
			_timer = null;
			clearFace();
			if(parent)
				parent.removeChild(this);
		}
	}
}