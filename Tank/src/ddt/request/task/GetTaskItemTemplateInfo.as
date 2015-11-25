package ddt.request.task
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import road.serialize.xml.XmlSerialize;
	
	import ddt.data.quest.*;
	import ddt.loader.CompressTextLoader;
	import ddt.data.PathInfo;
	import ddt.manager.PathManager;

	/**
	 * 任务模板 
	 * @author SYC
	 * 
	 */
	public class GetTaskItemTemplateInfo extends CompressTextLoader
	{
		private static const PATH:String = "QuestList.xml";
		
		public var list:Dictionary;
		public function GetTaskItemTemplateInfo()
		{
			super(PathManager.solveXMLPath()+PATH+"?"+Math.random());
		}
		
		override protected function onTextReturn(txt:String):void
		{
			var xml:XML = new XML(txt);
		//	trace("==Quests==\n"+xml);
			var xmllist:XMLList = xml..Item;
			list = new Dictionary(); 
			var taskInfo:XML = describeType(new QuestInfo());
			
			for(var i:int = 0; i < xmllist.length(); i ++)
			{
				var x:XML = xmllist[i];
				var quest:QuestInfo = QuestInfo.createFromXML(x);
				
				list[quest.id] = quest;
				
			}
			super.onTextReturn(txt);
		}
	}
}