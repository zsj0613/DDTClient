package ddt.view.taskII
{
	import crazytank.view.task.CategoryTitle;
	
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;

	public class QuestCateTitleView extends CategoryTitle
	{
		private var _type:int;
		private var _isExpanded:Boolean;
		private var _title:String;
		
		private var rLum:Number = 0.2225;
		private var gLum:Number = 0.7169;
		private var bLum:Number = 0.0606; 
		private var bwMatrix:Array = [rLum, gLum, bLum, 0, 0,
			rLum, gLum, bLum, 0, 0,
			rLum, gLum, bLum, 0, 0,
			0, 0, 0, 1, 0]; 
		private var cmf:ColorMatrixFilter;
		public function QuestCateTitleView(cateID:int = 0)
		{
			_type = cateID;
			initView();
			initEvent();
			isExpanded = false;
			cmf = new ColorMatrixFilter(bwMatrix);
		}
		private function initView():void{
			buttonMode = true;
		}
		private function initEvent():void{
		}
		
		public function set enable(value:Boolean):void{
			if(!value){
				this.filters = [cmf];
				buttonMode = false;
			}else{
				this.filters = null;
				buttonMode = true;
			}
		}
		public function get isExpanded():Boolean{
			return _isExpanded;
		}
		public function set isExpanded(value:Boolean):void{
		
			_isExpanded = value;
			if(value == true){
				this.gotoAndStop("expanded");
				this.labelText.gotoAndStop(_type+1);
			}else{
				this.gotoAndStop("collapsed");
				this.labelText.gotoAndStop(_type+11);
			}
		}
		public function haveNew():void{
			newTaskMc.visible = true;
			taskOverMc.visible = false;
		}
		public function haveCompleted():void{
			taskOverMc.visible = true;
			newTaskMc.visible = false;
		}
		public function update():void{
			newTaskMc.visible = false;
			taskOverMc.visible = false;
		}
		public function dispose():void{
			this.parent.removeChild(this);
		}
	}
}