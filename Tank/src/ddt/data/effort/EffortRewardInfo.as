package ddt.data.effort
{
	public class EffortRewardInfo
	{
		/**
		 *  成就ID对应EffortInfo的ID
		 */
		public var AchievementID:int;
		
		/**
		 *  奖励类型0表空，1表称号，2表图标，3表物品
		 */
		public var RewardType:int;
		
		/**
		 *  扩展字段
		 */
		public var RewardPara:String;
		
		/**
		 *  奖励品的编号
		 */
		public var RewardValueId:int;
		
		/**
		 *  奖励品的数量
		 */
		public var RewardCount:int;
							
		public function EffortRewardInfo()
		{
		}

	}
}