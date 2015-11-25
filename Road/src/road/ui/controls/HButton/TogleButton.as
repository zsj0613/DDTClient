package road.ui.controls.HButton
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class TogleButton extends HTipButton
	{
		private var tip1:String;
		private var tip2:String;
		public var enableFilter:Array = [new GlowFilter(0xffffff,1,4,4,10)];
		public var enableTextFormat:TextFormat = new TextFormat();
		public var unableFilter:Array = [new GlowFilter(0xffffff,1,4,4,10)];
		public var unableTextFormat:TextFormat = new TextFormat();
				
		public function TogleButton($bg:DisplayObject,$label:String = "",$tip1:String = "",$tip2:String = "")
		{
			tip1 = $tip1;
			tip2 = $tip2;
			if($bg is MovieClip)
			{
				($bg  as MovieClip).gotoAndStop(1);
			}
			super($bg,$label,$tip1);
			mouseChildren = false;
		}
		
		private var _selected:Boolean;
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function addIcon(icon:DisplayObject,$x:int,$y:int):void
		{
			icon.x = $x;
			icon.y = $y;
			_container.addChild(icon);
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected != value)
			{
				_selected = value;
				if(_selected)
				{
					(bg as MovieClip).gotoAndStop(3);
					tipText = tip2;
				}
				else
				{
					(bg as MovieClip).gotoAndStop(1);
					tipText = tip1;
				}
				dispatchEvent(new Event(Event.SELECT));
			}
		}
		
		override protected function creatTextField():TextField
		{
			if(_label == "")return null;
			_textField = new TextField();
			_textField.autoSize = "left";
			_textField.selectable = false;
			_textField.mouseEnabled = false;
			_textField.text = _label;
			_textField.filters = [new GlowFilter(0xffffff,1,4,4,10)];
			return _textField
		}
		
		private var _gape:Number;
		public function set textGape(gape:Number):void
		{
			_gape = gape;
			center();
		}
		
		override public function center():void
		{
			if(_textField)
			{
				_textField.x = bg.x+bg.width+_gape;
				_textField.y = (bg.height - _textField.height)/2;
				graphics.clear();
				graphics.beginFill(0xff00ff,0);
				graphics.drawRect(0,0,_textField.x+_textField.width,Math.max(bg.height,_textField.height));
				graphics.endFill();
			}
			centerTip();
		}
		
		override public function set enable(b:Boolean):void
		{
			super.enable = b;
			if(_textField)
			{
				if(enable)
				{
					textFilters = enableFilter;
					textFormat = enableTextFormat;
				}else
				{
					textFilters = unableFilter;
					textFormat = unableTextFormat;
				}
			}
		}
		
		public function set textFilters(filter:Array):void
		{
			_textField.filters = filter;
		}
		
		private var _textFormat:TextFormat;
		public function set textFormat (tf:TextFormat):void
		{
			_textFormat = tf;
			_textField.setTextFormat(_textFormat);
		}
	}
}