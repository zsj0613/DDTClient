package ddt.game.actions
{
	import ddt.actions.BaseAction;
	import ddt.data.game.LocalPlayer;
	import ddt.socket.GameInSocketOut;
	
	public class SelfSkipAction extends BaseAction
	{
		private var _info:LocalPlayer;
		
		public function SelfSkipAction(info:LocalPlayer)
		{
			_info = info;
		}
		
		override public function prepare():void
		{
			GameInSocketOut.sendGameSkipNext(_info.shootTime);
		}
		
	}
}