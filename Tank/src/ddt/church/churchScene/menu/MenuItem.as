package ddt.church.churchScene.menu
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import tank.church.ChurchMenuItemAsset;

	public class MenuItem extends ChurchMenuItemAsset
	{
		public function MenuItem(label:String = "")
		{
			tbxName.text = label ? label : "";
			tbxName.mouseEnabled = false;
			
			mouseChildren = false;
			buttonMode = true;
			useHandCursor = true;
			
			enable = true;
			addEventListener(MouseEvent.CLICK,__mouseClick);
			addEventListener(MouseEvent.ROLL_OVER,__rollOver);
			addEventListener(MouseEvent.ROLL_OUT,__rollOut);
		}
		private function removeEvent() : void
		{
			removeEventListener(MouseEvent.CLICK,__mouseClick);
			removeEventListener(MouseEvent.ROLL_OVER,__rollOver);
			removeEventListener(MouseEvent.ROLL_OUT,__rollOut);
		}
		private function __rollOver(event:MouseEvent):void
		{
			gotoAndStop(2);
		}
		
		private function __rollOut(event:MouseEvent):void
		{
			gotoAndStop(1);
		}
		
		private function __mouseClick(event:MouseEvent):void
		{
			if(_enable)
			{
				dispatchEvent(new Event("menuClick"));
			}
		}
		
		protected var _enable:Boolean = false;
		public function get enable():Boolean
		{
			return _enable;
		}
		
		public function set enable(value:Boolean):void
		{
			if(_enable != value)
			{
				_enable = value;
				mouseEnabled = value;
				gotoAndStop(1);
				
				if(value)
				{
					tbxName.setTextFormat(new TextFormat(null,null,0xFFFFFF));
				}
				else
				{
					tbxName.setTextFormat(new TextFormat(null,null,0x999999));
				}
			}
		}
		
		public function dispose() : void
		{
			removeEvent();
			if(parent)this.parent.removeChild(this);
		}
		
	}
}