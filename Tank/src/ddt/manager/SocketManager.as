package ddt.manager
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import road.comm.ByteSocket;
	import road.comm.PackageIn;
	import road.comm.SocketEvent;
	import road.loader.LoaderSavingManager;
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HAlertDialog;
	
	import ddt.data.socket.ChurchPackageType;
	import ddt.data.socket.CrazyTankPackageType;
	import ddt.data.socket.HotSpringPackageType;
	import ddt.data.socket.ePackageType;
	import ddt.data.socket.WorldBossPackageType;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.socket.GameSocketOut;
	import ddt.states.StateType;
	import ddt.utils.LeavePage;
	import ddt.view.common.CheckCodePanel;

	public class SocketManager extends EventDispatcher
	{
		private var _socket:ByteSocket;
		
		private var _out:GameSocketOut;
		
		private var _isLogin:Boolean;
		
		public static const PACKAGE_CONTENT_START_INDEX:int = 20;
		public function set isLogin(value:Boolean):void
		{
			_isLogin = value;
		}
		
		public function get isLogin():Boolean
		{
			return _isLogin;
		}
		
		public function get socket():ByteSocket
		{
			return _socket;
		}
		
		public function get out():GameSocketOut
		{
			return _out;
		}
		
		public function SocketManager()
		{
			_socket = new ByteSocket();
			_socket.addEventListener(Event.CONNECT,__socketConnected);
			_socket.addEventListener(Event.CLOSE,__socketClose);
			_socket.addEventListener(SocketEvent.DATA,__socketData);
			_socket.addEventListener(ErrorEvent.ERROR,__socketError);
			
			_out = new GameSocketOut(_socket);
		}
		
		public function connect(ip:String,port:Number):void
		{
			_socket.connect(ip,port);
		}
		
		private function __socketConnected(event : Event) : void 
		{
			dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONNECT_SUCCESS));
			//登陆	
			//global.traceStr("sendLogin");
			out.sendLogin(PlayerManager.Instance.Account);
		}

		private function __socketClose(event : Event) : void 
		{
			if(StateManager.currentStateType != StateType.LOGIN)
			{
				StateManager.setState(StateType.SERVER_LIST);
			}
			CheckCodePanel.Instance.close();
			HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.manager.RoomManager.break"),true,gotoLogin,false,null,gotoLogin);
		}
		
		private function gotoLogin():void
		{
			LeavePage.LeavePageTo(PathManager.solveLogin(),"_self");
		}
		
		private function __socketError(event:ErrorEvent):void
		{
			HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.manager.RoomManager.false"),true,null,true);
			//AlertDialog.show("提示","连接失败",true,null,false);
			CheckCodePanel.Instance.close();
		}
		
		private function __sysOK():void
		{	
			SoundManager.Instance.play("008");
		}
		
		private function __socketData(event:SocketEvent):void
		{
			try
			{
				var pkg:PackageIn = event.data;
				//trace("......pkg.code......",pkg.code);
				switch(pkg.code)
				{
					//收到密码
					case ePackageType.RSAKEY:
						break;
					case ePackageType.SYS_MESSAGE:
						var type:int = pkg.readInt();
						var msg:String = pkg.readUTF();
						switch(type)
						{
							//普通消息,错误消息
							case 0:
								MessageTipManager.getInstance().show(msg);
								ChatManager.Instance.sysChatYellow(msg);
								break;
							case 1:
								MessageTipManager.getInstance().show(msg);
								ChatManager.Instance.sysChatRed(msg);
								break;
							//系统消息
							case 2:
								/**
								* 黄色的
								*/
								ChatManager.Instance.sysChatYellow(msg);							
								break;
							case 3:
								/**
								*红色 
								*/							
								ChatManager.Instance.sysChatRed(msg);
								break;
							case 4:
								HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,true,__sysOK,false);
								break;
							case 5:
								/**
								*每日奖励 
								*/
								ChatManager.Instance.sysChatYellow(msg);
								break;
							case 6:
								/**
								* 防御宝珠提示
								*/
//								ChatManagerII.getInstance().defenseTip(msg);
								break;
						}
						break;
					case ePackageType.DAILY_AWARD:
					     dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DAILY_AWARD,pkg));
					     break;
					case ePackageType.LOGIN:
	  					/*登陆结果 */
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOGIN,pkg));
						break;
					case ePackageType.KIT_USER:
					    /* 用户被踢下线 */
					    kitUser(pkg.readUTF());
					    break;
					case ePackageType.PING:
						out.sendPint();
						break	
					case ePackageType.EDITION_ERROR:
						cleanLocalFile(pkg.readUTF());
						break;
					case ePackageType.BAG_LOCKED:
					     /**背包锁的操作**/
					     dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BAG_LOCKED,pkg));
					     break;
					case ePackageType.CONSORTIA_EQUIP_CONTROL:
					     /***公会设备使用***/
					     dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_EQUIP_CONTROL,pkg));
					     break;
					case ePackageType.GAME_ROOMLIST_UPDATE:
						/* 创建的房间信息 */
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOMLIST_UPDATE,pkg));
						break;
					case ePackageType.ROOM_PASS:
						/* 创建的房间信息 */
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ROOMLIST_PASS,pkg));
						break;
					case ePackageType.SCENE_ADD_USER:
						/* 返回玩家列表信息 */
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_ADD_USER,pkg));
						break;
					case ePackageType.SCENE_REMOVE_USER:
						/* 场景中用户离开 */
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_REMOVE_USER,pkg));
						break;
					////////////////////////房间中的消息都加入队列中处理/////////////////////////////////////////
					case ePackageType.GAME_ROOM_ADDPLAYER:
						/* 发送指令让玩家进入房间 */
						QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_PLAYER_ENTER,pkg));
						break;
					case ePackageType.GAME_ROOM_UPDATE_PLACE:
					    /* 房间主人信息 */		
					    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_UPDATE_PLACE,pkg));
					    break;
					
					case ePackageType.GAME_ROOM_KICK:
						/* 踢人 */
						QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_KICK,pkg));
						break;
					case ePackageType.GAME_ROOM_REMOVEPLAYER:
						/* 退出房间 */
						QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_PLAYER_EXIT,pkg));
						break;
					case ePackageType.GAME_ROOM_LOGIN:
						/* 用户进入房间前是否成功 */
						QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_LOGIN,pkg));
						break;
					case ePackageType.GAME_ROOM_CREATE:
						/* 用户进入房间前是否成功 */
						QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_CREATE,pkg));
						break;
