package road.utils
{
	public class DateUtils
	{
		/**
		 * 
		 * @param value
		 * @return 
		 * 2008-12-1 11:40:14
		 */		
		public static function getDateByStr(value:String):Date
		{
			if(value)
			{
				var temp:Array = value.split(" ");
				var date:Array = temp[0].split("-");
				var year:int = date[0];
				var month:int = date[1] - 1;
				var day:int = date[2];
				var time:Array = temp[1].split(":");
				var hour:int = time[0];
				var minute:int = time[1];
				var second:int = time[2];
				return new Date(year,month,day,hour,minute,second)
			}
			else
			{
				return new Date(0);
			}
		}
		
		public static function getHourDifference(start:Number,end:Number):int
		{
			return Math.floor((end - start) / 3600000);
		}

	}
}