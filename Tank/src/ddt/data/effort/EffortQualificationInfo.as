package ddt.data.effort
{
	public class EffortQualificationInfo
	{
		/**
		 * 成就ID对应EffortInfo的ID
		 */
		public var AchievementID:int;
		
		/**
		 *  条件ID
		 */
		public var CondictionID:int;
		
		/**
		 *  条件类型
		 */
		public var CondictionType:int;
		
		/**
		 *  条件类型的第1个控制字段
		 */
		public var Condiction_Para1:int;
		
		/**
		 *  条件类型的第2个控制字段
		 */
		public var Condiction_Para2:int;
		
		/**
		 *  条件类型的第2个控制字段的当前值
		 */
		public var para2_currentValue:int;
											
		public function EffortQualificationInfo()
		{
		}

	}
}