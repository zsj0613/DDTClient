package ddt.WorldBoss
{
	import ddt.hotSpring.model.HotSpringRoomModel;
	import ddt.hotSpring.view.HotSpringRoomView;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;

	public class WorldBossRoomController extends BaseStateView
	{
		private var view:WorldBossRoomView;
		public function WorldBossRoomController() 
		{
		}
		override public function prepare():void
		{
			super.prepare();
		}
		
		override public function enter(prev:BaseStateView, data:Object=null):void
		{
			global.traceStr("try in WorldBoss");
			super.enter(prev,data);
			TipManager.clearTipLayer();
			UIManager.clear();
			this.view = new WorldBossRoomView();
			this.addChild(view);
			
		}
		
		
		override public function leaving(next:BaseStateView):void
		{
			dispose();
			super.leaving(next);
		}
		
		override public function getBackType():String
		{
			return StateType.MAIN;
		}
		
		override public function getType():String
		{
			return StateType.WORLD_BOSS_ROOM;
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}