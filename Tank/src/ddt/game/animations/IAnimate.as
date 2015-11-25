package ddt.game.animations
{
	import flash.display.DisplayObject;
	
	public interface IAnimate
	{
		/**
		 * 当前动作的等级小于正在执行的动作等级时，当前动作会被忽略。
		 * 当前动作等级大于等于正在执行动作的等级时，会调用canReplace()来判断是否被替代。 
		 * @return 
		 * 
		 */		
		function get level():int;
		function prepare(aniset:AnimationSet):void
		function canAct():Boolean;
		function update(movie:DisplayObject):Boolean;
		function canReplace(anit:IAnimate):Boolean;
		function cancel():void;
	}
}