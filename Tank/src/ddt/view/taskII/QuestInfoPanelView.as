package ddt.view.taskII
{
	import crazytank.view.task.GotoConsortia;
	import crazytank.view.task.QuestInfoPanelAsset;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	import road.ui.controls.HButton.HFrameButton;
	
	import ddt.data.quest.QuestCondition;
	import ddt.data.quest.QuestInfo;
	import ddt.manager.StateManager;
	import ddt.states.StateType;

	public class QuestInfoPanelView extends QuestInfoPanelAsset
	{
		private var _info:QuestInfo;
		private var condArr:Array;
		private var gotoC:HFrameButton;
		private var gotoCMoive:GotoConsortia;
		public function QuestInfoPanelView()
		{
			condArr = new Array();
			init();
		}
		
		private function init():void {
			gotoCMoive = new GotoConsortia();
			gotoC = new HFrameButton(gotoCMoive);
			gotoC.x = 210;
			gotoC.y = 50;
			gotoC.addEventListener(MouseEvent.CLICK, gotoConsortia);
			addChild(gotoC);
			gotoC.visible = false;
		}
		
		public function set info(value:QuestInfo):void{
			clear();
			_info = value;
			
			for(var i:int = 0;_info._conditions[i];i++){
				var cond:QuestCondition = _info._conditions[i];
				var condView:QuestConditionView = new QuestConditionView(cond);
				condView.status = _info.conditionStatus[i];
				if(_info.progress[i]<=0){
					condView.isComplete = true;
				}
				condView.x = 0;
				condView.y = i*32+28;
				condArr.push(condView);
				addChild(condView);
				
			}
			summaryText.mouseWheelEnabled = false;
			summaryText.autoSize = TextFieldAutoSize.LEFT;
			summaryTitle.visible = true;
			summaryTitle.y = i*32+40;
			summaryText.text = _info.Detail;
			summaryText.y = i*32+68;
			bgposMC.width = 394;
			bgposMC.height = summaryText.y + summaryText.height;
		}
		
		public function canGotoConsortia(value:Boolean):void {
			gotoC.visible = value;
		}
		
		private function gotoConsortia(e:MouseEvent):void {
			StateManager.setState(StateType.CONSORTIA);
			TaskMainFrame.Instance.switchVisible();
		}
		private function clear():void{
			_info = null;
			summaryTitle.visible = false;
			summaryText.text = "";
			for each (var view:QuestConditionView in condArr){
				if(view.parent){
					view.parent.removeChild(view);
				}
				view.dispose();
			}
			condArr = new Array();
		}
		public function get info():QuestInfo{
			return _info;
		}
		
		public function dispose():void{
			if(gotoC) {
				removeChild(gotoC);
				gotoC = null;
			}
			for each(var e:QuestConditionView in condArr){
				e.dispose();
				e = null;
			}
			if(this.parent){
				this.parent.removeChild(this);
			}
		}
	}
}