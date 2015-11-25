package ddt.view.scenechatII
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.ChatFaceItemAsset;
	
	import ddt.view.common.FaceSource;

	public class SceneChatIIFaceItem extends ChatFaceItemAsset
	{
		private var _id:int;
		private var _face:MovieClip;
		
		
		public function SceneChatIIFaceItem()
		{
			super();
			init();
			initEvent();
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function set id(value:int):void
		{
			_id = value;
		}
		
		private function init():void
		{
			graphics.beginFill(0x000000,0);
			graphics.drawRect(0,0,40,40);
			graphics.endFill();
			buttonMode = true;
			bg_mc.visible = false;
			_id = -1;
		}
		
		private function initEvent():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,__mouseOver,false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT,__mouseOut,false,0,true);
		}
		
		private function __mouseOver(evt:MouseEvent):void
		{
			if(_id != -1)
				bg_mc.visible = true;
		}
		
		private function __mouseOut(evt:MouseEvent):void
		{
			bg_mc.visible = false;
		}
	}
}