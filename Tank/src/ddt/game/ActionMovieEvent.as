package ddt.game
{
	import flash.events.Event;

	public class ActionMovieEvent extends Event
	{
		public static const MOVIE_PLAY_START:String = "moviePlayStart";
		public static const MOVIE_PLAY_FINISH:String = "moviePlayFinish";
		public var action:String;
		public var lastAction:String;
		public function ActionMovieEvent(type:String,actionType:String,lastActionType:String)
		{
			action = actionType;
			lastAction = lastActionType;
			super(type);
		}
		
	}
}