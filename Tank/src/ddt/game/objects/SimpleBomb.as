package ddt.game.objects
{	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import game.crazyTank.view.SmallBallAsset;
	
	import par.emitters.Emitter;
	import par.manager.ParticleManager;
	
	import phy.bombs.BaseBomb;
	import phy.maps.Map;
	import phy.object.Physics;
	
	import road.display.MovieClipWrapper;
	import road.manager.SoundManager;
	
	import ddt.data.GameInfo;
	import ddt.data.game.Bomb;
	import ddt.data.game.Living;
	import ddt.data.game.Player;
	import ddt.game.animations.PhysicalObjFocusAnimation;
	import ddt.game.animations.ShockMapAnimation;
	import ddt.game.map.MapView;
	import ddt.manager.GameManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SharedManager;
	
	public class SimpleBomb extends BaseBomb
	{
		private var _info:Bomb;
		
		private var _lifeTime:int;
	
		private var _owner:Living;
		
		protected var _emitters:Array;
		
		private var _spinV:Number;
		
		private var _blastMC:MovieClipWrapper;
		
		private var _dir:int = 1;
		
		private var _smallBall:SmallBallAsset;
		
		private var _game:GameInfo;
		
		override public function get smallView():Sprite
		{
			return _smallBall;
		}

		public function get map():MapView
		{
			return _map as MapView;
		}
		
		public function get info():Bomb
		{
			return _info;
		}
		
		public function get owner():Living
		{
			return _owner;
		}
		
		override public function isMoving():Boolean
		{
			return true;
		}
		
		public function SimpleBomb(info:Bomb,owner:Living,asset:Sprite,refineryLevel:int = 0)
		{
			_info = info;
			_lifeTime = 0;
			_owner = owner;
			super(_info.Id,asset["ball"],asset["shape"],asset["border"],info.Template.Mass,info.Template.Weight,info.Template.Wind,info.Template.DragIndex);
			if(asset["boon"])
			{
				asset["boon"].x = 0;
				asset["boon"].y = 0;
			}
			_blastMC = new MovieClipWrapper(asset["boon"] as MovieClip,false,true);
			asset["ball"].gotoAndStop(refineryLevel+1);
			_testRect = new Rectangle(-3,-3,6,6);	
			addSpeedXY(new Point(_info.VX,_info.VY));	
			_dir = _info.VX >= 0 ? 1 : -1;
			x = _info.X;
			y = _info.Y;
			
			if(_info.Template.SpinV > 0 )
				_movie.scaleX = _dir;
			else
				_movie.scaleY = _dir;
				
			_emitters = new Array();
			_smallBall = new SmallBallAsset();
			rotation =  motionAngle * 180 / Math.PI ;
			
			if(owner && !owner.isSelf && _info.Template.ID == Bomb.FLY_BOMB && owner.isHidden)
			{
				this.visible = false;
				_smallBall.visible = false;
			}
			
			mouseChildren = mouseEnabled = false;
		}
		
		override public function setMap(map:Map):void
		{
			super.setMap(map);
			if(map)
			{
				_game = this.map.game;
			}
		}
		
		override public function startMoving():void
		{
			super.startMoving();
			if(GameManager.Instance.Current == null)return;
			if(_info.changedPartical && SharedManager.Instance.showParticle && visible)
			{
				var index:int = 0;
				var emitter:Emitter;
				if(_info.changedPartical.length >= 1 && _info.changedPartical[0] != "")
				{
					if(owner.isPlayer())
					{
						var player:Player = owner as Player;
						index = player.currentWeapInfo.refineryLevel;
					}
					emitter = ParticleManager.creatEmitter(_info.changedPartical[index]);
				}
				if(emitter)
				{
					_map.particleEnginee.addEmitter(emitter);
					_emitters.push(emitter);
				}
			}
			_spinV =  _info.Template.SpinV * _dir;
		}
		
		override public function moveTo(p:Point):void
		{
			while(_info.Actions.length > 0)
			{
				if(_info.Actions[0].time > _lifeTime)
				{
					break;
				}
				else
				{
					var action:BombAction = _info.Actions.shift();
					action.execute(this,_game);
					if(!_isLiving)return;
				}
			}
			
			if(_isLiving)
			{
				if(_map.IsOutMap(p.x,p.y))
				{
					die();
				}
				else
				{
					map.smallMap.updatePos(_smallBall,pos);
					for each(var e:Emitter in _emitters)
					{
						e.x = x;
						e.y = y;
						e.angle = motionAngle;
					}
					pos = p;
					map.animateSet.addAnimation(new PhysicalObjFocusAnimation(this,25));
				}
				
			}
		}
		
		public function clearWG():void
		{
			_wf = 0;
			_gf = 0;
			_arf = 0;
		}

		override public function bomb():void
		{
			if(_info.IsHole)
			{
				//更新大地图
				super.DigMap();
				//更新小地图
				map.smallMap.draw();
				map.resetMapChanged();
			}
			var list:Array = map.getPhysicalObjectByPoint(pos,100,this);
			for each(var p:Physics in list)
			{
				if(p is TombView)
				{
					TombView(p).startMoving();
				}
			}
			
			stopMoving();
			if(!fastModel)
			{
				if(_info.Template.Shake)
				{
					map.animateSet.addAnimation(new ShockMapAnimation(this));
				}
				else
				{
					map.animateSet.addAnimation(new PhysicalObjFocusAnimation(this,10));
				}
			}
			
			//隐藏炮弹的形状
			if(!fastModel)
			{
				if(_isLiving)SoundManager.Instance.play(_info.Template.BombSound);
//				if(visible)
//				{
					_blastMC.x = x;
					_blastMC.y = y;
					_map.addBomb(_blastMC);
					_blastMC.addEventListener(Event.COMPLETE,__complete);
					_blastMC.play();
					_blastMC.visible = visible;
//				}
//				else
//				{
//					die();
//				}
			}
			else
			{
				die();
			}
			this.visible = false;
		}
		
		private var fastModel:Boolean;
		public function bombAtOnce():void
		{
			fastModel = true;
			var boomAction:BombAction;
			for(var i:int = 0;i<_info.Actions.length;i++)
			{
				if(_info.Actions[i].type == ActionType.BOMB)
				{ 
					boomAction = _info.Actions[i];
					break;
				}
			}
			var boomIndex:int = _info.Actions.indexOf(boomAction);
			var newActions:Array = _info.Actions.splice(boomIndex,1);
			if(boomAction)_info.Actions.push(boomAction);
			while(_info.Actions.length > 0)
			{
				var action:BombAction = _info.Actions.shift();
				action.execute(this,_game);
				if(!_isLiving)return;
			}
			
			if(_info)_info.Actions = [];
		}
		
		private function __complete(event:Event):void
		{
			die();
		}
		
		override public function die():void
		{
			super.die();
			dispose();
		}
		
		override public function stopMoving():void
		{
			for each(var e:Emitter in _emitters)
			{
				_map.particleEnginee.removeEmitter(e);
			}
			_emitters = [];
			super.stopMoving();
		}
		
		override protected function updatePosition(dt:Number):void
		{
			_lifeTime += 40;
//			trace("af:",_arf,"wf:",_wf,"gf:",_gf,"vx:",_vx.x1,"vy:",_vy.x1," x:",x," y:",y);
			super.updatePosition(dt);
			if(!_isLiving)return;
			if(_spinV > 1 || _spinV < -1)
			{
				_spinV = int(_spinV * _info.Template.SpinVA);
				_movie.rotation +=  _spinV;
			}
			rotation =  motionAngle * 180 / Math.PI ;
		}
		override public function dispose():void
		{	
			if(_blastMC)
			{
				_blastMC.removeEventListener(Event.COMPLETE,__complete);
			}
			if(_map)
			{
				_map.removePhysical(this);
			}
			if(_smallBall && _smallBall.parent)
				_smallBall.parent.removeChild(_smallBall);
			if(parent)
			{
				parent.removeChild(this);
			}
			_owner=null;
			_emitters=null;
			_blastMC=null;
			_info=null;
			_smallBall = null;
			_game = null;
			super.dispose();
		}
	}
}