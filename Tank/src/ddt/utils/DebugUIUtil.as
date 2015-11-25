package ddt.utils
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	public class DebugUIUtil
	{
		private static var _instance:DebugUIUtil;
		public function DebugUIUtil(singletonEnfocer:SingletonEnfocer)
		{
			
		}
		
		public static function get Instance():DebugUIUtil
		{
			if(_instance == null)
			{
				_instance = new DebugUIUtil(new SingletonEnfocer());
			}
			return _instance;
		}
		
		public function setUp(target:DisplayObject):void
		{
			if(target)
			{
				target.addEventListener(MouseEvent.CLICK,clickHandler);
			}
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			
		}

	}
}

class SingletonEnfocer {}