package ddt.view.characterII
{
	import flash.geom.Point;
	
	import interfaces.IDisplayObject;
	import ddt.data.player.PlayerInfo;
	
	public interface ICharacter extends IColorEditable,IDisplayObject
	{
		function get info():PlayerInfo;
		function get currentFrame():int;
		function doAction(actionType:*):void;
		function actionPlaying():Boolean;
		function dispose():void;
		function show(clearLoader:Boolean = true,dir:int = 1):void;
		function setFactory(factory:ICharacterLoaderFactory):void;
		function set showGun(value:Boolean):void;
		function setShowLight(b:Boolean,p:Point = null):void;
		function drawFrame(frame:int):void;
		function get currentAction():*;
		function get characterWidth():Number;
		function get characterHeight():Number;
		function get completed():Boolean;
		function setDefaultAction(actionType:*):void;
	}
}