package ddt.view.taskII
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	
	import ddt.data.quest.QuestCategory;
	import ddt.data.quest.QuestInfo;
	import ddt.events.TaskEvent;
	import ddt.manager.TaskManager;
	
	public class QuestCateView extends Sprite
	{
		public static var TITLECLICKED:String = "titleClicked";
		public static var EXPANDED:String = "expanded";
		public static var COLLAPSED:String = "collapsed"
			
		private var _data:QuestCategory;
		private var _titleView:QuestCateTitleView;
		private var _listView:QuestCateListView;
		private var _isExpanded:Boolean;
		private var _infoList:Array;
		
		public var questType:int;
		public function get contentHeight():int{
			if(!_isExpanded){
				return 45;
			}
			if(_data.list.length<8){
				return 45 + _data.list.length * 40;
			}
			return 45 + 40 * 7;
		}
		public function get data():QuestCategory{
			return _data;
		}
		public function QuestCateView(cateID:int = -1)
		{
			super();
			_infoList = new Array();
			questType = cateID;
			initView();
			initEvent();
			updateData();
			collapse();
		}
		private function initView():void{
			_titleView = new QuestCateTitleView(questType);
			_titleView.x = 0;
			_titleView.y = 0;
			_listView = new QuestCateListView();
			_listView.width = _titleView.width;
			_listView.x = 0;
			_listView.y = _titleView.height;
			addChild(_titleView);
		}
		private function initEvent():void{
			_titleView.addEventListener(MouseEvent.CLICK,__onTitleClicked);
			_listView.addEventListener(Event.CHANGE,__onListChange);
			TaskManager.addEventListener(TaskEvent.CHANGED,__onQuestData);
		}
		private function removeEvent():void{
			_titleView.removeEventListener(MouseEvent.CLICK,__onTitleClicked);
			_listView.removeEventListener(Event.CHANGE,__onListChange);
			TaskManager.removeEventListener(TaskEvent.CHANGED,__onQuestData);
		}
		public function initData():void{
			updateData();
		}
		public function active():Boolean{
			if(_data.list.length == 0){
				return false;
			}
			SoundManager.Instance.play("008");
			TaskManager.currentCategory = questType;
			expand();
			updateView();
			_listView.active();
			dispatchEvent(new Event(TITLECLICKED));
			return true;
		}
		private function __onQuestData(e:TaskEvent):void{
			if(!TaskMainFrame.Instance.parent){
				return;
			}
			updateData();
		}
		private function __onTitleClicked(e:MouseEvent):void{	
			
			active();
		}
		private function __onListChange(e:Event):void{
			updateView();
		}
		public function set dataProvider(value:Array):void{
			
		}
		private function updateView():void{
			
			updateTitleView();
			if(this.isExpanded){
				_listView.active();
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		public function get isExpanded():Boolean{
			return _isExpanded;
		}
		
		public function collapse():void{
			if(_isExpanded == false){
				return;
			}
			_isExpanded = false;
			_titleView.isExpanded = _isExpanded;
			_listView.visible = false;
			if(_listView.parent == this){
				removeChild(_listView);
			}
			updateTitleView();
			dispatchEvent(new Event(COLLAPSED));
			height = 45;
		}
		public function expand():void{
			if(_isExpanded == true){
				return;
			}
			updateData();
			
			_isExpanded = true;
			_titleView.isExpanded = _isExpanded;
			_listView.visible = true;
			addChild(_listView);
			updateTitleView();
			dispatchEvent(new Event(EXPANDED));
		}
		private function set enable(value:Boolean):void{
			if(value){
				_titleView.enable = true;
			}else{
				_titleView.update();
				_titleView.enable = false;
				collapse();
			}
		}
		private function updateData():void{
			_data = TaskManager.getAvailableQuests(questType);
			_listView.dataProvider = _data.list;
			if(_data.list.length == 0){
				enable = false;
				return;
			}
			enable = true;
			updateTitleView();
		};
		private function updateTitleView():void{
			if(_isExpanded){
				_titleView.update();
				return;
			}
			if(_data.haveCompleted){
				_titleView.haveCompleted();
			}else if(_data.haveNew){
				_titleView.haveNew();
			}else{
				_titleView.update();
			}
			if(_isExpanded){
				_listView.active();
			}
		}
		public function dispose():void{
			removeEvent();
			_titleView.dispose();
			
			_listView.dispose();
		}
	}
}