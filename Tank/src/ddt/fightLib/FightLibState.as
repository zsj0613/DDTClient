package ddt.fightLib
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import road.manager.SoundManager;
	
	import ddt.command.fightLibCommands.script.BaseScript;
	import ddt.command.fightLibCommands.script.FightLibGuideScripit;
	import ddt.gameLoad.GameLoadingControler;
	import ddt.manager.FightLibManager;
	import ddt.manager.GameManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.RoomManager;
	import ddt.manager.SharedManager;
	import ddt.manager.StateManager;
	import ddt.socket.GameInSocketOut;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	import ddt.view.common.BellowStripViewII;
	
	/**
	 * 
	 * @author WickiLA
	 * @time 0526/2010
	 * @description 作战实验室视图
	 */	
	
	public class FightLibState extends BaseStateView
	{
		private var _container:Sprite;
		private var _fightLibView:FightLibView;
		private var _loadingGame:GameLoadingControler;
		
		public function FightLibState()
		{
			super();
			GameManager.Instance.setup();
			RoomManager.Instance.setup();
			_container = new Sprite();
		}
		
		override public function enter(prev:BaseStateView,data:Object = null):void
		{
			SoundManager.Instance.playMusic("065");
			if(RoomManager.Instance.current == null)
			{
				GameInSocketOut.sendCreateRoom("",5);
			}
			FightLibManager.Instance.reset();
			checkIfFirtEnter();
			BellowStripViewII.Instance.show();
			GameManager.Instance.addEventListener(GameManager.START_LOAD,__startLoading);
			_fightLibView = new FightLibView();
			_container.addChild(_fightLibView);
		}
		
		private function checkIfFirtEnter():void
		{
			if(!FightLibManager.Instance.getFightLibInfoByID(5).normalCanPlay)
			{
				startScript();
			}
			SharedManager.Instance.save();
		}
		
		private function startScript():void
		{
			FightLibManager.Instance.script = new FightLibGuideScripit(this);
			FightLibManager.Instance.script.start();
		}
		
		public function showGuide1():void
		{
			_fightLibView.showGuide1();
		}
		
		public function showGuide2():void
		{
			_fightLibView.showGuide2();
		}
		
		public function hideGuide():void
		{
			_fightLibView.hideGuide();
		}
		
		override public function getBackType():String
		{
			return StateType.MAIN;
		}
		
		override public function getView():DisplayObject
		{
			return _container;
		}
		
		override public function getType():String
		{
			return StateType.FIGHT_LIB;
		}
		
		override public function leaving(next:BaseStateView):void
		{
			GameManager.Instance.removeEventListener(GameManager.START_LOAD,__startLoading);
			_fightLibView.dispose();
			_fightLibView = null;
			if(_loadingGame) _loadingGame.dispose();
			_loadingGame = null;
			if(next.getType() != StateType.FIGHT_LIB_GAMEVIEW)
			{
				GameInSocketOut.sendGamePlayerExit();
				RoomManager.Instance.removeAndDisposeAllPlayer();
				RoomManager.Instance.current = null;
			}
		}
		
		private function __startLoading(evt:Event):void
		{
			_loadingGame = new GameLoadingControler();
			_container.removeChild(_fightLibView);
			_container.addChild(_loadingGame);
			RoomManager.Instance.current.resetReadyStates();
		}
	}
}