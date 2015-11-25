package ddt.view.personalinfoII
{
	import flash.events.EventDispatcher;
	
	import ddt.data.player.PlayerInfo;

	public class PersonalInfoIIModel extends EventDispatcher implements IPersonalInfoIIModel
	{
		private var _info:PlayerInfo;
		
		public function PersonalInfoIIModel(info:PlayerInfo)
		{
			_info = info;
			super();
		}
		
		public function getPlayerInfo():PlayerInfo
		{
			return _info;
		}
		
		public function dispose():void
		{
			_info = null;
		}
	}
}