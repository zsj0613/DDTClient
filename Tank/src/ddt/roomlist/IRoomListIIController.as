package ddt.roomlist
{
	import flash.display.DisplayObject;
	
	import ddt.data.RoomInfo;
	import ddt.data.SimpleRoomInfo;
	public interface IRoomListIIController
	{
		function getView():DisplayObject;
		function dispose():void;
		function showCreateView():void;
		function sendGoIntoRoom(info:SimpleRoomInfo):void;
		function setRoomShowMode(mode:int):void;
		function showFindRoom():void;
	}
}