package ddt.manager
{
	import ddt.events.CrazyTankSocketEvent;
	import ddt.states.StateType;

	//import ddt.events.CrazyTankSocketEvent;
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
				SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_JOIN, this.__join);
			}
			
			public function __join(e:CrazyTankSocketEvent):void
			{
				StateManager.setState(StateType.WORLD_BOSS_ROOM);
			}
	}
}