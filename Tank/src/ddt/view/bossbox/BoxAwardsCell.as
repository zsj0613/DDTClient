package ddt.view.bossbox
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import road.manager.SoundManager;
	
	import ddt.manager.TaskManager;
	import ddt.view.cells.BaseCell;
	
	import webgame.crazytank.game.view.task.BgAsset;
	import tank.game.movement.BgBoxAsset;
	
	public class BoxAwardsCell extends BaseCell
	{
		private var count_txt:TextField;
		public function BoxAwardsCell()
		{
			super(new BgBoxAsset());
			var format:TextFormat = new TextFormat();
			format.bold = true;
			format.leading = 3;
			_bg["itemName"].defaultTextFormat = format;
			_bg["itemName"].autoSize = TextFieldAutoSize.LEFT;
			_bg["selected"].visible = false;
			this.addEventListener(Event.CHANGE,__setItemName);
			_bg["itemName"].mouseEnabled = false;
			_bg["count_txt"].mouseEnabled = false;
		}
		protected override function onMouseOver(evt:MouseEvent):void
		{
			super.onMouseOver(evt);//by wicki 0621
			_tip.mouseEnabled = false;
			_tip.mouseChildren = false;
			_tip.x += 110;
		}
		public function get shine():MovieClip{
			return _bg["shine"];
		}
		public function set count(n:int):void
		{
			count_txt = _bg["count_txt"];
			count_txt.parent.removeChild(count_txt);
			addChild(count_txt);
			//addChild(_bg["active_area"]);
			if(n<=1){
				count_txt.text = "";
				return;
			}
			count_txt.text = String(n);
			
		}
		public function __setItemName(e:Event):void{
			itemName = this._info.Name;
		}
		public function set itemName(name:String):void{
			_bg["itemName"].text = name;
			_bg["itemName"].y = (45-_bg["itemName"].textHeight)/2
		}
		public function set selected(value:Boolean):void{
			if(!_bg["selected"].visible && value){
				SoundManager.instance.play("008");
			}
			_bg["selected"].visible = value;
			TaskManager.itemAwardSelected = this.info.TemplateID;
		}
		public function initSelected():void{
			_bg["selected"].visible = true;
			TaskManager.itemAwardSelected = this.info.TemplateID;
		}
		public function get selected():Boolean{
			return _bg["selected"].visible;
		}
		public function canBeSelected():void{
			this.buttonMode = true;
			addEventListener(MouseEvent.CLICK,__selected);
		}
		private function __selected(evt:MouseEvent):void{
		
		}
		override public function dispose():void{
			super.dispose();
			_bg = null;
		}
	}
}