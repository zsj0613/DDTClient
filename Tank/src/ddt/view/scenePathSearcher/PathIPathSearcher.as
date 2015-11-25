package ddt.view.scenePathSearcher
{
	import flash.geom.Point;	
	
	public interface PathIPathSearcher
	{
		function search(from : Point,end : Point,hittest:PathIHitTester):Array;
	}
}