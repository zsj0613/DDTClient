package road.ui.controls.hframe
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import road.manager.SoundManager;
	import road.ui.manager.TipManager;
	
	public class HConfirmDialog extends HConfirmFrame
	{
		public static var OK_LABEL:String = "确 定";
		public static var CANCEL_LABEL:String = "取 消";
		
		private var doCancelFun:Function;
		public function HConfirmDialog(title:String, msg:String, model:Boolean=true,callback:Function = null,cancelback:Function = null,confirmLabel:String = null,cancelLabels:String = null,frameWidth:Number = 0)
		{
			titleText = title;
//			_contentTextField.wordWrap = true;
//			_contentTextField.autoSize = TextFieldAutoSize.NONE;
			_contentTextField.width = 1000;
			_contentTextField.multiline = true;
			_contentTextField.htmlText =  msg;
			
//			_contentTextField.setTextFormat(tFormat);
			cancelLabel = cancelLabels ? cancelLabels : CANCEL_LABEL;
			okLabel = confirmLabel ? confirmLabel : OK_LABEL;
			alphaGound = model;
			blackGound = false;
			showCancel = true;
			stopKeyEvent = true;
			
			doCancelFun = cancelback;
			
			okFunction = callOKFunction;

			cancelFunction = callCancelFunction;
			
			if(frameWidth != 0)
			{
				if(frameWidth > _contentTextField.textWidth+100)
				{
					setSize(frameWidth,_contentTextField.textHeight+110);
				}else
				{
					setSize(_contentTextField.textWidth+100,_contentTextField.textHeight+110);
				}
			}else
			{
				if(_contentTextField.textWidth+100 < 270)
				{
					setSize(270,_contentTextField.textHeight+110);
				}else
				{
					setSize(_contentTextField.textWidth+100,_contentTextField.textHeight+110);
				}
			}
			
			buttonGape = 50;
			function callOKFunction():void
			{
				if(callback != null)
				{
					dispose();
					callback();
				}else
				{
					dispose();
				}
			}
			
			function callCancelFunction ():void
			{
				if(cancelback != null)
				{
					dispose();
					cancelback();
				}else
				{
					dispose();
				}
			}
		}
		
		
		override protected function __closeClick(e:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(doCancelFun != null)
			{
				doCancelFun();
			}
			dispose();
		}
	
	
		
		public static function show(title:String,msg:String,model:Boolean = true,callback:Function = null,cancelback:Function = null,autoClear:Boolean = true,confirmLabel:String = null,cancelLabel:String = null,frameWidth:Number = 0,isSetFocus:Boolean = true,$showCancel:Boolean = true):HConfirmDialog
		{
			var dialog:HConfirmDialog = new HConfirmDialog(title,msg,model,callback,cancelback,confirmLabel,cancelLabel,frameWidth);
			dialog.IsSetFouse = isSetFocus;
			dialog.showCancel = $showCancel;
			if(autoClear)
				TipManager.AddTippanel(dialog,true);	
			else
				TipManager.AddToLayerNoClear(dialog,true);
			return dialog;
		}
		
		override protected function __addToStage(e:Event):void
		{
			e.stopImmediatePropagation();
			super.__addToStage(e);
		}
		
		override public function dispose():void
		{
			if(stage) stage.focus = stage;
			super.dispose();
			doCancelFun = null;
		}
		
		//bret 09.6.12
		public function get contentTextField():TextField
		{
			return _contentTextField;
		}
	}
}