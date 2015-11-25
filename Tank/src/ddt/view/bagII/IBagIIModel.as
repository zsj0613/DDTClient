package ddt.view.bagII
{
	import flash.events.IEventDispatcher;
	
	import ddt.data.player.PlayerInfo;
	
	public interface IBagIIModel extends IEventDispatcher
	{
		function getPlayerInfo():PlayerInfo;
		function dispose():void;
	}
}