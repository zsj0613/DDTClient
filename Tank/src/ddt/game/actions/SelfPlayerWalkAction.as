package ddt.game.actions
{
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import org.aswing.KeyboardManager;
	
	import road.manager.SoundManager;
	
	import ddt.actions.BaseAction;
	import ddt.data.game.Player;
	import ddt.game.animations.AnimationLevel;
	import ddt.game.animations.BaseSetCenterAnimation;
	import ddt.game.objects.GameLiving;
	import ddt.game.objects.GameLocalPlayer;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.socket.GameInSocketOut;
	import ddt.view.characterII.GameCharacter;
	
	public class SelfPlayerWalkAction extends BaseAction
	{
		private var _player:GameLocalPlayer;
		private var _end:Point;
		private var _count:int;
		
		public function SelfPlayerWalkAction(player:GameLocalPlayer)
		{
			_player = player;
			_count = 0;
			_isFinished = false;
		}
		
		override public function connect(action:BaseAction):Boolean
		{
			//忽略掉相同的Action
			return action is SelfPlayerWalkAction;
		}
		
		
		private function isDirkeyDown():Boolean
		{
			if(_player.info.direction == -1)
			{
				return KeyboardManager.isDown(65) || KeyboardManager.isDown(Keyboard.LEFT);
			}
			else
			{
				return KeyboardManager.isDown(68) || KeyboardManager.isDown(Keyboard.RIGHT);
			}
		}
		
		override public function prepare():void
		{
			_player.startMoving();
			_player.map.animateSet.addAnimation(new BaseSetCenterAnimation(_player.x,_player.y - 150,0,false,AnimationLevel.MIDDLE));
		}
		
		override public function execute():void
		{
			if(isDirkeyDown() && _player.localPlayer.energy > 0 && _player.localPlayer.isAttacking)
			{
				var pos:Point = _player.getNextWalkPoint(_player.info.direction);
				if(pos)
				{
					_player.info.pos = pos;
					_player.body.doAction(GameCharacter.WALK);
					SoundManager.Instance.play("044",false,false);
					_player.map.animateSet.addAnimation(new BaseSetCenterAnimation(_player.x,_player.y - 150,0,false,AnimationLevel.MIDDLE));
					_count ++;
					if(_count >= 20)
					{
						sendAction();
					}
				}
				else
				{
					sendAction();
					finish();
					var tx:Number = _player.x + _player.info.direction * Player.MOVE_SPEED;
					if(_player.canMoveDirection(_player.info.direction) && _player.canStand(tx,_player.y) == false)
					{
						pos =  _player.map.findYLineNotEmptyPointDown(tx,_player.y - GameLiving.stepY,_player.map.bound.height);
						if(pos)
						{
							_player.act(new PlayerFallingAction(_player,pos,true,false));
							GameInSocketOut.sendGameStartMove(1,pos.x,pos.y,0,true,_player.map.currentTurn);
						}
						else
						{
							_player.act(new PlayerFallingAction(_player,new Point(tx,_player.map.bound.height - 70),false,false));
							GameInSocketOut.sendGameStartMove(1,tx,_player.map.bound.height,0,false,_player.map.currentTurn);
						}
					}
				}
			}
			else
			{
				if(_player.localPlayer.energy <= 0)
				{
					
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.actions.SelfPlayerWalkAction"));
					//MessageTipManager.getInstance().show("体力不足");
				}
				sendAction();
				finish();
			}
		}
		
		private function sendAction():void
		{
			GameInSocketOut.sendGameStartMove(0,_player.x,_player.y,_player.info.direction,_player.isLiving,_player.map.currentTurn);
			//发送到服务器广播
			_count = 0;
		}
		private function finish():void
		{
			_player.stopMoving();
			_isFinished = true;
		}		
	}
}