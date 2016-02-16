package ddt.game.animations
{
	import flash.display.DisplayObject;
	
	public class AnimationSet
	{
		private var _movie:DisplayObject;
		private var _running:Boolean;
		private var _current:IAnimate;
		
		private var _stageWidth:Number;
		private var _stageHeight:Number;
		private var _minX:Number;
		private var _minY:Number;
		public function get stageWidth():Number
		{
			return _stageWidth;
		}
		
		public function get stageHeight():Number
		{
			return _stageHeight;
		}
		public function get movie():DisplayObject{
			return _movie;
		}
		
		public function get minX():Number
		{
			return _minX;
		}
		
		public function get minY():Number
		{
			return _minY;
		}
		
		public function get current():IAnimate
		{
			return _current;
		}
		
		public function AnimationSet(movie:DisplayObject,stageWidth:Number,stageHeight:Number)
		{
			_movie = movie;
			_running = true;
			_current = null;
			_stageHeight = stageHeight;
			_stageWidth  = stageWidth;
			_minX = - _movie.width + stageWidth;
			_minY = - _movie.height  + stageHeight;
		}
		
		public function addAnimation(anit:IAnimate):void
		{
			if(_current)
			{
          		if(_current.level <= anit.level && _current.canReplace(anit))
				{
					_current.cancel();
					_current = anit;	
					_current.prepare(this);
				}
			}
			else
			{
				_current = anit;
				_current.prepare(this);
			}       
		}
		
		public function pause():void
		{
			_running = false;
		}
		
		public function play():void
		{
			_running = true;
		}
		
		public function dispose():void
		{
			if(_current)
			{
				_current.cancel();
				_current = null;
			}
		}
		
		public function clear():void
		{
			if(_current!=null)
			{
				_current.cancel();
			}
			_current = null;
		}
		
		public function update():Boolean
		{
			if(_running && _current)
			{
				
				if(_current.canAct())
				{
					return _current.update(_movie);
				}
				else
				{
					_current = null;
				}
			}
			return false;
		}

	}
}