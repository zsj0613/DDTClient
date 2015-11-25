package ddt.manager
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import road.comm.PackageIn;
	import road.ui.manager.TipManager;
	
	import ddt.events.CrazyTankSocketEvent;
	import ddt.states.StateType;
	import ddt.view.enthrall.EnthrallCheckFrame;
	import ddt.view.enthrall.EnthrallView;
	
	public class EnthrallManager extends Sprite
	{
		private static var _instance:EnthrallManager; //用于单件模式
		
		private var _view:EnthrallView;
		
        private var _timer : Timer;
        private var _timer1: Timer;
        
        private var _loadedTime:int = 0;//本次登录游戏时间
        
        private var _showEnthrallLight:Boolean = false;
        private var _popCIDChecker:Boolean = false;
        
        private var _enthrallSwicth:Boolean;
        private var _hasApproved:Boolean;
        private var _isMinor:Boolean;
        
        private var _enthrallFrame:EnthrallCheckFrame;
        
        private static var STATE_1:int = 1*60;
        private static var STATE_2:int = 2*60;
        private static var STATE_3:int = 4*60;
        private static var STATE_4:int = 5*60;
        
		public function EnthrallManager(singleton : SingletonEnfocer)
		{
			init();
		}
		
		private function init() : void
		{
			_view = new EnthrallView(this);
			_view.x = 110;
			_view.y = 5;
			_view.visible = false;
			TipManager.AddToLayerNoClear(_view);
			
			_enthrallFrame = new EnthrallCheckFrame();
			
			_timer = new Timer(60000);//游戏时间计时器
			_timer1 = new Timer(1000);//弹出框计时器
			_timer.addEventListener(TimerEvent.TIMER,  __timerHandler);
			_timer1.addEventListener(TimerEvent.TIMER,  __timer1Handler);	
			_timer.start();	
		}
		
		private function __timerHandler(evt : TimerEvent) : void
		{					
			_loadedTime++
			TimeManager.Instance.totalGameTime = TimeManager.Instance.totalGameTime + 1;
			
			checkState();
		}	
		
		private function checkState():void
		{
			if(_enthrallSwicth == false) return;
			if(TimeManager.Instance.totalGameTime == STATE_1)
			{
				if(_view.visible)
				{
					remind(LanguageMgr.GetTranslation("ddt.manager.enthrallRemind1"));
				}
			}
			
			if(TimeManager.Instance.totalGameTime == STATE_2)
			{
				remind(LanguageMgr.GetTranslation("ddt.manager.enthrallRemind2"));
			}
			
			if(TimeManager.Instance.totalGameTime == STATE_3)
			{
				if(_view.visible)
				{
					remind(LanguageMgr.GetTranslation("ddt.manager.enthrallRemind3"));
				}
			}
			
			if(TimeManager.Instance.totalGameTime == STATE_4)
			{
				if(_view.visible)
				{
					remind(LanguageMgr.GetTranslation("ddt.manager.enthrallRemind4"));
				}else
				{
					remind(LanguageMgr.GetTranslation("ddt.manager.enthrallRemind5"));
				}
			}
		}
		
		private function remind($msg:String):void
		{
			ChatManager.Instance.sysChatYellow($msg);
		}
		
		public function updateLight():void
		{
			_view.update();
		}
		
		private function __timer1Handler(evt:TimerEvent):void
		{
			if(!_popCIDChecker) return;
			if(StateManager.currentStateType == StateType.MAIN)
			{
				showCIDCheckerFrame();
				_timer1.stop();
			}
		}

		public function setup():void
		{
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CID_CHECK,changeCIDChecker);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ENTHRALL_LIGHT,readStates);
			
		}
		
		private function changeCIDChecker(evt:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = evt.pkg;
			_popCIDChecker = pkg.readBoolean();
			if(_popCIDChecker)
			{
				_timer1.start();
			}else
			{
				closeCIDCheckerFrame();
			}
		}
		
		private function readStates(evt:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = evt.pkg;
			_enthrallSwicth = pkg.readBoolean();
			_hasApproved = pkg.readBoolean();
			_isMinor = pkg.readBoolean();
			updateEnthrallView();
		}
		
		public function updateEnthrallView():void
		{
			if(_enthrallSwicth)
			{
				if(_hasApproved && !_isMinor)
				{
					hideEnthrallLight();
				}else
				{
					showEnthrallLight();
				}
			}else
			{
				hideEnthrallLight();
			}
			_view.changeBtn(false);
			_view.changeToGameState(false);
//			trace(StateManager.currentStateType);
			switch(StateManager.currentStateType)
			{
				case StateType.MAIN:
					_view.changeBtn(!_hasApproved);
					return;
				case StateType.FIGHTING:
					_view.changeToGameState(true);
					return;
			}
		}
		
		private function closeCIDCheckerFrame():void
		{
			TipManager.RemoveTippanel(_enthrallFrame);
		}
		
		public function showCIDCheckerFrame():void
		{
		   	TipManager.AddTippanel(_enthrallFrame,true);
		}
		
		public static function getInstance():EnthrallManager
		{
			if(_instance == null)
			{
				_instance = new EnthrallManager(new SingletonEnfocer());
			}
			return _instance;
		}
		
		public function showEnthrallLight():void
		{
			_view.visible = true;
			updateLight();
		}
		
		public function hideEnthrallLight():void
		{
			_view.visible = false;
		}
		
		public function gameState(num:Number):void
		{
			TipManager.AddToLayerNoClear(_view);
			_view.x = num - 100;
		    _view.y = 15;			
		}
		
		public function outGame():void
		{
			TipManager.AddToLayerNoClear(_view);
		    _view.x = 110;
	    	_view.y = 5;
		}
	}
}

class SingletonEnfocer {}


