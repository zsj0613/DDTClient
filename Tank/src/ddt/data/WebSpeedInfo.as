package ddt.data
{
	import flash.events.EventDispatcher;
	
	import ddt.events.WebSpeedEvent;
	import ddt.manager.LanguageMgr;
	
	[Event(name = "stateChange",type = "ddt.view.game.webspeed.WebSpeedEvent")]
	public class WebSpeedInfo extends EventDispatcher
	{
//		LanguageMgr.GetTranslation("ddt.data.WebSpeedInfo.bad")
		public static const BEST:String = LanguageMgr.GetTranslation("ddt.data.WebSpeedInfo.good");
		public static const BETTER:String = LanguageMgr.GetTranslation("ddt.data.WebSpeedInfo.find");
		public static const WORST:String = LanguageMgr.GetTranslation("ddt.data.WebSpeedInfo.bad");
		/* public static const BEST:String = "良好";
		public static const BETTER:String = "通畅";
		public static const WORST:String = "极差"; */
		public function WebSpeedInfo(delay:int)
		{
			_delay = delay;
		}
		/**
		 * 游戏帧数 
		 */		
		private var _fps:int;
		public function get fps():int
		{
			return _fps;
		}		
		public function set fps(value:int):void
		{
			if(_fps == value) return;
			_fps = value;
			dispatchEvent(new WebSpeedEvent(WebSpeedEvent.STATE_CHANE));
		}
		
		/**
		 * 延时 
		 */		
		private var _delay:int;
		public function get delay():int
		{
			return _delay;
		}
		public function set delay(value:int):void
		{
			if(_delay == value)return;
			_delay = value;
			dispatchEvent(new WebSpeedEvent(WebSpeedEvent.STATE_CHANE));
		}
		
		public function get stateId():int
		{
			if(_delay > 600)return 3;
			if(_delay > 300)return 2;
			return 1;
		}
		
		public function get state():String
		{
			if(_delay > 600)return WORST;
			if(_delay > 300)return BETTER;
			return BEST;
		}
		
		
	}
}