package ddt.invite
{
	import flash.events.IEventDispatcher;

	public interface IInviteModel extends IEventDispatcher
	{
		function setList(type:int,data:Array):void;
		function get currentList():Array;
		function get type():int;
		function dispose():void;
	}
}