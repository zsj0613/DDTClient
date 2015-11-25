package road.utils
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class ComponentHelper
	{
		public static function replaceChild(parent:Sprite,oldchild:DisplayObject,newchild:DisplayObject):void
		{
			var index:int = parent.getChildIndex(oldchild);	
			newchild.x = oldchild.x;
			newchild.y = oldchild.y;
			newchild.width = oldchild.width;
			newchild.height = oldchild.height;
			parent.addChildAt(newchild,index);
			parent.removeChildAt(index + 1);
		}
		
		public static function replaceChildToOtherContainer(parent:Sprite,oldchild:DisplayObject,newchild:DisplayObject):void
		{
			newchild.x = oldchild.x;
			newchild.y = oldchild.y;
			newchild.width = oldchild.width;
			newchild.height = oldchild.height;
			parent.addChild(newchild);
			if(oldchild.parent)
			{
				oldchild.parent.removeChild(oldchild);
			}
		}
		
		public static function createTextField(text:String="",width:Number=400,color:uint = 0xcccccc):TextField
		{
			var temp:TextField = new TextField();
			temp.selectable = false;
			temp.width = width;
			temp.textColor = color;
			temp.wordWrap = true;
			temp.autoSize = TextFieldAutoSize.LEFT;
			temp.text = text;
			return temp;
		}
	}
}