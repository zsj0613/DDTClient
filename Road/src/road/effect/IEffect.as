package road.effect
{
	import flash.display.DisplayObject;

	public interface IEffect
	{
		function actEffect(target:DisplayObject,data:Object = null):void;
	}
}