//					case ePackageType.GAME_ROOM_INFO:
//						/* 被邀请用户创建游戏信息 */
//						QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_INFO,pkg));
//						break;
//					case ePackageType.PLAY_INFO_IN_GAME:
//						QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_INFO_IN_GAME, pkg));
//						break;
					case ePackageType.GAME_TEAM:
						/* 组队 */
						QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_TEAM,pkg));
						break;
					case ePackageType.GAME_PLAYER_STATE_CHANGE:
						/*  玩家准备和取消 */
						QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_PLAYER_STATE_CHANGE,pkg));
						break;
					case ePackageType.GAME_CMD:
						/*  游戏中的协议 */
						createGameEvent(pkg);
						break;
					case ePackageType.GAME_PICKUP_FAILED:
						/*  戳和失败 */
						QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_WAIT_FAILED,pkg));
						break;
					case ePackageType.GAME_PICKUP_CANCEL:
						/* 撮合取消*/
						QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_AWIT_CANCEL,pkg));
						break;
					case ePackageType.GAME_PICKUP_STYLE:
						/* 撮合战类型*/
						QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GMAE_STYLE_RECV,pkg));
						break;
					case ePackageType.GAME_PICKUP_WAIT:
						/* 等待戳和返回*/
						QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_WAIT_RECV,pkg));
						break;
				
					case ePackageType.GAME_ROOM_SETUP_CHANGE:
						QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE,pkg));
						break;	
					////////////////////////////////////////////////////////////////////////////////////////
					case ePackageType.SCENE_CHANNEL_CHANGE:
						//更改场景聊天频道
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_CHANNEL_CHANGE,pkg));
						break;
					case ePackageType.SCENE_CHAT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_CHAT,pkg));
						break;
					case ePackageType.SCENE_FACE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_FACE,pkg));
						break;
					case ePackageType.DELETE_GOODS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DELETE_GOODS,pkg));
						break;
					case ePackageType.BUY_GOODS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUG_GOODS,pkg));
						break;
					case ePackageType.CHANGE_PLACE_GOODS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_GOODS_PLACE,pkg));
						break;	
					case ePackageType.CHAIN_EQUIP:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHAIN_EQUIP,pkg));
						break;
					case ePackageType.UNCHAIN_EQUIP:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UNCHAIN_EQUIP,pkg));
						break;		
					case ePackageType.SEND_MAIL:
					    /*发送邮件*/
					    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SEND_EMAIL,pkg));
					    break;
					case ePackageType.DELETE_MAIL:
						/*删除邮件*/
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DELETE_MAIL,pkg));
						break;
					case ePackageType.GET_MAIL_ATTACHMENT:
						/*取邮件*/
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_MAIL_ATTACHMENT,pkg));
						break;
					case ePackageType.MAIL_CANCEL:
						/*取邮件*/
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MAIL_CANCEL,pkg));
						break;	
					case ePackageType.SEll_GOODS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SELL_GOODS,pkg));
						break;	
					case ePackageType.UPDATE_MONEY:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_MONEY,pkg));
						break;
					case ePackageType.UPDATE_COUPONS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_COUPONS,pkg));
						break;
					case ePackageType.ITEM_STORE:
				    	dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_STORE,pkg));
				    break;
				    
					case ePackageType.UPDATE_PRIVATE_INFO:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_PRIVATE_INFO,pkg));
						break;
					case ePackageType.UPDATE_PLAYER_INFO:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_PLAYER_INFO,pkg));
						break;
					
					//case ePackageType.REPAIR_GOODS:
					//	dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REPAIR_GOODS,pkg));
					//	break;		
					
					case ePackageType.CONSORTIA_USER_GRADE_UPDATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_USER_GRADE_UPDATE,pkg));
						break;
					
					
					case ePackageType.GRID_PROP:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GRID_PROP,pkg));
						break;
					case ePackageType.EQUIP_CHANGE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.EQUIP_CHANGE,pkg));
						break;
					case ePackageType.GRID_GOODS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GRID_GOODS,pkg));
						break;
					
					case ePackageType.NETWORK:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.NETWORK,pkg));
						break;
					
					case ePackageType.GAME_TAKE_TEMP:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_TAKE_TEMP,pkg));
						break;
					
					case ePackageType.SCENE_USERS_LIST:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_USERS_LIST,pkg));
						break;
					case ePackageType.GAME_INVITE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_INVITE,pkg));
						break;
					case ePackageType.UPDATE_GP:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_GP,pkg));
						break;
					case ePackageType.S_BUGLE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.S_BUGLE,pkg));
						break;
					case ePackageType.B_BUGLE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.B_BUGLE,pkg));	
						break;
					case ePackageType.C_BUGLE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.C_BUGLE,pkg));	
						break;
					case ePackageType.DEFY_AFFICHE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DEFY_AFFICHE,pkg));
						break;
					case ePackageType.CHAT_PERSONAL:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHAT_PERSONAL,pkg));
						break;
					case ePackageType.FRIEND_ADD:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_ADD,pkg));
						break;
					case ePackageType.FRIEND_REMOVE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_REMOVE,pkg));
						break;
					case ePackageType.FRIEND_UPDATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_UPDATE,pkg));
						break;
					case ePackageType.FRIEND_STATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_STATE,pkg));
						break;
					case ePackageType.ITEM_COMPOSE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_COMPOSE,pkg));
						break;
					case ePackageType.ITEM_STRENGTHEN:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_STRENGTH,pkg));
						break;	
					case ePackageType.ITEM_TRANSFER:
					//转移
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_TRANSFER,pkg));
						break;	
					case ePackageType.ITEM_FUSION_PREVIEW:
					//这里是熔炼的预览
					    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_FUSION_PREVIEW,pkg));
					    break;
				    case ePackageType.ITEM_REFINERY_PREVIEW:
				    	dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_REFINERY_PREVIEW,pkg));
				    	break;
			    	case ePackageType.ITEM_REFINERY:
			    		dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_REFINERY,pkg));
			    		break;
			    	case ePackageType.ITEM_INLAY:
			    		dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_EMBED,pkg));
			    		break;
					case ePackageType.ITEM_FUSION:
					    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_FUSION,pkg));
					    break;
					case ePackageType.FRIEND_RESPONSE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_RESPONSE,pkg));	
						break;
					/**
					 * 任务
					 * */
					case ePackageType.QUEST_UPDATE:
