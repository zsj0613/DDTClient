package ddt.consortia.data
{
	/**
	 * 用户申请加入公会
	 * @author Administrator
	 * 
	 */	
	public class ConsortiaApplyInfo
	{
		public function ConsortiaApplyInfo()
		{
		}
		
		public var ID:int;
		public var ApplyDate:String;
		public var ConsortiaID:int;
		public var ConsortiaName:String;
		public var Remark:String;
		public var UserID:int;
		public var UserName:String;
		public var UserLevel:int;
		public var Repute:int;
		public var Win:int;
		public var Total:int;
		/**
		 * 战斗力
		 * */
		public var FightPower:int;
	}
}