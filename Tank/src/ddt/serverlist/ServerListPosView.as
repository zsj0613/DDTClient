package ddt.serverlist
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import game.crazyTank.view.ServerListPosAsset;
	import game.tutorial.asset.GreenArrowAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.HAlertDialog;
	import road.utils.ComponentHelper;
	
	import ddt.data.PathInfo;
	import ddt.data.ServerInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ServerManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StateManager;
	import ddt.states.StateType;
	import ddt.utils.LeavePage;
	import ddt.view.common.BellowStripViewII;
	import ddt.view.common.WaitingView;
	import ddt.view.personalinfoII.IPersonalInfoIIController;
	import ddt.view.personalinfoII.PersonalInfoIIController;

	public class ServerListPosView extends ServerListPosAsset
	{
		private var _box:SimpleGrid;
		private var _personal:IPersonalInfoIIController;
		
		private var _ok_btn : HBaseButton;
		private var _exit_btn : HBaseButton;
		
		private var _arrow:GreenArrowAsset;
		internal function get box():SimpleGrid
		{
			return _box;
		}
	
		public function ServerListPosView()
		{
			initView();
			initEvent();
		}
	
		private function initView():void
		{
			
			_box = new SimpleGrid(220,72);
			_box.column = 2;
			_box.cellPaddingWidth = 3;//6;
			_box.cellPaddingHeight = 18;//1;
			_box.marginWidth = 0;//8;
			_box.marginHeight = 0;//5;
			_box.horizontalScrollPolicy = "off";
			_box.verticalScrollPolicy = "off";
			
			ComponentHelper.replaceChild(this,listPos,_box);
			
			_ok_btn   = new HBaseButton(ok_btn);
			_ok_btn.useBackgoundPos = true;
			addChild(_ok_btn);
			
			_exit_btn = new HBaseButton(exit_btn);
			_exit_btn.useBackgoundPos = true;
			addChild(_exit_btn);

			if(PlayerManager.Instance.Self.IsFirst <= 2)
			{
				_arrow = new GreenArrowAsset();
				_arrow.scaleX = _arrow.scaleY = 0.7;
				_arrow.x = arrowPos.x;
				_arrow.y = arrowPos.y;
				_arrow.rotation = arrowPos.rotation;
				addChild(_arrow);
			}else
			{
				removeChild(enterServerTip);
			}
			removeChild(arrowPos);
		}
		
		private function initEvent():void
		{
			_ok_btn.addEventListener(MouseEvent.CLICK,__ok);
			_exit_btn.addEventListener(MouseEvent.CLICK,__exit);
		}
		
		private function removeEvent():void
		{
			_ok_btn.removeEventListener(MouseEvent.CLICK,__ok);
			_exit_btn.removeEventListener(MouseEvent.CLICK,__exit);
		}

		public function enter():void
		{
			_personal = new PersonalInfoIIController(PlayerManager.Instance.Self);
			_personal.setEnabled(false);
			var person:Sprite = _personal.getView() as Sprite;
			person.x = personPanelPos.x;
			person.y = personPanelPos.y;
			personPanelPos.visible = false;
			addChild(person);
		}
	
		public function leaving():void
		{
			removeEvent();
			_box.clearItems();
			removeChild(_box);
			_box = null;
			if(_arrow && _arrow.parent)
			{
				_arrow.parent.removeChild(_arrow);
			}
			_arrow=null;
			_personal.dispose();
			_personal = null;
		}
		
		public function tryLoginServer():void
		{
			if(_box.selectedIndex < 0 || _box.selectedIndex > 500000)
			{
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.serverlist.ServerListPosView.choose"),true);
				//AlertDialog.show("提示","请选择服务器",true);
				return;
			}
			ServerManager.Instance.current = _box.selectedItem["info"];
			if(ServerManager.Instance.current.MustLevel < PlayerManager.Instance.Self.Grade)
			{
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.serverlist.ServerListPosView.your"),true);
				//AlertDialog.show("提示","您的等级过高，无法进入此服务器，请选择合适的服务器进行游戏。",true);
				return;
			}
			if(ServerManager.Instance.current.LowestLevel > PlayerManager.Instance.Self.Grade)
			{
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.serverlist.ServerListPosView.low"),true);
				//AlertDialog.show("提示","您的等级过低，无法进入此服务器，请选择合适的服务器进行游戏。",true);
				return;
			}
			
			var info:ServerInfo = ServerManager.Instance.current;
			if(!info)
			{
				
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.serverlist.ServerListPosView.choose"),true);
				//AlertDialog.show("提示","请选择服务器",true);
			}
			else if(SocketManager.Instance.socket.connected && SocketManager.Instance.socket.isSame(info.IP,info.Port) && SocketManager.Instance.isLogin)
			{
				//选择的服务器和当前连接的服务器相同，直接进入主界面
				StateManager.setState(StateType.MAIN);
			}
			else if(info.State == 5)
			{
				
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.serverlist.ServerListPosView.full"),true);
				//AlertDialog.show("提示","人数已满，请选择其他服务器!",true);
			}
			else if(info.State == 1)
			{
				
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.serverlist.ServerListPosView.maintenance"),true);
				//AlertDialog.show("提示","该服务器在维护中，请选择其他服务器!",true);
			}
			else
			{
				WaitingView.instance.show(WaitingView.LOGIN);
				SocketManager.Instance.isLogin = false;
				SocketManager.Instance.connect(info.IP,info.Port);
				PlayerManager.Instance.Self.resetProps();
			}
		}
		
		private function __closeF11(event:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			f11Cite_mc.play();
			LanguageMgr.GetTranslation("ddt.serverlist.ServerListPosView.close")
		}
		
		private function __ok(event:MouseEvent):void
		{
			tryLoginServer();
			SoundManager.Instance.play("008");
		}	
		
		private function __exit(event:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			//if(LeavePage.IsDesktopApp)
			//{
			//	ExternalInterface.call("WindowReturn");
			//	return;
			//}
			//if(ExternalInterface.available && PathManager.solveAllowPopupFavorite())
			//{
			//	if(PlayerManager.Instance.Self.IsFirst <= 1)
			//	{
			//		ExternalInterface.call("setFavorite",PathManager.solveLogin(),BellowStripViewII.siteName,"3");
			//	}else
			//	{
			//		ExternalInterface.call("setFavorite",PathManager.solveLogin(),BellowStripViewII.siteName,"1");
			//	}
			//}
			//if(PathInfo.ISTOPDERIICT)
			//{
				var redirictURL:String = "function redict () {top.location.href=\""+"logout.aspx"+"\"}";
				ExternalInterface.call(redirictURL);
			//}
			//else
			//{
			//	navigateToURL(new URLRequest(PathManager.solveLogin()),"_self");
			//}
		}
	}
}