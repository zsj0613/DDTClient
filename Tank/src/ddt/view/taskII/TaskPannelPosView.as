package ddt.view.taskII
{
	import crazytank.view.task.QuestBackground;
	
	import fl.containers.ScrollPane;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.utils.ComponentHelper;
	
	import tank.assets.ScaleBMP_16;
	import ddt.data.quest.QuestInfo;
	import ddt.events.TaskEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.SocketManager;
	import ddt.manager.TaskManager;
	
	import webgame.crazytank.view.task.TaskPannelAsset;

	public class TaskPannelPosView extends QuestBackground
	{
		private var _allTasks:Array;
		
		private var _tasks:Array;
		
		private var _questInfoArea:ScrollPane;
		private var _questAwardArea:ScrollPane;
		
		private var _taskPannelRight:QuestInfoPanelView;
		private var _questAward:TaskAwardView;
		
		private var _currentPage:int;
		
		private var _totalPages: int;
		
		private var _bg:ScaleBMP_16;
		
		private var cateViewArr:Array;
		
		private static const MAX_STRIPS:int = 6;
		
		private var _getHortationBtn : HBaseButton;
				
		public function TaskPannelPosView()
		{
			super();
			initView();
			addEvent();
		}
		
		private function initView():void
		{
			addQuestList();
			
			
			var myBg:Shape = new Shape();
			myBg.graphics.beginFill(0x000000,0);
			myBg.graphics.drawRect(0,0,10,10);
			myBg.graphics.endFill();
			_questInfoArea = new ScrollPane()
			_questInfoArea.setStyle("upSkin",myBg);
			_questInfoArea.verticalScrollPolicy = "auto";		
			_questInfoArea.horizontalScrollPolicy = "off";
			_questInfoArea.width = 394;
			_questInfoArea.height = 186;
			_questInfoArea.x = 300;
			_questInfoArea.y = 64;
			addChild(_questInfoArea);
			
			_questAwardArea = new ScrollPane();
			_questAwardArea.setStyle("upSkin",myBg);
			_questAwardArea.verticalScrollPolicy = "auto";	
			_questAwardArea.horizontalScrollPolicy = "off";
			addChild(_questAwardArea);
			_questAwardArea.width = 394;
			_questAwardArea.height =164;
			_questAwardArea.x = 300;
			_questAwardArea.y = 262;
			
			
			
			_tasks = [];
			_allTasks = [];
			_taskPannelRight = new QuestInfoPanelView();
			_questAward = new TaskAwardView();
			
		
			
			_getHortationBtn = new HBaseButton(GetHortationBtn);
			_getHortationBtn.useBackgoundPos = true;
			_getHortationBtn.enable = false;
			addChild(_getHortationBtn);
			btnShine.visible = false;
			
			getTotalPages();
		}
		
		public function initList():void{
			for each(var cate:QuestCateView in cateViewArr){
				cate.initData();
			}
			if(TaskManager.selectedQuest){
				if(cateViewArr[TaskManager.selectedQuest.Type].active()){
					return;
				}
			}
			for each(var cateView:QuestCateView in cateViewArr){
				if(cateView.data.haveCompleted || cateView.data.haveNew){
					cateView.active();
					return;
				}
			}
			
			if(TaskManager.currentCategory){
				if(cateViewArr[TaskManager.currentCategory].active()){
					return;
				}
			}
			for(var i:int=0;i<4;i++){
				if(cateViewArr[i].active())return;
			}
		}
		private function addQuestList():void{
			if(cateViewArr){
				return;
			}
			cateViewArr = new Array();
			for(var i:int = 0;i<4;i++){
				var cateView:QuestCateView = new QuestCateView(i);
				cateView.x = 24;
				cateView.y = 12 + 45*i;
				cateView.addEventListener(QuestCateView.TITLECLICKED,__onTitleClicked);
				cateView.addEventListener(Event.CHANGE,__onCateViewChange);
				cateViewArr.push(cateView);
				addChild(cateView);
				
			}
			
			
		}
		private function __onCateViewChange(e:Event):void{
			var _currentY:int = 12;
			for(var i:int = 0;i<cateViewArr.length;i++){
				var view:QuestCateView =  cateViewArr[i] as QuestCateView;
				view.y = _currentY;
				_currentY += view.contentHeight;
			}
		}
		private function __onTitleClicked(e:Event):void{
			var _currentY:int = 12;
			for(var i:int = 0;i<cateViewArr.length;i++){
				var view:QuestCateView =  cateViewArr[i] as QuestCateView;
				if(view != e.target){
					view.collapse();
				}
				view.y = _currentY;
				_currentY += view.contentHeight;
			}
		}
		private function checkCanCompleted(arr : Array, mc : DisplayObject) : void
		{
			mc.visible = false;
			if(arr.length>0)
			{
				for each(var info:QuestInfo in arr)
				{
					if(info.isCompleted)
					{
						mc.visible = true;
						break;
					}
				}
			}
		}
		
		/**
		 *  是否更新当前页数 
		 * @param updateCurPage
		 * 
		 */		
		private function getTotalPages(updateCurPage:Boolean = false):void
		{
		}
		
		/**
		 * emptyItem : 当前列表是否有已接受的任务
		 */
		/************************************************
		 *  在接受任务时,更新按钮的显示状态和显示的总页数
		 * **********************************************/
		private function addStrip(tasks:Array):void
		{
			
		}	
		
		
		
		private function addEvent():void
		{
			TaskManager.addEventListener(TaskEvent.ADD,__loadTask);
			TaskManager.addEventListener(TaskEvent.FINISH,__onQuestFinish);
			_getHortationBtn.addEventListener(MouseEvent.CLICK,   __accedeTaskHandler);
			this.addEventListener(Event.ADDED_TO_STAGE,  __addToStageHandler);
		}
		
		private function removeEvent():void
		{
			TaskManager.removeEventListener(TaskEvent.ADD,__loadTask);
			TaskManager.removeEventListener(TaskEvent.FINISH,__onQuestFinish);
			_getHortationBtn.removeEventListener(MouseEvent.CLICK,   __accedeTaskHandler);
			this.removeEventListener(Event.ADDED_TO_STAGE,  __addToStageHandler);
		}
		
		private function __addToStageHandler(evt : Event) : void{
		}
		private function __onQuestFinish(e:TaskEvent):void{
			TaskManager.selectedQuest = null;
			initList();
		}
		
		private function __accept(event : TaskEvent):void{
		}
		private function __accedeTaskHandler(evt : MouseEvent) : void
		{
			SoundManager.instance.play("008");
			var questInfo:QuestInfo = TaskManager.getQuestByID(_taskPannelRight.info.QuestID);
			if(questInfo && !questInfo.isCompleted)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.task.TaskCatalogContentView.dropTaskIII"));
				return;
			}
			else if(TaskManager.itemAwardSelected == -1){//option item award not chosen
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.task.TaskCatalogContentView.chooseYourAward"));
				
				//_questAwardArea.verticalScrollPosition = _questAwardArea.maxVerticalScrollPosition;
				for each(var cell:TaskAwardCell in _questAward.optionalCells){
					cell.shine.play();
				}
				return;
			}
			else
			{
				if(_taskPannelRight.info)
				{
					SocketManager.Instance.out.sendQuestFinish(_taskPannelRight.info.QuestID,TaskManager.itemAwardSelected);
				}
			}
			
		}
		
		private function __loadTask(event:TaskEvent):void
		{
		}
		
		/**
		 * 成长任务 
		 * @param event
		 * 
		 */		
		
		/**
		 * 日常任务 
		 * @param event
		 * 
		 */		
		/**
		 * 公会任务
		 * @param evt
		 * 
		 */
		
		private var _lastItem:TaskPannelStripView;
		private function __select(event:TaskEvent):void
		{
			if(_lastItem)
			{
				_lastItem;
			}
			_lastItem = event.target as TaskPannelStripView;
			setRightContent(event.info);
		}
		
		public function activeInit():void
		{
			clearList();
			_getHortationBtn.visible = false;
		}
		private function clearList():void{
		}
		
		public function jumpToQuest(info:QuestInfo):void{
			setRightContent(info)
		}
		private function clearRightContent():void{
			questTitle.text = "";
			_questInfoArea.source = new Sprite();
			_questAwardArea.source = new Sprite();
			
			_questInfoArea.verticalScrollPosition = 0;
			_questAwardArea.verticalScrollPosition = 0;
			
			_getHortationBtn.visible = false;
			btnShine.visible = false;
		}
		private function setRightContent(info:QuestInfo):void
		{
			TaskManager.currentQuest = info;
			clearList()
			
			questTitle.text = info.Title;
			if(info.Type == 2){
				questTitle.appendText("(Lv"+info.NeedMinLevel+"-Lv"+info.NeedMaxLevel+")");
			}
			
			_taskPannelRight.info = info;
			
			if(info.QuestID == 47) { 
				_taskPannelRight.canGotoConsortia(true);
			}
			else {
				_taskPannelRight.canGotoConsortia(false);
			}
			
			_questAward.info = info;
			_questInfoArea.source = _taskPannelRight;
			_questAwardArea.source = _questAward;
			
			_questInfoArea.verticalScrollPosition = 0;
			_questAwardArea.verticalScrollPosition = 0;
			
			_getHortationBtn.visible = true;
			if(info.isCompleted)
			{
				btnShine.visible = true;
				_getHortationBtn.enable = true;
			}
			else
			{
				btnShine.visible = false;
				_getHortationBtn.enable = false;
			}
			
			TaskManager.selectedQuest = info;
		}
		
		public function dispose():void
		{
			for each(var e:QuestCateView in cateViewArr){
				e.dispose();
			}
			removeEvent();
			TaskManager.clearNewQuest();
			
			if(_getHortationBtn)
			{
				_getHortationBtn.dispose();
				if(_getHortationBtn.parent)
					_getHortationBtn.parent.removeChild(_getHortationBtn);
			}
			_getHortationBtn = null;
			
			if(_questInfoArea)
			{
				if(_questInfoArea.parent)
					_questInfoArea.parent.removeChild(_questInfoArea);
			}
			_questInfoArea = null;
			
			if(_taskPannelRight)
				_taskPannelRight.dispose();
			_taskPannelRight = null;
			if(_questAward)
				_questAward.dispose();
			_questAward = null;
			
			if(_bg && _bg.parent)
				_bg.parent.removeChild(_bg);
			_bg = null;
			
			_tasks = null;
			_allTasks = null;
			_lastItem = null;
			
			if(parent)
				parent.removeChild(this);
		}
		
		public function showGlow():void
		{
			
		}
		
		
	}
}