package road.ui.manager
{
	import road.ui.controls.hframe.HFrame;
	
	
	public class BufferManager
	{
		private static var _instance:BufferManager;
		private var _isBuffering:Boolean = false;
		private var _buffers:Array = [];
		
		public function BufferManager(single:SingletonEnfocer)
		{
		}
		
		public function set isBuffering(value:Boolean):void
		{
			_isBuffering = value;
		}
		
		public function get isBuffering():Boolean
		{
			return _isBuffering;
		}
		
		public function pushToBuffer(panel:HFrame):void
		{
			_buffers.push(panel);
		}
		
		public function clearBuff():void
		{
			while(_buffers.length>0)
			{
				var panel:HFrame = _buffers.shift() as HFrame;
				panel.show();
			}
		}
		
		public static function get Instance():BufferManager
		{
			if(_instance == null) _instance = new BufferManager(new SingletonEnfocer());
			return _instance;
		}

	}
}

class SingletonEnfocer{}