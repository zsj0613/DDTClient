package ddt.fightLib
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import road.comm.PackageIn;
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HLabelButton;
	
	import ddt.command.fightLibCommands.script.BaseScript;
	import ddt.command.fightLibCommands.script.HighGap.EasyHighGap;
	import ddt.command.fightLibCommands.script.HighGap.NormalHighGap;
	import ddt.command.fightLibCommands.script.HighThrow.DifficultHighThrow;
	import ddt.command.fightLibCommands.script.HighThrow.EasyHighThrow;
	import ddt.command.fightLibCommands.script.HighThrow.NormalHighThrow;
	import ddt.command.fightLibCommands.script.MeasureScree.DifficultMeasureScreenScript;
	import ddt.command.fightLibCommands.script.MeasureScree.EasyMeasureScreenScript;
	import ddt.command.fightLibCommands.script.MeasureScree.NomalMeasureScreenScript;
	import ddt.command.fightLibCommands.script.SixtyDegree.DifficultSixtyDegreeScript;
	import ddt.command.fightLibCommands.script.SixtyDegree.EasySixtyDegreeScript;
	import ddt.command.fightLibCommands.script.SixtyDegree.NormalSixtyDegreeScript;
	import ddt.command.fightLibCommands.script.TwentyDegree.DifficultTwentyDegree;
	import ddt.command.fightLibCommands.script.TwentyDegree.EasyTwentyDegree;
	import ddt.command.fightLibCommands.script.TwentyDegree.NormalTwentyDegree;
	import ddt.data.Config;
	import ddt.data.FightLibInfo;
	import ddt.data.game.Living;
	import ddt.data.game.Player;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.events.LivingEvent;
	import ddt.game.DungeonInfoView;
	import ddt.game.GameView;
	import ddt.manager.FightLibManager;
	import ddt.manager.GameManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.RoomManager;
	import ddt.manager.SocketManager;
	import ddt.socket.GameInSocketOut;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	import tank.fightLib.FightLibPowerTableAsset;
	
	public class FightLibGameView extends GameView
	{
		
		private var _script:BaseScript;
		private var _frame:FightLibQuestionFrame;
		
		private var _redPoint:Sprite;
		
		private var _shouldShowTurn:Boolean = true;
		
		private var _isWaittingToAttack:Boolean = false;
		
		private var _scriptStarted:Boolean;
		
		private var _powerTable:FightLibPowerTableAsset;
		
		private var _reAnswerBtn:HLabelButton;
		private var _viewTutorialBtn:HLabelButton;
		
		public function FightLibGameView()
		{
			super();
		}
		
		override public function getType():String
		{
			return StateType.FIGHT_LIB_GAMEVIEW;
		}
		
		override public function enter(prev:BaseStateView, data:Object=null):void
		{
			super.enter(prev,data);
			initScript();
//			blockExist();
			closeShowTurn();
			blockFly();
			setPropBarClickEnable(true,true);
			arrowHammerEnable = false;
			blockHammer();
			_tool.specialEnabled = false;
			pauseGame();
			_map.smallMap.setHardLevel(RoomManager.Instance.current.hardLevel,1);
			
			initBtn();
			initEvents();
		}
		
		private function initBtn():void
		{
			_reAnswerBtn = new HLabelButton();
			_reAnswerBtn.label = LanguageMgr.GetTranslation("ddt.fightLib.FightLibQuestionFrame.reAnswer");
			_reAnswerBtn.x = 825;
			_reAnswerBtn.y = 240;
			_reAnswerBtn.enable = false;
			_viewTutorialBtn = new HLabelButton();
			_viewTutorialBtn.label = LanguageMgr.GetTranslation("ddt.fightLib.FightLibQuestionFrame.viewTutorial");
			_viewTutorialBtn.x = 825;
			_viewTutorialBtn.y = 270;
			addChild(_reAnswerBtn);
			addChild(_viewTutorialBtn);
		}
		
		private function initEvents():void
		{
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.POPUP_QUESTION_FRAME,__popupQuestionFrame);
			_reAnswerBtn.addEventListener(MouseEvent.CLICK,__reAnswer);
			_viewTutorialBtn.addEventListener(MouseEvent.CLICK,__viewTutorial);
		}
		
		private function removeEvents():void
		{
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.POPUP_QUESTION_FRAME,__popupQuestionFrame);
			_reAnswerBtn.removeEventListener(MouseEvent.CLICK,__reAnswer);
			_viewTutorialBtn.removeEventListener(MouseEvent.CLICK,__viewTutorial);
		}
		
		private function __reAnswer(evt:MouseEvent):void
		{
			_reAnswerBtn.visible = false;
			SoundManager.Instance.play("008");
			GameInSocketOut.sendFightLibReanswer();
			FightLibManager.Instance.reAnswerNum --;
		}
		
		private function __viewTutorial(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			_viewTutorialBtn.visible = false;
			FightLibManager.Instance.script.restart();
			GameInSocketOut.sendClientScriptStart();
			closeShowTurn();
			if(_frame)
			{
				_frame.close();
			}
		}
		
		private function initScript():void
		{
			if(FightLibManager.Instance.currentInfo.id == 5)
			{
				if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
				{
					_script = new EasyMeasureScreenScript(this);
				}else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
				{
					_script = new NomalMeasureScreenScript(this);
				}else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.DIFFICULT)
				{
					_script = new DifficultMeasureScreenScript(this);
				}
			}else if(FightLibManager.Instance.currentInfo.id == 6)
			{
				if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
				{
					_script = new EasyTwentyDegree(this);
				}else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
				{
					_script = new NormalTwentyDegree(this);
				}else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.DIFFICULT)
				{
					_script = new DifficultTwentyDegree(this);
				}
			}else if(FightLibManager.Instance.currentInfo.id == 7)
			{
				if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
				{
					_script = new EasySixtyDegreeScript(this);
				}else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
				{
					_script = new NormalSixtyDegreeScript(this);
				}else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.DIFFICULT)
				{
					_script = new DifficultSixtyDegreeScript(this);
				}
			}else if(FightLibManager.Instance.currentInfo.id == 8)
			{
				if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
				{
					_script = new EasyHighThrow(this);
				}else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
				{
					_script = new NormalHighThrow(this);
				}else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.DIFFICULT)
				{
					_script = new DifficultHighThrow(this);
				}
			}else if(FightLibManager.Instance.currentInfo.id == 9)
			{
				if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
				{
					_script = new EasyHighGap(this);
				}else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
				{
					_script = new NormalHighGap(this);
				}else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.DIFFICULT)
				{
					_script = new NormalHighGap(this);
				}
			}
			FightLibManager.Instance.script = _script;
		}
		/**
		 *除小地图以外加蒙版 
		 * 
		 */		
		public function drawMasks():void
		{
			if(!_tipLayers)
			{
				_tipLayers = new Sprite();
				addChild(_tipLayers);
			}
			_tipLayers.graphics.clear();
			_tipLayers.graphics.beginFill(0x000000,0.8);
			_tipLayers.graphics.drawRect(-10,-10,810,820);
			_tipLayers.graphics.drawRect(800,116,200,690);
			_tipLayers.graphics.endFill();
		}
		
		public function pauseGame():void
		{
			closeShowTurn();
		}
		
		public function continueGame():void
		{
			_barrier = new DungeonInfoView();
			addChild(_barrier);
			_barrier.x = Config.GAME_WIDTH - 205;
			_barrier.y = 150;
			setTimeout(openShowTurn,3000);
			setTimeout(enableReanswerBtn,3000);
		}
		
		public function splitSmallMapDrager():void
		{
			_map.smallMap.showSpliter();
		}
		
		public function hideSmallMapSplit():void
		{
			_map.smallMap.hideSpliter();
		}
		
		public function restoreText():void
		{
			_map.smallMap.restoreText();
		}
		
		public function shineText():void
		{
			_map.smallMap.ShineText(9);
		}
		
		public function screanAddEvent():void
		{
			_map.smallMap.foreMap_mc.addEventListener(MouseEvent.MOUSE_DOWN,__downHandler);
		}
		
		private function __downHandler(evt:MouseEvent):void
		{
			_map.smallMap.foreMap_mc.removeEventListener(MouseEvent.MOUSE_DOWN,__downHandler);
			_script.continueScript();
		}
		
		override protected function __playerChange(event:CrazyTankSocketEvent):void
		{
			if(!_scriptStarted)
			{
				_script.start();
				_scriptStarted = true;
			}
			if(_shouldShowTurn)
			{
				super.__playerChange(event);
			}
			setPropBarClickEnable(true,true);
		}
		
		public function clearMask():void
		{
			_tipLayers.graphics.clear();
		}
		
		public function sendClientScriptStart():void
		{
			GameInSocketOut.sendClientScriptStart();
		}
		
		public function sendClientScriptEnd():void
		{
			GameInSocketOut.sendClientScriptEnd();
		}
		
		private function __popupQuestionFrame(evt:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = evt.pkg;
			var pop:Boolean = pkg.readBoolean();
			if(pop)
			{
				var id:int = pkg.readInt();
				var hasAnswered:int = pkg.readInt();
				var needAnswer:int = pkg.readInt();
				var questionNumber:int = pkg.readInt();
				var timeLimit:int = pkg.readInt();
				var title:String = pkg.readUTF();
				var question:String = pkg.readUTF();
				var answer1:String = pkg.readUTF();
				var answer2:String = pkg.readUTF();
				var answer3:String = pkg.readUTF();
				if(_frame)
				{
					_frame.close();
				}
				_frame = new FightLibQuestionFrame(id,title,hasAnswered,needAnswer,questionNumber,question,answer1,answer2,answer3,timeLimit);
				_frame.show();
			}else
			{
				if(_frame)
				{
					_frame.close();
				}
			}
		}
		
		public function addRedPointInSmallMap():void
		{
			_redPoint = new Sprite();
			_redPoint.graphics.beginFill(0xff0000,1);
			_redPoint.graphics.drawCircle(0,0,5);
			_map.smallMap.addObj(_redPoint);
			_map.smallMap.updatePos(_redPoint,new Point(GameManager.Instance.Current.selfGamePlayer.pos.x+1000,GameManager.Instance.Current.selfGamePlayer.pos.y));
		}
		
		public function removeRedPointInSmallMap():void
		{
			_map.smallMap.removeObj(_redPoint);
			_redPoint = null;
		}
		
		public function leftJustifyWithPlayer():void
		{
			_map.setCenter(_selfGamePlayer.pos.x+500,_selfGamePlayer.pos.y,false);
		}
		
		public function leftJustifyWithRedPoint():void
		{
			_map.setCenter(_selfGamePlayer.pos.x+1500,_selfGamePlayer.pos.y,false);
		}
		
		override protected function __addLiving(event:CrazyTankSocketEvent):void
		{
			super.__addLiving(event);
			if(_isWaittingToAttack)
			{
				for each(var living:Living in _gameInfo.livings)
				{
					if(!(living is Player))
					{
						living.addEventListener(LivingEvent.DIE,continueScript);
					}
				}
			}
		}
		
		public function waitAttack():void
		{
			_isWaittingToAttack = true;
		}
		
		public function continueScript(evt:LivingEvent):void
		{
			_isWaittingToAttack = false;
			for each(var living:Living in _gameInfo.livings)
			{
				if(!(living is Player))
				{
					living.removeEventListener(LivingEvent.DIE,continueScript);
				}
			}
			_script.continueScript();
		}
		
		public function closeShowTurn():void
		{
			_shouldShowTurn = false;
		}
		
		public function openShowTurn():void
		{
			_shouldShowTurn = true;
		}
		
		public function enableReanswerBtn():void
		{
			_reAnswerBtn.enable = true;
		}
		
		public function blockFly():void
		{
			_arrow.closeFly = true;
		}
		
		public function blockSmallMap():void
		{
			_map.smallMap.allowDrag = false;
		}
		
		public function blockExist():void
		{
			_tool.enableExit = false;
		}
		
		public function enableExist():void
		{
			_tool.enableExit = true;
		}
		
		public function activeSmallMap():void
		{
			_map.smallMap.allowDrag = true;
		}
		
		public function skip():void
		{
			GameInSocketOut.sendGameSkipNext(1);
		}
		
		public function showPowerTable1():void
		{
			_powerTable = new FightLibPowerTableAsset();
			_powerTable.gotoAndStop(1);
			addChild(_powerTable);
		}
		
		public function showPowerTable2():void
		{
			_powerTable = new FightLibPowerTableAsset();
			_powerTable.gotoAndStop(2);
			addChild(_powerTable);
		}
		
		public function showPowerTable3():void
		{
			_powerTable = new FightLibPowerTableAsset();
			_powerTable.gotoAndStop(3);
			addChild(_powerTable);
		}
		
		public function hidePowerTable():void
		{
			if(_powerTable && contains(_powerTable))
			removeChild(_powerTable);
			_powerTable = null;
		}
		
		override public function leaving(next:BaseStateView):void
		{
			_scriptStarted = false;
			_isWaittingToAttack = false;
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.POPUP_QUESTION_FRAME,__popupQuestionFrame);
			for each(var living:Living in _gameInfo.livings)
			{
				if(!(living is Player))
				{
					living.removeEventListener(LivingEvent.DIE,continueScript);
				}
			}
			if(_frame)
			{
				if(_frame.parent)
				{
					_frame.dispose()
				}
				_frame = null;
			}
			if(_powerTable)
			{
				if(_powerTable.parent) _powerTable.parent.removeChild(_powerTable);
				_powerTable = null;
			}
			if(_script)
			{
				_script.dispose();
				_script = null;
			}
			super.leaving(next);
		}
	}
}