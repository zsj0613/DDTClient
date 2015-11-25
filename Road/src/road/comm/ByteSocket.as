package road.comm
{
	import flash.events.EventDispatcher;
	import flash.net.Socket;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import road.utils.ByteUtils;
	import flash.utils.ByteArray;
	
	public class ByteSocket extends EventDispatcher
	{
		private var _debug:Boolean;
		private var _socket:Socket;
		private var _ip:String;
		private var _port:Number;
		private var _send_fsm:FSM;
		private var _receive_fsm:FSM;
		private var _encrypted:Boolean;
		private var _readBuffer:ByteArray;
		private var _readOffset:int;
		private var _writeOffset:int;
		private var _headerTemp:ByteArray;
		
		public function ByteSocket(encrypted:Boolean = true, debug:Boolean = false)
		{
			super();
			this._readBuffer = new ByteArray();
			this._send_fsm = new FSM(2059198199, 1501);
			this._receive_fsm = new FSM(2059198199, 1501);
			this._headerTemp = new ByteArray();
			this._encrypted = encrypted;
			this._debug = debug;
			return;
		}// end function
		
		public function setFsm(param1:int, param2:int) : void
		{
			this._send_fsm.setup(param1, param2);
			this._receive_fsm.setup(param1, param2);
			return;
		}// end function
		
		public function connect(param1:String, param2:Number) : void
		{
			var ip:* = param1;
			var port:* = param2;
			try
			{
				if (this._socket)
				{
					this.close();
				}
				this._socket = new Socket();
				this.addEvent(this._socket);
				this._ip = ip;
				this._port = port;
				this._readBuffer.position = 0;
				this._readOffset = 0;
				this._writeOffset = 0;
				this._socket.connect(ip, port);
			}
			catch (err:Error)
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, err.message));
			}
			return;
		}// end function
		
		private function addEvent(param1:Socket) : void
		{
			param1.addEventListener(Event.CONNECT, this.handleConnect);
			param1.addEventListener(Event.CLOSE, this.handleClose);
			param1.addEventListener(ProgressEvent.SOCKET_DATA, this.handleIncoming);
			param1.addEventListener(IOErrorEvent.IO_ERROR, this.handleIoError);
			param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleIoError);
			return;
		}// end function
		
		private function removeEvent(param1:Socket) : void
		{
			param1.removeEventListener(Event.CONNECT, this.handleConnect);
			param1.removeEventListener(Event.CLOSE, this.handleClose);
			param1.removeEventListener(ProgressEvent.SOCKET_DATA, this.handleIncoming);
			param1.removeEventListener(IOErrorEvent.IO_ERROR, this.handleIoError);
			param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleIoError);
			return;
		}// end function
		
		public function get connected() : Boolean
		{
			return (this._socket) && (this._socket.connected);
		}
		
		public function isSame(ip:String, port:int) : Boolean
		{
			return (this._ip == ip) && (port == this._port);
		}
		
		public function send(param1:PackageOut) : void
		{
			var _loc_2:int = 0;
			var _loc_3:int = 0;
			if((this._socket) && (this._socket.connected))
			{
				param1.pack();
				if (this._debug)
				{
					trace(ByteUtils.ToHexDump("Send:" + this._port, param1, 0, param1.length));
				}
				if (this._encrypted)
				{
					_loc_2 = this._send_fsm.getState();
					_loc_3 = 0;
					while (_loc_3 < param1.length)
					{
						
						this._socket.writeByte(param1[_loc_3] ^ (_loc_2++ & 255 << 16) >> 16);
						_loc_3 = _loc_3 + 1;
					}
					this._send_fsm.updateState();
				}
				else
				{
					this._socket.writeBytes(param1, 0, param1.length);
				}
				this._socket.flush();
			}
			return;
		}// end function
		
		public function sendString(param1:String) : void
		{
			if (this._socket.connected)
			{
				this._socket.writeUTF(param1);
				this._socket.flush();
			}
			return;
		}// end function
		
		public function close() : void
		{
			this.removeEvent(this._socket);
			if (this._socket.connected)
			{
				this._socket.close();
			}
			return;
		}// end function
		
		private function handleConnect(event:Event) : void
		{
			var event:* = event;
			try
			{
				this._send_fsm.reset();
				this._receive_fsm.reset();
				this._send_fsm.setup(2059198199, 1501);
				this._receive_fsm.setup(2059198199, 1501);
				dispatchEvent(new Event(Event.CONNECT));
			}
			catch (e:Error)
			{
				trace(e.getStackTrace());
			}
			return;
		}// end function
		
		private function handleClose(event:Event) : void
		{
			var event:* = event;
			try
			{
				this.removeEvent(this._socket);
				dispatchEvent(new Event(Event.CLOSE));
			}
			catch (e:Error)
			{
				trace(e.getStackTrace());
			}
			return;
		}// end function
		
		private function handleIoError(event:ErrorEvent) : void
		{
			var event:* = event;
			try
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, event.text));
			}
			catch (e:Error)
			{
				trace(e.getStackTrace());
			}
			return;
		}// end function
		
		private function handleIncoming(event:ProgressEvent) : void
		{
			var _loc_2:int = 0;
			if (this._socket.bytesAvailable > 0)
			{
				_loc_2 = this._socket.bytesAvailable;
				this._socket.readBytes(this._readBuffer, this._writeOffset, this._socket.bytesAvailable);
				this._writeOffset = this._writeOffset + _loc_2;
				if (this._writeOffset > 1)
				{
					this._readBuffer.position = 0;
					this._readOffset = 0;
					if (this._readBuffer.bytesAvailable >= PackageIn.HEADER_SIZE)
					{
						this.readPackage();
					}
				}
			}
			return;
		}// end function
		
		private function readPackage() : void
		{
			var _loc_2:int = 0;
			var _loc_3:int = 0;
			var _loc_4:PackageIn = null;
			var _loc_1:int = this._writeOffset - this._readOffset;
			do
			{
				
				_loc_2 = 0;
				while (this._readOffset + 4 < this._writeOffset)
				{
					
					this._headerTemp.position = 0;
					this._headerTemp.writeByte(this._readBuffer[this._readOffset]);
					this._headerTemp.writeByte(this._readBuffer[(this._readOffset + 1)]);
					this._headerTemp.writeByte(this._readBuffer[this._readOffset + 2]);
					this._headerTemp.writeByte(this._readBuffer[this._readOffset + 3]);
					_loc_3 = this._receive_fsm.getState();
					if (this._encrypted)
					{
						this._headerTemp[0] = this._headerTemp[0] ^ (_loc_3++ & 255 << 16) >> 16;
						this._headerTemp[1] = this._headerTemp[1] ^ (_loc_3++ & 255 << 16) >> 16;
						this._headerTemp[2] = this._headerTemp[2] ^ (_loc_3++ & 255 << 16) >> 16;
						this._headerTemp[3] = this._headerTemp[3] ^ (_loc_3++ & 255 << 16) >> 16;
					}
					this._headerTemp.position = 0;
					if (this._headerTemp.readShort() == PackageOut.HEADER)
					{
						_loc_2 = this._headerTemp.readUnsignedShort();
						break;
						continue;
					}
					this._readOffset++;
				}
				_loc_1 = this._writeOffset - this._readOffset;
				
				if (_loc_1 >= _loc_2&&(_loc_2 != 0))
				{
					this._readBuffer.position = this._readOffset;
					_loc_4 = new PackageIn();
					if (this._encrypted)
					{
						_loc_4.loadE(this._readBuffer, _loc_2, this._receive_fsm.getState());
						this._receive_fsm.updateState();
					}
					else
					{
						_loc_4.load(this._readBuffer, _loc_2);
					}
					this._readOffset = this._readOffset + _loc_2;
					_loc_1 = this._writeOffset - this._readOffset;
					this.handlePackage(_loc_4);
					continue;
				}
				break;
			}while (_loc_1 >= PackageIn.HEADER_SIZE)
			this._readBuffer.position = 0;
			if (_loc_1 > 0)
			{
				this._readBuffer.writeBytes(this._readBuffer, this._readOffset, _loc_1);
			}
			this._readOffset = 0;
			this._writeOffset = _loc_1;
			return;
		}// end function
		
		private function handlePackage(param1:PackageIn) : void
		{
			var pkg:* = param1;
			if (this._debug)
			{
				trace(ByteUtils.ToHexDump("Receive Pkg:" + this._port, pkg, 0, pkg.length));
			}
			try
			{
				if (pkg.checkSum == pkg.calculateCheckSum())
				{
					pkg.position = PackageIn.HEADER_SIZE;
					dispatchEvent(new SocketEvent(SocketEvent.DATA, pkg));
				}
				else
				{
					trace("pkg checksum error:", ByteUtils.ToHexDump("Bytes Left:", pkg, 0, pkg.length));
				}
			}
			catch (err:Error)
			{
				trace("handlePackage:", err.getStackTrace());
				trace(ByteUtils.ToHexDump("Bytes Left:", _readBuffer, _readOffset, _readBuffer.bytesAvailable));
			}
			return;
		}// end function
		
		public function dispose() : void
		{
			if (this._socket.connected)
			{
				this._socket.close();
			}
			this._socket = null;
			return;
		}// end function
		
	}
}


class FSM extends Object
{
	
	function FSM(adder:int, multiper:int)
	{
		super();
		this.setup(adder,multiper);
	}
	
	private var _state:int;
	
	private var _adder:int;
	
	private var _multiper:int;
	
	public function getState() : int
	{
		return this._state;
	}
	
	public function reset() : void
	{
		this._state = 0;
	}
	
	public function setup(adder:int, multiper:int) : void
	{
		this._adder = adder;
		this._multiper = multiper;
		this.updateState();
	}
	
	public function updateState() : int
	{
		this._state = (~this._state + this._adder) * this._multiper;
		this._state = this._state ^ this._state >> 16;
		return this._state;
	}
}

