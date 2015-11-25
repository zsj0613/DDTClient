package ddt.data.effort
{
	import fl.controls.progressBarClasses.IndeterminateBar;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import road.data.DictionaryData;
	
	import ddt.events.EffortEvent;
	
	public class EffortInfo extends EventDispatcher
	{
		/**
		* 成就ID
		*/
		public var ID:int;
		
		/**
		* 成就显示的位置，0为综合，1为角色，2为任务，3为副本，4为战斗
		*/
		public var PlaceID:int;
		
		/**
		* 在游戏中显示的成就标题
		*/
		public var Title:String;
		
		/**
		* 在游戏中显示的成就条件说明
		*/
		public var Detail:String;	
		
		/**
		* 接受该成就的最小等级，玩家等级小于此等级则无法接受该成就
		*/
		public var NeedMinLevel:int;
		
		/**
		* 接受该成就的最大等级，玩家等级大于此等级则无法接受该成就
		*/
		public var NeedMaxLevel:int;
		
		/**
		* 该成就的前置成就，可以有复数个，接到该成就需要完成所有前置成就
		*/		
		public var PreAchievementID:String;
		
		/**
		* 领取此成就是否有特殊要求（备用）
		*/
		public var IsOther:Boolean;
		
		/**
		* 0表普通成就1表段式成就
		*/
		public var AchievementType:int;
		
		/**
		* 是否可展开，0表不可展开1表可展开。
		*/
		public var CanHide:Boolean;
		
		/**
		* 有时间限制的成就开始的时间
		*/
		public var StartDate:Date;
		
		/**
		* 	有时间限制的成就结束的时间
		*/		
		public var EndDate:Date;
		
		/**
		* 	成就点
		*/		
		public var AchievementPoint:int;
		
		/**
		 * 成就完成条件 
		 */
		public var EffortQualificationList:DictionaryData;	
		
		/** 
		 * 成就奖励
		 */
		public var effortRewardArray:Array;
		
		/**
		 * 成就进展信息
		 */		
		private var effortCompleteState:EffortCompleteStateInfo;
		
		/**
		 * 成就是否显示出来
		 */		
		public var isAddToList:Boolean;
		
		/**
		 * 图片ID
		 */		
		public var picId:int;
		
		/**
		 * 排序用的
		 */	
		public var completedDate:Date;
		public function set CompleteStateInfo(info:EffortCompleteStateInfo):void
		{
			effortCompleteState = info;
		}
		
		public function get CompleteStateInfo():EffortCompleteStateInfo
		{
			return effortCompleteState;
		}
		
		public function update():void
		{
			dispatchEvent(new EffortEvent(EffortEvent.CHANGED));
		}
		
		public function testIsComplete():void
		{
//			for each(var info:EffortCompleteStateInfo in effortCompleteStateList)
//			{
//				if(info.Total == (EffortQualificationLise[info.RecordID] as EffortQualificationInfo).Condiction_Para2)
//				{
//					
//				}
//			}
		}
		
		public function addEffortQualification(info:EffortQualificationInfo):void
		{
			if(!EffortQualificationList)EffortQualificationList = new DictionaryData();
			EffortQualificationList[info.CondictionType] = info;
			update();
		}
		
		public function addEffortReward(info:EffortRewardInfo):void
		{
			if(!effortRewardArray)effortRewardArray = [];
			effortRewardArray.push(info);
		}
							
		public function EffortInfo()
		{
		}
				

	}
}