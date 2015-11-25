package ddt.data.game
{
	import flash.events.EventDispatcher;
	
	import ddt.data.BallInfo;
	
	public class Bomb extends EventDispatcher
	{	
		public var Id:int;
		public var X:int;
		public var Y:int;
		public var VX:int;
		public var VY:int;
		public var Actions:Array;
		public var Template:BallInfo;
		
		public var changedPartical:Array = null;
		
		private var i:int=0;
		
		private function checkFly(arr1:Array,arr2:Array):Boolean
		{
			if(int(arr1[0]) != int(arr2[0]))
			{
				return true;
			}
			return false;
		}
		
		public var IsHole : Boolean;	
		
		
		public static const FLY_BOMB:int = 3; //传送弹
	}
}