package ddt.events
{
	import flash.events.Event;
	
	import road.comm.ByteSocket;
	import road.comm.PackageIn;

	public class BaseSocketEvent extends Event
	{
		public static const SOCKET_ONDATE:String = "socketondata";
		public static const SOCKET_CLOSE:String = "socketclose";
		public static const SOCKET_IOERROR:String = "socketerror";
		public static const SOCKET_CONNECT:String = "socketconnect";
		
		public var socket:ByteSocket;
		public var data:PackageIn;
		
		public function BaseSocketEvent(type:String,socket:ByteSocket,data:PackageIn = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.socket = socket;
			this.data = data;
			super(type, bubbles, cancelable);
		}
		
	}
}