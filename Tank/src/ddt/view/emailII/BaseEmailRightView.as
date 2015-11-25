package ddt.view.emailII
{
	import fl.controls.TextArea;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HFrame;

	public class BaseEmailRightView extends HFrame
	{
		protected var _sender:TextField;
		
		protected var _topic:TextField;
		
		protected var _ta:TextArea;
		
		public function BaseEmailRightView()
		{
			super();
			alphaGound = false;
			blackGound = true;
			fireEvent = false;
			showBottom = true;
			showClose = true;
			moveEnable = false;
			
			initView();
			addEvent();
		}
		
		protected function initView():void
		{	
			_sender = new TextField();
			_sender.maxChars = 36;
			_sender.defaultTextFormat = new TextFormat("Arial",12,0x000000);
			
			_topic = new TextField();
			_topic.maxChars = 22;
			_topic.defaultTextFormat = new TextFormat("Arial",12,0x000000);
			
			_ta = new TextArea();
			_ta.setStyle("upSkin",new Sprite());
			_ta.setStyle("disabledSkin",new Sprite());
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.size = 12;
			format.color = 0x000000;
			format.leading = 3;
			_ta.setStyle("disabledTextFormat",format);
			_ta.setStyle("textFormat",format);
		}
		
		protected function addEvent():void
		{
		}
		
		protected function removeEvent():void
		{
		}
		
		protected function btnSound():void
		{
			SoundManager.instance.play("043");
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			removeEvent();
			
			if(_sender.parent)
			{
				_sender.parent.removeChild(_sender);
			}
			_sender = null;
			
			if(_topic.parent)
			{
				_topic.parent.removeChild(_topic);
			}
			_topic = null;
			
			if(_ta.parent)
			{
				_ta.parent.removeChild(_ta);
			}
			_ta = null;			
		}
		
		
	}
}