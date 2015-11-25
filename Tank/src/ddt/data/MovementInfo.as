package ddt.data
{
	import road.utils.DateUtils;
	
	import ddt.manager.LanguageMgr;
	import ddt.manager.TimeManager;
	
	public class MovementInfo
	{
		public var ActiveID:int;
		
		public var Title:String;
		
		public var isAttend : Boolean = false;//是否已领取该任务
		
		
		public var Description:String;
		
		public var StartDate:String;
		
		public var EndDate:String;
		
		public var Content:String;
		
		public var AwardContent:String;
		
		/*0 没有 1 hot 2 new*/
		public var Type:int;
		
		public var IsOnly:Boolean;
		
		public var HasKey:int;
		
		/* 活动时间文字内容 bret09.7.8 */
		public var ActionTimeContent:String;
		
		public function activeTime():String
		{
			var result:String;
			var begin:Date = DateUtils.getDateByStr(StartDate);
			
			if(ActionTimeContent)result = ActionTimeContent;
			
			else
			{
				if(EndDate)
				{
					var end:Date = DateUtils.getDateByStr(EndDate);
					result =  getActiveString(begin) + "-" + getActiveString(end);
				}
				else
				{
				
					result =  LanguageMgr.GetTranslation("ddt.data.MovementInfo.begin",getActiveString(begin))
					//result =  "从" + getActiveString(begin) + "开始";
				}
			}
			return result;
		}
		
		private function getActiveString(date:Date):String
		{
			
			return LanguageMgr.GetTranslation("ddt.data.MovementInfo.date",addZero(date.getFullYear()),addZero(date.getMonth() + 1),addZero(date.getDate()));
			//return addZero(date.getFullYear()) + "年" + addZero(date.getMonth() + 1) + "月" + addZero(date.getDate()) + "日";
		}
		
		private function addZero(value:Number):String
		{
			var result:String;
			if(value < 10)
			{
				result = "0" + value.toString();
			}
			else
			{
				result = value.toString();
			}
			return result;
		}
		
		public function overdue():Boolean
		{
			var now:Number = TimeManager.Instance.Now().time;
			var begin:Date = DateUtils.getDateByStr(StartDate);
			if(now < begin.getTime())
			{
				return true;
			}
			var end:Date;
			if(EndDate)
			{
				 end = DateUtils.getDateByStr(EndDate);
				 if(now > end.getTime())
				 {
				 	return true;
				 }
			}
			return false;
		}
	}
}