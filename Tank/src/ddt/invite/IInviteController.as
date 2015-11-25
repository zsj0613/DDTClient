package ddt.invite
{
	import flash.display.Sprite;
	
	public interface IInviteController
	{
		function refleshList(type:int,count:int = 0):void;
		function getView():Sprite;
		function hide():void;
		function dispose():void;
	}
}