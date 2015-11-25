package ddt.church.churchScene.path
{
	/**
	 * @author core-S
	 */
	import flash.geom.Point; 

	public class AstarPoint extends Point{
		public var g:int;
		public var h:int;
		public var f:int;
		public var source_point:AstarPoint;
		public function AstarPoint(x:int=0,y:int=0){
			super(x,y);
			source_point=null;
		}
	}
}
