package ddt.view.taskII
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import road.manager.SoundManager;
	import ddt.manager.LanguageMgr;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.HFrame;
	import road.utils.ComponentHelper;
	
	import ddt.data.quest.QuestInfo;
	import ddt.manager.TaskManager;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import webgame.crazytank.view.task.NewQuestConfirm;

	public class NewQuestDialog extends HFrame
	{
		private var _contentMC:NewQuestConfirm;
		private var btnOK:HBaseButton;
		private var _list:SimpleGrid;
		private var _questList:Array;
		private var _questMainFrame:TaskMainFrame
		public function NewQuestDialog(mainFrame:TaskMainFrame)
		{
			super();
			_questMainFrame = mainFrame;
			init();
		}
		private function init():void{
			blackGound = false;
			alphaGound = false;
			moveEnable = false;
			fireEvent = false;
			showBottom = true;
			showClose = true;
			titleText = LanguageMgr.GetTranslation("ddt.view.task.TaskCanAcceptView.finishTask");
			centerTitle = true;
			setSize(300,320);
			x = 0;
			y = 0;
			_contentMC = new NewQuestConfirm();
			addChild(_contentMC);
			addEventListener(KeyboardEvent.KEY_DOWN,__keyDownHandler)
			initList();
			
			
			initView();
			initData();
		}
		private function __keyDownHandler(evt : KeyboardEvent) : void
		{
			if(evt.keyCode == Keyboard.ESCAPE)
			{
				evt.stopImmediatePropagation();
				__onBtnClicked(null);
			}
		}
		private function initView():void{
			_contentMC.dialogText.filters = [new GlowFilter(0x000000,1,4,4,10)];
			btnOK = new HLabelButton();
			btnOK.label = LanguageMgr.GetTranslation("cancel");
			btnOK.x = _contentMC.okBtnPos.x+10;
			btnOK.y = _contentMC.okBtnPos.y+2;
			btnOK.addEventListener(MouseEvent.CLICK,__onBtnClicked);
			_contentMC.removeChild(_contentMC.okBtnPos);
			addChild(btnOK);
		}
		private function __onBtnClicked(e:MouseEvent):void{
			SoundManager.Instance.play("008");
			this.dispose();
		}
		public function update():void{
			clearList();
			initData();
		}
		private function initList():void{
			_list = new SimpleGrid();
			_list.verticalScrollPolicy = "auto";		
			_list.horizontalScrollPolicy = "off";
			_list.cellHeight = 40;
			_list.cellWidth = 220;
			ComponentHelper.replaceChild(_contentMC,_contentMC.listPos_mc,_list);
		}
		private function initData():void{
			_questList = new Array();
			var tempList:Array = TaskManager.newQuests;
			for each(var i:QuestInfo in tempList){
				if(i.Type != 2 ){/** 日常任务不提示 */
					_questList.push(i);
				}
			}
			
			for each(var j:QuestInfo in _questList){
				var tempStrip:NewTaskStripView = new NewTaskStripView(j);
				tempStrip.addEventListener(MouseEvent.CLICK,__questStripClicked);
				_list.appendItem(tempStrip);
			}
		}
		
		private function clearList():void
		{
			if(_list)
			{
				for each(var i:NewTaskStripView in _list.items)
				{
					i.removeEventListener(MouseEvent.CLICK,__questStripClicked);
					i.dispose();
					i = null;
				}
				
				_list.clearItems();
			}
		}
		
		private function __questStripClicked(e:MouseEvent):void{
			if(_questMainFrame.parent){
				return;
			}
			clearList();
			TaskManager.selectedQuest = e.target.info;
			_questMainFrame.switchVisible()
		}
		override public function dispose():void
		{
			TaskManager.clearNewQuest();
			
			if(btnOK)
			{
				btnOK.removeEventListener(MouseEvent.CLICK,__onBtnClicked);
				btnOK.dispose();
			}
			btnOK = null;
			
			clearList();
			if(_list && _list.parent)
				_list.parent.removeChild(_list);
			_list = null;
			
			if(_contentMC && _contentMC.parent)
				_contentMC.parent.removeChild(_contentMC);
			
			_questList = null;
			_questMainFrame = null;
			
			super.dispose();
		}
		
	}
}