//						trace("QUEST_UPDATE");
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_UPDATE,pkg));
						break;
					case ePackageType.QUSET_OBTAIN:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_OBTAIN,pkg));
						break;
					
					case ePackageType.QUEST_CHECK:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_CHECK,pkg));
						break;
					case ePackageType.QUEST_FINISH:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_FINISH,pkg));
						break;
						
					case ePackageType.ITEM_OBTAIN:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_OBTAIN,pkg));
						break;
					case ePackageType.ITEM_CONTINUE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_CONTINUE,pkg));
						break;
					case ePackageType.SYS_DATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SYS_DATE,pkg));
						break;
					case ePackageType.ITEM_EQUIP:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_EQUIP,pkg));
						break;
					case ePackageType.SYS_NOTICE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SYS_NOTICE,pkg));
						break;
					case ePackageType.MAIL_RESPONSE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MAIL_RESPONSE,pkg));
						break;
					case ePackageType.AUCTION_REFRESH:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AUCTION_REFRESH,pkg));
						break;
						
					case ePackageType.CHECK_CODE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHECK_CODE,pkg));
						break;
					/******************************公会***********************************/
					case ePackageType.CONSORTIA_RESPONSE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_RESPONSE,pkg));
						break;
					case ePackageType.CONSORTIA_CREATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_CREATE,pkg));
						break;
					case ePackageType.CONSORTIA_TRYIN_DEL:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_TRYIN_DEL,pkg));
						break;
					case ePackageType.CONSORTIA_TRYIN:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_TRYIN,pkg));
						break;
					case ePackageType.CONSORTIA_ALLY_APPLY_UPDATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_ALLY_APPLY_UPDATE,pkg));
						break;
					case ePackageType.CONSORTIA_ALLY_APPLY_DELETE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_ALLY_APPLY_DELETE,pkg));
						break;
					case ePackageType.CONSORTIA_ALLY_APPLY_ADD:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_ALLY_APPLY_ADD,pkg));
						break;
					case ePackageType.CONSORTIA_CHAIRMAN_CHAHGE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_CHAIRMAN_CHAHGE,pkg));
						break;
					case ePackageType.CONSORTIA_TRYIN_PASS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_TRYIN_PASS,pkg));
						break;
					case ePackageType.CONSORTIA_ALLY_UPDATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_ALLY_UPDATE,pkg));
						break;
					case ePackageType.CONSORTIA_LEVEL_UP:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_LEVEL_UP,pkg));
						break;	
					case ePackageType.CONSORTIA_SHOP_UPGRADE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_SHOP_UPGRADE,pkg));
						break;	
					case ePackageType.CONSORTIA_SMITH_UPGRADE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_SMITH_UPGRADE,pkg));
						break;	
					case ePackageType.CONSORTIA_STORE_UPGRADE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_STORE_UPGRADE,pkg));
						break;					
					case ePackageType.CONSORTIA_PLACARD_UPDATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_PLACARD_UPDATE,pkg));
						break;
					case ePackageType.CONSORTIA_DESCRIPTION_UPDATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_DESCRIPTION_UPDATE,pkg));
						break;
					case ePackageType.CONSORTIA_DISBAND:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_DISBAND,pkg));
						break;
					case ePackageType.CONSORTIA_APPLY_STATE:
					    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_APPLY_STATE,pkg));
					    break;
					case ePackageType.CONSORTIA_INVITE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_INVITE,pkg));
						break;
					case ePackageType.CONSORTIA_INVITE_PASS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_INVITE_PASS,pkg));
						break;
					case ePackageType.CONSORTIA_RENEGADE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_RENEGADE,pkg));
						break;
					case ePackageType.CONSORTIA_DUTY_DELETE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_DUTY_DELETE,pkg));
						break;
					case ePackageType.CONSORTIA_DUTY_UPDATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_DUTY_UPDATE,pkg));
						break;
					case ePackageType.CONSORTIA_BANCHAT_UPDATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_BANCHAT_UPDATE,pkg));
						break;
					case ePackageType.CONSORTIA_USER_REMARK_UPDATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_USER_REMARK_UPDATE,pkg));
						break;
					case ePackageType.CONSORTIA_CHAT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_CHAT,pkg));
						break;
					case ePackageType.CONSORTIA_RICHES_OFFER:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_RICHES_OFFER,pkg));
						break;
					case ePackageType.CONSORTIA_MAIL_MESSAGE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_MAIL_MESSAGE,pkg));
						//trace("...........你退出了工会.......");
						break;
					/**
					 * 防沉迷
					 * */
					case ePackageType.CID_CHECK:
					    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CID_CHECK,pkg));
					    break;
					case ePackageType.ENTHRALL_LIGHT:
					    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ENTHRALL_LIGHT,pkg));
					    break;
					/**
					 * buff信息
					 * */
					case ePackageType.BUFF_OBTAIN:
					    if(pkg.clientId == PlayerManager.Instance.Self.ID)
					    {
					    	dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_OBTAIN,pkg));
					    }else
					    {
					    	QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_OBTAIN,pkg));
					    }
					    break;
					case ePackageType.BUFF_ADD:
					    if(pkg.clientId == PlayerManager.Instance.Self.ID)
					    {
					    	dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_ADD,pkg));
					    }else
					    {
					    	QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_ADD,pkg));
					    }
					    break;
					case ePackageType.BUFF_UPDATE:
					    if(pkg.clientId == PlayerManager.Instance.Self.ID)
					    {
					    	dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_UPDATE,pkg));
					    }else
					    {
					    	QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_UPDATE,pkg));
					    }
					    break;
					/**
					 * 使用变色卡
					 * */
					case ePackageType.USE_COLOR_CARD:
					    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USE_COLOR_CARD,pkg));
					    break;
					    
					/**
					 * 返回竞拍成功与否
					 * */
					case ePackageType.AUCTION_UPDATE:
					    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AUCTION_UPDATE,pkg));
					    break;
					
					/**
					 * 商城赠送
					 */    
					case ePackageType.GOODS_PRESENT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GOODS_PRESENT,pkg));
						break;
					case ePackageType.GOODS_COUNT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GOODS_COUNT,pkg));
						break;

					/* 民政中心 */
					case ePackageType.MARRYINFO_GET:
					    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRYINFO_GET,pkg));
					    break;
					/***************************************************************************************/

					/*********************************结婚系统相关********************************************/
					case ePackageType.MARRY_STATUS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_STATUS,pkg));
						break;
					case ePackageType.MARRY_ROOM_CREATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_CREATE,pkg));
						break;
					case ePackageType.MARRY_ROOM_LOGIN:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_LOGIN,pkg));
						break;
					case ePackageType.MARRY_SCENE_LOGIN:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_SCENE_LOGIN,pkg));
						break;
					case ePackageType.PLAYER_ENTER_MARRY_ROOM:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_ENTER_MARRY_ROOM,pkg));
						break;
					case ePackageType.PLAYER_EXIT_MARRY_ROOM:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_EXIT_MARRY_ROOM,pkg));
						break;
					case ePackageType.MARRY_APPLY:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_APPLY,pkg));
						break;
					case ePackageType.MARRY_APPLY_REPLY:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_APPLY_REPLY,pkg));
						break;
					case ePackageType.DIVORCE_APPLY:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DIVORCE_APPLY,pkg));
						break;
					case ePackageType.MARRY_ROOM_STATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_STATE,pkg));
						break;
					case ePackageType.MARRY_ROOM_DISPOSE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_DISPOSE,pkg));
						break;
					case ePackageType.MARRY_ROOM_UPDATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_UPDATE,pkg));
						break;
					case ePackageType.MARRYPROP_GET:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRYPROP_GET,pkg));
						break;
					case ePackageType.MARRY_CMD:
						createChurchEvent(pkg);
						break;
					case ePackageType.AMARRYINFO_REFRESH:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AMARRYINFO_REFRESH,pkg));
						break;
					case ePackageType.MARRYINFO_ADD:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRYINFO_ADD,pkg));
						break;
					case ePackageType.LINKREQUEST_GOODS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LINKGOODSINFO_GET,pkg));
						break;
					case CrazyTankPackageType.INSUFFICIENT_MONEY:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.INSUFFICIENT_MONEY,pkg));
						break;
					case ePackageType.GET_ITEM_MESS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_ITEM_MESS,pkg));
						break;
						
					case ePackageType.USER_ANSWER:
					    dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_ANSWER,pkg));
					    break;
					case ePackageType.MARRY_SCENE_CHANGE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_SCENE_CHANGE,pkg));
						break;
					//*********温泉系统开始 *********	
					case ePackageType.HOTSPRING_CMD:
						createHotSpringEvent(pkg);
						break;
					case ePackageType.HOTSPRING_ROOM_CREATE://玩家创建房间成功
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_CREATE,pkg));
						break;
					case ePackageType.HOTSPRING_ROOM_ENTER://进入房间成功
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_ENTER,pkg));
						break;
					case ePackageType.HOTSPRING_ROOM_ADD_OR_UPDATE://增加或更新房间
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_ADD_OR_UPDATE,pkg));
						break;
					case ePackageType.HOTSPRING_ROOM_REMOVE://温泉房间列表移除房间
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_REMOVE,pkg));
						break;
					case ePackageType.HOTSPRING_ROOM_LIST_GET://取得温泉房间列表  
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_LIST_GET,pkg));
						break;
					case ePackageType.HOTSPRING_ROOM_PLAYER_ADD://温泉房间内加入一个玩家
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_ADD,pkg));
						break;	
					case ePackageType.HOTSPRING_ROOM_PLAYER_REMOVE://玩家退出房间 /房间内移除玩家
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_REMOVE,pkg));
						break;
					case ePackageType.HOTSPRING_ROOM_PLAYER_REMOVE_NOTICE://玩家退出房间后广播给房间内其它玩家  
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_REMOVE_NOTICE,pkg));
						break;
					case ePackageType.HOTSPRING_ROOM_ENTER_CONFIRM://进入房间的确认
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_ENTER_CONFIRM,pkg));
						break;
					//*********温泉系统结束 *********

					
					case ePackageType.GET_TIME_BOX:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_TIME_BOX,pkg));
						break;

					//**********成就系统*************
					case ePackageType.ACHIEVEMENT_UPDATE://更新成就进度
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACHIEVEMENT_UPDATE,pkg));
						break;
					case ePackageType.ACHIEVEMENT_FINISH://成就完成
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACHIEVEMENT_FINISH,pkg));
						break;
					case ePackageType.ACHIEVEMENT_INIT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACHIEVEMENT_INIT,pkg));
						break;
					case ePackageType.ACHIEVEMENTDATA_INIT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACHIEVEMENTDATA_INIT,pkg));
						break;
					case ePackageType.FIGHT_NPC:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_NPC,pkg));
						break;

					//************轮盘宝箱****************
					//case ePackageType.LOTTERY_ALTERNATE_LIST:
					//	dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOTTERY_ALTERNATE_LIST , pkg));
					//	break;
					//case ePackageType.LOTTERY_GET_ITEM:
					////	dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOTTERY_GET_ITEM , pkg));
						break;

					//case ePackageType.LOOKUP_EFFORT:
					//	dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOOKUP_EFFORT,pkg));
					//	break;

					
					//*********投诉反馈系统开始 *********
					case ePackageType.FEEDBACK_REPLY://取得回复
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FEEDBACK_REPLY,pkg));
						break;
					//*********投诉反馈系统结束*********
					
					case ePackageType.VIP_UPDATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.VIP_UPDATE,pkg));
						break;
					
					
					case ePackageType.WORLDBOSS_JOIN:
					{
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_JOIN,pkg));
						break;
					}

					
					default:
						break;
				}
			}
			catch(err:Error)
			{
//				trace("error:"+err.message +"\r\n"+err.getStackTrace());
				SocketManager.Instance.out.sendErrorMsg(err.message +"\r\n"+err.getStackTrace());
			}
		}
		
		
		
		
		private function kitUser(msg:String):void
		{
			_socket.close();
			if(msg.indexOf(LanguageMgr.GetTranslation("ddt.manager.SocketManager.copyRight")) != -1)
			//if(msg.indexOf("版本") != -1)
			{
				LoaderSavingManager.clearFiles("*.swf");
			}
			StateManager.setState(StateType.SERVER_LIST);				//[frank 2009-04-04]解决：加载房间的时候被KICK
			HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,true,gotoLogin,false,null,gotoLogin);
		}
		
		private function cleanLocalFile(msg:String):void
		{
			_socket.close();
			LoaderSavingManager.clearFiles("*.swf");
			StateManager.setState(StateType.SERVER_LIST);
			HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,true,gotoLogin,false);
			
		}
		
		private function createChurchEvent(pkg:PackageIn):void
		{
			var cmd:int = pkg.readByte();
			var event:CrazyTankSocketEvent = null;
			switch(cmd)
			{
				case ChurchPackageType.MOVE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.MOVE,pkg);
					break;
				case ChurchPackageType.HYMENEAL:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.HYMENEAL,pkg);
					break;
				case ChurchPackageType.CONTINUATION:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CONTINUATION,pkg);
					break;
				case ChurchPackageType.INVITE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.INVITE,pkg);
					break;
				case ChurchPackageType.USEFIRECRACKERS:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.USEFIRECRACKERS,pkg);
					break;
				case ChurchPackageType.HYMENEAL_STOP:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.HYMENEAL_STOP,pkg);
					break;
				case ChurchPackageType.GUNSALUTE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GUNSALUTE,pkg);
					break
				default:
					break;
			}
			if(event)
			{
				dispatchEvent(event);
			}
		}
		
		/**
		 * 温泉子协议
		 */		
		private function createHotSpringEvent(pkg:PackageIn):void
		{
			var cmd:int = pkg.readByte();
			var event:CrazyTankSocketEvent = null;
			switch(cmd)
			{
				case HotSpringPackageType.TARGET_POINT://玩家要移动到的目标点
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_TARGET_POINT,pkg);
					break;
				case HotSpringPackageType.HOTSPRING_ROOM_RENEWAL_FEE://通知玩家续费
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_RENEWAL_FEE,pkg));
					break;
				case HotSpringPackageType.HOTSPRING_ROOM_INVITE://邀请进入温泉房间
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_INVITE,pkg);
					break;
				case HotSpringPackageType.HOTSPRING_ROOM_TIME_UPDATE://房间时间更新
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_TIME_UPDATE,pkg);
					break;
				case HotSpringPackageType.HOTSPRING_ROOM_PLAYER_CONTINUE://系统房间刷新时，针对于玩家的继续提示(扣费)
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_CONTINUE,pkg);
					break;
				default:
					break;
			}
			if(event)
			{
				dispatchEvent(event);
			}
		}		
		
		
		/**
		 * 发布游戏事件 
		 * 
		 */	
		private function createGameEvent(pkg:PackageIn):void
		{
			var cmd:int = pkg.readUnsignedByte();
			var event:CrazyTankSocketEvent = null;
			switch(cmd)
			{
				case CrazyTankPackageType.GEM_GLOW:
				     event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GEM_GLOW,pkg);
				     break;
				case CrazyTankPackageType.SEND_PICTURE:
				     event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SEND_PICTURE,pkg);
				     break;
				case CrazyTankPackageType.GAME_MISSION_START:
					 event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_START,pkg);
				     break;
				case CrazyTankPackageType.GAME_MISSION_PREPARE:
					 event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_PREPARE,pkg);
					 break;
				case CrazyTankPackageType.UPDATE_BOARD_STATE:
				     event = new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_BOARD_STATE,pkg);
				     break;
				case CrazyTankPackageType.ADD_MAP_THING:
				     event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_MAP_THING,pkg);
				     break;
				case CrazyTankPackageType.BARRIER_INFO:
				     event = new CrazyTankSocketEvent(CrazyTankSocketEvent.BARRIER_INFO,pkg);
				     break;
				case CrazyTankPackageType.GAME_CREATE:
						/* 创建游戏		*/
						QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_CREATE,pkg));
						break;
				case CrazyTankPackageType.START_GAME:
						/*   游戏开始  */
						QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_START,pkg));
						break;
				case CrazyTankPackageType.WANNA_LEADER:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_WANNA_LEADER,pkg);
					break;
					
				case CrazyTankPackageType.GAME_LOAD:
					/* 开始加载 */
					//global.traceStr("createGameEvent");
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_LOAD,pkg));
					break;
				case CrazyTankPackageType.GAME_MISSION_INFO:
				    /**关卡信息*/
				    QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_INFO,pkg));
				    break;
				case CrazyTankPackageType.GAME_OVER:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_OVER,pkg));
					break;
				case CrazyTankPackageType.MISSION_OVE:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.MISSION_OVE,pkg));
					break;
				case CrazyTankPackageType.GAME_ALL_MISSION_OVER:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ALL_MISSION_OVER,pkg));
					break;
				case CrazyTankPackageType.DIRECTION:
					/*  改变方向  */
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.DIRECTION_CHANGED,pkg);
					break;
				case CrazyTankPackageType.GUN_ROTATION:
				    /* 枪的角度改变 */
				   	event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_GUN_ANGLE,pkg);
				    break;
				case CrazyTankPackageType.FIRE:
					/* 开火　*/
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_SHOOT,pkg);
					break;
				case CrazyTankPackageType.SYNC_LIFETIME:
					QueueManager.setLifeTime(pkg.readInt());
					break;
				case CrazyTankPackageType.MOVESTART:
					/* 开始移动　*/
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_START_MOVE,pkg);
					break;
				case CrazyTankPackageType.MOVESTOP:
					/* 停止移动　*/
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_STOP_MOVE,pkg);
					break;
				case CrazyTankPackageType.TURN:
