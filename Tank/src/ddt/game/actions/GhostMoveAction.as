package ddt.game.actions
{
	import flash.geom.Point;
	
	import road.manager.SoundManager;
	
	import ddt.actions.BaseAction;
	import ddt.data.game.LocalPlayer;
	import ddt.data.game.Player;
	import ddt.game.objects.GameLocalPlayer;
	import ddt.game.objects.GamePlayer;
	import ddt.manager.GameManager;
	
	public class GhostMoveAction extends BaseAction
	{
		private var _target:Point;
		private var _player:GamePlayer;
		private var _vp:Point;
		
		public function GhostMoveAction(player:GamePlayer,target:Point)
		{
			_target = target;
			_player = player;
			
			_vp = _target.subtract(_player.pos);
			_vp.normalize(2);		
		}
		
		override public function prepare():void
		{
			if(_isPrepare) return;
			_isPrepare = true;
			SoundManager.Instance.play("010",true);
			_player.startMoving();		
		}
		
		override public function execute():void
		{
			_player.info.direction = _vp.x > 0 ? 1 : -1;
			if(Point.distance(_player.pos,_target) > _vp.length )
			{
				if(_vp.length < Player.GHOST_MOVE_SPEED)
				{
					_vp.normalize(_vp.length * 1.1);
				}
				
				var posA:Point=_player.info.pos;
				_player.info.pos = _player.info.pos.add(_vp);
				var posB:Point=_player.info.pos;
				if(_player is GameLocalPlayer)
				{
					(_player as GameLocalPlayer).localPlayer.energy-=Math.round(Point.distance(posA,posB)/1.5);
				}
			}
			else
			{
				_player.info.pos = _target;
				if(_player is GameLocalPlayer)
				{
					GameLocalPlayer(_player).hideTargetMouseTip();
				}
				finish();
			}
		}
		
		public function finish():void
		{
			_player.stopMoving();
			_isFinished = true;
		}
		
		override public function executeAtOnce():void
		{
			super.executeAtOnce();
			while(!_isFinished)
			{
				execute();
			}
		}
	}
}