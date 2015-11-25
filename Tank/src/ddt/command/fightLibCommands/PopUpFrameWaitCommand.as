package ddt.command.fightLibCommands
{
	import ddt.manager.LanguageMgr;
	import ddt.view.AlertInfoView;

	public class PopUpFrameWaitCommand extends WaittingCommand
	{
		private var _frame:AlertInfoView;
		public function PopUpFrameWaitCommand(infoString:String,$finishFun:Function,okLabel:String=null,okFun:Function=null,cancelLabel:String=null,cancelFun:Function=null,showOkBtn:Boolean = true,showCancelBtn:Boolean=false)
		{
			super($finishFun);
			_frame = new AlertInfoView(infoString,okLabel,okFun,cancelLabel,cancelFun,showOkBtn);
		}
		
		override public function excute():void
		{
			_frame.show();
			super.excute();
		}
		
		override public function undo():void
		{
			_frame.hide();
			super.undo();
		}
		
		override public function finish():void
		{
			super.finish();
			_frame.hide();
		}
		
		override public function dispose():void
		{
			_frame.dispose();
			_frame = null;
		}
	}
}