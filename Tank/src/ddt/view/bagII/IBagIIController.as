package ddt.view.bagII
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import ddt.data.player.BagInfo;
	
	public interface IBagIIController
	{
		function getView():DisplayObject;
		function loadList():void;
		function setList():void;
		function getEnabled():Boolean;
		function setEnabled(value:Boolean):void;
		function dispose():void;
	}
}