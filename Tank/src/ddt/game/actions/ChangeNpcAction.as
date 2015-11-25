package ddt.game.actions
{
	import road.comm.PackageIn;
	
	import ddt.actions.BaseAction;
	import ddt.data.PathInfo;
	import ddt.data.game.Living;
	import ddt.data.game.SmallEnemy;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.game.GameView;
	import ddt.game.map.MapView;
	import ddt.game.objects.GameSamllEnemy;
	import ddt.game.objects.SimpleBox;
	import ddt.manager.GameManager;
	import ddt.manager.MessageTipManager;

	public class ChangeNpcAction extends BaseAction
	{
		private var _gameView:GameView;
		private var _map:MapView;
		private var _info:Living;
		private var _pkg:PackageIn;
		private var _event:CrazyTankSocketEvent;
		private var _ignoreSmallEnemy:Boolean;
		public function ChangeNpcAction(game:GameView,map:MapView,info:Living,event:CrazyTankSocketEvent,sysMap:PackageIn,ignoreSmallEnemy:Boolean)
		{
			_gameView = game;
			_event = event;
			_event.executed = false;
			_pkg = sysMap;
			_map = map;
			_info = info;
			_ignoreSmallEnemy = ignoreSmallEnemy;
		}
		
		private function syncMap():void
		{
			if(_pkg)
			{
				GameManager.Instance.Current.setWind(_pkg.readInt() / 10,false);//风力
				_pkg.readBoolean();//是否隐藏
				var count:int = _pkg.readInt();//箱子数
				for(var i:uint = 0; i < count; i ++)
				{
					var bid:int = _pkg.readInt();
					var bx:int = _pkg.readInt();
					var by:int = _pkg.readInt();
					var box:SimpleBox = new SimpleBox(bid,String(PathInfo.GAME_BOXPIC));
					box.x = bx;
					box.y = by;
					_map.addPhysical(box);
					if(_pkg.readBoolean())
					{
						var str:String = _pkg.readUTF();
						MessageTipManager.getInstance().show(str);
					}
				}
			}
		}
		
		private function updateNpc():void
		{
			if(GameManager.Instance.Current == null)return;
			for each(var p:Living in GameManager.Instance.Current.livings)
			{
				p.beginNewTurn();
			}
			_map.cancelFocus();
			_gameView.setCurrentPlayer(_info);
			
			if(!_map.smallMap.locked){
				focusOnSmallEnemy();
			}
			
			if(!_ignoreSmallEnemy){
				_ignoreSmallEnemy = true;
			}else{
				return;
			}
				
			_gameView.updateControlBarState(GameManager.Instance.Current.selfGamePlayer);
		}
		
		
		/**
		 * 获取离玩家最近的enemy
		 */ 
		private function getClosestEnemy():SmallEnemy{
			var instance:int = -1;
			var x:int = GameManager.Instance.Current.selfGamePlayer.pos.x;
			var result:SmallEnemy;
			for each(var p:Living in GameManager.Instance.Current.livings){
				if(p is SmallEnemy && p.isLiving && p.typeLiving !=3 ){
					if(instance == -1 || Math.abs(p.pos.x-x)<instance){
						instance = Math.abs(p.pos.x-x);
						result = p as SmallEnemy;
					}
				}
			}
			return result;
		}
		private function focusOnSmallEnemy():void{
			var closestEnemy:SmallEnemy = getClosestEnemy();
			if(closestEnemy){
				if(closestEnemy.LivingID && _map.getPhysical(closestEnemy.LivingID)){
				 (_map.getPhysical(closestEnemy.LivingID) as GameSamllEnemy).needFocus();
				_map.currentFocusedLiving = (_map.getPhysical(closestEnemy.LivingID) as GameSamllEnemy);
				}
			}
		}
		override public function execute():void
		{
			_event.executed = true;
			syncMap();
			updateNpc();
			_isFinished = true;
		}
	}
}