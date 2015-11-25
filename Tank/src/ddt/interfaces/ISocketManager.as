package ddt.interfaces
{
	import flash.events.IEventDispatcher;
	
	import road.comm.ByteSocket;
	import road.comm.PackageIn;
	
	public interface ISocketManager extends IEventDispatcher
	{
		function setup():void;
		function addHandler(hander:ISocketHandler):void;
		function getHandler(code:int):ISocketHandler;
		function removeHandler(code:int):void;
		function getSocket():ByteSocket;
	}
}