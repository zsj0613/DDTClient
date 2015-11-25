package ddt.interfaces
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;

	public interface IPublicChat extends IEventDispatcher
	{
		function getView():DisplayObject;
		function dispose():void;
		function sendMessage(roomid:Number,nick:String,msg:String):void;
		function sendChangeChannel(roomid:Number):void;
		function appendText(channelid:uint,playerid:uint,nick:String,msg:String):void;
	}
}