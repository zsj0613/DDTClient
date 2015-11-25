package ddt.tofflist.data
{
	
	import ddt.data.ConsortiaInfo;
	public class TofflistConsortiaData
	{
		private var _playerInfo    : TofflistPlayerInfo;
		private var _consortiaInfo : TofflistConsortiaInfo;
		
		public function set playerInfo(info : TofflistPlayerInfo) : void
		{
			this._playerInfo = info;
		}
		public function get playerInfo() : TofflistPlayerInfo
		{
			return this._playerInfo;
		}
		public function set consortiaInfo(info : TofflistConsortiaInfo) : void
		{
			this._consortiaInfo = info;
		}
		public function get consortiaInfo() : TofflistConsortiaInfo
		{
			return this._consortiaInfo;
		}

	}
}