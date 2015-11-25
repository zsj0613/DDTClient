package ddt.view.characterII
{
	import flash.display.BitmapData;
	
	public interface ICharacterLoader
	{
		function setFactory(factory:ILayerFactory):void;
		function getContent():Array;
		function load(callBack:Function = null):void;
		function update():void;
		function dispose():void;
	}
}