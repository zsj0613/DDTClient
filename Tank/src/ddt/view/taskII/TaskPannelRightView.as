package  ddt.view.taskII
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import ddt.data.quest.QuestDataInfo;
	import ddt.data.quest.QuestInfo;
	import ddt.manager.TaskManager;
	
	import webgame.crazytank.view.task.TaskPannelRightAsset;

	public class TaskPannelRightView extends TaskPannelRightAsset
	{ 
		
		private var _info:QuestInfo;
		
		private var _content:TextField;
		
		private var _conditionsArray:Array;
		
		private var _questSummaryContent:TextField;
		
		private var _currentPosY:Number;
		
		private var _data : QuestDataInfo
		
		public function set info(value:QuestInfo):void
		{
			_info = value;
			_data = TaskManager.getTaskData(_info.QuestID);
			update();
		}
		
		public function get info() : QuestInfo
		{
			return this._info;
		}
		public function TaskPannelRightView()
		{
			
			initView();
		}
		
		private function update():void
		{
			_content.text = _info.Objective;
			_questSummaryContent.text = _info.Detail;
			for(var i:int=0;i<4;i++){
				if(_info._conditions[i]){
					_conditionsArray[i].text = _info.conditionDescription[i];
					addChild(_conditionsArray[i])
				}else{
					if(_conditionsArray[i].parent){
						removeChild(_conditionsArray[i])
					}
				}
			}
			updatePos();
		}
		
		private function initView():void
		{
			var conFormat:TextFormat = new TextFormat();
			conFormat.bold = true;
			txtCon1.autoSize = TextFieldAutoSize.LEFT;
			txtCon1.defaultTextFormat = conFormat;
			txtCon2.autoSize = TextFieldAutoSize.LEFT;
			txtCon2.defaultTextFormat = conFormat;
			txtCon3.autoSize = TextFieldAutoSize.LEFT;
			txtCon3.defaultTextFormat = conFormat;
			txtCon4.autoSize = TextFieldAutoSize.LEFT;
			txtCon4.defaultTextFormat = conFormat;
			_conditionsArray = new Array(txtCon1,txtCon2,txtCon3,txtCon4);
			_content = createText(0,8,0xff9900,18,"Arial",true,"",245);
			_content.autoSize = TextFieldAutoSize.LEFT;
			addChild(_content);
				
			_questSummaryContent = createText(15,0,0xffffff,14,"Arial",true,"",245);
			addChild(_questSummaryContent);
		}
		private function __onAwardComplete(e:Event):void{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		private function updatePos():void
		{
			_currentPosY = 3
			target_mc.y = _currentPosY;
			_content.y = (_currentPosY+=34);
			_content.x = 15;
			_currentPosY += _content.height;
			for(var i:int=0;i<4;i++){
				if(!_conditionsArray[i].parent){
					continue;
				}
				_conditionsArray[i].x = target_mc.x+15;
				_conditionsArray[i].y = _currentPosY;
				_currentPosY+= ((_conditionsArray[i] as TextField).textHeight + 3);
			}
			_questSummaryContent.x = 15;
			_questSummaryContent.y = _currentPosY + 9;
			_currentPosY += 9;
			_currentPosY += _questSummaryContent.textHeight; 
			
			bg_mc.width = this.width;
			bg_mc.height = _currentPosY
			bg_mc.visible = false;
			this.hitArea = bg_mc;
			bg_mc.visible = false;
			dispatchEvent(new Event(Event.COMPLETE));
		}

		
		private function createText(posX:int,posY:int,color:uint,size:int,font:String,isBold:Boolean = false,content:String = "",$width:int=330):TextField
		{
			var format:TextFormat = new TextFormat();
			format.bold = isBold;
			format.font = font;
			format.color = color;
			format.size = size;
			var txt:TextField = new TextField();
			txt.defaultTextFormat = format;
			txt.selectable = false;
			txt.multiline = true;
			txt.wordWrap = true;
			txt.width = $width;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.x = posX;
			txt.y = posY;
			txt.mouseWheelEnabled = false;
			txt.text = content;
			return txt;
		}
		public function dispose():void
		{
			_info = null;
			if(_content.parent)
			{
				removeChild(_content);
			}
			_content = null;
			for each(var condition:DisplayObject in _conditionsArray){
				if(condition.parent)
			{
				removeChild(condition);
			}
			condition = null;
			}
		}
		
	}
}