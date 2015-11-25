package ddt.view.bagII
{
	import flash.events.EventDispatcher;
	
	import ddt.data.player.PlayerInfo;

	public class BagIIModel extends EventDispatcher implements IBagIIModel
	{
		private var _info:PlayerInfo;
		
		public function BagIIModel(info:PlayerInfo)
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