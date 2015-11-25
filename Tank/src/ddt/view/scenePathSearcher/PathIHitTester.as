package ddt.view.scenePathSearcher
{
	import flash.geom.Point;
	
	public interface PathIHitTester
	{
		/*
		*	point为地图坐标的点
		*/
		function isHit(point:Point):Boolean;
		function getNextMoveAblePoint(point:Point,angle:Number,step:Number,max:Number):Point;
		
	}
}