package ddt.utils
{
	import road.data.DictionaryData;
	import road.utils.DateUtils;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.manager.TimeManager;
	
	public class StringUtils
	{
		public static function CompareString(a:String,b:String):int
		{
			if(Number(a) > Number(b)) return 1;
			if(Number(a) < Number(b)) return -1;
			return 0;	
		}
		public static function getOverdueItemsFrom(param:DictionaryData):Array
		{
			var betoArr:Array = [];
			var hasArr:Array = [];
			var date : Date;
			var diff:Number;
			var remainDate:Number;
			for each(var i:InventoryItemInfo in param)
			{
				if(!i)continue;
				if(!i.IsUsed)continue;
				if(i.ValidDate ==0)continue;
				
				date = DateUtils.getDateByStr(i.BeginDate);
				diff = TimeManager.Instance.TotalDaysToNow(date);
				remainDate = (i.ValidDate - diff)*24;
				
				if(remainDate<24&&remainDate>0)	
				{
					betoArr.push(i);
				}else if(remainDate<=0)
				{
					hasArr.push(i);
				}
			}
			
			return [betoArr,hasArr];
		}
	}
}
