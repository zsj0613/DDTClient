package ddt.view.personalinfoII
{
	import flash.events.IEventDispatcher;
	
	import ddt.data.player.PlayerInfo;

	public interface IPersonalInfoIIModel extends IEventDispatcher
	{
		function getPlayerInfo():PlayerInfo;
		function dispose():void;
	}
}