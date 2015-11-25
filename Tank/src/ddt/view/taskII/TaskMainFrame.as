package ddt.view.taskII
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HFrame;
	import road.ui.manager.UIManager;
	
	import ddt.data.quest.QuestInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.TaskManager;
	import ddt.view.common.BellowStripViewII;

	public class TaskMainFrame extends HFrame
	{
		private var _newQuestDialog:NewQuestDialog;
		private var _asset:TaskPannelPosView;
		public function TaskMainFrame()
		{
			super();
			init();
			addEvent();
		}
		private function init() : void
		{
			blackGound = false;
			alphaGound = false;
			mouseEnabled = false;
			showBottom = false;
			fireEvent = false;
			setSize(740,552);
			titleText = LanguageMgr.GetTranslation("ddt.game.ToolStripView.task");
			//titleText = "任务";
			_asset = new TaskPannelPosView();
			this.addContent(_asset,false);
			_asset.x = 6;
			_asset.y = 34;
			
		}
		override protected function __closeClick(e:MouseEvent):void{
			switchVisible();
		}
		private function addEvent() : void
		{
			addEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
		}
		private function removeEvent():void
		{
			removeEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
		}
		private function __keyDown(evt : KeyboardEvent) : void
		{
			evt.stopImmediatePropagation();
			if(evt.keyCode == Keyboard.ESCAPE)
			{
				if(parent)
				{
					
					switchVisible();
/* 					parent.removeChild(this);
					SoundManager.instance.play("008"); */
				}
			}
		}
		public function newQuest(info:QuestInfo):void{
			if(_asset && this.parent){
				return;
			}
			if(!_newQuestDialog || !_newQuestDialog.parent){
				_newQuestDialog = new NewQuestDialog(this);
				UIManager.AddDialog(_newQuestDialog);
				return;
			}else{
				_newQuestDialog.update();
			}
			
		}
		public function disposeNewQuest():void{
			UIManager.RemoveDialog(_newQuestDialog);
			_newQuestDialog = null;
		}
		public function switchVisible() : void
		{
			if(_newQuestDialog)
				disposeNewQuest();
			
			if(this.parent){//show -> dispose
				SoundManager.instance.play("008");
				this.parent.removeChild(this);
				_asset.dispose();
				_asset = null;
				TaskManager.selectedQuest = null;
				TaskManager.clearNewQuest();
				TaskManager.checkHighLight();
			}else{//display
				if(!_asset){
					init();
				}
				BellowStripViewII.Instance.unReadTask = false;
				
				UIManager.AddDialog(this,true);
				posView.initList();
			}
		}
		private static var instance : TaskMainFrame;
		public static function get Instance():TaskMainFrame
		{
			if(instance == null)
			{
				instance = new TaskMainFrame();
			}
			return instance;
		}
		public function get posView():TaskPannelPosView{
			return _asset;
		}
		
		override public function dispose():void
		{
			removeEvent();
			
			if(_newQuestDialog)
				disposeNewQuest();
			
			if(_asset)
				_asset.dispose();
			_asset = null;
			
			super.dispose();
		}
	}
}