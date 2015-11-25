package ddt.command.fightLibCommands
{
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HFrame;

	public class PopupHFrameCommand extends BaseFightLibCommand
	{
		private var _frame:HConfirmDialog;
		private var _callBack:Function;
		
		public function PopupHFrameCommand(infoString:String,okLabel:String=null,okCallBack:Function = null,cancelLabel:String = null,cancelCallBack:Function=null,showOkBtn:Boolean = true,showCancelBtn:Boolean=false)
		{
			_frame = new HConfirmDialog("",infoString,true,finish,cancelCallBack,okLabel,cancelLabel,300);
			_callBack = okCallBack;
		}
		
		override public function excute():void
		{
			super.excute();
			_frame.show();
		}
		
		override public function finish():void
		{
			if(_callBack!=null)
			{
				_callBack();
			}
			_frame.hide();
			super.finish();
		}
		
		override public function undo():void
		{
			_frame.hide();
			super.undo();
		}
		
		override public function dispose():void
		{
			if(_frame)
			{
				_frame.hide();
				_frame.dispose();
				_frame = null;
			}
			_callBack = null;
		}
	}
}