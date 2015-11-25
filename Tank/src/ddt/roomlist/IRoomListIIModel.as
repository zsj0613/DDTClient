package ddt.roomlist
{
	import flash.events.IEventDispatcher;
	
	import road.data.DictionaryData;
	
	import ddt.data.SimpleRoomInfo;
	import ddt.data.player.PlayerInfo;
	
	public interface IRoomListIIModel extends IEventDispatcher
	{
		function dispose():void;
		function updateRoom(tempArray : Array):void;
		function getRoomById(id:int):SimpleRoomInfo;
		function getRoomList():DictionaryData;
		function addWaitingPlayer(info:PlayerInfo):void;
		function removeWaitingPlayer(id:int):void;
		function getPlayerList():DictionaryData;
		function getSelfPlayerInfo():PlayerInfo;
		function get roomShowMode():int;
		function set roomShowMode(value:int):void;
		function get roomTotal():int;
		function set roomTotal(value:int):void
		function get isAddEnd():Boolean
	}
}