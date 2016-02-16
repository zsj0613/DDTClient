package ddt.roomlist
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.crazyTank.view.roomlistII.RoomListIIBtnPanelAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HTipButton;
	
	import ddt.manager.LanguageMgr;
	import ddt.manager.SocketManager;
	import ddt.manager.UserGuideManager;
	import ddt.socket.GameInSocketOut;

	public class RoomListIIRoomBtnPanel extends RoomListIIBtnPanelAsset
	{
		private var _controller:IRoomListIIController;
		private var _hadGetRoom:Boolean;
		public  var createRoom_btn:HTipButton;
		private var compete_btn:HTipButton;
		private var all_btn:HTipButton;
		private var findroom_btn:HTipButton;
		private var waiting_btn:HTipButton;
		private var fastjoin_btn:HTipButton;
		
		private var MyTimer:Timer;
		private var isClickJoin:Boolean;
		
		public function RoomListIIRoomBtnPanel(controller:IRoomListIIController)
		{
			_controller = controller;
			super();
			init();
			initEvent();
		}
		private function init():void
		{
			_hadGetRoom = false;
			createRoom_btn = new HTipButton(creatRoom,"",LanguageMgr.GetTranslation("ddt.roomlist.RoomListIIRoomBtnPanel.createRoom"));
			createRoom_btn.useBackgoundPos = true;
			addChild(createRoom_btn);
			
			compete_btn = new HTipButton(rivalship_mc,"",LanguageMgr.GetTranslation("ddt.roomlist.joinBattleQuickly"));
			compete_btn.useBackgoundPos = true;
			addChild(compete_btn);	
//			addChild(joinFlag);
			
			findroom_btn = new HTipButton(findRoom,"",LanguageMgr.GetTranslation("ddt.roomlist.RoomListIIRoomBtnPanel.findRoom"));
			findroom_btn.useBackgoundPos = true;
			addChild(findroom_btn);

			
			isClickJoin = true;
			MyTimer = new Timer(1500,0); 
		}
		
		private function initEvent():void
		{
			createRoom_btn.addEventListener(MouseEvent.CLICK,__createRoomBtn);
			compete_btn.addEventListener(MouseEvent.CLICK,__fastCompeteClick);
			findroom_btn.addEventListener(MouseEvent.CLICK,__findRoomClick);
			MyTimer.addEventListener(TimerEvent.TIMER , __isCanClick);
			createRoom_btn.addEventListener(Event.ADDED_TO_STAGE,userGuide);
		}
		public function userGuide(e:Event):void{
			if(UserGuideManager.Instance.getIsFinishTutorial(53)){
				if(!UserGuideManager.Instance.getIsFinishTutorial(54)){
					UserGuideManager.Instance.setupStep(54,UserGuideManager.BUTTON_GUIDE,beforeUserGuide51,createRoom_btn);
				}
			}
		}
		private function beforeUserGuide51():void{
			createRoom_btn.removeEventListener(Event.ADDED_TO_STAGE,userGuide);
		}
		private function __isCanClick(evt:Event):void
		{
			isClickJoin = true;
		}
		private function __createRoomBtn(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			_controller.showCreateView();
		}
		
		private function __fastJoinClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(isClickJoin)
			{
				MyTimer.start();
				isClickJoin = false;	
//				SocketManager.Instance.out.sendGameLogin(2);
				SocketManager.Instance.out.sendGameLogin(1,2);
			}
		}
		
		private function __fastCompeteClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
//			SocketManager.Instance.out.sendGameLogin(0);
			SocketManager.Instance.out.sendGameLogin(1,0);
		}
		
		private function __findRoomClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			evt.stopImmediatePropagation();
			_controller.showFindRoom();
		}
		
		private function __allClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(!_hadGetRoom)
			{
				GameInSocketOut.sendGetAllRoom();
//				SocketManager.Instance.out.sendGetAllRoom();
				_hadGetRoom = true;
			}
			_controller.setRoomShowMode(0);
		}
		
		private function __waitingClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			_controller.setRoomShowMode(1);
		}
		
		public function dispose():void
		{
			createRoom_btn.removeEventListener(MouseEvent.CLICK,__createRoomBtn);
			findroom_btn.removeEventListener(MouseEvent.CLICK,__findRoomClick);
			MyTimer.removeEventListener(TimerEvent.TIMER , __isCanClick);
			_controller = null;
		}
	}
}