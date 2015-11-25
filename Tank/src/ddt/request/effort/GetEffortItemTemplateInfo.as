package ddt.request.effort
{
	import flash.utils.Dictionary;
	
	import road.data.DictionaryData;
	
	import ddt.data.effort.EffortInfo;
	import ddt.data.effort.EffortQualificationInfo;
	import ddt.data.effort.EffortRewardInfo;
	import ddt.loader.CompressTextLoader;
	import ddt.data.PathInfo;
	import ddt.manager.PathManager;

	public class GetEffortItemTemplateInfo extends CompressTextLoader
	{
		private static const PATH:String = "AchievementList.xml";
		public var list:DictionaryData;
		public function GetEffortItemTemplateInfo(paras:Object=null)
		{
			super(PathManager.solveXMLPath()+PATH, paras);
		}
		/**
		*成就的多个完成条件和多个奖励物品是统一字段 
		*/
		override protected function onTextReturn(txt:String):void
		{
			var xml:XML = new XML(txt);
			var xmllist:XMLList = xml..Item;
			list = new DictionaryData(); 
			
			for(var i:int = 0; i < xmllist.length(); i ++)
			{
				var x:XML = xmllist[i];
				var effortInfo:EffortInfo = new EffortInfo();
				effortInfo.ID 				= x.@ID;
				effortInfo.PlaceID 			= x.@PlaceID;
				effortInfo.Title 			= x.@Title;
				effortInfo.Detail 			= x.@Detail;
				effortInfo.NeedMinLevel 	= x.@NeedMinLevel;
				effortInfo.NeedMaxLevel 	= x.@NeedMaxLevel;
				effortInfo.PreAchievementID = x.@PreAchievementID;
				effortInfo.IsOther 			= x.@IsOther;
				effortInfo.AchievementType  = x.@AchievementType;
				effortInfo.CanHide 			= getBoolean(x.@CanHide);
				effortInfo.picId            = x.@PicID;
				effortInfo.StartDate = new Date((String(x.@StartDate).substr(5,2)+"/"+String(x.@StartDate).substr(8,2)+"/"+String(x.@StartDate).substr(0,4)));
				effortInfo.EndDate =  new Date((String(x.@StartDate).substr(5,2)+"/"+String(x.@StartDate).substr(8,2)+"/"+String(x.@StartDate).substr(0,4)));
				effortInfo.AchievementPoint = x.@AchievementPoint;
				var conditions:XMLList = x..Item_Condiction;
				for (var j:int = 0 ; j < conditions.length() ; j++)
				{
					var effortQualificationInfo:EffortQualificationInfo = new EffortQualificationInfo();
					effortQualificationInfo.AchievementID  		= conditions[j].@AchievementID;
					effortQualificationInfo.CondictionID   		= conditions[j].@CondictionID;
					effortQualificationInfo.CondictionType 		= conditions[j].@CondictionType;
					effortQualificationInfo.Condiction_Para1  	= conditions[j].@Condiction_Para1;
					effortQualificationInfo.Condiction_Para2  	= conditions[j].@Condiction_Para2;
					effortInfo.addEffortQualification(effortQualificationInfo);
				}
				
				var rewards:XMLList = x..Item_Reward;
				for(var k:int = 0 ; k < rewards.length() ; k++)
				{
					var effortRewardInfo:EffortRewardInfo = new EffortRewardInfo(); 
					effortRewardInfo.AchievementID = rewards[k].@AchievementID;
					effortRewardInfo.RewardCount   = rewards[k].@RewardCount;
					effortRewardInfo.RewardPara    = rewards[k].@RewardPara;
					effortRewardInfo.RewardType    = rewards[k].@RewardType;
					effortRewardInfo.RewardValueId = rewards[k].@RewardValueId;
					effortInfo.addEffortReward(effortRewardInfo);
				}
				list[effortInfo.ID] = effortInfo;
			}
			super.onTextReturn(txt);
		}
		
		private function getBoolean(value:String):Boolean
		{
			if(value == "true")
			{
				return true;
			}else
			{
				return false;
			}
		}
	}
}