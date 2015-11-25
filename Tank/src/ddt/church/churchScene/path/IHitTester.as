package ddt.church.churchScene.path
{
	import flash.geom.Point;
	
	public interface IHitTester
	{
		/*
		*	point为地图坐标的点
		*/
		function isHit(point:Point):Boolean;
		function getNextMoveAblePoint(point:Point,angle:Number,step:Number,max:Number):Point;
		
	}
}