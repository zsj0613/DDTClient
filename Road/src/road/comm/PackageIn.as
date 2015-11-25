package road.comm
{
	import flash.utils.ByteArray;
	import road.serialize.json.JSON;
	
	
	public class PackageIn extends ByteArray
	{
		private var _len:int;
		private var _checksum:int;
		private var _clientId:int;
		private var _code:int;
		private var _extend1:int;
		private var _extend2:int;
		public static const HEADER_SIZE:Number = 20;
		
		public function PackageIn()
		{
			return;
		}// end function
		
		public function load(param1:ByteArray, param2:int) : void
		{
			param1.readBytes(this, 0, param2);
			this.readHeader();
			return;
		}// end function
		
		public function loadE(param1:ByteArray, param2:int, param3:int) : void
		{
			var _loc_4:int = 0;
			while (_loc_4 < param2)
			{
				
				writeByte(param1.readByte() ^ (param3++ & 255 << 16) >> 16);
				_loc_4 = _loc_4 + 1;
			}
			position = 0;
			this.readHeader();
			return;
		}// end function
		
		public function readHeader() : void
		{
			readShort();
			this._len = readShort();
			this._checksum = readShort();
			this._code = readShort();
			this._clientId = readInt();
			this._extend1 = readInt();
			this._extend2 = readInt();
			return;
		}// end function
		
		public function get checkSum() : int
		{
			return this._checksum;
		}// end function
		
		public function get code() : int
		{
			return this._code;
		}// end function
		
		public function get clientId() : int
		{
			return this._clientId;
		}// end function
		
		public function get extend1() : int
		{
			return this._extend1;
		}// end function
		
		public function get extend2() : int
		{
			return this._extend2;
		}// end function
		
		public function get Len() : int
		{
			return this._len;
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
		
		public function readJson() : Object
		{
			return road.serialize.json.JSON.decode(readUTF());
		}// end function
		
		public function readXml() : XML
		{
			return new XML(readUTF());
		}// end function
		
		public function readDateString() : String
		{
			return readShort() + "-" + readByte() + "-" + readByte() + " " + readByte() + ":" + readByte() + ":" + readByte();
		}// end function
		
		public function readDate() : Date
		{
			return new Date(readShort(), (readByte() - 1), readByte(), readByte(), readByte(), readByte());
		}// end function
		
		public function readByteArray() : ByteArray
		{
			var _loc_1:* = new ByteArray();
			readBytes(_loc_1, 0, this._len - this.position);
			_loc_1.position = 0;
			return _loc_1;
		}// end function
		

		public function depack() : void
		{
			this.position = HEADER_SIZE;
			var _loc_1:* = new ByteArray();
			readBytes(_loc_1, 0, this._len - HEADER_SIZE);
			_loc_1.uncompress();
			this.position = HEADER_SIZE;
			this.writeBytes(_loc_1, 0, _loc_1.length);
			this._len = HEADER_SIZE + _loc_1.length;
			this.position = HEADER_SIZE;
			return;
		}

	}
}
