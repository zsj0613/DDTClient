package ddt.view.personalinfoII
{
	import flash.display.DisplayObject;
	
	import road.data.DictionaryData;
	
	public interface IPersonalInfoIIController
	{
		function getView():DisplayObject;
		function loadList():void;
		function setList(list:DictionaryData):void;
		function getEnabled():Boolean;
		function setEnabled(value:Boolean):void;
		function getShowOption():Boolean;
		function dispose():void;
	}
}