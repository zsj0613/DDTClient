package road.ui.manager
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class SpriteLayer extends Sprite
	{
		public function SpriteLayer()
		{
			super();
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			if(child is Sprite)
			{
				Sprite(child).addEventListener(MouseEvent.MOUSE_DOWN,__childMouseDown);
			}
			return super.addChild(child);	
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			if(child is Sprite)
			{
				Sprite(child).removeEventListener(MouseEvent.MOUSE_DOWN,__childMouseDown);
			}
			return super.removeChild(child);
		}
		
		private function __childMouseDown(event:MouseEvent):void
		{
			super.setChildIndex(event.currentTarget as Sprite,numChildren - 1);
		}
	}
}