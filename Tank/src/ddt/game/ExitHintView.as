package ddt.game
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.manager.TipManager;
	
	import ddt.manager.LanguageMgr;

	public class ExitHintView extends HConfirmDialog
	{
		override public function ExitHintView(title:String, msg:String, model:Boolean=true, callback:Function=null, cancelback:Function=null, confirmLabel:String=null, cancelLabels:String=null, frameWidth:Number=0)
		{
			super(title, msg, model, callback, cancelback, confirmLabel, cancelLabels, frameWidth);
		    
		}
		
		public static function show(title:String,msg:String,model:Boolean = true,callback:Function = null,cancelback:Function = null,autoClear:Boolean = true,confirmLabel:String = null,cancelLabel:String = null,frameWidth:Number = 0,isSetFocus:Boolean = true):HConfirmDialog
		{
			var format:TextFormat = new TextFormat("Arial",12,0xff0000);
			var hint:TextField = new TextField();
			hint.defaultTextFormat = format;
			hint.text = LanguageMgr.GetTranslation("ddt.view.ExitHint.hint.text");
			//hint.text = "退出后将扣除一定的经验及功勋。";
			hint.autoSize = TextFieldAutoSize.LEFT;
			hint.x = 48;
			hint.y = 83;
			
			var dialog:HConfirmDialog = new HConfirmDialog(title,msg,model,callback,cancelback,confirmLabel,cancelLabel,frameWidth);
			dialog.IsSetFouse = isSetFocus;
			dialog.setSize(290,160);
			if(autoClear)
				TipManager.AddTippanel(dialog,true);	
			else
				TipManager.AddToLayerNoClear(dialog,true);
				
			dialog.addChild(hint);
			return dialog;
		}
	}
}