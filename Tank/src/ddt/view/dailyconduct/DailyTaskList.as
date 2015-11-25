package ddt.view.dailyconduct
{
	import com.dailyconduct.view.DailyConductBgAsset;
	import com.dailyconduct.view.TaskTypeTitleAsset;
	
	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;
	import fl.core.UIComponent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import road.ui.controls.SimpleGrid;
	import road.utils.ComponentHelper;
	
	import ddt.data.quest.QuestInfo;
	import ddt.manager.TaskManager;

	public class DailyTaskList
	{
		private var _panel           : ScrollPane;
		private var _uipanel         : UIComponent;
		private var _dailyTaskList   : SimpleGrid;
		private var _clubTaskList    : SimpleGrid;
		private var _parant          : DailyConductBgAsset;
		private var _dailyTaskTitle  : TaskTypeTitleAsset;
		private var _clubTaskTitle   : TaskTypeTitleAsset;
		
		public function DailyTaskList(parant : DailyConductBgAsset)
		{
			_parant = parant;
			super();
			init();
		}
		
		private function init() : void
		{
			_uipanel = new UIComponent();
			
			
			_panel = new ScrollPane();
			_panel.setStyle("upSkin",new Sprite());
			_panel.setStyle("skin",new Sprite());
			_panel.horizontalScrollPolicy = ScrollPolicy.OFF;
			ComponentHelper.replaceChild(_parant,_parant.pos3,_panel);
			_panel.source = _uipanel;
			
			
			_dailyTaskList = new SimpleGrid(_parant.pos3.width,20);
			_clubTaskList  = new SimpleGrid(_parant.pos3.width,20);
			_dailyTaskTitle = new TaskTypeTitleAsset();
			_clubTaskTitle  = new TaskTypeTitleAsset();
			
			_uipanel.addChild(_dailyTaskTitle);
			_uipanel.addChild(_clubTaskTitle);
			_uipanel.addChild(_dailyTaskList);
			_uipanel.addChild(_clubTaskList);
			_panel.addEventListener(Event.ADDED_TO_STAGE,   __addedToStageHandler);
		}
		
		private function drawBackground():void
		{
			var dailyTaskArray : Array = TaskManager.welcomeQuests;
			_dailyTaskTitle.y = 6;
			_dailyTaskTitle.titleTxt.text = "日常任务";
			var item : DailyTaskItem;
			_dailyTaskList.clearItems();
			var completedNum : int = 0;
			for(var i:int=0;i<dailyTaskArray.length;i++)
			{
				var taskInfo : QuestInfo = dailyTaskArray[i] as QuestInfo;
				item = new DailyTaskItem();
				item.text(taskInfo.Title,taskInfo.isCompleted);
				if(taskInfo.isCompleted)completedNum++;
				_dailyTaskList.appendItem(item);
			}
			_dailyTaskTitle.taskProgressTxt.text = "完成进度: " + String(completedNum) + "/" +String(dailyTaskArray.length);
			_dailyTaskList.drawNow();
			_dailyTaskList.setSize(_dailyTaskList.getContentWidth() + 10,_dailyTaskList.getContentHeight());
			_dailyTaskList.verticalScrollPolicy = _dailyTaskList.horizontalScrollPolicy = ScrollPolicy.OFF;;
			_dailyTaskList.y = _dailyTaskTitle.y + _dailyTaskTitle.height;
			
			var clubTaskArr : Array = TaskManager.welcomeGuildQuests;
			var overClubNum : int   = 0;//TaskManager.overCurrnetClubDailyNum;
			_clubTaskTitle.titleTxt.text = "公会日常";
			_clubTaskTitle.y = _dailyTaskList.y +_dailyTaskList.height+3;
			_clubTaskList.clearItems();
			for(var j:int=0;j<clubTaskArr.length;j++)
			{
				var culbInfo : QuestInfo = clubTaskArr[j] as QuestInfo;
				item = new DailyTaskItem();
				item.text(culbInfo.Title,culbInfo.isCompleted);
				if(culbInfo.isCompleted)overClubNum++;
				_clubTaskList.appendItem(item);
			}
			_clubTaskTitle.taskProgressTxt.text ="完成进度: " + String(overClubNum) + "/" + String(clubTaskArr.length);
			_clubTaskList.drawNow();
			_clubTaskList.setSize(_clubTaskList.getContentWidth()+10,_clubTaskList.getContentHeight());
			_clubTaskList.y = _clubTaskTitle.y + _clubTaskTitle.height;
			_clubTaskList.verticalScrollPolicy = _clubTaskList.horizontalScrollPolicy = ScrollPolicy.OFF;;
			
			_uipanel.height = _clubTaskList.y + _clubTaskList.height;
			_panel.update();
		}
		
		private function __addedToStageHandler(evt : Event) : void
		{
			drawBackground();
		}
		
		public function dispose() : void
		{
			if(_dailyTaskTitle && _dailyTaskTitle.parent)
				_dailyTaskTitle.parent.removeChild(_dailyTaskTitle);
			_dailyTaskTitle = null;
			
			if(_clubTaskTitle && _clubTaskTitle.parent)
				_clubTaskTitle.parent.removeChild(_clubTaskTitle);
			_clubTaskTitle = null;
			
			if(_dailyTaskList)_dailyTaskList.clearItems();
			_dailyTaskList = null;
			
			if(_clubTaskList)_clubTaskList.clearItems();
			_clubTaskList = null;
			
			if(_uipanel && _uipanel.parent)
				_uipanel.parent.removeChild(_uipanel);
			_uipanel = null;
			
			if(_panel)
			{
				_panel.removeEventListener(Event.ADDED_TO_STAGE,   __addedToStageHandler);
				_panel.source = null;
				if(_panel.parent)_panel.parent.removeChild(_panel);
			}
			_panel = null;
			
			_parant = null;
		}
		
	}
}