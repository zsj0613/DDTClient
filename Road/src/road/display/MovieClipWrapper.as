package road.display
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[Event(name="complete",type="flash.events.Event")]
	public class MovieClipWrapper extends Sprite
	{
		private var _movie:MovieClip;
		
		public var repeat:Boolean;
		
		public var autoDisappear:Boolean;
		
		public function MovieClipWrapper(movie:MovieClip,autoplay:Boolean = false,autodisappear:Boolean = false)
		{
			_movie = movie;
//			_movie.addFrameScript(_movie.framesLoaded-1,__endFrame);
			autoDisappear = autodisappear;
			if(!autoplay)
			{
				_movie.gotoAndStop(1);
			}else
			{
				_movie.addEventListener(Event.ENTER_FRAME,__frameHandler);
			}
			addChild(_movie);
		}
		
		public function gotoAndPlay(frame:Object):void
		{
			_movie.addEventListener(Event.ENTER_FRAME,__frameHandler);
			_movie.gotoAndPlay(frame);
		}
		
		public function gotoAndStop(frame:Object):void
		{
			_movie.addEventListener(Event.ENTER_FRAME,__frameHandler);
			_movie.gotoAndStop(frame);
		}
		
		public function addFrameScriptAt(index:Number,func:Function):void
		{
			if(index == _movie.framesLoaded)
			{
				throw new Error("You can't add scprit at that frame,The MovieClipWrapper used for COMPLETE event!");
			}
			else
			{
				_movie.addFrameScript(index,func);
			}
		}
		
		public function play():void
		{
			_movie.addEventListener(Event.ENTER_FRAME,__frameHandler);
			_movie.play();
			if(_movie.framesLoaded <= 1)
			{
				stop();
			}
		}
		
		public function stop():void
		{
			_movie.removeEventListener(Event.ENTER_FRAME,__frameHandler);
			dispatchEvent(new Event(Event.COMPLETE));
			if(autoDisappear && parent)
			{
				parent.removeChild(this);
			}
			_movie.stop();
			_movie = null;
		}
		
		private function __frameHandler(e:Event):void
		{
			if(_movie.currentFrame == _movie.totalFrames)
			{
				__endFrame();
			}
		}
		
		private function __endFrame():void
		{
			if(repeat)
			{
				_movie.gotoAndPlay(1);
			}
			else
			{
				stop();
			}
		}
	}
}