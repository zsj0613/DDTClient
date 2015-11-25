package road.ui.controls
{
	import fl.controls.Button;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import road.ui.manager.TipManager;
	
	public class ConfirmDialog extends MessageDialog
	{
		public static var OK_LABEL:String = "Ok";
		public static var CANCEL_LABEL:String = "Cancel";
		
		protected var _btnOK:Button;
		protected var _btnCancel:Button;
		protected var __callback:Function;
		protected var __cancelback:Function;
		protected var _confirmLabel:String;
		protected var _cancelLabel:String;	
		
		public function ConfirmDialog(title:String, msg:String, model:Boolean=true,callback:Function = null,cancelback:Function = null,confirmLabel:String = null,cancelLabel:String = null)
		{
			__callback = callback;
			__cancelback = cancelback;
			_confirmLabel = confirmLabel ? confirmLabel : OK_LABEL;
			_cancelLabel = cancelLabel ? cancelLabel : CANCEL_LABEL;
			super(title,msg,model);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			_btnOK = new Button();
			_btnOK.label = _confirmLabel;
			_btnOK.setSize(_btnOK.textField.textWidth + 26,24);
			_btnCancel = new Button();
			_btnCancel.label = _cancelLabel;
			_btnCancel.setSize(_btnCancel.textField.textWidth + 26,24);
			
			_btnOK.x = (contentWidth - (_btnOK.width + _btnCancel.width + 4)) / 2;
			_btnCancel.x = _btnOK.x + _btnOK.width + 4;
			_btnOK.addEventListener(MouseEvent.CLICK,__btnOKClick);
			_btnCancel.addEventListener(MouseEvent.CLICK,__btnCancelClick);
			
			ButtomPanel.addChild(_btnOK);
			ButtomPanel.addChild(_btnCancel);
		}
		
		public function get okBtn():Button
		{
			return _btnOK;
		}
		public function get cancelBtn():Button
		{
			return _btnCancel;
		}
		
		private function __btnOKClick(evt:MouseEvent):void
		{
			super.doClosing();
			if(parent)
				parent.removeChild(this);
			if(__callback != null)
			{
				__callback();
			}
		}
		
		override protected function __addToStage(evt:Event):void
		{
			super.__addToStage(evt);
			stage.focus = this;
		}
		
		private function __btnCancelClick(evt:MouseEvent):void
		{
			doClosing();
		}
		
		override protected function doClosing():void
		{
			super.doClosing();
			if(__cancelback != null)
			{
				__cancelback();
			}
		}
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			removeKeyEvent();
			if(event.keyCode == Keyboard.ENTER)
			{
				event.stopImmediatePropagation();
				__btnOKClick(null);
			}
			else if(event.keyCode == Keyboard.ESCAPE)
			{
				event.stopImmediatePropagation();
				__btnCancelClick(null);
			}
		}
		
		public function removeKeyEvent():void
		{
			removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			removeEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
		}
		
		public function addKeyEvent():void
		{
			addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
		}
		
		public static function show(title:String,msg:String,model:Boolean = true,callback:Function = null,cancelback:Function = null,autoClear:Boolean = true,confirmLabel:String = null,cancelLabel:String = null):ConfirmDialog
		{
			var dialog:ConfirmDialog = new ConfirmDialog(title,msg,model,callback,cancelback,confirmLabel,cancelLabel);
			dialog.addKeyEvent();
			if(autoClear)
				TipManager.AddTippanel(dialog,true);
			else
				TipManager.AddToLayerNoClear(dialog,true);
			return dialog;
		}
	}
}