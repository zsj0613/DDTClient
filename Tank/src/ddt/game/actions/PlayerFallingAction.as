package ddt.game.actions
{
	import flash.geom.Point;
	
	import ddt.actions.BaseAction;
	import ddt.data.game.Living;
	import ddt.data.game.Player;
	import ddt.game.animations.AnimationLevel;
	import ddt.game.animations.BaseSetCenterAnimation;
	import ddt.game.objects.GameLiving;
	import ddt.manager.GameManager;
	import ddt.data.game.LocalPlayer;
	
	public class PlayerFallingAction extends BaseAction
	{
		protected var _player:GameLiving;
		private var _info:Living;
		private var _target:Point;
		private var _isLiving:Boolean;
		private var _canIgnore:Boolean;
		private var _self:LocalPlayer;
		
		public function PlayerFallingAction(player:GameLiving,target:Point,isLiving:Boolean,canIgnore:Boolean)
		{
			_target = target;
			_isLiving = isLiving;
			if(!_isLiving)
			{
				_target.y += 70;
			}
			_info = player.info;
			_player = player;
			_self = GameManager.Instance.Current.selfGamePlayer;
			_canIgnore = canIgnore;
		}
		
		override public function connect(action:BaseAction):Boolean
		{
			var ac:PlayerFallingAction = action as PlayerFallingAction;
			if(ac && ac._target.y < _target.y)
			{
				//过滤掉掉落点比现在点高的FallingAction
				return true;
			}
			return false;
		}
		
		override public function canReplace(action:BaseAction):Boolean
		{
			if(action is PlayerWalkAction)
			{
				if(_canIgnore)
				{
					return true;
				}
			}
			return false;
		}
		
		override public function prepare():void
		{
			if(_isPrepare) return;
			_isPrepare = true;
			if(_player.isLiving)
			{
				if(_player.x == _target.x || !_canIgnore)
				{
					_player.startMoving();
				}
				else
				{
					finish();
				}
			}
			else
			{
				finish();
			}
		}
		
		override public function execute():void
		{
			if(_target.y - _info.pos.y <= Player.FALL_SPEED)
			{
				executeAtOnce();
			}
			else
			{
				_info.pos = new Point(_target.x,_info.pos.y + Player.FALL_SPEED);
				_player.map.animateSet.addAnimation(new BaseSetCenterAnimation(_player.x,_player.y-150,50,false,AnimationLevel.LOW));
			}
		}
		
		override public function executeAtOnce():void
		{
			super.executeAtOnce();
			_info.pos = _target;
//			_player.needFocus();
			_player.map.setCenter(_info.pos.x,_info.pos.y - 150,false);
			if(!_isLiving)
			{
				_info.die();
			}
			finish();
		}
		
		private function finish():void
		{
//			trace("FallingAction Finish _player.x :"+_player.pos.x + "   _player.y"+_player.pos.y);
			_isFinished = true;
			_player.stopMoving();
		}
	}
}