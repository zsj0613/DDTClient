package ddt.command.fightLibCommands
{
	import ddt.view.AlertInfoView;

	public class PopupFrameCommand extends BaseFightLibCommand
	{
		private var _frame:AlertInfoView;
		private var _callBack:Function;
//		,showArrow:Boolean = false,arrFrom:Point = null,arrTo:Point = null,arrStr:String="",arrStrPoint:Point=null
		public function PopupFrameCommand(infoString:String,okLabel:String=null,okCallBack:Function = null,cancelLabel:String = null,cancelCallBack:Function=null,showOkBtn:Boolean = true,showCancelBtn:Boolean=false)
		{
			_frame = new AlertInfoView(infoString,okLabel,finish,cancelLabel,cancelCallBack,showOkBtn,showCancelBtn);
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