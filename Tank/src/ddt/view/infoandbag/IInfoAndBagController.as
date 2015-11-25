package ddt.view.infoandbag
{
	import flash.display.Sprite;
	
	public interface IInfoAndBagController
	{
		function getView():Sprite;
		function dispose():void;
	}
}