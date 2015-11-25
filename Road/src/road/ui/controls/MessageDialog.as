package road.ui.controls
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class MessageDialog extends Frame2
	{
		protected var _title:String;
		protected var _msg:String;
		
		protected var titleField:TextField;
		protected var msgField:TextField;
		protected var contentWidth:Number;
		protected var contentHeight:Number;
		
		private static const defaultStyle:Object = { alertHeaderTextFormat:new TextFormat("_sans", 12, 0xffffff, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0),
													 alertHeaderFilter:new GlowFilter(0x000000,1,2,2,1000,1),
													 alertContentTextFormat:new TextFormat("_sans", 12, 0x003366, false, false, false, "", "", TextFormatAlign.CENTER, 0, 0, 0, 0)}
		
		public static function getStyleDefinition():Object 
		{ 
			return mergeStyles(defaultStyle,Frame2.getStyleDefinition());
		}
		
		public function MessageDialog(title:String,msg:String,model:Boolean = true)
		{
			_title = title;
			_msg = msg;
			super(model);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			var w:uint = 240;
			
			setName(_title);
			
			msgField = new TextField();
			msgField.text = _msg;
			msgField.setTextFormat(getStyleValue("alertContentTextFormat") as TextFormat);
			msgField.width = w - 16;
			msgField.autoSize = TextFieldAutoSize.LEFT;
			msgField.wordWrap = true;
			msgField.selectable = false;
			msgField.x = 8;
			msgField.y = 8;
			
			ContentPanel.addChild(msgField);
			
			this.contentWidth = w;
			this.contentHeight = msgField.height + 16;
			setContentSize(contentWidth,contentHeight);
			
			
			this.addEventListener(Event.ADDED_TO_STAGE,__addToStage);
		}
		
		public function setMsgTextFormat(t:TextFormat):void
		{
			msgField.setTextFormat(t);
		}
		
		protected function __addToStage(evt:Event):void
		{
			x = (stage.stageWidth - width)/ 2;
			y = (stage.stageHeight - height) / 2;
		}
		

		
		public static function show(title:String,msg:String,model:Boolean = true):MessageDialog
		{
			var dialog:MessageDialog = new MessageDialog(title,msg,model);
			dialog.show();
			if(dialog.stage)
			{
				dialog.stage.focus = dialog;
			}
			return dialog;
		}
	}
}