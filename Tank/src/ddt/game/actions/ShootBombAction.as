package ddt.game.actions
{
	import road.manager.SoundManager;
	
	import ddt.actions.BaseAction;
	import ddt.command.PlayerAction;
	import ddt.data.BallInfo;
	import ddt.data.game.Bomb;
	import ddt.data.game.LocalPlayer;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.game.objects.ActionType;
	import ddt.game.objects.GameLocalPlayer;
	import ddt.game.objects.GamePlayer;
	import ddt.game.objects.SimpleBomb;
	import ddt.manager.BallManager;
	import ddt.view.characterII.GameCharacter;
	
	public class ShootBombAction extends BaseAction
	{
		private var _player:GamePlayer;
		private var _showAction:PlayerAction;
		private var _hideAction:PlayerAction;
		private var _bombs:Array;
		private var _isShoot:Boolean;
		private var _shootInterval:int;
		private var _info:BallInfo;
		private var _event:CrazyTankSocketEvent;
		
		public function ShootBombAction(player:GamePlayer,bombs:Array,event:CrazyTankSocketEvent,interval:int)
		{
			_player = player;
			_bombs = bombs;
			_event = event;
			_shootInterval = interval / 40;
			_event.executed = false;
		}
		
		override public function prepare():void
		{
			if(_isPrepare) return;
			_isPrepare = true;
			if(_player == null || _player.body == null || _player.player == null)
			{
				finish();
				return;
			}
			_info = BallManager.findBall(_player.player.currentBomb);
			_showAction = _info.ActionType == 0 ? GameCharacter.THROWS : GameCharacter.SHOT;
			_hideAction = _info.ActionType == 0 ? GameCharacter.HIDETHROWS : GameCharacter.HIDEGUN;
			if(_player.isLiving)
			{
				_player.body.doAction(_showAction);
				if(_player.weaponMovie)
				{
					_player.weaponMovie.visible = true;
					_player.setWeaponMoiveActionSyc("shot");
					_player.setWingRotation();
				}
			}
		}
		
		override public function execute():void
		{
			if(_player == null || _player.body == null || _player.body.currentAction == null)
			{
				finish();
				return;
			}
			if(_player.body.currentAction != _showAction)
			{
				if(_player.weaponMovie)
				{
					_player.weaponMovie.visible = false;
				}
				_player.setWingNoRotation();
			}
			if(!_isShoot)
			{
				if(!_player.body.actionPlaying() || _player.body.currentAction != _showAction)
				{
					executeImp(false);
				}
			}
			else
			{
				_shootInterval --;
				if(_shootInterval <=0)
				{
					if(_player.body.currentAction == _showAction)
					{
						if(_player.isLiving)
						{
							_player.body.doAction(_hideAction);
						}
						if(_player.weaponMovie)
						{
							_player.setWeaponMoiveActionSyc("end");
						}
						_player.setWingNoRotation();
					}
					finish();
				}
			}
		}
		
		private function setSelfShootFinish():void
		{
			if(!_player.isExist)return;
			if(!_player.info.isSelf)return ;
			if(GameLocalPlayer(_player).shootOverCount >= LocalPlayer(_player.info).shootCount)
			{
				GameLocalPlayer(_player).shootOverCount = LocalPlayer(_player.info).shootCount;
			}else
			{
				GameLocalPlayer(_player).shootOverCount ++;
			}
		}
		
		private function finish():void
		{
			_isFinished = true;
			_event.executed = true;
			setSelfShootFinish();
		}
		
		private function executeImp(fastModel:Boolean):void
		{
			if(!_isShoot)
			{
				_isShoot = true;
				SoundManager.Instance.play(_info.ShootSound);
				for (var i:int = 0;i<_bombs.length;i++)
				{
					for(var j:int = 0;j<_bombs[i].Actions.length;j++)
					{
						if(_bombs[i].Actions[j].type == ActionType.KILL_PLAYER)
						{
							_bombs.unshift(_bombs.splice(i,1)[0]);
							break;
						}
					}
				}
					
				for each(var b:Bomb in _bombs)
				{
//					b.Template = _info;
					var bomb:SimpleBomb = new SimpleBomb(b,_player.info,BallManager.createBallAsset(b.Template.ID),_player.player.currentWeapInfo.refineryLevel);
					_player.map.addPhysical(bomb);
					bomb.startMoving();
					if(fastModel)
					{
						bomb.bombAtOnce();
					}
				}
			}
		}
		
		override public function executeAtOnce():void
		{
			super.executeAtOnce();
			executeImp(true);
		}
	}
}