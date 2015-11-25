package ddt.auctionHouse.view.vmenu
{
	import flash.events.IEventDispatcher;
	public interface IMenuItem extends IEventDispatcher
	{
		function get info ():Object;
		function get x ():Number;
		function get y ():Number;
		function set x (n:Number):void;
		function set y (n:Number):void;
		function get isOpen ():Boolean;
		function set isOpen (b:Boolean):void;
		function set enable (b:Boolean):void;
		function dispose():void;
	}
}