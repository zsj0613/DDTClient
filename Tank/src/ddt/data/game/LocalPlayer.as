package ddt.data.game
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import ddt.data.player.SelfInfo;
	import ddt.events.LivingEvent;
	import ddt.manager.SocketManager;
	
	[Event(name="energyChanged",type="ddt.events.LivingEvent")]
	[Event(name="gunangleChanged",type="ddt.events.LivingEvent")]
	[Event(name="forceChanged",type="ddt.events.LivingEvent")]
	[Event(name="skip",type="ddt.events.LivingEvent")]
	[Event(name="sendShootAction",type="ddt.events.LivingEvent")]
	public class LocalPlayer extends Player
	{
		public function LocalPlayer(info:SelfInfo,id:int,team:int,maxBlood:int)
		{
			super(info,id,team,maxBlood);
		}
		
		public function get selfInfo():SelfInfo
		{
			return playerInfo as SelfInfo;
		}
		private var _energy:Number = 0;
		public function get energy():Number
		{
			return _energy;
		}
		public function set energy(value:Number):void
		{
			if(value != _energy && value <= maxEnergy)
			{
				_energy = value >= 0 ? value : 0;
				dispatchEvent(new LivingEvent(LivingEvent.ENERGY_CHANGED));
			}
		}
		
		/**
		 * 位置
		 */		
		override public function set pos(value:Point):void
		{
			if(value.equals(_pos) == false)
			{
				if(isLiving)
				{
					energy -= Math.abs(value.x - _pos.x);
				}
				super.pos = value;
			} 
		}
		
		/**
		 * 开炮类型，次数，时间 
		 */		
		public var shootType:int = 0;
		public var shootCount:int = 0;
		public var shootTime:int;
		
//		public var extraShootCount:int = 0;
		
		/**
		 * 枪的角度 
		 */		
		private var _gunAngle:Number = 0;
		
		public function setGunAngle(value:Number):Boolean
		{
			var oldGunAngle:int = gunAngle;
			gunAngle = value;
			var result:Boolean = oldGunAngle != gunAngle;
			return result;
		}
		
		public function get gunAngle():Number
		{
			return _gunAngle;
		}
		public function set gunAngle(value:Number):void
		{
			if(value == _gunAngle) return;
			if(currentBomb == 3 && (value <0 || value > 90)) return;
			if(currentBomb != 3 && (value <currentWeapInfo.armMinAngle)){
				_gunAngle = currentWeapInfo.armMinAngle;
				return;
			}else if (currentBomb != 3 && (value > currentWeapInfo.armMaxAngle)){
				_gunAngle = currentWeapInfo.armMaxAngle;
				return;
			} 
			_gunAngle = value;		
			dispatchEvent(new LivingEvent(LivingEvent.GUNANGLE_CHANGED));
		}
		public function calcBombAngle():Number
		{
			return direction > 0 ? playerAngle - _gunAngle : playerAngle + _gunAngle - 180;
		}
		
		private var _force:Number = 0;
		public function get force():Number
		{
			return _force;
		} 
		public function set force(value:Number):void
		{
			_force = Math.min(value,Player.FORCE_MAX);
			dispatchEvent(new LivingEvent(LivingEvent.FORCE_CHANGED));			
		}
		
		override public function beginNewTurn():void
		{
			super.beginNewTurn();
			checkAngle();
			dispatchEvent(new LivingEvent(LivingEvent.GUNANGLE_CHANGED));
//			shootCount = 1;
			shootType = 0;
			
		}
		private function checkAngle() : void
		{
			if((_gunAngle <currentWeapInfo.armMinAngle)){
				gunAngle = currentWeapInfo.armMinAngle;
				return;
			}
			if ((_gunAngle > currentWeapInfo.armMaxAngle)){
				gunAngle = currentWeapInfo.armMaxAngle;
				return;
			} 
		}
		
		public function skip():void
		{
			if(isAttacking)
			{
				stopAttacking();
				dispatchEvent(new LivingEvent(LivingEvent.SKIP));
			}
		}
		
		public function sendShootAction(force:Number):void
		{
			dispatchEvent(new LivingEvent(LivingEvent.SEND_SHOOT_ACTION,0,0,force));
		}
		
		public function canUseProp(currentPlayer:TurnedLiving):Boolean
		{
			return (this == currentPlayer && !LockState) || (!isLiving && team == currentPlayer.team);
		}
		
		override public function pick(box:int):void
		{
			super.pick(box);
			SocketManager.Instance.out.sendGamePick(box);
		}
		
		override protected function setWeaponInfo():void
		{
			super.setWeaponInfo();
			gunAngle = currentWeapInfo.armMinAngle;
		}	
		
		override public function reset():void
		{
			super.reset();
			if(currentWeapInfo)gunAngle = currentWeapInfo.armMinAngle;
		}
		
		private var _selfDieTimer:Timer;
		override public function die(widthAction:Boolean=true):void
		{
			super.die(widthAction);
			_selfDieTimer = new Timer(500,1);
			_selfDieTimer.start();
			_selfDieTimer.addEventListener(TimerEvent.TIMER,__onDieDelayPassed);
		}
		
		private function __onDieDelayPassed(event:TimerEvent):void
		{
			removeSelfDieTimer();
			_selfDieTimeDelayPassed = true;
		}
		
		private function removeSelfDieTimer():void
		{
			if(_selfDieTimer == null)return;
			_selfDieTimer.stop();
			_selfDieTimer.removeEventListener(TimerEvent.TIMER,__onDieDelayPassed);
			_selfDieTimer = null;
		}
		
		private var _selfDieTimeDelayPassed:Boolean = false;
		public function get selfDieTimeDelayPassed():Boolean
		{
			return _selfDieTimeDelayPassed;
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeSelfDieTimer();
		}
		
	}
}