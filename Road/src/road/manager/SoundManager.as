package road.manager
{
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Dictionary;
	
	import road.loader.*;
	import road.utils.ClassUtils;
	import road.math.randRange;
	
	public class SoundManager
	{
		private static const MusicFailedTryTime:int = 3;
		
		private var currentMusicTry:int = 0;
		
		private var _dic:Dictionary;
		private var _music:Array;
		
		private var _allowSound:Boolean;
		private var _currentSound:Dictionary;

		private var _allowMusic:Boolean;
		private var _currentMusic:String;
		private var _musicLoop:Boolean;
		private var _isMusicPlaying:Boolean;
		private var _musicPlayList:Array;
		private var _musicVolume:Number;
		private var soundVolumn:Number;
		
		
		private var _nc:NetConnection;
		private var _ns:NetStream;
		
		private static var _instance:SoundManager;
		
		public static var SITE_MAIN:String = "";
		
		public static function get instance():SoundManager
		{
			if(_instance == null)
			{
				_instance = new SoundManager();
			}
			return _instance;
		}
		
		public function get allowSound():Boolean
		{
			return _allowSound;
		}
		
		public function set allowSound(value:Boolean):void
		{
			if(_allowSound == value) return;
			_allowSound = value;
			if(!_allowSound)
				stopAllSound();
		}
		
		public function get allowMusic():Boolean
		{
			return _allowMusic;
		}
		
		public function set allowMusic(value:Boolean):void
		{
			if(_allowMusic == value) return;
			_allowMusic = value;
			if(_allowMusic)
				resumeMusic();
			else
				pauseMusic();
		}
		
		public function SoundManager()
		{
			_dic = new Dictionary();
			
			_currentSound = new Dictionary(true);
			_isMusicPlaying= false;
			_musicLoop = false;
			_allowMusic = true;
			_allowSound = true;
			_nc = new NetConnection();
			_nc.connect(null);
			_ns = new NetStream(_nc);
			_ns.bufferTime = 0.3;
			_ns.client = this;
			_ns.addEventListener(NetStatusEvent.NET_STATUS,__netStatus);
			_musicPlayList = [];
		}
		
		public function setup(music:Array,siteMain:String):void
		{
			_music = music ? music : [];
			SITE_MAIN = siteMain;
			var loader:ModuleLoader =  LoaderManager.Instance.createLoader("audio.swf",BaseLoader.MODULE_LOADER);
			loader.loadSync(__loadBack);
//			SharedManager.Instance.addEventListener(Event.CHANGE,__configChanged);
//			__configChanged(null);	
		}
		
		
		public function setConfig(allowMusic:Boolean,allowSound:Boolean,musicVolumn:Number,soundVolumn:Number):void
		{
			this.allowMusic = allowMusic;
			this.allowSound = allowSound;
			this._musicVolume = musicVolumn;
			this.soundVolumn = soundVolumn;
			_ns.soundTransform = new SoundTransform(musicVolumn / 100);
		}
		
		private function __loadBack(loader:ModuleLoader):void
		{
			if(loader.isSuccess)
			{
				init();
			}
		}
		
		private function init():void
		{
			_dic["001"] = ClassUtils.hasDefinition("Sound001");
//			_dic["002"] = Sound002;
			_dic["003"] = ClassUtils.hasDefinition("Sound003");
//			_dic["004"] = Sound004;
//			_dic["005"] = Sound005;
			_dic["006"] = ClassUtils.hasDefinition("Sound006");
			_dic["007"] = ClassUtils.hasDefinition("Sound007");
			_dic["008"] = ClassUtils.hasDefinition("Sound008");
			_dic["009"] = ClassUtils.hasDefinition("Sound009");
			_dic["010"] = ClassUtils.hasDefinition("Sound010");
//			_dic["011"] = Sound011;
			_dic["012"] = ClassUtils.hasDefinition("Sound012");
			_dic["013"] = ClassUtils.hasDefinition("Sound013");
			_dic["014"] = ClassUtils.hasDefinition("Sound014");
			_dic["015"] = ClassUtils.hasDefinition("Sound015");
			_dic["016"] = ClassUtils.hasDefinition("Sound016");
			_dic["017"] = ClassUtils.hasDefinition("Sound017");
			_dic["018"] = ClassUtils.hasDefinition("Sound018");
			_dic["019"] = ClassUtils.hasDefinition("Sound019");
			_dic["020"] = ClassUtils.hasDefinition("Sound020");
			_dic["021"] = ClassUtils.hasDefinition("Sound021");
//			_dic["022"] = Sound022;
			_dic["023"] = ClassUtils.hasDefinition("Sound023");
//			_dic["024"] = Sound024;
			_dic["025"] = ClassUtils.hasDefinition("Sound025");
//			_dic["026"] = Sound026;
			_dic["027"] = ClassUtils.hasDefinition("Sound027");
//			_dic["028"] = Sound028;
			_dic["029"] = ClassUtils.hasDefinition("Sound029");
//			_dic["030"] = Sound030;
			_dic["031"] = ClassUtils.hasDefinition("Sound031");
//			_dic["032"] = Sound032;
			_dic["033"] = ClassUtils.hasDefinition("Sound033");
//			_dic["034"] = Sound034;
			_dic["035"] = ClassUtils.hasDefinition("Sound035");
//			_dic["036"] = Sound036;
//			_dic["037"] = Sound037;
			_dic["038"] = ClassUtils.hasDefinition("Sound038");
			_dic["039"] = ClassUtils.hasDefinition("Sound039");
			_dic["040"] = ClassUtils.hasDefinition("Sound040");
			_dic["041"] = ClassUtils.hasDefinition("Sound041");
			_dic["042"] = ClassUtils.hasDefinition("Sound042");
			_dic["043"] = ClassUtils.hasDefinition("Sound043");
			_dic["044"] = ClassUtils.hasDefinition("Sound044");
			_dic["045"] = ClassUtils.hasDefinition("Sound045");
//			_dic["046"] = Sound046;
			_dic["047"] = ClassUtils.hasDefinition("Sound047");
			_dic["048"] = ClassUtils.hasDefinition("Sound048");
			_dic["049"] = ClassUtils.hasDefinition("Sound049");
			_dic["050"] = ClassUtils.hasDefinition("Sound050");
//			_dic["051"] = Sound051;
//			_dic["052"] = Sound052;
//			_dic["053"] = Sound053;
//			_dic["054"] = Sound054;
//			_dic["055"] = Sound055;
//			_dic["056"] = Sound056;
//			_dic["057"] = Sound057;
//			_dic["058"] = Sound058;
//			_dic["059"] = Sound059;
//			_dic["060"] = Sound060;
//			_dic["061"] = Sound061;
//			_dic["062"] = Sound062;
			_dic["057"] = ClassUtils.hasDefinition("Sound057");
			_dic["058"] = ClassUtils.hasDefinition("Sound058");

			_dic["063"] = ClassUtils.hasDefinition("Sound063");
			_dic["064"] = ClassUtils.hasDefinition("Sound064");
//			_dic["065"] = Sound065;
			_dic["067"] = ClassUtils.hasDefinition("Sound067");
			
			_dic["069"] = ClassUtils.hasDefinition("Sound069");
//			_dic["070"] = Sound070;
			_dic["071"] = ClassUtils.hasDefinition("Sound071");
			_dic["073"] = ClassUtils.hasDefinition("Sound073");
			_dic["075"] = ClassUtils.hasDefinition("Sound075");
			_dic["078"] = ClassUtils.hasDefinition("Sound078");
			_dic["079"] = ClassUtils.hasDefinition("Sound079");
//			_dic["080"] = Sound080;
			_dic["081"] = ClassUtils.hasDefinition("Sound081");
//			_dic["082"] = Sound082;
			_dic["083"] = ClassUtils.hasDefinition("Sound083");
//			_dic["084"] = Sound084;

			_dic["087"] = ClassUtils.hasDefinition("Sound087");
			_dic["088"] = ClassUtils.hasDefinition("Sound088");
			_dic["089"] = ClassUtils.hasDefinition("Sound089");
			_dic["090"] = ClassUtils.hasDefinition("Sound090");
			_dic["091"] = ClassUtils.hasDefinition("Sound091");
			_dic["092"] = ClassUtils.hasDefinition("Sound092");
			_dic["093"] = ClassUtils.hasDefinition("Sound093");
			_dic["094"] = ClassUtils.hasDefinition("Sound094");
			_dic["095"] = ClassUtils.hasDefinition("Sound095");
			_dic["096"] = ClassUtils.hasDefinition("Sound096");
			_dic["097"] = ClassUtils.hasDefinition("Sound097");
			
			
			_dic["098"] = ClassUtils.hasDefinition("Sound098");
			_dic["099"] = ClassUtils.hasDefinition("Sound099");
			_dic["100"] = ClassUtils.hasDefinition("Sound100");
			_dic["101"] = ClassUtils.hasDefinition("Sound101");
			_dic["102"] = ClassUtils.hasDefinition("Sound102");
			_dic["103"] = ClassUtils.hasDefinition("Sound103");
			_dic["104"] = ClassUtils.hasDefinition("Sound104");
			_dic["105"] = ClassUtils.hasDefinition("Sound105");
			_dic["106"] = ClassUtils.hasDefinition("Sound106");
			_dic["107"] = ClassUtils.hasDefinition("Sound107");
			_dic["108"] = ClassUtils.hasDefinition("Sound108");
			_dic["109"] = ClassUtils.hasDefinition("Sound109");
			_dic["110"] = ClassUtils.hasDefinition("Sound110");
			_dic["111"] = ClassUtils.hasDefinition("Sound111");
			_dic["112"] = ClassUtils.hasDefinition("Sound112");
			_dic["113"] = ClassUtils.hasDefinition("Sound113");
			_dic["114"] = ClassUtils.hasDefinition("Sound114");
			_dic["115"] = ClassUtils.hasDefinition("Sound115");
			_dic["116"] = ClassUtils.hasDefinition("Sound116");
			_dic["117"] = ClassUtils.hasDefinition("Sound117");
			_dic["118"] = ClassUtils.hasDefinition("Sound118");
			_dic["119"] = ClassUtils.hasDefinition("Sound119");
			_dic["120"] = ClassUtils.hasDefinition("Sound120");
			_dic["121"] = ClassUtils.hasDefinition("Sound121");
			_dic["1001"]= ClassUtils.hasDefinition("Sound1001");
		}
		
		public function checkHasSound(sound:String):Boolean
		{
			if(_dic[sound] != null)
			{
				return true;
			}
			return false;
		}
		
		
		public function initSound(sound:String):void
		{
			if(checkHasSound(sound)) return;
			_dic[sound] = ClassUtils.hasDefinition("Sound"+sound);
		}
		
		
		/**
		 * 播放音效
		 */		
		public function play(id:String,allowMulti:Boolean = false,replaceSame:Boolean = true,loop:Number = 0):void
		{
			if(_dic[id] == null) return;
			if(_allowSound)
			{
				try
				{
					if( allowMulti ||  replaceSame ||!isPlaying(id))
					{
						playSoundImp(id,loop);
					}
				}
				catch(e:Error){}
			}
		}
		
		private function playSoundImp(id:String,loop:Number):void
		{
			var ss:Sound = new _dic[id]();
			var sc:SoundChannel = ss.play(0,loop,new SoundTransform(soundVolumn / 100));
			
			sc.addEventListener(Event.SOUND_COMPLETE,__soundComplete);
			_currentSound[id] = sc;
		}
		
		private function __soundComplete(evt:Event):void
		{
			var c:SoundChannel = evt.currentTarget as SoundChannel;
			c.removeEventListener(Event.SOUND_COMPLETE,__soundComplete);
			c.stop();
			for(var i:String in _currentSound)
			{
				if(_currentSound[i] == c)
				{
					_currentSound[i] = null;
					return;
				}
			}
		}
		
		/**
		 * 停止播放音效
		 */		
		public function stop(s:String):void
		{
			if(_currentSound[s])
			{
				_currentSound[s].stop();
				_currentSound[s] = null;
			}
		}
			
		/**
		 * 
		 *停止播放所有音效 
		 */		
		public function stopAllSound():void
		{
			for each(var sound:SoundChannel in _currentSound)
			{
				if(sound)
				{
					sound.stop();
				}
			}
			_currentSound = new Dictionary();
		}

		/**
		 * 音效是否正在播放
		 */		
		public function isPlaying(s:String):Boolean
		{
			return _currentSound[s] == null ? false : true;
		}
		
		public function playMusic(id:String,loops:Boolean = true,replaceSame:Boolean = false):void
		{
			currentMusicTry = 0;
			if(replaceSame || _currentMusic != id)
			{
				if(_isMusicPlaying)
					stopMusic();
				playMusicImp([id],loops);
			}
		}
		
		private function playMusicImp(list:Array,loops:Boolean):void
		{
			_musicLoop = loops;
			_musicPlayList = list;
			if(list.length > 0)
			{
				
				_currentMusic = list[0];
				_isMusicPlaying = true;
				_ns.play(SITE_MAIN + "sound/" + _currentMusic+".flv");
				_ns.soundTransform = new SoundTransform(_musicVolume / 100);
				if(!_allowMusic)
				{
					_ns.removeEventListener(NetStatusEvent.NET_STATUS,__onMusicStaus);
					pauseMusic();
				}else
				{
					_ns.addEventListener(NetStatusEvent.NET_STATUS,__onMusicStaus);
				}
			}
		}
		
		private function __onMusicStaus(e:NetStatusEvent):void
		{
			if(e.info.code == "NetConnection.Connect.Failed" || e.info.code == "NetStream.Play.StreamNotFound")
			{
				if(currentMusicTry < MusicFailedTryTime)
				{
					currentMusicTry++;
					_ns.play(SITE_MAIN + "sound/" + _currentMusic+".flv");
				}else
				{
					_ns.removeEventListener(NetStatusEvent.NET_STATUS,__onMusicStaus);
				}
			}else if (e.info.code == "NetStream.Play.Start")
			{
				_ns.removeEventListener(NetStatusEvent.NET_STATUS,__onMusicStaus);
			}
		}
		
		
		public function pauseMusic():void
		{
			if(_isMusicPlaying)
			{
				_ns.pause();
				_isMusicPlaying = false;
			}
		}
		
		public function resumeMusic():void
		{
			if(_allowMusic && _currentMusic)
			{
				_ns.resume();
				_isMusicPlaying = true;
			}
		}
		
		public function stopMusic():void
		{
			if(_currentMusic)
			{
				_isMusicPlaying = false;
				_ns.close();
				_currentMusic = null;
			}
		}

		public function playGameBackMusic(id:String):void
		{
			playMusicImp([id,id],false);
		}
		
		
		private function __netStatus(event:NetStatusEvent):void
		{
			if(event.info.code == "NetStream.Play.Stop")
			{
				if(_musicLoop)
				{
					playMusicImp(_musicPlayList,true);
				}
				else 
				{
//					_musicPlayList.shift();循环播放，不进行两遍后随机
					if(_musicPlayList.length > 0)
					{
						playMusicImp(_musicPlayList,false);
					}
					else
					{
						var index:int = randRange(0,_music.length -1);
						playMusicImp([_music[index]],false);
					}
				}
			}
		}
		
		public function onMetaData(info:Object):void {}
		
	}
}