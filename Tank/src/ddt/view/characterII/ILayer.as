package ddt.view.characterII
{
	import flash.display.DisplayObject;
	
	import ddt.data.goods.ItemTemplateInfo;
	
	public interface ILayer extends IColorEditable
	{
		function get info():ItemTemplateInfo;
		function set info(value:ItemTemplateInfo):void;
		function getContent():DisplayObject;
		function dispose():void;
		function load(callBack:Function):void;
		function set currentEdit(n:int):void;
		function get currentEdit():int;
		function get width():Number;
		function get height():Number;
	}
}