package ddt.church.churchScene.path
{
	import flash.geom.Point;	
	
	public interface IPathSearcher
	{
		function search(from : Point,end : Point,hittest:IHitTester):Array;
	}
}