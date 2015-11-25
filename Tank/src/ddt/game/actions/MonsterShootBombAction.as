package ddt.game.actions
{
	import flash.events.Event;
	
	import road.manager.SoundManager;
	
	import ddt.actions.BaseAction;
	import ddt.data.BallInfo;
	import ddt.data.game.Bomb;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.game.ActionMovieEvent;
	import ddt.game.animations.AnimationLevel;
	import ddt.game.animations.BaseSetCenterAnimation;
	import ddt.game.objects.ActionType;
	import ddt.game.objects.GameLiving;
	import ddt.game.objects.SimpleBomb;
	import ddt.manager.BallManager;

	public class MonsterShootBombAction extends BaseAction
	{
		private var _monster:GameLiving;
		private var _bombs:Array;
		private var _isShoot:Boolean;
		private var _prepared:Boolean;
		private var _prepareAction:String;
		private var _shootInterval:int;
		private var _info:BallInfo;
		private var _event:CrazyTankSocketEvent;
		private var _endAction:String = "";
		
		private var _canShootImp:Boolean;
		public function MonsterShootBombAction(monster:GameLiving,bombs:Array,event:CrazyTankSocketEvent,interval:int)
		{
			_monster = monster;
			_bombs = bombs;
			_event = event;
			_prepared = false;
			_shootInterval = interval / 40;
		}
		
		override public function prepare():void
		{
			_info = BallManager.findBall(_bombs[0].Template.ID);
			_monster.map.requestForFocus(_monster,AnimationLevel.MIDDLE);
			_monster.actionMovie.addEventListener("shootPrepared",onEventPrepared);
			_monster.actionMovie.doAction("shoot",onCallbackPrepared);
		}
		protected function onEventPrepared(evt:Event):void{
			
			_monster.actionMovie.removeEventListener("shootPrepared",onEventPrepared);
			_prepared = true;
			_monster.map.cancelFocus(_monster);
		}
		protected function onCallbackPrepared():void{
			
			_monster.actionMovie.removeEventListener("shootPrepared",onEventPrepared);
			_prepared = true;
			_monster.map.cancelFocus(_monster);
		}
		override public function execute():void
		{
			if(!_prepared){
				return;
			}
			if(!_isShoot)
			{
				executeImp(false);
			}
			else
			{
				_shootInterval --;
				if(_shootInterval <=0)
				{
					_isFinished = true;
					_event.executed = true;
				}
			}
		}
		
		private function executeImp(fastModel:Boolean):void
		{
			if(!_isShoot)
			{
				_isShoot = true;
				
				SoundManager.instance.play(_info.ShootSound);
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
					var bomb:SimpleBomb = new SimpleBomb(b,_monster.info,BallManager.createBallAsset(_info.ID));
					_monster.map.addPhysical(bomb);
					bomb.startMoving();
					if(fastModel)
					{
						bomb.bombAtOnce();
					}
				}
			}
		}
		
	}
}