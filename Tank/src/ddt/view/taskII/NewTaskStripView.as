package ddt.view.taskII
{
	import ddt.data.quest.QuestInfo;

	public class NewTaskStripView extends TaskPannelStripView
	{
		public function NewTaskStripView(info:QuestInfo)
		{
			super(info);
		}
		override protected function _active() : void
		{
		}
		/*override protected function addEvent():void
		{
		}
		override protected function removeEvent():void
		{
		}*/
		
	}
}