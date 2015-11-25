package ddt.game.actions
{
	import com.hurlant.util.Memory;
	
	import ddt.actions.BaseAction;
	import ddt.command.PlayerAction;
	import ddt.data.BallInfo;
	import ddt.game.objects.GamePlayer;
	import ddt.manager.BallManager;
	import ddt.manager.SharedManager;
	import ddt.view.characterII.GameCharacter;
	
	public class PrepareShootAction extends BaseAction
	{
		private var _player:GamePlayer;
		private var _actionType:PlayerAction;
		public function PrepareShootAction(player:GamePlayer)
		{
			_player = player;
			
		}
		
		override public function connect(action:BaseAction):Boolean
		{
			return action is PrepareShootAction;
		}
		
		override public function prepare():void
		{
			if(_player.isLiving)
			{
				Memory.gc();
				var ball:BallInfo = BallManager.findBall(_player.player.currentBomb);
				_actionType = ball.ActionType == 0 ? GameCharacter.SHOWTHROWS : GameCharacter.SHOWGUN;
				
				if(_player.player.isSpecialSkill && SharedManager.Instance.showParticle)
				{
					_player.map.spellKill(_player);
				}
					
				_player.weaponMovie = BallManager.createBallWeaponMovie(_player.player.currentBomb);
				_player.body.doAction(_actionType);
				if(_player.weaponMovie)
				{
					_player.weaponMovie.visible = true;
					_player.weaponMovie.gotoAndStop(_player.player.currentWeapInfo.refineryLevel+1);
					_player.setWeaponMoiveActionSyc("start");
					_player.setWingRotation();
				}
			}
			else
			{
				_isFinished = true;
			}
		}
		
		override public function execute():void
		{
			if(_player == null || _player.body == null || _player.body.currentAction == null)
			{
				_isFinished = true;
				return;
			}
			
			if(_player.body.currentAction != _actionType)
			{
				if(_player.weaponMovie)
				{
					_player.weaponMovie.visible = false;
				}
				_player.setWingNoRotation();
				
			}
			if(!_player.map.isPlayingMovie && (!_player.body.actionPlaying() || _player.body.currentAction != _actionType))
			{
				_player.isShootPrepared = true;
				_isFinished = true;
			}
		}
		
	}
}