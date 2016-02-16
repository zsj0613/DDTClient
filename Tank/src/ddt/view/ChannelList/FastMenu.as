package ddt.view.ChannelList
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import game.crazyTank.view.common.ChannelListBtn;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.controls.hframe.HFrame;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	import road.utils.StringHelper;
	
	import ddt.data.store.StoreState;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.StateManager;
	import ddt.states.StateType;
	import ddt.view.common.BellowStripViewII;
	import tank.view.ChannelList.ChannelList;
	
	public class FastMenu extends HConfirmFrame
	{
		private static const CLOSE_GAPE:uint = 1;
		private var _newIcon:ChannelList;
		private var _listBtn:ChannelListBtn;
		private var _listBtnArray:Array;
		private var _currentClick:int = -1;;
		private static var instance: FastMenu;
		public function FastMenu()
		{
			super();
			
			init();
		}
		
		private function init():void
		{
			
			titleText = LanguageMgr.GetTranslation("ddt.view.ChannelList.FastMenu.titleText");
			//titleText = "跳 转";
			okLabel = LanguageMgr.GetTranslation("close");
			//okLabel = "退 出";
			setSize(280,445);
			showCancel = false;
			alphaGound = false;
			moveEnable = false;
			blackGound = false;
			this.x  = 715;
			this.y  = 100;
			
			_newIcon = new ChannelList();
			_newIcon.new_mc.visible = false;
			_newIcon.x = 10;
			_newIcon.y = 48;
			addChild(_newIcon);
			creatListBtn();
			
		}
		override protected function __addToStage(e:Event):void
		{
			super.__addToStage(e);
			for(var i:int=0;i<_listBtnArray.length;i++)
			{
				_listBtnArray[i].alpha = 0;
			}
			
			stage.addEventListener(MouseEvent.CLICK, clearThis);
		}
		
		private function clearThis(e:MouseEvent):void {
			var temp:DisplayObject = e.target as DisplayObject;
			while(temp.parent) {
				if(temp == this) {
					return;
				}
				temp = temp.parent;
			}
			if(stage) {
				stage.removeEventListener(MouseEvent.CLICK, clearThis);
			}
			close();
		}
		
		
		private function creatListBtn():void
		{
			_listBtnArray = [];
			for(var i:int=0;i<8;i++)
			{
				_listBtn = new ChannelListBtn();
				_listBtn.x = 15
				_listBtn.y = (_listBtn.height) * i + 43;
				_listBtn.alpha = 0;
				_listBtn.buttonMode = true;
				_listBtn._currentClick = i;
			    addChild(_listBtn);
			    _listBtnArray[_listBtnArray.length] = _listBtn;
			    _listBtn.addEventListener(MouseEvent.MOUSE_OVER,overHandle);
			    _listBtn.addEventListener(MouseEvent.MOUSE_OUT,outHandle);
			    _listBtn.addEventListener(MouseEvent.CLICK,clickHandle);
			}
		}
		private function overHandle(e:MouseEvent):void
		{
			e.target.alpha = 1;
		}
		private function outHandle(e:MouseEvent):void
		{
			e.target.alpha = 0;
		}
		private function clickHandle(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			_currentClick = e.target._currentClick;
			SoundManager.Instance.play("047");
			
			switch(e.target._currentClick)
			{
				case 0:
				StateManager.setState(StateType.SHOP);
			    break;
			    
			    case 1:
			    StoreState.storeState = StoreState.BASESTORE;
			    StateManager.setState(StateType.STORE_ARM);
			    
			    break;
			    
			    case 2:
			    StateManager.setState(StateType.CONSORTIA);
			    break;
			    
			    case 3:
			    StateManager.setState(StateType.AUCTION);
			    break;
			    case 4:
			    StateManager.setState(StateType.SERVER_LIST);
			    break;
			    
			    case 5:
			    BellowStripViewII.Instance.switchDailyConduct();
			    break;
			    case 6:
			    StateManager.setState(StateType.ROOM_LIST);
			    break;
			    case 7:
			    if(PlayerManager.Instance.checkEnterDungeon)
			    StateManager.setState(StateType.DUNGEON,StateType.DUNGEON);
			    break;
			}
			
			switchVisible();
		}
		
		
		public function switchVisible():void
		{
			if(parent)
			{
				this.parent.removeChild(this);	
			}	
			else
			{
				//TipManager.AddTippanel(this,false,true);
				UIManager.AddDialog(this,false);
				
			}
		}
		
		override protected function __onKeyDownd(e:KeyboardEvent):void
		{
			super.__onKeyDownd(e);
			e.stopImmediatePropagation();
		}
		
		public static function get Instance():FastMenu
		{
			if(instance == null)
			{
				instance = new FastMenu();
			}
			return instance;
		}
		
	}
}