package ddt.states
{
	public interface IStateCreator
	{
		function create(type:String):BaseStateView
		function createAsync(type:String,callback:Function):void
	}
}