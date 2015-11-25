package ddt.command.fightLibCommands
{
	import flash.events.Event;
	
	import ddt.events.FightLibCommandEvent;

	/**
	 * 
	 * @author WickiLA
	 * @time 0601/2010
	 * @description 需要等待的命令，比如执行完函数以后要等待用户输入才执行下一条命令的，会造成脚本命令的阻塞
	 */	
	public class WaittingCommand extends BaseFightLibCommand
	{
		protected var _finishFun:Function;
		public function WaittingCommand(finishFun:Function)
		{
			super();
			_finishFun = finishFun;
		}
		
		override public function finish():void
		{
			if(_finishFun!=null)
			{
				_finishFun();
			}
			super.finish();
		}
		
		override public function excute():void
		{
			super.excute();
			dispatchEvent(new FightLibCommandEvent(FightLibCommandEvent.WAIT));
		}
		
		override public function dispose():void
		{
			_finishFun = null;
			super.dispose();
		}
	}
}