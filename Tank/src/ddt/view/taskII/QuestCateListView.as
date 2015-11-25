package ddt.view.taskII
{
	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ddt.manager.TaskManager;

	public class QuestCateListView extends ScrollPane
	{
		private var _content:Sprite;
		private var _stripArr:Array;
		private var _currentStrip:TaskPannelStripView;
		public function QuestCateListView()
		{
			super();
			_stripArr = new Array();
			initView();
		}
		private function initView():void{
			var myBg:Shape = new Shape();
			myBg.graphics.beginFill(0x000000,0);
			myBg.graphics.drawRect(0,0,10,10);
			myBg.graphics.endFill();
			setStyle("upSkin",myBg);
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.AUTO;
		}
		public function set dataProvider(value:Array):void{
			if(value.length ==0){
				return;
			}
			source = null;
			this.height = 0;
			clear();
			_content = new Sprite();
			var needScrollBar:Boolean = false;
			if(value.length>7){
				needScrollBar = true;
			}
			for(var i:int=0;value[i];i++){
				var strip:TaskPannelStripView = new TaskPannelStripView(value[i]);
				strip.x = 8;
				if(needScrollBar){
					strip.x = 0;
				}
				strip.y = i*40;
				strip.addEventListener(MouseEvent.CLICK,__onStripClicked);
				_content.addChild(strip);
				_stripArr.push(strip);
			}
			source = _content;
			if(_content.height<285){
				this.setSize(this.width,_content.height);
			}else{
				this.setSize(this.width,285);
			}
			this.dispatchEvent(new Event(Event.CHANGE));
			
		}
		public function active():void{
			for each(var strip:TaskPannelStripView in _stripArr){
				if(strip.info == TaskManager.selectedQuest){
					gotoStrip(strip);
					strip.active();
					return;
				}
			}
			if(_stripArr[0]){
				gotoStrip(_stripArr[0]);
				_stripArr[0].active();
				return;
			}
		}
		private function gotoStrip(strip:TaskPannelStripView):void{
			if(_currentStrip == strip){
				return;
			}
			if(_currentStrip){
				_currentStrip.deactive();
			}
			_currentStrip = strip;
			strip.active();
			//TaskManager.jumpToQuest(_currentStrip.info);
			dispatchEvent(new Event(Event.CHANGE));
		}
		private function __onStripClicked(e:MouseEvent):void{
			gotoStrip(e.target as TaskPannelStripView)
			
		}
		private function clear():void{
			if(_content){
				_content = null;
			}
			for each(var strip:TaskPannelStripView in _stripArr ){
				strip.removeEventListener(MouseEvent.CLICK,__onStripClicked);
				strip.dispose();
				_stripArr = new Array();
			}
		}
		
		public function dispose():void{
			clear();
			if(this.parent)
				this.parent.removeChild(this);
		}
	}
}