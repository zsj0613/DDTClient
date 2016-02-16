package ddt.view.taskII
{
	import crazytank.view.task.QuestItemAsset;
	
	import fl.controls.TextArea;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import road.manager.SoundManager;
	
	import ddt.data.quest.QuestDataInfo;
	import ddt.data.quest.QuestInfo;
	import ddt.events.TaskEvent;
	import ddt.manager.TaskManager;
	
	import webgame.crazytank.view.task.TaskPannelStripAsset;
	
	public class TaskPannelStripView extends QuestItemAsset
	{
		
		private var _info:QuestInfo;
		private var _status:String;
		
		private function set status(value:String):void{
			if(value == _status){
				return;
			}
			_status = value;
			update();
		}
		public function get info():QuestInfo
		{
			return _info;
		}
		
		
		
		private function get isHovered():Boolean{
			return (_status == "hover");
		}
		private function get isSelected():Boolean{
			return (_status == "active");
		}
		
		
		public function TaskPannelStripView(info:QuestInfo)
		{
			_info = info;
			initView();
			addEvent();
		}
		
		private function initView():void
		{
			mouseChildren = false;
			buttonMode = true;
			taskOverMc.visible = false;
			newTaskMc.visible = false;
			status = "normal"
			
			titleField.text = _info.Title;
			titleFieldHighlighted.text = _info.Title;
			txtTitleHighlightedSpecial.visible = false;
			txtTitleHighlighted.visible = false;
			txtTitleSpecial.visible = false;
			txtTitle.visible = false;
			update();
		}
		
		private function get titleField():TextField{
			if(_info.data && _info.data.quality>1){
				return txtTitleSpecial;
			}else{
				return txtTitle
			}
		}
		private function get titleFieldHighlighted():TextField{
			if(_info.data && _info.data.quality>1){
				return txtTitleHighlightedSpecial;
			}else{
				return txtTitleHighlighted;
			}
		}
		protected function addEvent():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,__onRollOver);
			addEventListener(MouseEvent.MOUSE_OUT,__onRollOut);
			addEventListener(MouseEvent.CLICK,__onClick);
		}
		protected function removeEvent():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER,__onRollOver);
			removeEventListener(MouseEvent.MOUSE_OUT,__onRollOut);
			removeEventListener(MouseEvent.CLICK,__onClick);
		}
		
		
		
		
		private function update():void
		{
			
			
			taskOverMc.visible = false;
			newTaskMc.visible = false;
			
			if(_info.isCompleted){
				taskOverMc.visible = true;
			}else if(_info.data && _info.data.isNew){
				newTaskMc.visible = true;
			}
			titleFieldHighlighted.visible = false;
			titleField.visible = true;
			
			if(isSelected){
				gotoAndStop("selected");
				titleFieldHighlighted.visible = true;
				titleField.visible = false;
			}else if(isHovered){
				gotoAndStop("hover");
			}else{
				gotoAndStop("normal");
			}
			
		}
		private function __onRollOver(event:MouseEvent):void
		{
			if(isSelected){
				return;
			}
			status = "hover";
		}	
		
		private function __onRollOut(event:MouseEvent):void
		{
			if(isSelected){
				return;
			}
			status = "normal";
		}
		
		private function __onClick(event:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			_active();
		}
		protected function _active() : void
		{
			if(isSelected)return;
			
			status = "active"
			dispatchEvent(new TaskEvent(TaskEvent.CHANGED,_info,_info.data));
			TaskManager.jumpToQuest(_info);
		}
		protected function _deactive():void{
			if(isSelected){
				status = "normal";
			}
		}
		
		
		
		public function active():void
		{
			_active();
		}
		public function deactive():void{
			_deactive();
		}
		
		public function dispose():void{
			removeEvent();
			if(this.parent)
				this.parent.removeChild(this);
		}
	}
}