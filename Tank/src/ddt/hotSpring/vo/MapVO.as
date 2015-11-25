package ddt.hotSpring.vo
{
	public class MapVO
	{
		private var _mapWidth:Number=1200;
		private var _mapHeight:Number=1077;
		
		/**
		 * 温泉房间地图总宽
		 */		
		public function get mapWidth():Number
		{
			return _mapWidth;
		}
		
		/**
		 * 温泉地图总高
		 */		
		public function get mapHeight():Number
		{
			return _mapHeight;
		}
	}
}