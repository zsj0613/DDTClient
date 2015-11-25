package ddt.manager
{
	import flash.events.Event;
	
	import ddt.data.effort.EffortInfo;
	import ddt.states.StateType;
	import ddt.view.effort.EffortMovieClipView;

	public class EffortMovieClipManager
	{
		private var infoQueue:Array;
		private var currentMoive:EffortMovieClipView;
		public function EffortMovieClipManager()
		{
			infoQueue = [];
		}
		
		public function addQueue(info:EffortInfo):void
		{
			if(infoQueue.length<=1)
			{
				infoQueue.push(info);
			}else
			{
				return;
			}
			if(StateManager.currentStateType != StateType.FIGHTING)
			{
				playMovie();
			}
		}
		
		public function show():void
		{
			playMovie();
		}
		
		private function playMovie():void
		{
			if(infoQueue && infoQueue[0])
			{
				if(!currentMoive)
				{
					currentMoive = new EffortMovieClipView(infoQueue[0]);
					currentMoive.addEventListener(EffortMovieClipView.MOVIE_END , __movieEnd);
				}
			}
		}
		
		private function __movieEnd(evt:Event):void
		{
			infoQueue.shift();
			if(currentMoive)
			{
				currentMoive.removeEventListener(EffortMovieClipView.MOVIE_END , __movieEnd);
				currentMoive.dispose();
			}
			currentMoive = null
			playMovie();
		}
		
		private static var _instance:EffortMovieClipManager;
		public static function get Instance():EffortMovieClipManager
		{
			if(_instance == null)
			{
				_instance = new EffortMovieClipManager();
			}
			return _instance;
		}
	}
}