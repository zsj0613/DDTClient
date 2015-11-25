package ddt.view.HAccordion
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class AccordionStrip extends Sprite
	{
		private var _bg:Sprite;
		private var _text:TextField;
		private var _opened:Boolean = false;
		private var _isParent:Boolean = false;
		
		public function AccordionStrip(bg:Sprite=null,text:String="",isParent:Boolean = false)
		{
			super();
			_bg = bg;
			if(_bg != null)
			{
				addChild(_bg);
			}
			_text = new TextField();
			_text.selectable = false;
			_text.width = 450;
			_text.height = 35;
			_text.defaultTextFormat = new TextFormat("微软雅黑","22",0x330000,true);
			_text.filters = [new GlowFilter(0xffffff,1,5,5,3,1)];
			_text.text = text;
			addChild(_text);
		}
		
		public function get textField():TextField
		{
			return _text;
		}
		
		public function get isOpened():Boolean
		{
			return _opened;
		}
		
		public function open():void
		{
			if(isOpened) return;
			_opened = true;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function close():void
		{
			if(!isOpened) return;
			_opened = false;
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function get isParent():Boolean
		{
			return _isParent;
		}

		public function set isParent(value:Boolean):void
		{
			_isParent = value;
		}

	}
}