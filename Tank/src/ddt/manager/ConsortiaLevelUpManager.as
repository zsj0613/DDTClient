package ddt.manager
{
	import ddt.data.ConsortiaLevelInfo;
	import ddt.request.LoadConsortiaLevelData;
	
	public class ConsortiaLevelUpManager
	{
		private static var _list:Array;
		private static var _instance:ConsortiaLevelUpManager;
		public function setup():void
		{
			new LoadConsortiaLevelData().loadSync(__loaded,3);
		}
		
		public function getLevelData(level:int):ConsortiaLevelInfo
		{
			
			for(var i:uint = 0;i<_list.length;i++)
			{
				if(_list[i]["Level"] == level)
				{
					return _list[i] as ConsortiaLevelInfo;
				}
			}
			return null
		}
		
		private static function __loaded(loader:LoadConsortiaLevelData):void
		{
			_list = loader.list;
		}
		public static function get Instance():ConsortiaLevelUpManager
		{
			if(!_instance)
			{
				_instance = new ConsortiaLevelUpManager()
			}
			return _instance;
		}
		

	}
}