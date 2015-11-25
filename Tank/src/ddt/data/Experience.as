package ddt.data
{
	import ddt.manager.PlayerManager;
	import road.utils.ClassUtils
	
	public class Experience
	{
		public static var Expericence:Array = ClassUtils.getDefinition("ddt.Config")["Expericence"];
		private static var MAX_LEVEL:int = ClassUtils.getDefinition("ddt.Config")["MAX_LEVEL"];
		public static function getExpPercent(level:int,gp:int):Number
		{
			if(level == MAX_LEVEL){return 0};
			if(level == 1)
			{
				gp--;
			}
			return int((gp - Expericence[level - 1]) / (Expericence[level] - Expericence[level - 1]) * 10000) / 100;
		}	
		
		public static function getGrade(exp:Number):int
		{
			var result:int = PlayerManager.Instance.Self.Grade;
			for(var i:int = 0; i < Expericence.length ; i ++)
			{
				if(exp >= Expericence[MAX_LEVEL-1]){
					result = MAX_LEVEL;
					break;
				}
				else if(exp < Expericence[i])
				{
					result = i;
					break;
				}else if(exp < 0)
				{
					result = 0;
					break;
				}
			}
			return result;
		}	
	}
}