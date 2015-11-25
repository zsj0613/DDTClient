package ddt.interfaces
{
	import road.comm.PackageIn;
	
	public interface ISocketHandler
	{
		function getCode():String;
		function doGetPackage(pkg:PackageIn):void;
		function dispose():void;
		function clear():void;
		function sendPackage(...args):void;
	}
}