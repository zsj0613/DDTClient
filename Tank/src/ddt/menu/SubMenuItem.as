package ddt.menu
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextFormat;
	import tank.menu.MenuItemAsset;

	public class SubMenuItem extends MenuItemAsset
	{
		private var _icon:MovieClip;
		private var myColorMatrix_filter:ColorMatrixFilter;
		public function SubMenuItem(label:String = "",icon:MovieClip = null)
		{
			if(icon)
			{
				_icon = icon;
				initIcon();
			}
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
		
		private function initIcon():void
		{
			_icon.mouseEnabled = false;
			myColorMatrix_filter = new ColorMatrixFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0]);
			this.addChild(_icon);
			_icon.x = tbxName.x;
			_icon.y = tbxName.y;
//			tbxName.x = _icon.x + _icon.width;
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
				dispatchEvent(new MenuEvent(MenuEvent.CLICK));
			}
		}
		
		private var _enable:Boolean = false;
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
				if(value && _icon)
				{
					_icon.filters = null;
				}else if(_icon)
				{
					_icon.filters = [myColorMatrix_filter];
				}
				if(_icon.text && value)
				{
					_icon.text.setTextFormat(new TextFormat(null,null,0xFFFFFF));
				}else if(_icon.text)
				{
					_icon.text.setTextFormat(new TextFormat(null,null,0x999999));
				}
			}
		}
		
	}
}