//					DebugUtil.debugText("======================================================");
//					DebugUtil.debugText("pkg: TURN st:"+pkg.extend2+"ct:"+QueueManager.lifeTime);
					/* 换人　*/
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_CHANGE,pkg);
					break;
				case CrazyTankPackageType.HEALTH:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_BLOOD,pkg);
					break;
				case CrazyTankPackageType.FROST:
					/*冰冻*/
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_FROST,pkg);
					break;
				case CrazyTankPackageType.NONOLE:
				    /**免坑**/
				    event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_NONOLE,pkg);
				    break;
				case CrazyTankPackageType.CHANGE_STATE:
					/**状态改变**/
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_STATE,pkg);
					break;
				case CrazyTankPackageType.LOCK_STATE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LOCK_STATE,pkg);
					break;
				case CrazyTankPackageType.INVINCIBLY:
					/* 无敌 */
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_INVINCIBLY,pkg);
					break;
				case CrazyTankPackageType.VANE:
					/* 改变风向 */
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_VANE,pkg);
					break;
				case CrazyTankPackageType.HIDE:
					/* 团隐或自己隐身 */
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_HIDE,pkg);
					break;
				case CrazyTankPackageType.CARRY:
					/* 传送 */
					//event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_CARRY,pkg);
					break;
				case CrazyTankPackageType.BECKON:
					/*　召唤　*/
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_BECKON,pkg);
					break;
				
				case CrazyTankPackageType.FIGHTPROP:
					/*检箱子*/
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_FIGHT_PROP,pkg);
					break;
				case CrazyTankPackageType.STUNT:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_STUNT,pkg);
					break;
				case CrazyTankPackageType.PROP:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_PROP,pkg);
					break;
				case CrazyTankPackageType.DANDER:
					/*怒气值*/
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_DANDER,pkg);
					break;
				case CrazyTankPackageType.LOAD:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LOAD,pkg);
					break;
				case CrazyTankPackageType.ADDATTACK:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_ADDATTACK,pkg);
					break;
				case CrazyTankPackageType.ADDBALL:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_ADDBAL,pkg);
					break;
				case CrazyTankPackageType.SHOOTSTRAIGHT:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOOTSTRAIGHT,pkg);
					break;
				case CrazyTankPackageType.SUICIDE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SUICIDE,pkg);
					break;
