package ddt.view.chatsystem
{
	import flash.events.MouseEvent;
	import game.crazyTank.view.FastReplyItemBgAsset;
	public class SceneChatIIFastReplyItem extends FastReplyItemBgAsset
	{
		
		public function SceneChatIIFastReplyItem(s:String)
		{
			_itemText = s;
			super();
			init();
			initEvent();
		}

		private var _itemText:String;
		
		public function dispose():void
		{
			removeEvent();
			if(parent)
				parent.removeChild(this);
		}
		
		public function get word():String
		{
			return _itemText;
		}
		
		private function __mouseOut(evt:MouseEvent):void
		{
			bg_mc.visible = false;
		}
		
		private function __mouseOver(evt:MouseEvent):void
		{
			bg_mc.visible = true;
		}
		
		private function init():void
		{
			bg_mc.visible = false;
			content_txt.text = String(_itemText);
		}
		
		private function initEvent():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,__mouseOver,false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT,__mouseOut,false,0,true);
		}
		
		private function removeEvent():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER,__mouseOver,false);
			removeEventListener(MouseEvent.MOUSE_OUT,__mouseOut,false);
		}
	}
}