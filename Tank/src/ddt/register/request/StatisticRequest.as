package ddt.register.request
{
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLVariables;
	
	import ddt.loader.RequestLoader;

	public class StatisticRequest extends RequestLoader
	{
		private var path:String = "ddt_game/List_BI_Click.ashx";
		private var REGISTERCHARACTER:String = "regCharacter";//注册统计
		public function StatisticRequest(mainPath:String,agentID:int,status:String = "yes")
		{
			var data : URLVariables = new URLVariables();
		 	data["appid"] = "1";
		 	data["style"] = REGISTERCHARACTER+"_"+status;
		 	data["subid"] = agentID;
			super(mainPath + path, data,false);
		}
		

		
		override protected function onRequestReturn(xml:XML):void
		{
//			if(xml)
//				super.onRequestReturn(xml);
			
		}
	}
}