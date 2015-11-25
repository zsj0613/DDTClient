package ddt.roomlist
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.roomlistII.RoomListIITipItemAsset;
	
	import ddt.game.map.MapBigIcon;
	import ddt.game.map.MapSmallIcon;

	public class RoomListIITipItem extends Sprite
	{
		private var _info:*;
		private var _bg:RoomListIITipItemAsset;
		private var _asset:Object;
		
		public function RoomListIITipItem(asset:Object,data:*)
		{
			_asset = asset;
			_info = data;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			_bg = new RoomListIITipItemAsset();
			_bg.visible = false;
			_bg.width = _asset.width;
			_bg.height = _asset.height;
			addChild(_bg);
			addChild(_asset as DisplayObject);
			if(_asset is MovieClip)
			{
				(_asset as MovieClip).gotoAndStop("s" + String(_info["index"]));
			}else if(_asset is MapSmallIcon)
			{
				_asset.id = _info["index"];
			}
			
			buttonMode = true;
		}
		
		public function get info():*
		{
			return _info; 
		}
		
		private function initEvent():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,__mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,__mouseOut);
		}
		
		public function dispose ():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER,__mouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT,__mouseOut);
			if(_asset is MapBigIcon)
			{
				_asset.dispose();
			}
			_asset = null;
			_info = null;
			if(_bg && _bg.parent)
			{
				_bg.parent.removeChild(_bg);
				_bg = null;
			}
		}
		
		private function __mouseOver(evt:MouseEvent):void
		{
			_bg.visible = true;
		}
		
		private function __mouseOut(evt:MouseEvent):void
		{
			_bg.visible = false;
		}
	}
}