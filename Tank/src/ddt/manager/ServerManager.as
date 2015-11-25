package ddt.manager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import ddt.data.ServerInfo;
	
	public class ServerManager extends EventDispatcher
	{
		private var _list:Array;
		private var _current:ServerInfo;
		private var _zoneName:String;
		private var _agentid:int;
		// 代理商ID

		public function get zoneName():String
		{
			return _zoneName;
		}

		public function set zoneName(value:String):void
		{
			_zoneName = value;
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function get AgentID():int
		{
			return _agentid;
		}
		
		public function set AgentID(value:int):void
		{
			_agentid = value;
		}
		
		public function set current(value:ServerInfo):void
		{
			_current = value;
		}
		
		public function get current():ServerInfo
		{
			return _current;
		}
		
		public function get list():Array
		{
			return _list;
		}
		
		public function set list(value:Array):void
		{
			_list = value;
		}
		
		private static var _instance:ServerManager;
		public static function get Instance():ServerManager
		{
			if(_instance == null)
			{
				_instance = new ServerManager();
			}
			return _instance;
		}
	}
}