package ddt.view.cells
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	
	import interfaces.IDisplayContainer;
	
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.interfaces.IAcceptDrag;
	import ddt.interfaces.IDragable;
	import ddt.view.characterII.IColorEditable;

	public interface ICell extends IEventDispatcher,IDragable,IAcceptDrag,IColorEditable
	{
		function set info(value:ItemTemplateInfo):void;
		function get info():ItemTemplateInfo;
		function getBg():Sprite;
		function getContent():Sprite;
		function dispose():void;
		function get locked():Boolean;
		function set locked(value:Boolean):void
	}
}