package ddt.game.objects
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import game.crazyTank.view.MoveStripAsset;
	import game.crazyTank.view.TakeAimAsset;
	
	import org.aswing.KeyStroke;
	import org.aswing.KeyboardManager;
	
	import road.manager.SoundManager;
	
	import ddt.data.game.LocalPlayer;
	import ddt.data.game.Player;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.events.LivingEvent;
	import ddt.game.actions.PlayerBeatAction;
	import ddt.game.actions.PrepareShootAction;
	import ddt.game.actions.SelfPlayerWalkAction;
	import ddt.game.actions.SelfSkipAction;
	import ddt.game.animations.AnimationLevel;
	import ddt.game.animations.BaseSetCenterAnimation;
	import ddt.socket.GameInSocketOut;
	import ddt.view.characterII.GameCharacter;
	import ddt.view.characterII.ShowCharacter;

	public class GameLocalPlayer extends GamePlayer
	{
		public function GameLocalPlayer(player:LocalPlayer,character:ShowCharacter,movie:GameCharacter = null)
		{
			super(player,character,movie);
		}
		
		public function get localPlayer ():LocalPlayer
		{
			return info as LocalPlayer;
		}
		
		/**
		 * 描准器 
		 */		
		private var _takeAim:TakeAimAsset;
		
		/**
		 * 移动力
		 */		
		private var _moveStrip:MoveStripAsset;
		private var _ballpos:Point;
		protected var _shootTimer:Timer;
		
		private var mouseAsset:MouseShape1;
		
		public function get aim():TakeAimAsset
		{
			return _takeAim;
		}
		
		override protected function initView():void
		{
			super.initView();
			_ballpos = new Point(30,-20);
			_takeAim = new TakeAimAsset();
			_takeAim.x = _ballpos.x * - 1;
			_takeAim.y = _ballpos.y;
			_takeAim.hand.rotation = localPlayer.currentWeapInfo.armMinAngle;
			_takeAim.visible = false;
			_player.addChild(_takeAim);
			
			
			_moveStrip = new MoveStripAsset();
			if(_consortiaName)
			{
				_moveStrip.x = 0;
				_moveStrip.y = _consortiaName.y + 11;
			}
			else
			{
				_moveStrip.x = 0;
				_moveStrip.y = _nickName.y + 11;
			}
			_moveStrip.visible = false;
			localPlayer.energy = localPlayer.maxEnergy;	
			addChild(_moveStrip);
			mouseAsset = new MouseShape1(); 
			mouseAsset.visible = false;
			
			_shootTimer = new Timer(Player.SHOOT_INTERVAL);
		}
		
		override protected function initListener():void
		{
			super.initListener();
			localPlayer.addEventListener(LivingEvent.SEND_SHOOT_ACTION,__sendShoot);
			localPlayer.addEventListener(LivingEvent.ENERGY_CHANGED,__energyChanged);
			localPlayer.addEventListener(LivingEvent.GUNANGLE_CHANGED,__gunangleChanged);
			localPlayer.addEventListener(LivingEvent.SKIP,__skip);
			_shootTimer.addEventListener(TimerEvent.TIMER,__shootTimer);
			KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_LEFT,__turnLeft);
			KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_A,__turnLeft);
			KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_RIGHT,__turnRight);
			KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_D,__turnRight);
		}
		
		override public function dispose():void
		{
			_shootTimer.removeEventListener(TimerEvent.TIMER,__shootTimer);
			localPlayer.removeEventListener(LivingEvent.SEND_SHOOT_ACTION,__sendShoot);
			localPlayer.removeEventListener(LivingEvent.ENERGY_CHANGED,__energyChanged);
			localPlayer.removeEventListener(LivingEvent.GUNANGLE_CHANGED,__gunangleChanged);
			localPlayer.removeEventListener(LivingEvent.SKIP,__skip);
			_shootTimer.reset();
			KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_LEFT,__turnLeft);
			KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_A,__turnLeft);
			KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_RIGHT,__turnRight);
			KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_D,__turnRight);
			if(!_isLiving)
			{
				_map.removeEventListener(MouseEvent.CLICK,__mouseClick);
			}
			if(_takeAim && _takeAim.parent) _takeAim.parent.removeChild(_takeAim);
			_takeAim = null;
			if(_moveStrip && _moveStrip.parent)_moveStrip.parent.removeChild(_moveStrip);
			_moveStrip = null;
			super.dispose();
		}
		
		protected function __skip(event:LivingEvent):void
		{
			act(new SelfSkipAction(localPlayer));
		}
					
		private function __turnLeft():void
		{
			if(!_isShooting)
			{
				info.direction = -1;
				walk();
			}
		}

		private function __turnRight():void
		{
			if(!_isShooting)
			{
				info.direction = 1;
				walk();
			}
		}
		
		protected function walk():void
		{
			if(!_isMoving && localPlayer.isAttacking)
			{
				act(new SelfPlayerWalkAction(this));
			}
		}
		
		override protected function __attackingChanged(event:LivingEvent):void
		{
//			super.__attackingChanged(event);
			attackingViewChanged();
			if(localPlayer.isAttacking && localPlayer.isLiving)
			{
				act(new SelfPlayerWalkAction(this));
			}
		}
		
		override protected function attackingViewChanged() : void
		{
			super.attackingViewChanged();
			if(localPlayer.isAttacking && localPlayer.isLiving)
			{
				_takeAim.visible = true;
				_moveStrip.visible = true;
				
			}else
			{
				_takeAim.visible = false;
				_moveStrip.visible = false;
			}
		}
		
		override public function die():void
		{
			localPlayer.dander = 0;
			_takeAim.visible = false;
			_moveStrip.visible = true;	
			map.animateSet.addAnimation(new BaseSetCenterAnimation(x,y-150,50,false,AnimationLevel.MIDDLE));
			map.addEventListener(MouseEvent.CLICK,__mouseClick);
			_shootTimer.removeEventListener(TimerEvent.TIMER, __shootTimer);
			super.die();
		}
		
		private function __mouseClick(event:MouseEvent):void
		{
			var p:Point = _map.globalToLocal(new Point(event.stageX,event.stageY));
			_map.addChild(mouseAsset);
			SoundManager.Instance.play("041");
			mouseAsset.x = p.x;
			mouseAsset.y = p.y;
			mouseAsset.visible = true;
			GameInSocketOut.sendGhostTarget(p);
		}
		
		public function hideTargetMouseTip():void
		{
			mouseAsset.visible = false;
		}
		
		override protected function __usingItem(event:LivingEvent):void
		{
			super.__usingItem(event);
			if(event.paras[0] is ItemTemplateInfo)
				localPlayer.energy = localPlayer.energy - int(event.paras[0].Property4);
		}
		
		protected var _isShooting:Boolean = false;
		protected var _shootCount:int = 0;
		protected function __sendShoot(event:LivingEvent):void
		{
			shootOverCount = _shootCount = 0;
			localPlayer.isAttacking = false;
			_isShooting = true;
			//使焦点回到自己身上，并且清除掉其他优先级比较高的焦点。
			map.animateSet.addAnimation(new BaseSetCenterAnimation(x,y - 150,1,false,AnimationLevel.HIGHT));
			GameInSocketOut.sendShootTag(true,localPlayer.shootTime);
			if(localPlayer.shootType == 0)
			{
				localPlayer.force = event.paras[0];
				_shootTimer.start();
				__shootTimer(null);
				map.act(new PrepareShootAction(this));
			}else
			{
				act(new PlayerBeatAction(this));
			}
			
		}
		
		private function __shootTimer(event:Event):void
		{
			if(localPlayer && localPlayer.isLiving && _shootCount < localPlayer.shootCount)
			{
				var p:Point = shootPoint();
				var angle:Number = localPlayer.calcBombAngle();
				var force :int= localPlayer.force;
				GameInSocketOut.sendGameCMDShoot(p.x,p.y,force,angle);
				_shootCount ++;
			}
		}
		
		override protected function __beginNewTurn(event:LivingEvent):void
		{
			super.__beginNewTurn(event);
			_shootTimer.reset();
			_takeAim.visible = false;
			_isShooting = false;
		}
		
		private var _shootOverCount:int = 0;
		
		public function get shootOverCount():int
		{
			return _shootOverCount;
		}
		
		public function set shootOverCount(count:int):void
		{
			_shootOverCount = count;
			if(_shootOverCount == _shootCount)
			{
				_isShooting = false;
			}
		}
		
		protected function __gunangleChanged(event:LivingEvent):void
		{
			_takeAim.hand.rotation = localPlayer.gunAngle;
		}
		
		protected function __energyChanged(event:LivingEvent):void
		{
			_moveStrip.moveStrip_mc.scaleX = localPlayer.energy / localPlayer.maxEnergy;//Player.ENERGY_MAX;
		}
	}
}