package ddt.data.player
{
	public class ChurchPlayerInfo
	{
		private var _info:PlayerInfo;
		
		public function get info():PlayerInfo
		{
			return _info;
		}
		
		public var posX:int;
		public var posY:int;
		
		public function ChurchPlayerInfo(info:PlayerInfo)
		{
			_info = info;
		}
	}
}