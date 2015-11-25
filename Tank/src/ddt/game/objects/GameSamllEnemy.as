package ddt.game.objects
{
	import flash.events.Event;
	
	import phy.maps.Map;
	import phy.object.PhysicalObj;
	
	import ddt.data.game.Living;
	import ddt.data.game.Player;
	import ddt.data.game.SmallEnemy;
	import ddt.events.LivingEvent;
	import ddt.game.actions.MonsterShootBombAction;

	public class GameSamllEnemy extends GameLiving
	{
		public function GameSamllEnemy(info:SmallEnemy)
		{
			super(info);
			info.defaultAction = "stand";
		}
		
		override protected function initView():void
		{
			super.initView();
			initMovie();
		}
		
		override protected function __dirChanged(event:LivingEvent):void
		{
			super.__dirChanged(event);
			actionMovie.scaleX = -_info.direction;
		}
		
		override public function setMap(map:Map):void
		{
			super.setMap(map);
			if(map)
			{
				__posChanged(null);
			}
		}
		
		public function get smallEnemy():SmallEnemy
		{
			return info as SmallEnemy;
		}
		
		override protected function __bloodChanged(event:LivingEvent):void
		{
			super.__bloodChanged(event);
			if(event.value - event.old < 0)
			{
				doAction(Living.CRY_ACTION);
			}
		}
		
		override protected function __die(event:LivingEvent):void
		{
			if(isMoving())stopMoving();
			super.__die(event);
			if(event.paras[0])
			{
				if(_info.typeLiving == 2)
				{
					_actionMovie.doAction(Living.DIE_ACTION,clearEnemy);
				}else
				{
					_actionMovie.doAction(Living.DIE_ACTION,dispose);
				}
			}else
			{
				if(_info.typeLiving == 2)
				{
					clearEnemy();
				}else
				{
					dispose();
				}
			}
			_chatballview.dispose();
			_isDie = true;
		}
		
		override public function collidedByObject(obj:PhysicalObj):void
		{
			if(obj is SimpleBomb)
			{
				info.isFrozen = false;
				info.isHidden = false;
			}
		}
		override protected function fitChatBallPos():void{
			_chatballview.x =  20;
			_chatballview.y =  -50;
		}
		private function clearEnemy() : void
		{
			removeEvents(true);
			deleteSmallView();
		}
		
		private function removeEvents(flag:Boolean = false):void
		{
			super.removeListener();
			if(flag)_info.addEventListener(LivingEvent.BEGIN_NEW_TURN,__beginNewTurn);//保留beginNewTurn，用来实现5个回合后再清理
		}
		private var _bombEvent:LivingEvent;
		override protected function __shoot(event:LivingEvent):void
		{
			map.act(new MonsterShootBombAction(this,event.paras[0],event.paras[1],Player.SHOOT_INTERVAL));
		}
		
		override protected function __beginNewTurn(event:LivingEvent):void
		{
			if(_isDie)
			{
				_turns++;
			}
			if(_turns >= 5)
			{
				dispose();
			}
		}
		
		override public function dispose():void
		{
			_info.dispose();
			super.dispose();
		}
		
	}
}