//				case CrazyTankPackageType.TEMP_INVENTORY:
//					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.TEMP_INVENTORY,pkg);
//					break;
				case CrazyTankPackageType.FIRE_TAG:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_SHOOT_TAG,pkg);
					break;
				case CrazyTankPackageType.CHANGE_BALL:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_BALL,pkg);
					break;
				case CrazyTankPackageType.PICK:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_PICK_BOX,pkg);
					break;
				case CrazyTankPackageType.BLAST:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.BOMB_DIE,pkg);
					break;
				
				case CrazyTankPackageType.BEAT:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_BEAT,pkg);
					break;
				case CrazyTankPackageType.DISAPPEAR:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.BOX_DISAPPEAR,pkg);
					break;
				case CrazyTankPackageType.TAKE_CARD:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_TAKE_OUT,pkg);
					break;
					
				case CrazyTankPackageType.ADD_LIVING:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_LIVING,pkg);
					break;
				case CrazyTankPackageType.PLAY_MOVIE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_MOVIE,pkg);
					break;
				case CrazyTankPackageType.PLAY_SOUND:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_SOUND,pkg);
					break;
				case CrazyTankPackageType.LOAD_RESOURCE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LOAD_RESOURCE,pkg);
					break;
				case CrazyTankPackageType.ADD_MAP_THINGS:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_MAP_THINGS,pkg);
					break;	
				case CrazyTankPackageType.LIVING_BEAT:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_BEAT,pkg);
					break;
				case CrazyTankPackageType.LIVING_FALLING:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_FALLING,pkg);
					break;
				case CrazyTankPackageType.LIVING_JUMP:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_JUMP,pkg);
					break;
				case CrazyTankPackageType.LIVING_MOVETO:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_MOVETO,pkg);
					break;
				case CrazyTankPackageType.LIVING_SAY:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_SAY,pkg);
					break;
				case CrazyTankPackageType.LIVING_RANGEATTACKING:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_RANGEATTACKING,pkg);
					break;
				case CrazyTankPackageType.SHOW_CARDS:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOW_CARDS,pkg);
					break;
				case CrazyTankPackageType.FOCUS_ON_OBJECT:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.FOCUS_ON_OBJECT,pkg);
					break;
