
package ddt.view.taskII
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ddt.manager.TaskManager;
	
	import ddt.data.quest.QuestInfo;

	public class QuestListView extends Sprite
	{
		private var _dataProvider:Array;
		private var _mainQuests:Array;
		private var _sideQuests:Array;
		private var _dailyQuests:Array;
		private var _currentCat:int;
		private var _list:Array;
		public function QuestListView()
		{
			init();
		}
		private function init():void{
			_currentCat = 0;
			_list = new Array();
			_mainQuests = new Array();
			_sideQuests = new Array();
			_dailyQuests = new Array();
			
			for(var i:int = 0;i<4;i++){
				var e:QuestCateView = new QuestCateView();
				e.x = 0;
				//e.addEventListener(ExpandableContainer.TITLECLICKED,__onClickItem);
				_list.push(e);
				addChild(e);
			}
			updateView();
			updateList();
		}
		private function expandCategory(index:int):void{
			
			_currentCat = index;
			updateView();
		}
		
		private function set dataProvider(value:Array):void{
			clearLists();
			for each(var i:QuestInfo in value){
				switch(i.Type){
					case 1:
						addMainQuests(i);
						break;
					case 2:
						_sideQuests.push(i);
						break;
					case 3:
						_dailyQuests.push(i);
						break;
					case 4:
						//todo
						break;
					default:
						break;
				}
			}
			updateList();
		}
		
		private function addMainQuests(value:QuestInfo):void{
			_mainQuests.push(value);
		};
		private function updateList():void{
			var cat:QuestCateView = new QuestCateView();
			cat.dataProvider = TaskManager.allAvailableQuests;
			//(_list[0] as ExpandableContainer).content = cat;
		}
			
		private function clearLists():void{
			
			_mainQuests = new Array();
			_sideQuests = new Array();
			_dailyQuests = new Array();
		}
		private function updateView():void{
			for(var i:int = 0;i<4;i++){
				var e:QuestCateView = _list[i];
				e.collapse();
				if(i == _currentCat){
					e.expand();
				}
				if(i<=_currentCat){
					e.y = 45 * i;
				}else{
					e.y = 45 * i + 285;
				}
			}
		}
		private function __onClickItem(e:Event):void{
			for(var i:int = 0;i<4;i++){
				if(_list[i] == e.target){
					if(!_list[i].isExpanded){
						expandCategory(i);
					}else{
						expandCategory(4);
					}
				}
			}
		}
		
	}
}