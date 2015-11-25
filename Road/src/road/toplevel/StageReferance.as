package road.toplevel
{
	import flash.display.Stage;
	import flash.events.Event;

	public final class StageReferance
	{
		public static var stageHeight:int
		public static var stageWidth:int
		private static var _stage:Stage;
		/**
		 * 
		 * @param $stage 舞台对象
		 * 初始化 舞台引用
		 * 
		 */		
		public static function setup($stage:Stage):void
		{
			if(_stage != null)return;
			_stage = $stage;
			_stage.addEventListener(Event.EXIT_FRAME,__onNextFrame);
			_stage.addEventListener(Event.RESIZE,__onResize);
		}
		
		private static function __onNextFrame(event:Event):void
		{
			if(_stage.stageWidth > 0)
			{
				_stage.removeEventListener(Event.EXIT_FRAME,__onNextFrame);
				stageWidth = _stage.stageWidth;
				stageHeight = _stage.stageHeight;
			}
		}
		
		private static function __onResize(event:Event):void
		{
			stageWidth = _stage.stageWidth;
			stageHeight = _stage.stageHeight;
		}
		/**
		 * 
		 * @return 获取舞台
		 * 
		 */		
		public static function get stage():Stage
		{
			return _stage;
		}

		public function StageReferance()
		{
		}
	}
}