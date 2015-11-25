package ddt.view
{
	import interfaces.IDisplayObject;
	
	public interface IDisposeable extends IDisplayObject
	{
		function dispose():void;
	}
}