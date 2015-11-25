package ddt.events
{
	import flash.events.Event;

	public class RoomEvent extends Event
	{
		public static const CHANGED:String = "changed";
		public static const ROOMPLACE_CHANGED:String = "roomplaceChanged";
		public static const PLAYER_STATE_CHANGED:String = "playerStateChanged"
		public static const WAITGAMEFAILED:String = "waitgamefailed";
		public static const WAITGAMERECV:String = "waitgamerecv";
		public static const WAITGAMECANCEL:String = "waitgamecancel";
		public static const GAMESTYLE:String = "gamestyle";
		public static const STATE_CHANGED:String = "stateChanged"
		public static const START_LOADING:String = "startLoading";
		public static const WAITSEC30:String = "waitSec30";
		public static const LOADING_PROGRESS:String = "loadingProgress";
		public static const TEAM_CHANGE:String = "";
		public static const HOST_LEAVE:String  ="Hostleave";
		public static const ALLOW_CROSS_CHANGE:String = "allowCrossChange";
		
		private var _params:Array;
		public function get params():Array
		{
			return _params;
		}
		
		public function RoomEvent(type:String,...arg)
		{
			super(type);
			_params = arg;
		}
		
	}
}