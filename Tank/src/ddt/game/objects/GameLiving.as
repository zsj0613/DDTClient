package ddt.game.objects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	
	import game.asset.bijouGlow.GemDefenseAsset;
	import game.crazyTank.view.FrostEffectAsset;
	
	import phy.object.PhysicalObj;
	
	import road.data.DictionaryEvent;
	import road.display.MovieClipWrapper;
	import road.utils.ClassUtils;
	
	import ddt.actions.BaseAction;
	import ddt.data.game.EffectIconContainer;
	import ddt.data.game.Living;
	import ddt.data.game.Player;
	import ddt.data.game.mirarieffecticon.BaseMirariEffectIcon;
	import ddt.data.game.mirarieffecticon.MirariEffectIconManager;
	import ddt.data.game.mirarieffecticon.NoHoleEffectIcon;
	import ddt.events.ActionEvent;
	import ddt.events.LivingEvent;
	import ddt.game.ActionMovie;
	import ddt.game.LeftPlayerCartoonView;
	import ddt.game.actions.LivingFallingAction;
	import ddt.game.actions.LivingJumpAction;
	import ddt.game.actions.LivingMoveAction;
	import ddt.game.animations.ShockMapAnimation;
	import tank.game.effects.AttackEffect1;
	import tank.game.effects.AttackEffect2;
	import ddt.game.map.MapView;
	import ddt.game.player.NickNameView;
	import ddt.game.player.SmallBloodView;
	import ddt.game.smallmap.SmallMapPlayer;
	import ddt.manager.GameManager;
	import ddt.view.ShootPercentView;
	import ddt.view.ShowEffect;
	import ddt.view.common.ChatBallBase;
	import ddt.view.common.ChatBallView;
	import tank.game.objects.*;
	
	public class GameLiving extends PhysicalObj
	{
		
		protected static var SHOCK_EVENT:String = "shockEvent";
		protected static var SHOCK_EVENT2:String = "shockEvent2";
		protected static var SHIELD:String = "shield";
		protected static var BOMB_EVENT:String = "bombEvent";
		protected static var SHOOT_PREPARED:String = "shootPrepared";
		
		protected static var RENEW:String = "renew";
		
		public static const stepX:int = 3;
		public static const stepY:int = 7;
		public static const npcStepX:int = 1;
		public static const npcStepY:int = 3;
		
		
		protected var _info:Living;
		
		protected var _actionMovie:ActionMovie;
		
		protected var _smallBlood:SmallBloodView;
		
		protected var _chatballview:ChatBallBase;
		
		private var _smallView:SmallMapPlayer;
		
		/**
		 * 昵称 
		 */		
		protected var _nickName:NickNameView;
		
		protected var _targetBlood:int;
		protected var targetAttackEffect:int;
		
		protected var _originalHeight:Number;
		protected var _originalWidth:Number;
		
		public var bodyWidth:Number;
		public var bodyHeight:Number;
		public var isExist:Boolean = true;
		
		protected var _turns:int;
		
		// 宝珠效果容器
		private var _effectIconContainer:EffectIconContainer;
		public function get EffectIcon():EffectIconContainer
		{
			return _effectIconContainer;
		}
		
		public function GameLiving(info:Living)
		{
			_info = info;
			initView();
			initListener();
			super(info.LivingID);
		}
		
		public function get info():Living
		{
			return _info;
		}
		
		public function get map():MapView
		{
			return _map as MapView;
		}
		
		protected function initView():void
		{
			_smallBlood = new SmallBloodView(info.maxBlood,info.team);
			_smallBlood.init(info);
			_smallBlood.x = 0;
			_smallBlood.y = 20;
			addChild(_smallBlood);
			_nickName = new NickNameView(info);
			_nickName.x =  - _nickName.width/2 + 2
			_nickName.y = _smallBlood.y + _smallBlood.height / 2 + 16;
			
			addChild(_nickName);
			initSmallMapObject();
			_effectIconContainer = new EffectIconContainer();
			addChild(_effectIconContainer);
			
			mouseChildren = mouseEnabled = false;
		}
		protected function initSmallMapObject():void{
			_smallView = new SmallMapPlayer(info);
		}
		protected function initEffectIcon():void{
			
		}
		//TODO
		protected function initFreezonRect():void
		{
			_effRect = new Rectangle(0,24,200,200);
		}
		
		protected function initListener():void
		{
			_info.addEventListener(LivingEvent.ANGLE_CHANGED,__angleChanged);
			_info.addEventListener(LivingEvent.BEAT,__beat);
			_info.addEventListener(LivingEvent.BEGIN_NEW_TURN,__beginNewTurn);
			_info.addEventListener(LivingEvent.BLOOD_CHANGED,__bloodChanged);
			_info.addEventListener(LivingEvent.DIE,__die);
			_info.addEventListener(LivingEvent.DIR_CHANGED,__dirChanged);
			_info.addEventListener(LivingEvent.FALL,__fall);
			_info.addEventListener(LivingEvent.FORZEN_CHANGED,__forzenChanged);
			_info.addEventListener(LivingEvent.HIDDEN_CHANGED,__hiddenChanged);
			_info.addEventListener(LivingEvent.PLAY_MOVIE,__playMovie);
			_info.addEventListener(LivingEvent.JUMP,__jump);
			_info.addEventListener(LivingEvent.MOVE_TO,__moveTo);
			_info.addEventListener(LivingEvent.NOHOLE_CHANGED,__noholeChanged);
			_info.addEventListener(LivingEvent.LOCK_STATE,__lockStateChanged);
			_info.addEventListener(LivingEvent.POS_CHANGED,__posChanged);
			_info.addEventListener(LivingEvent.SHOOT,__shoot);
			_info.addEventListener(LivingEvent.TRANSMIT,__transmit);
			_info.addEventListener(LivingEvent.SAY,__say);
			_info.addEventListener(LivingEvent.START_MOVING,__startMoving);
			_info.addEventListener(LivingEvent.CHANGE_STATE,__changeState);
			_info.addEventListener(LivingEvent.SHOW_ATTACK_EFFECT,__showAttackEffect);
			
			
			_info.addEventListener(LivingEvent.GEM_DEFENSE_CHANGED, __gemDefenseChanged);
			
			_info.MirariEffects.addEventListener(DictionaryEvent.ADD, __addEffectHandler);
			_info.MirariEffects.addEventListener(DictionaryEvent.REMOVE, __removeEffectHandler);
			_info.MirariEffects.addEventListener(DictionaryEvent.CLEAR, __clearEffectHandler);
			
			_effectIconContainer.addEventListener(Event.CHANGE, __sizeChangeHandler);
			
			if(_actionMovie) 
			{
				_actionMovie.addEventListener("renew",__renew);
				_actionMovie.addEventListener(SHOCK_EVENT2,__shockMap2);
				_actionMovie.addEventListener(SHOCK_EVENT,__shockMap);
				_actionMovie.addEventListener(SHIELD,__showDefence);
				_actionMovie.addEventListener(BOMB_EVENT,__startBlank);
			}
		}
		
		protected function removeListener():void
		{
			_info.removeEventListener(LivingEvent.ANGLE_CHANGED,__angleChanged);
			_info.removeEventListener(LivingEvent.BEAT,__beat);
			_info.removeEventListener(LivingEvent.BEGIN_NEW_TURN,__beginNewTurn);
			_info.removeEventListener(LivingEvent.BLOOD_CHANGED,__bloodChanged);
			_info.removeEventListener(LivingEvent.DIE,__die);
			_info.removeEventListener(LivingEvent.DIR_CHANGED,__dirChanged);
			_info.removeEventListener(LivingEvent.FALL,__fall);
			_info.removeEventListener(LivingEvent.FORZEN_CHANGED,__forzenChanged);
			_info.removeEventListener(LivingEvent.HIDDEN_CHANGED,__hiddenChanged);
			_info.removeEventListener(LivingEvent.PLAY_MOVIE,__playMovie);
			_info.removeEventListener(LivingEvent.JUMP,__jump);
			_info.removeEventListener(LivingEvent.MOVE_TO,__moveTo);
			_info.removeEventListener(LivingEvent.NOHOLE_CHANGED,__noholeChanged);
			_info.removeEventListener(LivingEvent.LOCK_STATE,__lockStateChanged);
			_info.removeEventListener(LivingEvent.POS_CHANGED,__posChanged);
			_info.removeEventListener(LivingEvent.SHOOT,__shoot);
			_info.removeEventListener(LivingEvent.TRANSMIT,__transmit);
			_info.removeEventListener(LivingEvent.SAY,__say);
			_info.removeEventListener(LivingEvent.START_MOVING,__startMoving);
			_info.removeEventListener(LivingEvent.CHANGE_STATE,__changeState);
			_info.removeEventListener(LivingEvent.SHOW_ATTACK_EFFECT,__showAttackEffect);
			
			_info.removeEventListener(LivingEvent.GEM_DEFENSE_CHANGED, __gemDefenseChanged);
			
			if(_info.MirariEffects)
			{
				_info.MirariEffects.removeEventListener(DictionaryEvent.ADD, __addEffectHandler);
				_info.MirariEffects.removeEventListener(DictionaryEvent.REMOVE, __removeEffectHandler);
				_info.MirariEffects.removeEventListener(DictionaryEvent.CLEAR, __clearEffectHandler);
			}
			if(_effectIconContainer)
				_effectIconContainer.removeEventListener(Event.CHANGE, __sizeChangeHandler);
				
			if(_actionMovie) 
			{
				_actionMovie.removeEventListener("renew",__renew);
				_actionMovie.removeEventListener(SHOCK_EVENT2,__shockMap2);
				_actionMovie.removeEventListener(SHOCK_EVENT,__shockMap);
				_actionMovie.removeEventListener(SHIELD,__showDefence);
				_actionMovie.removeEventListener(BOMB_EVENT,__startBlank);
			}
		}
		
		protected function __shockMap(evt:ActionEvent):void
		{
			map.animateSet.addAnimation(new ShockMapAnimation(this,evt.param,20));
		}
		protected function __shockMap2(evt:Event):void
		{
			map.animateSet.addAnimation(new ShockMapAnimation(this,30,20));
		}
		protected function __renew(evt:Event):void{
			this._info.showAttackEffect(2);
		}
		protected var counter:int = 1;
		protected var ap:Number = 0;
		protected function __startBlank(evt:Event):void
		{
			addEventListener(Event.ENTER_FRAME,drawBlank);
		}
		
		protected function drawBlank(evt:Event):void
		{
			if(counter <= 15)
			{
				graphics.clear();
				ap = (1/225)*(counter*counter);
				graphics.beginFill(0xffffff,ap);
				graphics.drawRect(-3000,-1800,7000,4200);
			}else if(counter <=23)
			{
				graphics.clear();
				ap = 1;
				graphics.beginFill(0xffffff,ap);
				graphics.drawRect(-3000,-1800,7000,4200);
			}else if(counter <= 75)
			{
				graphics.clear();
				ap -= 0.02;
				graphics.beginFill(0xffffff,ap);
				graphics.drawRect(-3000,-1800,7000,4200);
			}else
			{
				graphics.clear();
				removeEventListener(Event.ENTER_FRAME,drawBlank);
			}
			counter++;
//			trace("==========drawBlank alpha is:"+ap);
		}
		
		protected function __showDefence(evt:Event):void
		{
			var show:ShowEffect = new ShowEffect(ShowEffect.GUARD);
			show.x = x + offset();
			show.y = y -50 + offset(25);
			_map.addChild(show);
		}
		
		protected function __addEffectHandler(e:DictionaryEvent):void
		{
			var baseeffect:BaseMirariEffectIcon = e.data as BaseMirariEffectIcon;
			_effectIconContainer.handleEffect(baseeffect.MirariType,baseeffect.getEffectIcon());
			baseeffect.excuteEffect(_info);
		}
		
		protected function __removeEffectHandler(e:DictionaryEvent):void
		{
			var baseeffect:BaseMirariEffectIcon = e.data as BaseMirariEffectIcon;
			_effectIconContainer.removeEffect(baseeffect.MirariType);
			baseeffect.unExcuteEffect(_info);
		}
		
		protected function __clearEffectHandler(e:DictionaryEvent):void
		{
			_effectIconContainer.clearEffectIcon();
		}
		
		protected function __sizeChangeHandler(e:Event):void
		{
			_effectIconContainer.x = 5 - (_effectIconContainer.width/2);
			
			/* 当为玩家时，bodyHeight的值为NaN */
			if(isNaN(bodyHeight))
			{
				_effectIconContainer.y = -55 - _effectIconContainer.height;
			}
			else
			{
				_effectIconContainer.y = (bodyHeight * -1) - _effectIconContainer.height;
			}
		}
		
		protected function __changeState(evt:LivingEvent):void
		{
			
		}
		
		protected function initMovie():void
		{
			var movieClass:Class
			if(ClassUtils.hasDefinition(info.actionMovieName))
			{
				movieClass = ClassUtils.getDefinition(info.actionMovieName) as Class;
			}else
			{
				throw new Error("找不到 info.actionMovieName : " + info.actionMovieName);
			}
			_actionMovie = new ActionMovie(new movieClass());
			_info.actionMovieBitmap = new Bitmap(getBodyBitmapData("show2"));
			_info.thumbnail = new Bitmap(getBodyBitmapData("show"));
			_actionMovie.mouseEnabled = false;
			_actionMovie.mouseChildren = false;
			_actionMovie.scrollRect = null;
			addChild(_actionMovie);
			_actionMovie.scaleX = - _info.direction;
			initChatball();
		}
		protected function initChatball():void{
			_chatballview = new ChatBallView();
			_originalHeight = this.height;
			_originalWidth = this.width;
			addChild(_chatballview);
		}
		
		protected function __startMoving(event:LivingEvent):void
		{
			var pos:Point = _map.findYLineNotEmptyPointDown(x,y,_map.height);
			if(pos == null)
			{
				pos = new Point(x,_map.height +1);
			}
			_info.fallTo(pos,20);
		}
		
		protected function __say(event:LivingEvent):void
		{
			if(_info.isHidden)
			{
				return;
			}
			_chatballview.x = 0;
			_chatballview.y = 0;
			var data:String = event.paras[0] as String// as ChatMsg;
			var type:int = 0;
			if(event.paras[1]){
				type = event.paras[1];
			};
			//var size_x:Number = this.width;
			//_size_y:Number = this.height;
			_chatballview.setText(data,type);
			fitChatBallPos();
		}
		protected function fitChatBallPos():void{
			_chatballview.x =   _originalWidth *0.15 - _chatballview.width;
			_chatballview.y =  - _originalHeight*0.6 - _chatballview.height;
		}
		override public function collidedByObject(obj:PhysicalObj):void
		{
			
		}
		
		protected function __angleChanged(event:LivingEvent):void
		{
			
		}
		
		protected function __beat(event:LivingEvent):void
		{
			trace("__beat=============");
			if(_isLiving)
			{
				var target:Living = event.paras[1];
				var damage:int = event.paras[2];
				var targetBlood:int = event.value;
				targetAttackEffect = event.paras[3];
				_actionMovie.doAction(event.paras[0],updateTargetsBlood,[target,damage,targetBlood]);
			}
		}

		protected function updateTargetsBlood(target:Living,damage:int,targetBlood:int):void
		{
			trace("updateTargetsBlood called");
			if(target == null) return;
			if(target.isLiving)
			{
				target.isHidden = false;
				target.isFrozen = false;
				target.showAttackEffect(targetAttackEffect);
				target.updateBload(targetBlood,3,damage);
			}
		}
		
		protected function __beginNewTurn(event:LivingEvent):void
		{
		}
		
		protected function __playMovie(event:LivingEvent):void
		{
			_actionMovie.doAction(event.paras[0],event.paras[1],event.paras[2]);
		}
		
		
		protected function __bloodChanged(event:LivingEvent):void
		{
			var diff:Number = event.value - event.old;
			var movie:ShootPercentView;
			var index:int;
			var showBlood:int;
			var type:int = event.paras[0];
			switch(type)
			{
				case 0:
				    diff = event.paras[1];
					if(diff != 0 && _info.blood != 0)
					{
						movie = new ShootPercentView(Math.abs(diff),1,true);
						movie.x = x + offset();
						movie.y = y -50 + offset(25);
						movie.scaleX = movie.scaleY = .8 + Math.random()*.4;
						_map.addBlood(movie);
						if(_info.isHidden)
						{
							if(_info.team == GameManager.Instance.Current.selfGamePlayer.team)
							{
								movie.alpha == 0.5;
							}
							else
							{
								visible = false;
								movie.alpha = 0;	
							}
						}
					}
					break;
				case 90:
					movie = new ShootPercentView(0,2);
					movie.x = x + offset();
					movie.y = y -50 + offset(25);
					movie.scaleX = movie.scaleY = .8 + Math.random()*.4;
					_map.addBlood(movie);
					break;
				case 5:
					break;
				case 3://小怪的beat掉血
					showBlood = event.paras[1];
					diff = showBlood;
					if(diff != 0)
					{
						trace("__bloodChanged smallNPC");
						movie = new ShootPercentView(Math.abs(diff),1,false);
						movie.x = x + offset();
						movie.y = y -50 + offset(25);
						movie.scaleX = movie.scaleY = .8 + Math.random()*.4;
						_map.addBlood(movie);
					}
					
//					trace("*********showed:" + diff);
					break;
				case 11://新手小怪伤
				    showBlood = event.paras[1];
					if(showBlood<0)
					{
						diff = showBlood;
					}
					if(diff != 0)
					{
						movie = new ShootPercentView(Math.abs(diff),event.paras[0],false);
						movie.x = x - 70;
						movie.y = y - 80;
						movie.scaleX = movie.scaleY = .8 + Math.random()*.4;
						_map.addBlood(movie);
					}
					break;
				default:
					showBlood = event.paras[1];
					if(showBlood<0)
					{
						diff = showBlood;
					}
					if(diff != 0)
					{
						movie = new ShootPercentView(Math.abs(diff),event.paras[0],false);
						movie.x = x + offset();
						movie.y = y -50 + offset(25);
						movie.scaleX = movie.scaleY = .8 + Math.random()*.4;
						_map.addBlood(movie);
					}
					
					break;
			}
			_smallBlood.updateBlood(info.blood);
		}
		
		private function offset(off : int=30) : int
		{
			var i : int = int(Math.random()*10);
			if(i % 2 == 0)
			{
				return -int(Math.random()*off);
			}
			else
			{
				return int(Math.random()*off);
			}
			
		}		
		protected function __die(event:LivingEvent):void
		{
			if(_isLiving)
			{
				_info.MirariEffects.removeEventListener(DictionaryEvent.ADD, __addEffectHandler);
				_info.MirariEffects.removeEventListener(DictionaryEvent.REMOVE, __removeEffectHandler);
				_info.MirariEffects.removeEventListener(DictionaryEvent.CLEAR, __clearEffectHandler);
				
				_isLiving = false;
				die();
			}
		}
		
		override public function die():void
		{
			info.isFrozen = false;
			info.isNoNole = false;
			info.isHidden = false;
			_smallBlood.visible = false;
			
			if(_effectIconContainer)
			{
				_effectIconContainer.removeEventListener(Event.CHANGE, __sizeChangeHandler);
				_effectIconContainer.dispose();
			}
			if(lock)
			{
				removeChild(lock);
				lock = null;
			}
			_effectIconContainer = null;
		}
		
		protected function __dirChanged(event:LivingEvent):void
		{
		}

		protected var effectForzen:Sprite;
		protected function __forzenChanged(event:LivingEvent):void
		{
			if(_info.isFrozen)
			{
				effectForzen = new FrostEffectAsset();
				
				effectForzen.y = 24;
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
		private var defense : GemDefenseAsset ;
		protected function __gemDefenseChanged(event : LivingEvent) : void
		{
			if(_info.gemDefense)
			{
				if(!defense)defense = new GemDefenseAsset();
				addChild(defense);
			}
			else
			{
				if(defense)
				{
					if(defense.parent)defense.parent.removeChild(defense);
				}
				defense = null;
			}
		}
		protected function __noholeChanged(event:LivingEvent):void
		{
			var baseEffect:BaseMirariEffectIcon = MirariEffectIconManager.getInstance().createEffectIcon(new NoHoleEffectIcon().MirariType);
			
			if(_info.isNoNole)
			{
				_info.handleMirariEffect(baseEffect);
			}
			else
			{
				_info.removeMirariEffect(baseEffect);
			}
		}
		
		protected var lock:LockAsset;
		protected function __lockStateChanged(evt:LivingEvent):void
		{
			if(_info.LockState)
			{
				lock = new LockAsset();
				lock.x = 10;
				lock.y = 5;
				addChild(lock);
				if(evt.paras[0] == 2)
				{
					lock.y += 50;
					lock.scaleX = lock.scaleY = 0.8;
					lock.stop();
					lock.alpha = 0.7;
				}
			}else
			{
				if(lock)
				{
					removeChild(lock);
					lock = null;
				}
			}
		}
		
		//10/6/28。修改适应16色玩家。
		protected function __hiddenChanged(event:LivingEvent):void
		{
			if(_info.isHidden)
			{
				if(_info.team != GameManager.Instance.Current.selfGamePlayer.team)
				{
					visible = false;
					alpha = 0;
				}
				else
				{
					alpha = 0.5;
				}
			}
			else
			{
				alpha = 1;
				visible = true;
				parent.addChild(this);
			}
		}
		
		protected function __posChanged(event:LivingEvent):void
		{
			pos = _info.pos;
			if(_isLiving)
			{
				var angle:Number = calcObjectAngle(16);
				_info.playerAngle = angle;	
			}
			if(map)
			{
				map.smallMap.updatePos(_smallView,pos);
				
			}
		}
		
		
		protected function __jump(event:LivingEvent):void
		{
			doAction(event.paras[2]);
			act(new LivingJumpAction(this,event.paras[0],event.paras[1],event.paras[3]));
		}
		
		protected function __moveTo(event:LivingEvent):void
		{
			doAction(event.paras[4]);
			var speed:int = event.paras[5];
			var pt:Point = event.paras[1] as Point;
			var dir:int = event.paras[2];
			if(x == pt.x && y == pt.y) return;
			var path:Array = [];
			var tx:int = x;
			var ty:int = y;
			var direction:int = pt.x > tx ? 1 :-1;
			while((pt.x - tx) * direction > 0)
			{
				var p:Point = _map.findNextWalkPoint(tx,ty,direction,speed*npcStepX,speed*npcStepY);
				if(p)
				{
					path.push(p);
					tx = p.x;
					ty = p.y;
				}
				else
				{
					break;
				}
			} 
			if(path.length > 0)
			{
				_info.act(new LivingMoveAction(this,path,dir));
			}else
			{
				_info.doDefaultAction();
			}
		}
		
		public function canMoveDirection(dir:Number):Boolean
		{
			return !map.IsOutMap(x + (15 + Player.MOVE_SPEED) * dir,y);
		}
		
		public function canStand(x:int,y:int):Boolean
		{
			return !map.IsEmpty(x-1,y) || !map.IsEmpty(x+1,y);
		}
		
		public function getNextWalkPoint(dir:int):Point
		{
			if(canMoveDirection(dir))
			{
				return _map.findNextWalkPoint(x,y,dir,stepX,stepY);
			}
			return null;
		}
		
		public function needFocus():void{
			map.livingSetCenter(_info.pos.x,_info.pos.y - 150,true);
		}
		
		protected function __shoot(event:LivingEvent):void
		{
			
		}
		
		protected function __transmit(event:LivingEvent):void
		{
			info.pos = event.paras[0];
		}
		
		protected function __fall(event:LivingEvent):void
		{
			_info.act(new LivingFallingAction(this,event.paras[0],event.paras[1],event.paras[3]));
		}
		
		public function get actionMovie():ActionMovie
		{
			return _actionMovie;
		}
		public function get movie():Sprite{
			return _actionMovie;
		}
		
		public function doAction(actionType:*):void
		{
			if(_actionMovie != null)
			{
				_actionMovie.doAction(actionType);
			}
		}
		
		public function act(action:BaseAction):void
		{
			_info.act(action);
		}
		
		public function traceCurrentAction():void
		{
			_info.traceCurrentAction();
		}
		
		protected var _isDie : Boolean = false;//是否死亡
		final override public function update(dt:Number):void
		{
			if(_isDie)return;
			super.update(dt);
			_info.update();
		}
		
		public function getBodyBitmapData(action:String = ""):BitmapData
		{
			var movieClass:Class;
			if(ClassUtils.hasDefinition(info.actionMovieName))
			{
				movieClass = ClassUtils.getDefinition(info.actionMovieName) as Class;
			}else
			{
				return null;
			}
			var container:Sprite = new Sprite();
			var source:MovieClip = new movieClass() as MovieClip;
			var transform : SoundTransform = new SoundTransform();
			transform.volume = 0;
			source.soundTransform = transform;
			bodyWidth = source.width;
			bodyHeight = source.height;
			source.gotoAndStop(action);
			if(LeftPlayerCartoonView.SHOW_BITMAP_WIDTH < source.width)
			{
				source.width = LeftPlayerCartoonView.SHOW_BITMAP_WIDTH;
				source.scaleY = source.scaleX;
			}
			container.addChild(source);
			var clipRect:Rectangle = source.getBounds(source);
			source.x = -clipRect.x * source.scaleX;
			source.y = -clipRect.y * source.scaleX;
			var bitmapdata:BitmapData = new BitmapData(container.width,container.height,true,0);
			bitmapdata.draw(container);
			return bitmapdata;
		}
		
		protected function deleteSmallView() : void
		{
			if(_smallBlood)
			{
				_smallBlood.visible = false;
				_smallBlood.dispose();
			}
			_smallBlood = null;
			if(_nickName){
				_nickName.visible = false;
			}
			if(_smallView)
			{
				_smallView.dispose();
				_smallView.visible = false;
			}
			_smallView = null;
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeListener();
			if(_effectIconContainer)
			{
				_effectIconContainer.dispose();
			}
			_effectIconContainer = null;
			_info = null;
			deleteSmallView();
			
			if(_nickName)
			{
				if(_nickName.parent)_nickName.parent.removeChild(_nickName);
			}
			_nickName = null;
			if(_actionMovie)
			{
				_actionMovie.dispose();
				_actionMovie = null;
			}
			if(_map)
			{
				_map.removePhysical(this);
			}
			
			if(parent)
			{
				parent.removeChild(this);
			}
			isExist = false;
		}
		protected var _effRect:Rectangle;
		public function get EffectRect():Rectangle
		{
			return _effRect;
		}
		
		override public function get smallView():Sprite
		{
			return _smallView;
		}
		/**	Attack Effect 
		 *	move to here from GamePlayer 
		 *	Welly @ 6/3/10 */
		private var _attackEffectPlayer:PhysicalObj;
		private var _attackEffectPlaying:Boolean=false;
		protected var _attackEffectPos:Point = new Point(0,5)
		
		protected function __showAttackEffect(event:LivingEvent):void
		{
			if (_attackEffectPlaying)
				return;
			if (_info == null)
				return;
			_attackEffectPlaying=true;
			var effectID:int=event.paras[0];
			var effect:MovieClip=getAttackEffectAssetByID(effectID);
			effect.scaleX=-1 * _info.direction;
			var warpper:MovieClipWrapper=new MovieClipWrapper(effect, true, true);
			warpper.addEventListener(Event.COMPLETE, __playComplete);
			_attackEffectPlayer=new PhysicalObj(-1);
			_attackEffectPlayer.addChild(warpper);
			var pos:Point=_map.globalToLocal(movie.localToGlobal(_attackEffectPos));
			_attackEffectPlayer.x=pos.x;
			_attackEffectPlayer.y=pos.y;
			_map.addPhysical(_attackEffectPlayer);
		}
		
		private function __playComplete(event:Event):void
		{
			if (event.currentTarget)
				event.currentTarget.removeEventListener(Event.COMPLETE, __playComplete);
			if (_map)
				_map.removePhysical(_attackEffectPlayer);
			if (_attackEffectPlayer && _attackEffectPlayer.parent)
				_attackEffectPlayer.parent.removeChild(_attackEffectPlayer);
			_attackEffectPlaying=false;
			_attackEffectPlayer=null;
		}
		
		public static function getAttackEffectAssetByID(id:int):MovieClip
		{
			var mcClass:Class=ATTACK_EFFECTS[id - 1];
			var mc:MovieClip=new mcClass();
			return mc;
		}
		
		
		private static var ATTACK_EFFECTS:Array=[AttackEffect1, AttackEffect2];
	}
}