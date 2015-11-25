package ddt.loginstate
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import road.ui.controls.hframe.HAlertDialog;
	import road.ui.manager.TipManager;
	
	import ddt.data.ServerInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.ItemManager;
	import ddt.manager.JSHelper;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ServerManager;
	import ddt.manager.ShopManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StateManager;
	import ddt.request.LoadServerListAction;
	import ddt.request.LoginAction;
	import ddt.request.LoginSelectList;
	import ddt.serverlist.ServerListView;
	import ddt.states.StateType;
	import ddt.utils.LeavePage;
	import ddt.view.common.WaitingView;

	public class LoginPosView extends Sprite
	{
		private static var stageLayer:DisplayObjectContainer;
		public function LoginPosView()
		{
			initView();

		}
		
		private function initView():void
		{			
			graphics.beginFill(0x000000,1);
			graphics.drawRect(0,0,1100,700);
			graphics.endFill();
			WaitingView.instance.show(WaitingView.DEFAULT,"",false);
			new LoginSelectList(PlayerManager.Instance.Account.Account).loadSync(onLoadCharListReturn);
		}
		
		private function chooeseComplete(e:Event):void
		{
			e.target.dispose();
			new LoginAction(PlayerManager.Instance.Account,e.target.LoginNickName).loadSync(__complete,3);
		}
		private function onLoadCharListReturn(loader:LoginSelectList):void
		{
			trace("onLoadCharListReturn")
			if(loader.list == null)
			{
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.loginstate.loginURLFail"),true,errorOkCallBack,true,null,errorOkCallBack);
			}
			var list:Array = loader.list;
			if(list.length <= 0) 
			{
				new LoginAction(PlayerManager.Instance.Account,"").loadSync(__complete);
				return;
			}
			if(list.length == 1 && list[0].Rename == false && list[0].ConsortiaRename == false)
			{
				new LoginAction(PlayerManager.Instance.Account,list[0].NickName).loadSync(__complete);
			}else
			{
				var chooeseFrame:ChooeseRoleFrame = new ChooeseRoleFrame();
				chooeseFrame.x = (1000 - chooeseFrame.width)/2;
				chooeseFrame.y = (600 - chooeseFrame.height)/2;
				chooeseFrame.drawBlack();
				chooeseFrame.info = list;
				chooeseFrame.addEventListener(Event.COMPLETE,chooeseComplete);
				TipManager.addToStageLayer(chooeseFrame);
			}
		}
		
		private function errorOkCallBack():void
		{
			LeavePage.LeavePageTo(PathManager.solveLogin(),"_self");
		}
		private function __complete(loader:LoginAction):void
		{
			trace("__complete")
			if(loader.isSuccess)
			{
				JSHelper.setFavorite(PlayerManager.Instance.Self.IsFirst == 0);
				if(ItemManager.Instance.goodsTemplates == null)
				{
					ItemManager.Instance.addEventListener("templateReady",__waitForItemTemplate);
				}
				else
				{
					__waitForItemTemplate(null);
				}
			}
		}
		
		private function __waitForItemTemplate(event:Event):void
		{
			trace("__waitForItemTemplate")
			if(ShopManager.Instance.initialized == false)
			{
				ShopManager.Instance.addEventListener("shopManagerReady",__waitForShopGoods);
			}else
			{
				__waitForShopGoods(null);
			}
		}
		
		private function __waitForShopGoods(evt:Event):void
		{
			trace("__waitForShopGoods")
			new LoadServerListAction().loadSync(loadServerListComplete,6);
		}
		
		private function loadServerListComplete(loader:LoadServerListAction):void
		{
			trace("loadServerListComplete")
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOGIN,__loginComplete);
			//searchAvailableServer();
			//if(_currentServerInfo)
			//{
			//	trace("_currentServerInfo")
			//	SocketManager.Instance.isLogin = false;
			//	SocketManager.Instance.connect(_currentServerInfo.IP,_currentServerInfo.Port);
			//	PlayerManager.Instance.Self.resetProps();
			//}else
			//{
				createView();
			//}
		}
		
		private var _currentServerInfo:ServerInfo;
		private function searchAvailableServer():void
		{
			trace("searchAvailableServer")
			var serverInfoList:Array = ServerManager.Instance.list;
			var player:PlayerInfo = PlayerManager.Instance.Self;
			/** 连接特定服务器 */
			//_currentServerInfo = ServerManager.Instance.current = serverInfoList[9];return;
			if(PathManager.solveServerListIndex() != -1)
			{
				_currentServerInfo = ServerManager.Instance.current = serverInfoList[PathManager.solveServerListIndex()];
				return;
			}else
			{
				for(var i:int = 0;i<serverInfoList.length;i++)
				{
					if(serverInfoList[i].State != 1 && serverInfoList[i].State != 5 && player.Grade >= serverInfoList[i].LowestLevel)
					{
						_currentServerInfo = ServerManager.Instance.current = serverInfoList[i];
						break;
					}
				}
			}
		}
		
		internal function dispose():void
		{
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LOGIN,__loginComplete);
			WaitingView.instance.hide();
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		
		private function __loginComplete(event:CrazyTankSocketEvent):void
		{
			ServerListView.onLoginComplete(event);
		}
		
		private function createView():void
		{
			PlayerManager.Instance.Self.loadPlayerItem();
			StateManager.setState(StateType.SERVER_LIST);
		}
		
	}
}