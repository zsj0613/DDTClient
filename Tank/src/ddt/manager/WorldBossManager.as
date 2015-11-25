package ddt.manager
{
	import ddt.events.CrazyTankSocketEvent;
	public class WorldBossManager
	{
			private static var _instance:WorldBossManager;
			public static function get Instance() : WorldBossManager
			{
				if (!WorldBossManager._instance)
				{
					WorldBossManager._instance = new WorldBossManager();
				}
				return WorldBossManager._instance;
			}
			
			public function setup() : void
			{
				SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_INIT, this.__init);
			}
			
			public function __init():void
			{
			}
	}
}