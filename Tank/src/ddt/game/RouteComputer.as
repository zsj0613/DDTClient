package ddt.game
{
	import flash.geom.Point;
	
	import phy.maps.Map;
	import phy.object.PhysicalObj;
	
	import ddt.manager.GameManager;
	import ddt.manager.StateManager;

	public class RouteComputer
	{
		private static var DELAY_TIME:Number = 0.04;
		private var _map:Map;
		
		public function RouteComputer(map:Map)
		{
			_map = map;
		}
		
		public function getPath(angle:int,power:int):Array
		{
			var obj:PhysicalObj = new PhysicalObj(0,1,10,70,240,1);
			obj.x = GameManager.Instance.Current.selfGamePlayer.pos.x;
			obj.y = GameManager.Instance.Current.selfGamePlayer.pos.y;
			obj.setSpeedXY(new Point(getVx(angle,power),getVy(angle,power)));
			obj.setCollideRect(-3,-3,6,6);
			_map.addPhysical(obj);
			obj.startMoving();
			var result:Array = [];
			while(obj.isMoving())
			{
				result.push(new Point(obj.x,obj.y));
				obj.update(DELAY_TIME);
			}
			return result;
		}
		
		private function getVx(angle:int,power:int):Number
		{
			var vx:Number = power * Math.cos((angle / 180 * Math.PI));
			return vx;
		}
		
		private function getVy(angle:int,power:int):Number
		{
			var vy:Number = power * Math.sin((angle / 180 * Math.PI));
			return vy;
		}
	}
}