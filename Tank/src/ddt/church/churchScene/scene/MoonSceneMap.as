package ddt.church.churchScene.scene
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import road.data.DictionaryData;
	import road.manager.SoundManager;
	import road.utils.ClassUtils;
	
	import tank.church.FireMaskOfMoonScene;
	import ddt.events.ChurchRoomEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;

	public class MoonSceneMap extends SceneMap
	{
		/**
		 *礼炮容器
		 */		
		private var saluteContainer:Sprite;
		/**
		 *礼炮遮罩 
		 */		
		private var saluteMask:MovieClip;
		
		/**
		 *当前是否正在放礼炮 
		 */		
		private var _isSaluteFiring:Boolean;
		private function get isSaluteFiring():Boolean
		{
			return _isSaluteFiring;
		}
		private function set isSaluteFiring(value:Boolean):void
		{
			if(_isSaluteFiring == value)return;
			
			_isSaluteFiring = value;
			if(_isSaluteFiring)
			{
				playSaluteSound();
			}else
			{
				stopSaluteSound();
			}
		}
		
		/**
		 *礼炮队列 
		 */		
		private var saluteQueue:Array;
		/**
		 * 礼炮声音timer 
		 */		
		private var timer:Timer;
		
		public function MoonSceneMap(scene:Scene, data:DictionaryData, bg:Sprite, mesh:Sprite, acticle:Sprite=null, sky:Sprite=null)
		{
			super(scene, data, bg, mesh, acticle, sky);
			
			SoundManager.Instance.playMusic("3003");
			
			initSaulte();
		}

		override public function setCenter(event:ChurchRoomEvent =null):void
		{
			var xf : Number = -(reference.x - 1000 / 2);
			var yf : Number = -(reference.y - 600 / 2)+230;
			
			if(xf > 0)xf = 0;
			if(xf < 1000 - scene.info.mapW)
				xf = 1000 - scene.info.mapW;
			if(yf > 0)yf = 0;
			if(yf < 600 - scene.info.mapH)
				yf = 600 - scene.info.mapH;
					
			x = xf;
			y = yf;
		}
		
		private function initSaulte():void
		{
			var index:int = this.getChildIndex(articleLayer);
			
			saluteContainer = new Sprite();
			addChildAt(saluteContainer,index);
			saluteMask = new FireMaskOfMoonScene();
			addChild(saluteMask);
			saluteContainer.mask = saluteMask;
			
			saluteQueue = [];
		}
		
		override public function  setSalute(id:int):void
		{
			if(isSaluteFiring && id == PlayerManager.Instance.Self.ID)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.scene.MoonSceneMap.lipao"));
				//MessageTipManager.getInstance().show("礼炮正在燃放中,请稍候.");
				return;
			}			
			if(id == PlayerManager.Instance.Self.ID)
			{
				if(PlayerManager.Instance.Self.bagLocked)
				{
					new BagLockedGetFrame().show();
					return;
				}
				SocketManager.Instance.out.sendGunSalute(id,22001);
			}
			
			
			var SaluteClass:Class = ClassUtils.getDefinition("ddt.church.fireAcect.Salute") as Class;
			var saluteFire:MovieClip = new SaluteClass();
			saluteFire.x = 700;
			saluteFire.y = 300;
		
			if(isSaluteFiring)
			{
				saluteQueue.push(saluteFire);
			}else
			{
				isSaluteFiring = true;
				saluteFire.addEventListener(Event.ENTER_FRAME,saluteFireFrameHandler);
				saluteFire.gotoAndPlay(1);
				saluteContainer.addChild(saluteFire);
			}
		}
		
		private function saluteFireFrameHandler(e:Event):void
		{
			var movie:MovieClip = e.currentTarget as MovieClip;
			if(movie.currentFrame == movie.totalFrames)
			{
				isSaluteFiring = false;
				clearnSaluteFire();
				var nextMovie:MovieClip = saluteQueue.shift();
				if(nextMovie)
				{
					isSaluteFiring = true;
					nextMovie.addEventListener(Event.ENTER_FRAME,saluteFireFrameHandler);
					nextMovie.gotoAndPlay(1);
					saluteContainer.addChild(nextMovie);
				}
			}
			
		}
		
		private function clearnSaluteFire():void
		{
			while(saluteContainer.numChildren > 0)
			{
				saluteContainer.getChildAt(0).removeEventListener(Event.ENTER_FRAME,saluteFireFrameHandler);
				saluteContainer.removeChildAt(0);
			}
		}
		
		private function playSaluteSound():void
		{
			timer = new Timer(100);
			timer.addEventListener(TimerEvent.TIMER,__timer);
			timer.start();
		}
		
		private function __timer(event:TimerEvent):void
		{
			var random:uint;
			var playSound:Boolean;
			
			random = Math.round(Math.random()*15);
			if(random<6)
			{
				playSound = !(Math.round(Math.random()*9)%3)?true:false;
				if(playSound)
				{
					SoundManager.Instance.play("118");
				}
			}
		}
		
		private function stopSaluteSound():void
		{
			if(timer)
			{
				timer.removeEventListener(TimerEvent.TIMER,__timer);
				timer = null;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			clearnSaluteFire();
			
			stopSaluteSound();
		}
	}
}