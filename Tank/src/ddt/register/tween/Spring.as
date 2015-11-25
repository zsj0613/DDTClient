package ddt.register.tween
{
	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.geom.Point;
	
	public class Spring
	{
		private var spr:Number = 0.1;// 弹性系数
		private var friction:Number = 0.75;// 摩擦力
		private var v:Point = new Point(0,30);// 速度
		private var _target:Point;// 目标点
		private var _display:DisplayObject;// 显示对象
		
		private var _hideTarget:Point;
		private var _secondTarget:Point;
		
		private var isHide:Boolean = false;
		private var dispatch:EventDispatcher;
		
		public function Spring(display:DisplayObject, target:Point)
		{
			_display = display;
			_target = target;
			dispatch = new EventDispatcher();
		}
		
		public function start():void
		{
			_display.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private var d:Point = new Point();
		private var a:Point = new Point();
		
		private function update(e:Event):void
		{
			d.x = _target.x - _display.x;
			d.y = _target.y - _display.y;
			
			a.x = d.x * spr;
			a.y = d.y * spr;
			
			v.x += a.x;
			v.y += a.y;
			
			v.x *= friction;
			v.y *= friction;
			
			var oldX:Number = _display.x;
			var oldY:Number = _display.y;
			
			_display.x += v.x;
			_display.y += v.y;
			
			if(isHide)
			{
				if(_display.y <= (-1 * _display.height))
				{
					_display.removeEventListener(Event.ENTER_FRAME, update);
					dispatchEvent(new Event(Event.CLOSE));
				}
			}
			else if(_display.x == oldX && _display.y == oldY)
			{
				_display.removeEventListener(Event.ENTER_FRAME, update);
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function hide():void
		{
			if(isHide)
				return;
			isHide = true;
			
			_display.removeEventListener(Event.ENTER_FRAME, update);
			
			_hideTarget = new Point(_display.x,(_display.y + _display.height + 100) * -1);
			_secondTarget = new Point(0,_display.y + 30);
			
			a.x = 0;
			a.y = 5;
			
			v.x = 0;
			v.y = 5;
			
			_display.addEventListener(Event.ENTER_FRAME, secondUpdate);
		}
		
		private function secondUpdate(e:Event):void
		{
			_display.x += v.x;
			_display.y += v.y;
			
			v.x += a.x;
			v.y += a.y;
			
			if(_display.y >= _secondTarget.y && _secondTarget.x >= _secondTarget.x)
			{
				_display.removeEventListener(Event.ENTER_FRAME, secondUpdate);
				_target = _hideTarget;
				_display.addEventListener(Event.ENTER_FRAME, update);
			}
		}
		
		public function addEventListener(type:String, listener:Function):void
		{
			dispatch.addEventListener(type,listener);
		}
		
		public function removeEventListener(type:String, listener:Function):void
		{
			dispatch.removeEventListener(type,listener);
		}
		
		public function dispatchEvent(event:Event):void
		{
			dispatch.dispatchEvent(event);
		}
		
		public function dispose():void
		{
			_display.removeEventListener(Event.ENTER_FRAME, update);
			_display.removeEventListener(Event.ENTER_FRAME, secondUpdate);
			
			dispatch = null;
			_display = null;
		}
	}
}