package ddt.game.objects
{
	import flash.geom.Rectangle;
	
	import game.crazyTank.view.FrostEffectAsset;
	
	import phy.maps.Map;
	
	import ddt.data.game.Living;
	import ddt.data.game.Player;
	import ddt.data.game.SimpleBoss;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.events.LivingEvent;
	import ddt.game.actions.ChangeDirectionAction;
	import ddt.game.actions.MonsterShootBombAction;
	import ddt.view.common.BossChatBall;

	public class GameSimpleBoss extends GameTurnedLiving
	{
		private var bombList:Array = [];
		private var shootEvt:CrazyTankSocketEvent;
		public function GameSimpleBoss(info:SimpleBoss)
		{
			super(info);
			info.defaultAction = Living.STAND_ACTION;
		}
		
		override protected function initView():void
		{
			initMovie();
			initFreezonRect();
			super.initView();
 			_nickName.x -= 2;
			_nickName.y += 2;
/* 			_nickName.visible = false;
			_smallBlood.visible = false; */
 
 		}
		override protected function initChatball():void{
			_chatballview = new BossChatBall();
			_originalHeight = this.height;
			_originalWidth = this.width;
			addChild(_chatballview);
		}
		override protected function initFreezonRect():void
		{
			_effRect = new Rectangle(-10,35,bodyWidth*1.3,bodyHeight*1.4);	
		}
		
		override protected function __forzenChanged(event:LivingEvent):void
		{
			if(_info.isFrozen)
			{
				effectForzen = new FrostEffectAsset();
				
				effectForzen.width = _effRect.width;
				effectForzen.height = _effRect.height;
				effectForzen.x = _effRect.x;
				effectForzen.y = _effRect.y;
				addChild(effectForzen);
			}
			else
			{
				if(effectForzen)
				{
					removeChild(effectForzen);
					effectForzen = null;
				}
			}
		}
		
		override protected function __dirChanged(event:LivingEvent):void
		{
			_info.act(new ChangeDirectionAction(this,_info.direction));
		}
		
		override public function setMap(map:Map):void
		{
			super.setMap(map);
			if(map)
			{
				__posChanged(null);
			}
		}
		
		private var shoots:Array = [];
		override protected function __shoot(event:LivingEvent):void
		{
//			DebugUtil.debugText("MonsterShootBombAction");
			map.act(new MonsterShootBombAction(this,event.paras[0],event.paras[1],Player.SHOOT_INTERVAL));
		}
		
		override protected function __attackingChanged(event:LivingEvent):void
		{
			
		}
		
		override protected function __posChanged(event:LivingEvent):void
		{
			super.__posChanged(event);
		}
		
		public function get simpleBoss():SimpleBoss
		{
			return info as SimpleBoss;
		}
		
		override protected function __bloodChanged(event:LivingEvent):void
		{
			if(event.paras[0] == 0)
			{
				if(_actionMovie != null)
				{
					_actionMovie.doAction(Living.RENEW,super.__bloodChanged,[event]);
				}
			}else
			{
				super.__bloodChanged(event);
				if(_info.State != 1) doAction(Living.CRY_ACTION);
			}
		}
		
		override protected function __die(event:LivingEvent):void
		{
			if(isMoving())stopMoving();
			super.__die(event);
			if(_info.typeLiving == 6)
			{
				_actionMovie.doAction("specialDie");
				return;
			}
			if(event.paras[0])
			{
				if(_info.typeLiving == 5)
				{
					_actionMovie.doAction(Living.DIE_ACTION,clearEnemy);
				}else
				{
					_actionMovie.doAction(Living.DIE_ACTION,dispose);
				}
			}else
			{
				if(_info.typeLiving == 5)
				{
					clearEnemy();
				}else
				{
					dispose();
				}
			}
			_isDie = true;
		}
		
		private function clearEnemy() : void
		{
			removeListener();
			deleteSmallView();
		}
		
		override protected function __changeState(evt:LivingEvent):void
		{
			if(_info.State == 1)
			{
				doAction(Living.ANGRY_ACTION);
			}else
			{
				doAction(Living.STAND_ACTION);
			}
		}
		
		override public function dispose():void
		{
			if(map && map.currentPlayer == _info) map.currentPlayer = null;
			super.dispose();
		}
	}
}