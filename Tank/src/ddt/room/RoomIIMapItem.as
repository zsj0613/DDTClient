package ddt.room
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Timer;
	
	import game.crazyTank.view.roomII.RoomIIMapBorderAsset;
	import game.crazyTank.view.roomII.RoomIIMapMaskAsset;
	
	import road.ui.controls.PictureBox;
	
	import ddt.game.map.MapBigIcon;

	public class RoomIIMapItem extends Sprite
	{
		private var _info:Object;
		private var _pic:DisplayObject;
		private var _selected:Boolean;
		private var _pictype:String;
		private var _mask:RoomIIMapMaskAsset;
		private var _border:RoomIIMapBorderAsset;
//		private var MyTimer:Timer;
		
		/**
		 * 
		 * @param info
		 * @param pic
		 * @param picType :pre:缩略图
		 * 					selected:大图
		 * 
		 */		
		public function RoomIIMapItem(info: Object,pic:DisplayObject,picType:String = "pre")
		{
			_info = info;
			_pic = pic;
			_pictype = picType;
			super();
			init();
		}
		
		private function init():void
		{
			_selected = false;
			if(_pictype == "pre")
			{
				_pic.width = 130;
				_pic.height = 49;
			}
			else if(_pictype == "selected")
			{
				_pic.width = 299;
				_pic.height = 110;
			}
			if(!_info.isOpen)
			{
				_pic.filters = [new ColorMatrixFilter ([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
			}
			
			buttonMode = _info.isOpen;
			var box:PictureBox = new PictureBox();
			box.appendItem(_pic);
			box.width = _pic.width+1;
			box.height = _pic.height +1;
			addChild(box);
			
			_mask = new RoomIIMapMaskAsset();
			_mask.x = _mask.y = 1;
			_mask.width -= 1;
			addChild(_mask);
			_mask.visible = !_info.isOpen;
			
			_border = new RoomIIMapBorderAsset();
			addChild(_border);
			_border.x = _border.y = -4;
			_border.gotoAndStop(1);
			_border.visible = false;
//			MyTimer = new Timer(1500,0);
		}
			
		public function get info():Object
		{
			return _info;
		}
		
		public function get id():int
		{
			return _info.ID;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
			_border.visible = value;
		}
		
		public function set enabled(b:Boolean):void
		{
			_mask.visible = !b;
		}
		
		public function flicker():void
		{
			_border.visible = true;
			_border.play();
//			MyTimer.start();
//			MyTimer.addEventListener(TimerEvent.TIMER , __stopFlicker);
		}
		
		public function stopFlicker():void
		{
			_border.visible = false;
			_border.gotoAndStop(1);
		}
		
//		private function __stopFlicker(evt:TimerEvent):void
//		{
//			_border.visible = false;
//			_border.gotoAndStop(1);
//			MyTimer.removeEventListener(TimerEvent.TIMER , __stopFlicker);
//			MyTimer.reset();
//		}
		
		public function dispose ():void
		{
			if(_mask && _mask.parent)
				_mask.parent.removeChild(_mask);
			_mask = null;
			
			if(_border && _border.parent)
				_border.parent.removeChild(_border);
			_border = null;
			
			if(_pic is MapBigIcon)
			{
				(_pic as MapBigIcon).dispose();
			}
			_pic = null;
			_info = null;
			
			if(parent)
				parent.removeChild(this);
//			if(MyTimer.running)
//			{
//				MyTimer.stop();
//			}
//			MyTimer = null;
		}
	}
}