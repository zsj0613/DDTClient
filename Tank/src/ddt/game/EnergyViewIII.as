package ddt.game
{
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import game.crazyTank.view.EnergyAsset;
	import game.crazyTank.view.FrostEffectAsset;
	
	import mx.olap.aggregators.MaxAggregator;
	
	import org.aswing.KeyboardManager;
	
	import road.manager.SoundManager;
	
	import ddt.data.game.LocalPlayer;
	import ddt.data.game.Player;
	import ddt.events.LivingEvent;
	import ddt.game.map.MapView;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;

	public class EnergyViewIII extends EnergyAsset
	{
		public static const STRIP_WIDTH:Number = 500;
		public static const FORCE_MAX:Number = 2000;
		public static const SHOOT_FORCE_STEP:Number = 20;
		public static const HIT_FORCE_STEP:Number = 40;
		private var _recordeWidth:Number;
		private var _self:LocalPlayer;
		private var _force:Number;
		private var _map:MapView;
		private var _hitArea:Sprite;
		private var _forceSpeed:Number;
		private var _hitX:int;
		public function EnergyViewIII(info:LocalPlayer,map:MapView)
		{
			slider.x = strip.x;
			slider.y = strip.y;
			
			_hitArea = new Sprite();
			_hitArea.graphics.beginFill(0xFFFF00,0.8);
			_hitArea.graphics.drawRect(-3,-5,6,10);
			_hitArea.graphics.endFill();
			
			_hitArea.y = strip.y;
			_hitArea.visible = true;
			
			strip.width = 0;
			_recordeWidth = 0;
			stripRecord.width = 0;
			
			hot.addEventListener(MouseEvent.CLICK,__click);
			
			_self = info;
			_self.addEventListener(LivingEvent.ATTACKING_CHANGED,__attackingChanged);
			_self.addEventListener(LivingEvent.BEGIN_NEW_TURN,__beginNewTurn);
			_map = map;
		}
		
		private function __attackingChanged(event:LivingEvent):void
		{
			if(_self.isAttacking && _self.isLiving)
			{
				addEventListener(Event.ENTER_FRAME,__enterFrame);
				_keyDown = false;
				_force = 0;
				_dir = 1;
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME,__enterFrame);
				//用户按下跳过，后要禁用力度条
			}
		}
		
		private var _keyDown:Boolean;
		private var _dir:int = 1;
		private function __enterFrame(event:Event):void
		{
			if(KeyboardManager.isDown(Keyboard.SPACE))
			{
				if(_keyDown)
				{
					calcForce();
				}
				else if(!_self.isMoving)
				{
					_keyDown = true;
					_self.beginShoot();
					_map.setCenter(_self.pos.x,_self.pos.y - 150,true);
				}
			}
			else
			{
				if(_keyDown)
				{
					SoundManager.Instance.stop("020");
					SoundManager.Instance.play("019");
					if(_self.shootType == 0)
					{
						_self.sendShootAction(_force);
					}
					else
					{
						_self.sendShootAction(_force - _hitX);
					}
					
					removeEventListener(Event.ENTER_FRAME,__enterFrame);
				}
			}
		}
		
		private function __changeShootType():void
		{
			if(!_keyDown && _self.isAttacking)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.EnergyViewIII.proximal"));
				_self.shootType = 1;
				_hitX = int(Math.random() * 2000);
				_hitArea.x = strip.x + (_hitX / 2000) * STRIP_WIDTH;
				_hitArea.visible = true;
				_hitArea.width = 100;
				_hitArea.height = 100;
			}
		}
		
		private function __beginNewTurn(event:LivingEvent):void
		{
			strip.width = 0;
			stripRecord.width = _recordeWidth;
			_hitArea.visible = false;
			_forceSpeed = SHOOT_FORCE_STEP;
		}
		
		private function calcForce():void
		{
			if(_force >= FORCE_MAX )
			{
				_dir = -1;
			}
			_force += _dir * _forceSpeed;
			_force = _force > FORCE_MAX ? FORCE_MAX : _force;
			strip.width = Math.ceil(STRIP_WIDTH / FORCE_MAX * _force);
			_recordeWidth = strip.width;
			SoundManager.Instance.play("020",false,false);
			if(_force <= 0)
			{
				removeEventListener(Event.ENTER_FRAME,__enterFrame);
				SoundManager.Instance.stop("020");
				_self.skip();
			}
		}
		
		public function get force():Number
		{
			return (slider.x-hot.x)/STRIP_WIDTH*FORCE_MAX;
		}
		
		private function __click(event:MouseEvent):void
		{
			slider.x = hot.x + event.localX;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function dispose():void
		{
			removeEventListener(Event.ENTER_FRAME,__enterFrame);
			_self.removeEventListener(LivingEvent.ATTACKING_CHANGED,__attackingChanged);
			_self.removeEventListener(LivingEvent.BEGIN_NEW_TURN,__beginNewTurn);
			hot.removeEventListener(MouseEvent.CLICK,__click);
			_map = null;
			_self = null;
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}