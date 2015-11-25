package ddt.data
{
	import ddt.data.goods.InventoryItemInfo;
	
	public class WeaponInfo
	{

		/**
		 * 武器转角的速度 
		 */		
		public static var ROTATITON_SPEED:Number = 1;
		
		private var _info:InventoryItemInfo;
		
		/**
		 * 武器最大最小角度 
		 */		
		public var armMaxAngle:Number = 90;
		public var armMinAngle:Number = 50;
		
		public var commonBall:int;
		
		public var skillBall:int;
		
		/**
		 * 武器的动作 0 为投掷 1为发射 
		 */		
		public var actionType:int;
		
		/**
		 * 必杀技能的动画 
		 */		
		public var specialSkillMovie:int;
		
		/**
		 * 
		 * @param 炼化等级
		 * 
		 */
		public var refineryLevel:int;		
		
		public function WeaponInfo(info:InventoryItemInfo)
		{
			_info = info;
			armMinAngle = Number(info.Property5);
			armMaxAngle = Number(info.Property6);
			commonBall = Number(info.Property1);
			skillBall = Number(info.Property2);
			actionType = Number(info.Property3);
			specialSkillMovie = int(info.Property4);
			refineryLevel = int(info.Refinery);
		}
		
		public function dispose():void
		{
			_info = null;
		}
	}
}