package ddt.view.taskII
{
	import crazytank.view.task.QuestConditionAsset;
	
	import flash.text.TextFieldAutoSize;
	
	import ddt.data.quest.QuestCondition;

	public class QuestConditionView extends QuestConditionAsset
	{
		private var _cond:QuestCondition;
		public function QuestConditionView(condition:QuestCondition)
		{
			super();
			conditionText.wordWrap = false;
			conditionText.autoSize = TextFieldAutoSize.LEFT;
			statusText.autoSize = TextFieldAutoSize.LEFT;
			statusText.multiline = false;
			_cond = condition;
			text = _cond.description;
		}
		public function set status(value:String):void{
			statusText.text = value;
		}
		public function set text(value:String):void{
			conditionText.text = value;
			statusText.x = conditionText.x + conditionText.width;
		}
		public function set isComplete(value:Boolean):void{
			if(value == true){
				gotoAndStop(2);
			}
		}
		
		public function dispose():void{
			if(this.parent)
				this.parent.removeChild(this);
			
		}
	}
}