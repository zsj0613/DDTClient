package ddt.game.objects
{
	import ddt.data.game.Living;
	
	public class ActionType
	{
		public static const PICK:int    = 1;
        public static const BOMB:int    = 2;
        public static const START_MOVE:int = 3;
        public static const FLY_OUT:int    = 4;
        public static const KILL_PLAYER:int = 5;
        public static const TRANSLATE:int   = 6;
        public static const FORZEN:int      = 7;
        public static const CHANGE_SPEED:int = 8;
        public static const UNFORZEN:int = 9;
        public static const DANER:int = 10;
        public static const CURE:int = 11;
        
        public static const GEM_DEFENSE_CHANGED : int = 12;//珠宝防御
        public static const CHANGE_STATE:int = 13;
        
        public static const DO_ACTION:int = 14;
        
        public static const ACTION_TYPES:Array = [Living.STAND_ACTION,Living.ANGRY_ACTION,Living.DEFENCE_ACTION];
	}
}