package ddt.church.player
{
	import flash.geom.Point;
	
	public class Direction
	{
		/* 16度,两个面 ,四个方向*/
		public static const RT:Direction = new Direction(1,false);
		public static const LT:Direction = new Direction(1,true);
		public static const RB:Direction = new Direction(0,true);
		public static const LB:Direction = new Direction(0,false);		
		
		private var _toward:uint;
		private var _isMirror:Boolean;
		
		public function get toward():uint
		{
			return _toward;
		}
		public function get isMirror():Boolean
		{
			return _isMirror;
		}
		
		public function Direction(toward:uint,isMirror:Boolean)
		{
			this._toward = toward;
			this._isMirror = isMirror;
		}
		
		public static function getDirection(thisP:Point,nextP:Point):Direction
		{
			var degrees:Number = Direction.getDegrees(thisP,nextP);
			
			if(degrees>=0&&degrees<90)
			{
				return Direction.RT;
			}else if(degrees>=90&&degrees<180)
			{
				return Direction.LT;
			}else if(degrees>=180&&degrees<270)
			{
				return Direction.LB;
			}else if(degrees>=270&&degrees<360)
			{
				return Direction.RB;
			}else
			{
				return Direction.RB;
			}
		}
		
		public static function getDegrees(thisP:Point,nextP:Point):Number
		{
			var degrees:Number = Math.atan2(thisP.y-nextP.y,nextP.x-thisP.x)*180/Math.PI;
			
			if(degrees<0)
			{
				degrees+=360;
			}
			return degrees;
		}
	}
}