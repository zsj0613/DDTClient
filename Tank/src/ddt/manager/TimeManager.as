package ddt.manager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	import ddt.events.CrazyTankSocketEvent;
	
	public class TimeManager
	{
		public static const DAY_TICKS:Number = 1000 * 24 * 60 * 60;
		public static const HOUR_TICKS:Number = 1000 * 60 * 60;
		public static const Minute_TICKS:Number = 1000 * 60;
		
		
		private var _serverDate:Date;
		private var _serverTick:int;
		public function setup():void
		{
			_serverDate = new Date();
			_serverTick = getTimer();
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SYS_DATE,__update);
		}
		
		private function __update(event:CrazyTankSocketEvent):void
		{
			_serverTick = getTimer();
			_serverDate = event.pkg.readDate();
		}
		
		public function Now():Date
		{
			return new Date(_serverDate.getTime() + getTimer() - _serverTick);
		}
		
		public function get currentDay():Number
		{
			return Now().getDay();
		}
		
		public function TimeSpanToNow(last:Date):Date
		{
			return new Date(Math.abs(_serverDate.getTime() + getTimer() - _serverTick - last.time));
		}
		
		public function TotalDaysToNow(last:Date):Number
		{
			return (_serverDate.getTime() + getTimer() - _serverTick - last.time) /(DAY_TICKS);
		}
		
		public function TotalHoursToNow(last:Date):Number
		{
			return (_serverDate.getTime() + getTimer() - _serverTick - last.time) /(HOUR_TICKS);
		}
		
		public function TotalDaysToNow2(last:Date):Number
		{
			var dt:Date = Now();
			dt.setHours(0,0,0,0);
			var lt:Date = new Date(last.time);
			lt.setHours(0,0,0,0);
			return (dt.time - lt.time) / DAY_TICKS;
		}
		
		
		private static var _dispatcher:EventDispatcher = new EventDispatcher();
		public static var  CHANGE : String = "change";
		public static function addEventListener(type:String,listener:Function):void
		{
			_dispatcher.addEventListener(type,listener);
		}
		
		public static function removeEventListener(type:String,listener:Function):void
		{
			_dispatcher.removeEventListener(type,listener);
		}
		//防沉迷 ==========================================================
 
		private var _startGameTime : Date; 
		private var _currentTime : Date; 
		
		
		//获取服务器一天之内游戏的总时间
				
		private var _totalGameTime : Number;
		public function set totalGameTime (time:int):void
		{
			_totalGameTime = time;
			_dispatcher.dispatchEvent(new Event(TimeManager.CHANGE));
		}
		
		public function get totalGameTime() : int
		{
			return this._totalGameTime;
		}
		
		//==========================================================
		
		
		private static var _instance:TimeManager
		public static function get Instance():TimeManager
		{
			if(_instance == null)
			{
				_instance = new TimeManager();
			}
			return _instance;
		}
	}
}