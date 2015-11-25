package ddt.game
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	import ddt.data.game.Living;
	import ddt.manager.QueueManager;
	
	public class ActionMovie extends Sprite
	{
		private var _movie:MovieClip;
		private var _labelLastFrames:Array = [];
		private var _soundControl:SoundTransform;
		public function gotoAndStop(frame : int) : void
		{
			if(_movie)_movie.gotoAndStop(frame);
		}
		
		public function get source():MovieClip
		{
			return _movie;
		}
		
		public function ActionMovie(movie:MovieClip)
		{
			_movie = movie;
			_movie.mouseEnabled = false;
			_movie.mouseChildren = false;
			_movie.scrollRect = null;
			_soundControl = new SoundTransform();
			_soundControl.volume = 0;
			_movie.soundTransform = _soundControl;
			initMovie();
		}
		private var _labelLastFrame:Dictionary = new Dictionary();
		private function initMovie():void
		{
			addChild(_movie);
			var labels:Array = _movie.currentLabels;
			for(var i:int = 0;i<labels.length;i++)
			{
				if(i == 0) continue;
				_labelLastFrame[labels[i-1].name]=int(labels[i].frame-1);
			}
			_labelLastFrame[labels[labels.length -1].name]=int(_movie.totalFrames);
		}
		
		public var currentAction:String = Living.STAND_ACTION;
		public var lastAction:String = "";
		private var _callBacks:Dictionary = new Dictionary();
		private var _argsDic:Dictionary = new Dictionary();
		private var _actionEnded:Boolean = false;
		public function doAction(type:String,callBack:Function = null,args:Array = null):void
		{
			if(_movie == null) return;
			if(!hasThisAction(type))
			{
					if(callBack != null) callFun(callBack,args);
					return;
			}
			
			if(!_actionEnded)
			{
				if(_callBacks[currentAction] != null) callCallBack(currentAction);
				dispatchEvent(new ActionMovieEvent(ActionMovieEvent.MOVIE_PLAY_FINISH,currentAction,lastAction));
				_actionEnded = true;
			}
			
			_actionEnded = false;
			if(callBack != null && _callBacks[type] != callBack)
			{
				_callBacks[type] = callBack;
				_argsDic[type] = args;
			}
			
			lastAction = currentAction;
			currentAction = type;
			_soundControl.volume = 1;
			_movie.soundTransform = _soundControl;
			_movie.gotoAndPlay(currentAction);
			_movie.addEventListener(Event.ENTER_FRAME,loop);
			dispatchEvent(new ActionMovieEvent(ActionMovieEvent.MOVIE_PLAY_START,type,currentAction));
		}
		
		private function hasThisAction(type:String):Boolean
		{
			var result:Boolean = false;
			for each(var i:FrameLabel in _movie.currentLabels)
			{
				if(i.name == type)
				{
					result = true;
					break;
				}
			}
			return result;
		}
		
		private function loop(e:Event):void
		{
			if(_movie && (_movie.currentFrame == _labelLastFrame[currentAction] || _movie.currentLabel != currentAction))
			{
				_movie.removeEventListener(Event.ENTER_FRAME,loop);
				_actionEnded = true;
				if( _callBacks[currentAction] != null)
				{
					callCallBack(currentAction);
				}
				dispatchEvent(new ActionMovieEvent(ActionMovieEvent.MOVIE_PLAY_FINISH,currentAction,lastAction));
			}
		}
		
		private function callCallBack(key:String):void
		{
			var args:Array = _argsDic[key];
			if(_callBacks[key] == null) 
			{
				return;
			}
			callFun(_callBacks[key],args);
			deleteFun(key);
		}
		
		private function deleteFun(key:String):void
		{
			if(_callBacks)
			{
				_callBacks[key] = null;
				delete _callBacks[key];
			}
			if(_argsDic)
			{
				_argsDic[key] = null;
				delete _argsDic[key];
			}
		}
		
		private function callFun(fun:Function,args:Array):void
		{
			if(args == null ||args.length == 0)
			{
				fun();
			}else if(args.length == 1)
			{
				fun(args[0]);
			}else if(args.length == 2)
			{
				fun(args[0],args[1]);
			}else if(args.length == 3)
			{
				fun(args[0],args[1],args[2]);
			}else if(args.length == 4)
			{
				fun(args[0],args[1],args[2],args[3]);
			}
		}
		
		public function dispose():void
		{
			_soundControl.volume = 0;
			_movie.removeEventListener(Event.ENTER_FRAME,loop);
			stopMovieClip(_movie);
			_movie = null;
			_soundControl = null;
			_labelLastFrames = null;
			if(parent)
			{
				parent.removeChild(this);
			}
			_callBacks = null;
		}
		/**
		 * 
		 * @param mc mc在调用stop的时候，他的子对象不会stop，此方法用以停止掉mc里面的所有movieclip
		 * 
		 */		
		private function stopMovieClip(mc:MovieClip):void
		{
			if(mc)
			{
				mc.gotoAndStop(1);
				if(mc.numChildren>0)
				{
					for(var i:int=0; i< mc.numChildren; i++)
					{
						stopMovieClip((mc.getChildAt(i) as MovieClip));
					}
				}
			}
		}
	}
}