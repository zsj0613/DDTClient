package road.ui.controls.hframe
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.ByteArray;
	
	import road.manager.SoundManager;
	import road.ui.manager.TipManager;
	
	public class HAlertDialog extends HConfirmFrame
	{
		public static var OK_LABEL:String = "Ok";
		private static var okBackFun:Function;
		private var closeCallBackFunc:Function;
		public function HAlertDialog(title:String, msg:String, model:Boolean=true,callback:Function = null,confirmLabel:String = null,closeFunc:Function = null)
		{
			super();
			titleText = title;
			okLabel = confirmLabel ? confirmLabel : OK_LABEL;
			okBackFun = callback;
			okFunction = callOKFunction;
			closeCallBackFunc = closeFunc;
			var b:ByteArray = new ByteArray();
        	b.writeUTF(msg);
        	while(b.length < 20)
        	{
        		msg = " " +msg+" ";
        		b = new ByteArray();
        		b.writeUTF(msg);
        	}
        	if(msg.indexOf("\\n") != -1)
        	{
        		var lineWidth:Number = 0;
        		var textLines:Array = msg.split("\\n");
        		var tempTF:TextField = new TextField();
        		tempTF.defaultTextFormat = _contentTextField.defaultTextFormat;
        		tempTF.autoSize = TextFieldAutoSize.LEFT;
        		for(var i:int = 0;i<textLines.length;i++)
        		{
        			tempTF.text = textLines[i];
        			lineWidth = Math.max(tempTF.width,lineWidth);
        		}
        		_contentTextField.width = lineWidth;
        		_contentTextField.text = msg.replace(/\\n/g,"\n");
        	}else
        	{
        		_contentTextField.text = msg;
        	}
			
			alphaGound = model;
			showCancel = false;
			blackGound = false;
			
			setSize(_contentTextField.width+100,_contentTextField.height+110);
		
			function callOKFunction():void
			{
				if(okBackFun != null)
				{
					okBackFun();
					if(autoClearn)
					{
						dispose();
					}
				}else
				{
					dispose();
				}
			}
			
		}
		
		override protected function __closeClick(e:MouseEvent):void
		{
			dispose();
			SoundManager.Instance.play("008");
			if(closeCallBackFunc != null)
			{
				closeCallBackFunc();
			}
		}
		
		public static function show(title:String,msg:String,model:Boolean = true,callback:Function = null,autoClear:Object = true,confirmLabel:String = null,closeFunc:Function = null):HAlertDialog
		{
			var dialog:HAlertDialog = new HAlertDialog(title,msg,model,callback,confirmLabel,closeFunc);
			dialog.autoClearn = true;
			var layerType:String = String(autoClear);
			if(layerType == "true")
			{
				TipManager.AddTippanel(dialog,true);
			}
			else if(layerType == "false")
			{
				TipManager.AddToLayerNoClear(dialog,true);
			}else if(layerType == "stage")
			{
				TipManager.addToStageLayer(dialog,true);
			}
			return dialog;
		}
	}
}