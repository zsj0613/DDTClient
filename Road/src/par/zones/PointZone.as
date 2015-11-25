package par.zones
{
	import flash.geom.Point;
	
	import road.math.randRange;


	public class PointZone implements IEmitteZone
	{
		private var _pos:Point;
		
		private var _raduis:uint;
		
		private var _onlyedge:Boolean;
		
		public function PointZone(pos:Point,raduis:uint = 1,onlyedge:Boolean = true)
		{
			_pos = pos;
			_raduis = raduis;
			_onlyedge = onlyedge;
		}

		public function get location():Point
		{
			var r:Number = _onlyedge ? _raduis : randRange(0,_raduis);
			return _pos.clone().add(Point.polar(r,randRange(0,3.141 * 2)));
		}
		
		
		
	}
}