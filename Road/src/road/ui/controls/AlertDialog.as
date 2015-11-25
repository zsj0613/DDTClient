package road.ui.controls
{
	import fl.controls.Button;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import road.ui.manager.TipManager;

	public class AlertDialog extends MessageDialog
	{
		public static var OK_LABEL:String = "Ok"
		
		protected var _btnOk:Button;
		protected var __callback:Function;
		protected var _confirmLabel:String;
		
		public function AlertDialog(title:String, msg:String, model:Boolean=true,callback:Function = null,confirmLabel:String = null)
		{
			__callback = callback;
			_confirmLabel = confirmLabel ? confirmLabel : OK_LABEL;
			super(title, msg, model);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			_btnOk = new Button();
			_btnOk.label = _confirmLabel;
			_btnOk.addEventListener(MouseEvent.CLICK,__btnOkClick);
			_btnOk.setSize(_btnOk.textField.textWidth + 30,24);
			
			_btnOk.x = (contentWidth - _btnOk.width) /2;
			
			ButtomPanel.addChild(_btnOk);
		}
		
		override protected function __addToStage(evt:Event):void
		{
			super.__addToStage(evt);
			stage.focus = this;
		}
		
		public function btnOK():Button
		{
			return _btnOk;
		}
		
		protected function __btnOkClick(event:MouseEvent):void
		{
			doClosing();
		}
		
		override protected function doClosing():void
		{
			super.doClosing();
			if(__callback != null)
				__callback();
		}
		
		public static function show(title:String,msg:String,model:Boolean = true,callback:Function = null,autoClear:Boolean = true,confirmLabel:String = null):AlertDialog
		{
			var dialog:AlertDialog = new AlertDialog(title,msg,model,callback,confirmLabel);
			if(autoClear)
				TipManager.AddTippanel(dialog,true);
			else
				TipManager.AddToLayerNoClear(dialog,true);
			return dialog;
		}
		
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ENTER || event.keyCode == Keyboard.ESCAPE)
			{
				event.stopImmediatePropagation();
				doClosing();
			}
		}
	}
}