package ddt.hall
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ddt.data.player.SelfInfo;
	import ddt.gameLoad.GameLoadingControler;
	import ddt.manager.BossBoxManager;
	import ddt.manager.ChatManager;
	import ddt.manager.ConsortiaQuitTipManager;
	import ddt.manager.GradeExaltClewManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ServerManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StateManager;
	import ddt.manager.TaskManager;
	import ddt.manager.UserGuideManager;
	import ddt.serverlist.ServerListView;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	import ddt.view.bossbox.SmallBoxButton;
	import ddt.view.common.BellowStripViewII;
	import ddt.view.common.DuplicatePreview;
	import ddt.view.continuation.ContinuationAlarmFrame;
	import ddt.view.dailyconduct.TestingTipFrame;
	import ddt.view.movement.MovementLeftView;
	import ddt.view.movement.MovementModel;
	
	import road.loader.LoaderSavingManager;
	import road.manager.SoundManager;
	import road.utils.ClassUtils;

	/**
	 * Hall
	 * 
	 * 
	 */
	 
	public class ChooseHallView extends BaseStateView
	{
		public static const GAME_WIDTH:Number = 1000;
		public static const GAME_HEIGHT:Number = 600;
		private var _loadingGame:GameLoadingControler;
		
		private var _asset:MovieClip;
		private var _consortiaInfo:HallConsortiaInfo;
		private var _boxButton:SmallBoxButton;
		
		private static const W:int = 1096;
		private static const H:int = 804;
		
		private var _isFirst:Boolean;
		private static var _isShowNotice:Boolean = false;
		
		private var _movementClick:Boolean;
		
		private var _pierMovementClick:Boolean; 
		
		private static var _isFirstLogin:Boolean;
		
		private var btnArray:Array = ["church_mc","shop_mc","dungeon_mc","roomList_mc","auction_mc","active_mc","civil_mc","store_mc","campaignLab_mc","tofflist_mc","hotWell_mc","consortia_mc",]
		
		//private var _trainerWelcomeView : TrainerWelcomeView;
		
		private var _duplicatePreview:DuplicatePreview;
				
		override public function prepare():void
		{
			super.prepare();
			
			_isFirst = true;
			
		}
		
		override public function enter(prev:BaseStateView,data:Object = null):void
		{
			super.enter(prev,data);
			SocketManager.Instance.out.sendSceneLogin(1);
			var self : SelfInfo = PlayerManager.Instance.Self;			
			GradeExaltClewManager.getInstance().steup();

			
			_asset = ClassUtils.CreatInstance("ddt.asset.hall.HallAsset") as MovieClip;
			if(_asset == null)
			{
				global.traceStr("asset is null");
			}
			_asset.gotoAndStop(13);
			addChild(_asset);
			
			var severName : String = String(ServerManager.Instance.current.Name);	
			var num : int = severName.indexOf("(");
			num = num == -1 ? severName.length : num;
			_asset.svrname_txt.text = severName.substr(0,num);
			
			if(BossBoxManager.DataLoaded)
			{
				checkShowBossBox();
			}else
			{
				BossBoxManager.instance.addEventListener(BossBoxManager.LOADUSERBOXINFO_COMPLETE,__onBossBoxDataLoaded);
			}
			
			SoundManager.instance.playMusic("062",true,false);
			
			BellowStripViewII.Instance.show();
			BellowStripViewII.Instance.enabled = true;
			BellowStripViewII.Instance.tutorialBtnsStatus(true);
			BellowStripViewII.Instance.tutorialStatus(false);
			BellowStripViewII.Instance.showDailyConduct(true);
			BellowStripViewII.Instance.showDownBtn();
			BellowStripViewII.Instance.showFeedbackNavigation(false);
			BellowStripViewII.Instance.showWorldBoss();
			
			for(var i:int = 0;i< 12 ; i++ )
			{
				_asset[btnArray[i]].addEventListener(MouseEvent.CLICK 		, __btnClick);
				_asset[btnArray[i]].addEventListener(MouseEvent.MOUSE_OVER  , __btnOver);
				_asset[btnArray[i]].addEventListener(MouseEvent.MOUSE_OUT 	, __btnOut);
				if(!(_asset[btnArray[i]] is SimpleButton))_asset[btnArray[i]].buttonMode = true;
			}
			
			addEventListener(Event.ENTER_FRAME,__enterframe);
			SocketManager.Instance.out.sendCurrentState(1);
			
			ChatManager.Instance.state = ChatManager.CHAT_HALL_STATE;
			addChild(ChatManager.Instance.view);
			ChatManager.Instance.setFocus();
			if(!_movementClick)
			{
				MovementModel.Instance.getActiveInfo();
				_movementClick = true;
			}
			if(!_isFirstLogin)
			{
				BellowStripViewII.Instance.switchDailyConduct();
				_isFirstLogin = true;
				
			}
			if(!_isShowNotice)
			{
				_isShowNotice =true;
				var a:TestingTipFrame = new TestingTipFrame();
				a.show();
			}
			
			this.tabEnabled = false;
			this.tabChildren = false;
			
			if(ServerListView.showContinuation)
			{
				ServerListView.showContinuation=false;
				var frame:ContinuationAlarmFrame = new ContinuationAlarmFrame();
				frame.show();
			}
			
			ConsortiaQuitTipManager.Instance.addEventListener(ConsortiaQuitTipManager.QUITCONSORTIAGOODSTOBAG, _showQuitMessage);
			if(ConsortiaQuitTipManager.Instance.isQuitMessage)
			{
				ConsortiaQuitTipManager.Instance.showMessage();
				ConsortiaQuitTipManager.Instance.isQuitMessage = false;
			}
		}
		
		private function __onBossBoxDataLoaded(event:Event):void
		{
			BossBoxManager.instance.removeEventListener(BossBoxManager.LOADUSERBOXINFO_COMPLETE,__onBossBoxDataLoaded);
			checkShowBossBox();
		}

		private function _showQuitMessage(e:Event):void
		{
			if(ConsortiaQuitTipManager.Instance.isQuitMessage)
			{
				ConsortiaQuitTipManager.Instance.showMessage();
				ConsortiaQuitTipManager.Instance.isQuitMessage = false;
			}
		}
		
		private function removeEvent():void
		{
			ConsortiaQuitTipManager.Instance.removeEventListener(ConsortiaQuitTipManager.QUITCONSORTIAGOODSTOBAG, _showQuitMessage);
		}
		
		private function checkShowBossBox():void
		{
			if(BossBoxManager.instance.isShowBoxButton())
			{
				_boxButton = new SmallBoxButton();
				_boxButton.x = _asset._smallBoxButton.x;
				_boxButton.y = _asset._smallBoxButton.y;
				BossBoxManager.instance.smallBoxButton = _boxButton;
				addChild(_boxButton);
			}
			if(BossBoxManager.instance.isShowGradeBox)
			{
				BossBoxManager.instance.isShowGradeBox = false;
				BossBoxManager.instance.showGradeBox();
			}
		}
		
		
		private function __btnClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("047");
			switch(evt.currentTarget.name)
			{
				case "auction_mc":
						StateManager.setState(StateType.AUCTION);
					break;				
				case "active_mc":
						{
							MovementLeftView.Instance.setup();
							MovementLeftView.Instance.open();		
							BellowStripViewII.Instance.clickMovement();
						}
					break;
				case "campaignLab_mc":
						StateManager.setState(StateType.FIGHT_LIB);
					break;
				case "church_mc":
						StateManager.setState(StateType.CHURCH_ROOMLIST);
					break;
				case "civil_mc":
						StateManager.setState(StateType.CIVIL);
					break;
				case "consortia_mc":
						StateManager.setState(StateType.CONSORTIA);
					break;
				case "dungeon_mc":
						StateManager.setState(StateType.DUNGEON);
					break;
				case "hotWell_mc":
						StateManager.setState(StateType.HOT_SPRING_ROOM_LIST);
					break;
				case "roomList_mc":
				case "roomList_btn":
						StateManager.setState(StateType.ROOM_LIST);
					break;
				case "shop_mc":
				case "shop_btn":
						StateManager.setState(StateType.SHOP);
					break;
				case "store_mc":
				case "store_btn":
						StateManager.setState(StateType.STORE_ARM);
					break;
				case "tofflist_mc":
						StateManager.setState(StateType.TOFFLIST);
					break;
			}
		}
		
		private function duplicatePreviewOK():void
		{
			if(_duplicatePreview)
			{
				_duplicatePreview.close();
			}
			_duplicatePreview=null;
		}
		
		private function __btnOver(evt:MouseEvent):void
		{
		}
		
		private function __btnOut(evt:MouseEvent):void
		{
			if(_asset)
			_asset.gotoAndStop(13)
		}
		
		override public function fadingComplete():void
		{
			super.fadingComplete();
			if(_isFirst)
			{
				_isFirst = false;
				TaskManager.requestCanAcceptTask();
				//var powerPackageID:int = (PlayerManager.Instance.Self.Sex)?11228:11230;
				//if(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(powerPackageID) > 0&&PlayerManager.Instance.Self.IsFirst == 2)
				//{
				//	new NoviceGiveWindow().show();
				//}
				
				if(LoaderSavingManager.cacheAble == false && UserGuideManager.Instance.getIsFinishTutorial(57))
				{
					new SaveFileWindow().show();
				}
				
			}
		}

		override public function leaving(next:BaseStateView):void
		{
			BellowStripViewII.Instance.closeDailyConduct();
			for(var i:int = 0;i< 12 ; i++ )
			{
				_asset[btnArray[i]].removeEventListener(MouseEvent.CLICK 		, __btnClick);
				_asset[btnArray[i]].removeEventListener(MouseEvent.MOUSE_OVER  , __btnOver);
				_asset[btnArray[i]].removeEventListener(MouseEvent.MOUSE_OUT 	, __btnOut);
			}
			BossBoxManager.instance.removeEventListener(BossBoxManager.LOADUSERBOXINFO_COMPLETE,__onBossBoxDataLoaded);
			removeEventListener(Event.ENTER_FRAME,__enterframe);
			removeEvent();
			BellowStripViewII.Instance.hide();
			BellowStripViewII.Instance.showDailyConduct(false);
			BellowStripViewII.Instance.hideDownBtn();
			BellowStripViewII.Instance.showFeedbackNavigation(false);
			if(_asset.parent)
			{
				removeChild(_asset);
			}
			_asset = null;
			
			if(_boxButton)
			{
				BossBoxManager.instance.deleteBoxButton();
				_boxButton.dispose();
			}
			_boxButton = null;
			
			//if(_trainerWelcomeView)
			//{
			//	_trainerWelcomeView.dispose();
			//}
			//_trainerWelcomeView = null;
			super.leaving(next);
		}
		
		override public function getBackType():String
		{
			return StateType.SERVER_LIST;
		}
		
		override public function getType():String
		{
			return StateType.MAIN;
		}
		
		private function __roup(event:MouseEvent):void
		{	
			SoundManager.instance.play("047");
			StateManager.setState(StateType.AUCTION);
		}
		
		
		private function __active(event:MouseEvent):void
		{
			SoundManager.instance.play("047");
			MovementLeftView.Instance.setup();
			MovementLeftView.Instance.open();		
			BellowStripViewII.Instance.clickMovement();  //bret 09.8.21
		}

		private var _targetX:Number = 0;
		private var _targetY:Number = 0;
		private function __move(event:MouseEvent):void
		{
			_targetX =  -event.stageX * (W - 1000) / GAME_WIDTH;
			_targetY =  -event.stageY * (H - 450) / GAME_HEIGHT;
		}
		
		private function __enterframe(event:Event):void
		{
			if(Math.abs(_targetX - x) < 1 && Math.abs(_targetY - y) < 1)return;
			var resultX:Number = x + (_targetX - x) / 1;
			resultX = resultX < - (W - GAME_WIDTH) ? -(W - GAME_WIDTH) : resultX;
			var resultY:Number = y + (_targetY - y) / 1;
			resultY = resultY < -(H - GAME_HEIGHT) ? -(H - GAME_HEIGHT) : resultY;
			if(resultX == _asset.x && resultY == _asset.y)return;
			_asset.x = resultX;
			_asset.y = resultY;
		}
	}
}