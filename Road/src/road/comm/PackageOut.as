package road.comm
{
	import flash.utils.*;
	import road.serialize.json.*;
	
	public class PackageOut extends ByteArray
	{
		private var _checksum:int;
		private var _code:int;
		public static const HEADER:int = 29099;
		
		public function PackageOut(param1:int, param2:int = 0, param3:int = 0, param4:int = 0)
		{
			writeShort(HEADER);
			writeShort(0);
			writeShort(0);
			writeShort(param1);
			writeInt(param2);
			writeInt(param3);
			writeInt(param4);
			this._code = param1;
			this._checksum = 0;
			return;
		}// end function
		
		public function get code() : int
		{
			return this._code;
		}// end function
		
		public function pack() : void
		{
			this._checksum = this.calculateCheckSum();
			var _loc_1:* = new ByteArray();
			_loc_1.writeShort(this.length);
			_loc_1.writeShort(this._checksum);
			this[2] = _loc_1[0];
			this[3] = _loc_1[1];
			this[4] = _loc_1[2];
			this[5] = _loc_1[3];
			return;
		}// end function
		
		public function calculateCheckSum() : int
		{
			var _loc_1:int = 119;
			var _loc_2:int = 6;
			var _loc_3:* = this.length;
			while (_loc_2 < _loc_3)
			{
				
				_loc_1 = _loc_1 + this[_loc_2++];
			}
			return _loc_1 & 32639;
		}// end function
		
		public function writeDate(param1:Date) : void
		{
			this.writeShort(param1.getFullYear());
			this.writeByte((param1.month + 1));
			this.writeByte(param1.day);
			this.writeByte(param1.hours);
			this.writeByte(param1.minutes);
			this.writeByte(param1.seconds);
			return;
		}// end function
		
		public function writeJsonObject(param1:Object) : void
		{
			this.writeUTF(road.serialize.json.JSON.encode(param1));
			return;
		}// end function
		
	}
}
