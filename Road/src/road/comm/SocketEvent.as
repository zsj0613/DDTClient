package road.comm
{
	import flash.events.*;
	
	public class SocketEvent extends Event
	{
		private var _data:PackageIn;
		public static const DATA:String = "data";
		
		public function SocketEvent(param1:String, param2:PackageIn)
		{
			super(param1);
			this._data = param2;
			return;
		}// end function
		
		public function get data() : PackageIn
		{
			return this._data;
		}// end function
		
	}
}
