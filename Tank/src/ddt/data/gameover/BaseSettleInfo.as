package ddt.data.gameover
{
	public class BaseSettleInfo
	{
		/**
		 *玩家ID 
		 */		
		public var playerid:int;
		
		/**
		 * 玩家等级
		 */		
		public var level:int;
		/**
		 * 玩家输出伤害值
		 */		
		public var hert:uint;
		public var hertAll:uint;
		
		/**
		 * 玩家治疗的HP值
		 */		
		public var treatment:uint;
		public var treatmentAll:uint;
		/**
		 * 命中值
		 */		
		public var made:int;
		public var madeAll:int;
		/**
		 * 玩家所得经验值
		 */		
		public var exp:uint;
		public var expAll:uint;
		/**
		 * 评分等级
		 */		
		public var graded:uint;
		public var gradedAll:uint;
		/**
		 * 是否能进入隐藏关卡
		 */		
		public var canEnterHidden:Boolean;
		/**
		 *得分 
		 */		
		public var score:int;
		public var scoreAll:int;
	}
}