//				case CrazyTankPackageType.PAYMENT_TAKE_CARD:
//					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PAYMENT_TAKE_CARD,pkg);
//					break;
				case CrazyTankPackageType.GAME_MISSION_TRY_AGAIN:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_TRY_AGAIN, pkg);
					break;
				case CrazyTankPackageType.PLAY_INFO_IN_GAME:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_INFO_IN_GAME, pkg);
					QueueManager.setLifeTime(pkg.extend2);
					break;
				case CrazyTankPackageType.GAME_ROOM_INFO:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_INFO, pkg);
					break;
				case CrazyTankPackageType.ADD_TIP_LAYER:
				    event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_TIP_LAYER, pkg);
				    break;
				case CrazyTankPackageType.PLAY_ASIDE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_ASIDE, pkg);
					break;
				case CrazyTankPackageType.FORBID_DRAG:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.FORBID_DRAG,pkg);
					break;
				case CrazyTankPackageType.TOP_LAYER:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.TOP_LAYER,pkg);
					break;
				case CrazyTankPackageType.CONTROL_BGM:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CONTROL_BGM,pkg);
					break;
				case CrazyTankPackageType.USE_DEPUTY_WEAPON:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.USE_DEPUTY_WEAPON,pkg);
					break;
				case CrazyTankPackageType.FIGHT_LIB_INFO_CHANGE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_LIB_INFO_CHANGE,pkg);
					break;
				case CrazyTankPackageType.POPUP_QUESTION_FRAME:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.POPUP_QUESTION_FRAME,pkg);
					break;
				case CrazyTankPackageType.PASS_STORY:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOW_PASS_STORY_BTN,pkg);
					break;
				case CrazyTankPackageType.LIVING_BOLTMOVE:
					/* 开始加载 */
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_BOLTMOVE,pkg));
					break;
				case CrazyTankPackageType.CHANGE_TARGET:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_TARGET,pkg);
					break;
				default:
					break;
			}
			if(event)
				QueueManager.addQueue(event);
		}
		
		private static var _instance:SocketManager;
		public static function get Instance() : SocketManager
		{
			if(_instance == null)
			{
				_instance = new SocketManager();
			}
			return _instance;
		}
	}
}