package ddt.game.actions
{
	import flash.geom.Point;
	
	import road.manager.SoundManager;
	
	import ddt.actions.BaseAction;
	import ddt.data.game.LocalPlayer;
	import ddt.game.animations.AnimationLevel;
	import ddt.game.animations.BaseSetCenterAnimation;
	import ddt.game.objects.GameLiving;
	import ddt.manager.GameManager;
	import ddt.view.characterII.GameCharacter;
	
	public class PlayerWalkAction extends BaseAction
	{
		private var _living:GameLiving;
		private var _action:*;
		private var _target:Point;
		private var _dir:Number;
		private var _self:LocalPlayer;
		public function PlayerWalkAction(living:GameLiving,target:Point,dir:Number,action:* = null)
		{
			_isFinished = false;
			_self = GameManager.Instance.Current.selfGamePlayer;
			_living = living;
			_action = action ? action : GameCharacter.WALK;
			_target = target;
			_dir = dir;
		}
		
		override public function connect(action:BaseAction):Boolean
		{
			var walk:PlayerWalkAction = action as PlayerWalkAction;
			if(walk)
			{
				_target = walk._target;
				_dir = walk._dir;
				return true;
			}
			return false;
		}
		
		override public function prepare():void
		{
			if(_isPrepare) return;
			_isPrepare = true;
			if(_living.isLiving)
			{
				_living.startMoving();
			}
			else
			{
				finish();
			}
		}
		
		override public function execute():void
		{
			if(Point.distance(_living.pos,_target) <= GameLiving.stepX || _target.x == _living.x)
			{
				finish();
			}
			else
			{
				_living.info.direction = _target.x > _living.x ? 1 : -1; 
				var p:Point = _living.getNextWalkPoint(_living.info.direction);
				if(p == null || (_living.info.direction > 0 && p.x >= _target.x) || (_living.info.direction < 0 && p.x <= _target.x))
				{
					finish();
				}else
				{
					_living.info.pos = p;
					_living.doAction(_action);
					SoundManager.instance.play("044",false,false);
					if(!_living.info.isHidden){
						_living.map.animateSet.addAnimation(new BaseSetCenterAnimation(_living.x,_living.y - 150,0,false,AnimationLevel.MIDDLE));
					}

				}
			}
		}
		
		private function finish():void
		{
			_living.info.pos = _target;
			_living.info.direction = _dir;
			_living.stopMoving();
			_isFinished = true;
		}
		
		override public function executeAtOnce():void
		{
			super.executeAtOnce();
			_living.info.pos = _target;
			_living.info.direction = _dir;
			_living.stopMoving();
		}
	}
}