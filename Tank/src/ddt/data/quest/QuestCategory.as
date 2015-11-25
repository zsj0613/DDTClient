package ddt.data.quest
{
	public class QuestCategory
	{
		private var _completedQuestArray:Array;
		private var _newQuestArray:Array;
		private var _questArray:Array;
		public function QuestCategory()
		{
			_completedQuestArray = new Array();
			_newQuestArray = new Array();
			_questArray = new Array();
		}
		public function addNew(questInfo:QuestInfo):void{
			_newQuestArray.push(questInfo);
		}
		
		public function addCompleted(questInfo:QuestInfo):void{
			_completedQuestArray.push(questInfo);
		}
		
		public function addQuest(questInfo:QuestInfo):void{
			_questArray.push(questInfo);
		}
		
		public function get list():Array{
			return _completedQuestArray.concat(_newQuestArray.concat(_questArray));
		}
		public function get haveNew():Boolean{
			for each(var info:QuestInfo in _newQuestArray){
				if(info.data && info.data.isNew){
					return true;
				}
			};
			return false;
		}
		public function get haveCompleted():Boolean{
			return (_completedQuestArray.length>0)
		}
		
	}
}