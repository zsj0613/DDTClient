package road.ui.controls
{
	import fl.controls.ScrollPolicy;
	import fl.controls.TextArea;
	import fl.core.InvalidationType;
	
	import flash.text.TextFormat;
	
	[Event(name = "link",type = "TextEvent")]
	public class SimpleTextArea extends TextArea
	{
		private var _autoScroll:Boolean;
		
		public function SimpleTextArea()
		{
			super();
		}
		
		public function get autoScroll():Boolean
		{
			return _autoScroll;
		}
		public function set autoScroll(value:Boolean):void
		{
			_autoScroll = value;
			invalidate(InvalidationType.SIZE);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			_autoScroll = true
			
			_horizontalScrollPolicy = ScrollPolicy.OFF;
			_verticalScrollPolicy = ScrollPolicy.AUTO;	
		}
		
		override public function get enabled():Boolean
		{
			return super.enabled;
		}
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			super.editable = value;
			if(value)
			{
				_verticalScrollPolicy = ScrollPolicy.AUTO;
			}
			else
			{
				_verticalScrollPolicy = ScrollPolicy.OFF;
			}
		}
		
		public function appendTextWithFormat(text:String,format:TextFormat = null):void
		{
			var ol:Number = length;
			appendText(text);
			if(format)
			{
				textField.setTextFormat(format,ol,length);
			}
			invalidate(InvalidationType.DATA);
		}
		
		public function appendHtmlText(text:String,format:TextFormat = null):void
		{
			htmlText += SimpleTextArea.getHtmlText(text,format);
			invalidate(InvalidationType.DATA);
		}
		
		public function appendURLText(text:String,format:TextFormat = null,url:String = ""):void
		{
			var str:String = SimpleTextArea.getHtmlText(text,format);
			if(url != "")
			{
				str = "<a href = '" + url + "'>" + str + "</a>";
			}
			htmlText += str;
			invalidate(InvalidationType.DATA);
		}
		
		public function appendEventText(text:String,format:TextFormat = null,event:String = ""):void
		{
			htmlText += SimpleTextArea.getEventText(text,format,event);
			invalidate(InvalidationType.DATA);
		}
		
		public static function getHtmlText(text:String,format:TextFormat = null):String
		{
			var str:String = text;
			if(format)
			{
				str = "<font color = '#" + format.color.toString(16) + "' size = '" + format.size + "' face = '" + format.font + "'>" + text + "</font>";
				if(format.bold)str = "<b>" + str + "</b>";
				if(format.italic)str = "<i>" + str + "</i>";
				if(format.underline)str = "<u>" + str + "</u>";
			}
			return str;
		}
		
		public static function getEventText(text:String,format:TextFormat = null,event:String = ""):String
		{
			var str:String = SimpleTextArea.getHtmlText(text,format);
			if(event != "")
			{
				str = "<a href = 'event:" + event + "'>" + str + "</a>";
			}
			return str;
		}
		
		override protected function drawLayout():void
		{
			super.drawLayout();
			if(_autoScroll)
			{
				verticalScrollBar.scrollPosition = verticalScrollBar.maxScrollPosition;
			}
		}
		
	}
}