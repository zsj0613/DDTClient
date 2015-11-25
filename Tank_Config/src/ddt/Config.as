package ddt
{

	public final class Config
	{
		public static function ParseAll(xml:XML):void
		{			
			Config.Expericence = xml.Expericence.@value.split(",");
			Config.MAX_LEVEL = int(xml.MAX_LEVEL.@value);
			Config.VIP_Moneys = xml.VIP_Moneys.@value.split(",");
		}
		public static var Expericence:Array =[0,int.MAX_VALUE];
		public static var MAX_LEVEL:int = 1;
		public static var VIP_Moneys:Array = [0, 5, 30, 50, 100, 200, 500, 1000, 1500, 2500, 5000];
	}
}