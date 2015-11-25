package ddt.register.view
{
	import choicefigure.view.*;
	
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.utils.Dictionary;
	
	public class RegisterSoundManager
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
		
		private static var _instance:RegisterSoundManager;
		
		public static var SITE_MAIN:String = "";
		
		public static function get instance():RegisterSoundManager
		{
			if(_instance == null)
			{
				_instance = new RegisterSoundManager();
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
		
		public function RegisterSoundManager()
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
			init();
		}
		
		
		public function setConfig(allowMusic:Boolean,allowSound:Boolean,musicVolumn:Number,soundVolumn:Number):void
		{
			this.allowMusic = allowMusic;
			this.allowSound = allowSound;
			this._musicVolume = musicVolumn;
			this.soundVolumn = soundVolumn;
			_ns.soundTransform = new SoundTransform(musicVolumn / 100);
		}
		
		private function init():void
		{  
			_dic["001"] = choicefigure.view.Sound001;
			_dic["002"] = Sound002;
			_dic["003"] = choicefigure.view.Sound003;
			_dic["004"] = Sound004;
			_dic["005"] = Sound005;
		}
		
		public function checkHasSound(sound:String):Boolean
		{
			if(_dic[sound] != null)
			{
				return true;
			}
			return false;
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
					_ns.play(SITE_MAIN + _currentMusic+".flv");
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
		
		public function randRange(min:Number, max:Number):Number
	    {
	        return Math.random() * (max - min) + min;
	    }
	    
		public function onMetaData(info:Object):void {}
	}
}