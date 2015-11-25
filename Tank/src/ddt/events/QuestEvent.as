package ddt.events
{
	import flash.events.Event;
	
	import ddt.data.quest.QuestDataInfo;
	import ddt.data.quest.QuestInfo;

	public class QuestEvent extends Event
	{
		public static const QUEST_ADD:String = "questAdd";
		
		public static const QUEST_REMOVE:String = "questRemove";

		public static const QUEST_UPDATE:String = "questUpdate";
		
		private var _data:QuestDataInfo;
		
		public function get data():QuestDataInfo
		{
			return _data;	
		}
		
		public function QuestEvent(type:String,data:QuestDataInfo)
		{
			super(type);
			_data = data;
		}
		
	}
}