package ddt.view.effort
{
	import crazytank.view.effort.EffortCompleteValue;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class EffortScaleStrip extends EffortCompleteValue
	{
		private var _bgWidth   :int;
		private var _bgHigh    :int;
		
		private var _stripWidth:int;
		private var _stripHigh :int;
		
		private var _totalValue:int;
		private var _currentVlaue:int;
		public function EffortScaleStrip(totalValue:int ,title:String="" , bgWidth:int =315  , bgHigh:int =28)
		{
			_totalValue = totalValue;
			_bgWidth    = bgWidth;
			_bgHigh     = bgHigh;
			_stripWidth = _bgWidth - 7;
			_stripHigh  = _bgHigh  - 10;
			super();
			title_txt.text = title;
			init();
		}
		
		private function init():void
		{
			initBg();
			initStrip();
			this.light_mc.visible = false;	
			if(title_txt.text == "")
			{
				scale_txt.x = _stripWidth/2 - scale_txt.width/2;
			}else
			{
				scale_txt.x = bg.width - scale_txt.width - 5;
			}
			scale_txt.mouseEnabled = false;
			title_txt.mouseEnabled = false;
		}
		
		private function initBg():void
		{
			this.bg.bg_2.width = _bgWidth - bg.bg_1.width -bg.bg_3.width;
			this.bg.height = _bgHigh;
			this.bg.bg_3.x = bg.bg_2.x + bg.bg_2.width;
			this.bg.bg_1.y = bg.bg_2.y = bg.bg_3.y;
		}
		
		private function initStrip():void
		{
			this.completeStrip.strip_2.width = _stripWidth - completeStrip.strip_1.width -completeStrip.strip_3.width;
			this.completeStrip.height = _stripHigh;
			this.completeStrip.strip_3.x = completeStrip.strip_2.x + completeStrip.strip_2.width;
			this.completeStrip.strip_1.y = completeStrip.strip_2.y + completeStrip.strip_3.y;
		}
		
		
		private function __stripOver(evt:MouseEvent):void
		{
			this.light_mc.visible = true;
		}
		
		private function __stripOut(evt:MouseEvent):void
		{
			this.light_mc.visible = false;	
		}
		
		public function set currentVlaue(value:int):void
		{
			_currentVlaue = value;
			update();
		}
		public function setButtonMode(value:Boolean):void
		{
			this.buttonMode = value;
			if(this.buttonMode)
			{
				addEventListener(MouseEvent.MOUSE_OVER , __stripOver);
				addEventListener(MouseEvent.MOUSE_OUT , __stripOut);
			}
		}
		
		public function setAutoSize(type:int):void
		{
			var textFormat:TextFormat = scale_txt.defaultTextFormat;
			switch(type)
			{
				case 0:
					textFormat.align = TextFormatAlign.LEFT;
					break;
				case 1:
					textFormat.align = TextFormatAlign.RIGHT;
					break;
				case 2:
					textFormat.align = TextFormatAlign.CENTER;
					break;
			}
			scale_txt.defaultTextFormat = textFormat;
		}
		
		private function update():void
		{
			exp_mask.width = (_currentVlaue/_totalValue)*_stripWidth;
			scale_txt.text = String(_currentVlaue) + "/" + String(_totalValue);
		}
		
		public function dispose():void
		{
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
			removeEventListener(MouseEvent.MOUSE_OVER , __stripOver);
			removeEventListener(MouseEvent.MOUSE_OUT  , __stripOut);
		}
	}
}