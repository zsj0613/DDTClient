package road.utils
{
	import flash.geom.Point;
	
	public class MathUtils
	{
		/**
		 *  
		 * @return 
		 * 度数转弧度
		 */		
		public static function AngleToRadian(angle:Number):Number
		{
			return angle / 180 * Math.PI;
		}
		
		/**
		 *  
		 * @return 
		 * 弧度转度数
		 */		
		public static function RadianToAngle(radian:Number):Number
		{
			return radian / Math.PI * 180;
		}
		
		public static function atan2(y:Number,x:Number):Number
		{
			return RadianToAngle(Math.atan2(y,x));
		}
		
		/**
		 * 计算由Point1到Point2的角度 
		 * @param point1
		 * @param point2
		 * @return 
		 * 
		 */		
		public static function GetAngleTwoPoint(point1:Point,point2:Point):Number
		{
			var disX:Number = point1.x - point2.x;
			var disY:Number = point1.y - point2.y;
			return Math.floor(RadianToAngle(Math.atan2(disY , disX)));
		}
		
		public static function cos(angle:Number):Number
		{
			return Math.cos(MathUtils.AngleToRadian(angle));
		}
		
		public static function sin(angle:Number):Number
		{
			return Math.sin(MathUtils.AngleToRadian(angle));
		}
	}
}