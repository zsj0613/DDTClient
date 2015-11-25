package ddt.utils
{
	import flash.display.DisplayObject;

	public class ComponentHelperII
	{
		public static function replaceChildPostion(position:DisplayObject,newchild:DisplayObject):void
		{
			var index:int = position.parent.getChildIndex(position);	
			newchild.x = position.x;
			newchild.y = position.y;
			position.parent.addChildAt(newchild,index);
			position.parent.removeChildAt(index + 1);
		}
	}
}