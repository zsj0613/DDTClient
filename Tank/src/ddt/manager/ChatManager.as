package ddt.manager
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	
	import road.comm.PackageIn;
	import road.comm.PackageOut;
	import road.ui.controls.hframe.HAlertDialog;
	import road.utils.StringHelper;
	
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.socket.ePackageType;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.utils.Helpers;
	import ddt.view.chatsystem.ChatData;
	import ddt.view.chatsystem.ChatEvent;
	import ddt.view.chatsystem.ChatFormats;
	import ddt.view.chatsystem.ChatHelper;
	import ddt.view.chatsystem.ChatInputView;
	import ddt.view.chatsystem.ChatModel;
	import ddt.view.chatsystem.ChatOutputView;
	import ddt.view.chatsystem.ChatView;
	import ddt.view.chatsystem.chat_system;
	import ddt.view.shop.ShopBugleFrame;
	
	use namespace chat_system;

	/**
	 * the the control set of the chat module
	 * @author Herman
	 * 
	 */	
	public final class ChatManager extends EventDispatcher
	{
		public static var isInGame:Boolean = false;
		
		public static const CHAT_CHURCH_CHAT_VIEW:int = 11;
		public static const CHAT_CLUB_STATE:int = 2;
		public static const CHAT_CONSORTIA_CHAT_VIEW:int = 12;
		public static const CHAT_CONSORTIA_ALL:int = 13;
		public static const CHAT_CIVIL_VIEW:int = 14;
		public static const CHAT_TOFFLIST_VIEW:int = 15;
		public static const CHAT_SHOP_STATE:int = 16;
		public static const CHAT_HOTSPRING_VIEW:int = 17;
		public static const CHAT_DUNGEONLIST_STATE:int = 7;
		public static const CHAT_GAMEOVER_STATE:int = 8;
		public static const CHAT_GAME_LOADING:int = 9;
		public static const CHAT_DUNGEON_STATE:int = 10;
		public static const CHAT_GAME_STATE:int = 1;
		public static const CHAT_HALL_STATE:int = 0;
		public static const CHAT_ROOMLIST_STATE:int = 6;
		public static const CHAT_ROOM_STATE:int = 5;
		public static const CHAT_WEDDINGLIST_STATE:int = 3;
		public static const CHAT_WEDDINGROOM_STATE:int = 4;
		
		/**
		 *温泉房间内聊天 (点卷房)
		 */		
		public static const CHAT_HOTSPRING_ROOM_VIEW:int = 18;
		
		/**
		 *温泉房间内聊天(金币房)
		 */
		public static const CHAT_HOTSPRING_ROOM_GOLD_VIEW:int = 19;
		
		public static var SHIELD_NOTICE:Boolean = false;
		
		private static var _instance:ChatManager;

		public static function get Instance():ChatManager
		{
			if(_instance == null) 
			{
				_instance = new ChatManager();
			}
			return _instance;
		}
		
		private var _chatView:ChatView;
		private var _model:ChatModel;
		private var _state:int = -1;
		private var _visibleSwitchEnable:Boolean = false;
		private var shopBugle : ShopBugleFrame;
		
		public function chat(data:ChatData,needFormat:Boolean = true):void
		{
			
			if(chatDisabled){
				return;
			}
			if(needFormat)ChatFormats.formatChatStyle(data);
			data.htmlMessage =Helpers.deCodeString(data.htmlMessage);
			_model.addChat(data);
		}
		
		public function get input():ChatInputView
		{
			return _chatView.input;
		}
		
		public function set inputChannel(channel:int):void
		{
			_chatView.input.channel = channel;
		}
		
		public function get lock():Boolean
		{
			return _chatView.output.isLock;
		}
		
		public function set lock(value:Boolean):void
		{
			_chatView.output.isLock = value;
		}
		
		public function get model():ChatModel
		{
			return _model;
		}
		
		public function get output():ChatOutputView
		{
			return _chatView.output;
		}
		
		public function set outputChannel(channel:int):void
		{
			_chatView.output.channel = channel;
		}
		
		public function privateChatTo(nickname:String,id:int = 0):void
		{
			_chatView.input.setPrivateChatTo(nickname,id);
		}
		public function sendBugle(msg:String,type:int):void
		{

			if(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(type,true) <= 0)
			{
				if(ShopManager.Instance.getMoneyShopItemByTemplateID(type))
					input.setInputText(msg);
				sysChatYellow(LanguageMgr.GetTranslation("ddt.manager.ChatManager.tool"));
				if(shopBugle && !shopBugle.parent)
				{
					shopBugle = null;
				}
				
				if(!shopBugle)
				{
					shopBugle = new ShopBugleFrame();
					shopBugle.type = type;
				}
			}
			else
			{
				msg=Helpers.enCodeString(msg)
//				SharedManager.Instance.showInvateWindow = true;
				if(type == EquipType.T_SBUGLE)//小喇叭 small bugle
				{
					SocketManager.Instance.out.sendSBugle(msg);	
				}
				else if(type == EquipType.T_BBUGLE)//大喇叭 big bugle
				{
					SocketManager.Instance.out.sendBBugle(msg);
				}
				else if(type == EquipType.T_CBUGLE)	//跨区大喇叭
				{
					SocketManager.Instance.out.sendCBugle(msg);
				}
			}
		}
		
		
		public var chatDisabled:Boolean = false;//全局禁用聊天。
		
		public function sendChat($chat:ChatData):void
		{
			if(chatDisabled){
				return;
			}
			if($chat.channel == ChatInputView.PRIVATE)
			{
				sendPrivateMessage($chat.receiver,$chat.msg,$chat.receiverID);
			}else if($chat.channel == ChatInputView.CROSS_BUGLE)
			{
				sendBugle($chat.msg,EquipType.T_CBUGLE);
			}
			else if($chat.channel == ChatInputView.BIG_BUGLE)
			{
				sendBugle($chat.msg,EquipType.T_BBUGLE);
			}else if($chat.channel == ChatInputView.SMALL_BUGLE)
			{
				sendBugle($chat.msg,EquipType.T_SBUGLE);
			}
			else if($chat.channel == ChatInputView.CONSORTIA)
			{
				sendMessage($chat.channel,$chat.sender,$chat.msg,false);
			}else if($chat.channel == ChatInputView.TEAM)
			{
				sendMessage($chat.channel,$chat.sender,$chat.msg,true);
			}
			else if($chat.channel == ChatInputView.CURRENT)
			{
				sendMessage($chat.channel,$chat.sender,$chat.msg,false);
			}else if($chat.channel == ChatInputView.CHURCH_CHAR)
			{
				sendMessage($chat.channel,$chat.sender,$chat.msg,false);
			}
			else if($chat.channel == ChatInputView.HOTSPRING_ROOM)
			{
				sendMessage($chat.channel,$chat.sender,$chat.msg,false);
			}
		}
		
		public function sendFace(faceid:int):void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.SCENE_FACE);
			pkg.writeInt(faceid);
			SocketManager.Instance.out.sendPackage(pkg);
		}
		public function sendMessage(channelid:int, fromnick:String, msg:String,team:Boolean):void
		{
			msg=Helpers.enCodeString(msg);
			var pkg:PackageOut = new PackageOut(ePackageType.SCENE_CHAT);
			pkg.writeByte(channelid);
			pkg.writeBoolean(team);
			pkg.writeUTF(fromnick);
			pkg.writeUTF(msg);
			SocketManager.Instance.out.sendPackage(pkg);
		}
		
		public function sendPrivateMessage(toNick:String, msg:String,toId:Number=0):void
		{
			msg=Helpers.enCodeString(msg);
			var pkg:PackageOut = new PackageOut(ePackageType.CHAT_PERSONAL);
			pkg.writeInt(toId);
			pkg.writeUTF(toNick);
			pkg.writeUTF(PlayerManager.Instance.Self.NickName);
			pkg.writeUTF(msg);
			SocketManager.Instance.out.sendPackage(pkg);
		}
		
		public function setFocus():void
		{
			_chatView.input.inputField.setFocus();
		}
		
		public function setup():void
		{
			initView();
			initEvent();
		}
		
		public function get state():int
		{
			return _state;
		}
		public function set state($state:int):void
		{
			if(_state == $state)return;
			_state = $state;
			_chatView.setChatViewState(_state);
		}
		
		public function switchVisible():void
		{
			if(_visibleSwitchEnable)
			_chatView.input.visible = !_chatView.input.visible;
		}
		
		public function sysChatRed(message:String):void
		{
			var chatData:ChatData = new ChatData();
			chatData.channel = ChatInputView.SYS_NOTICE;
			chatData.msg = StringHelper.trim(message);
			chat(chatData);
		}
		
		public function sysChatYellow(message:String):void
		{
			var chatData:ChatData = new ChatData();
			chatData.channel = ChatInputView.SYS_TIP;
			chatData.msg = StringHelper.trim(message);
			chat(chatData);
		}
		
		public function get view():Sprite
		{
			return _chatView;
		}
		
		public function get visibleSwitchEnable():Boolean
		{
			return _visibleSwitchEnable
		}
		public function set visibleSwitchEnable(value:Boolean):void
		{
			if(_visibleSwitchEnable == value)return;
			_visibleSwitchEnable = value;
		}
		
		private function __bBugle(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg as PackageIn;
			var cm:ChatData = new ChatData();
			cm.channel = ChatInputView.BIG_BUGLE;
			cm.senderID = pkg.readInt();
			cm.receiver = "";
			cm.sender = pkg.readUTF();
			cm.msg = pkg.readUTF();
			chat(cm);
		}
		private function __cBugle(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg as PackageIn;
			var cm:ChatData = new ChatData();
			cm.channel = ChatInputView.CROSS_BUGLE;
			cm.zoneID = pkg.readInt();
			cm.senderID = pkg.readInt();
			cm.receiver = "";
			cm.sender = pkg.readUTF();
			cm.msg = pkg.readUTF();
			chat(cm);
		}
		
		private function __bugleBuyHandler(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			pkg.position = SocketManager.PACKAGE_CONTENT_START_INDEX;
			var successType:int = pkg.readInt();
			var buyFrom:int = pkg.readInt();
			if(buyFrom == 3 && successType == 1)input.sendCurrentText();
		}
		
		private function __consortiaChat(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg as PackageIn;
			if(pkg.clientId != PlayerManager.Instance.Self.ID)
			{
				var c:int = pkg.readByte();
				var cm:ChatData = new ChatData();
				cm.channel = ChatInputView.CONSORTIA;
				cm.senderID = pkg.clientId;
				cm.receiver = ""
				cm.sender = pkg.readUTF();
				cm.msg = pkg.readUTF();
				chatCheckSelf(cm);
			}
		}
		
		private function __defyAffiche(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg as PackageIn;
			var cm:ChatData = new ChatData();
			cm.msg = pkg.readUTF();
			cm.channel = ChatInputView.DEFY_AFFICHE;
			chatCheckSelf(cm);
		}
		
		private function __getItemMsgHandler(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg as PackageIn;
			
			var nickName:String = pkg.readUTF();
			var battle_type:int = pkg.readInt();//撮合竞技战是0，副本是1
			var templateID:int = pkg.readInt();
			var isbinds:Boolean = pkg.readBoolean();
			var isBroadcast:int = pkg.readInt();
			
			var txt:String;
			var battle_str:String;
			
			if(battle_type==0)
			{
				battle_str=LanguageMgr.GetTranslation("ddt.game.GameView.unexpectedBattle");
			}else if(battle_type == 2)
			{
				battle_str=LanguageMgr.GetTranslation("ddt.game.GameView.RouletteBattle");
			}else
			{
				battle_str=LanguageMgr.GetTranslation("ddt.game.GameView.dungeonBattle");
			}
			
			if(isBroadcast == 1)
			{
				txt = LanguageMgr.GetTranslation("ddt.game.GameView.getgoodstip.broadcast","["+nickName+"]",battle_str);
//				ddt.game.GameView.getgoodstip.broadcast:恭喜{0}在{1}中获得
			}
			else if(isBroadcast == 2)
			{
				txt = LanguageMgr.GetTranslation("ddt.game.GameView.getgoodstip",nickName,battle_str);
//				ddt.game.GameView.getgoodstip:[{0}]在{1}中获得
			}
			else if(isBroadcast == 3)
			{
				var str:String = pkg.readUTF();
				txt = LanguageMgr.GetTranslation("ddt.manager.congratulateGain","["+nickName+"]",str);
//				ddt.manager.congratulateGain:恭喜{0}开启{1}获得
			}
			var itemInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(templateID);
			var goodname:String = "["+itemInfo.Name+"]";
			var data:ChatData = new ChatData();
			data.channel = ChatInputView.SYS_NOTICE;
			data.msg = txt+goodname;
			var channelTag:Array = ChatFormats.getTagsByChannel(data.channel);
			txt=StringHelper.rePlaceHtmlTextField(txt);
			var nameTag:String = ChatFormats.creatBracketsTag(txt,ChatFormats.CLICK_USERNAME);
			var goodTag:String = ChatFormats.creatGoodTag("["+itemInfo.Name+"]",ChatFormats.CLICK_GOODS,itemInfo.TemplateID,itemInfo.Quality,isbinds);
			data.htmlMessage = channelTag[0]+nameTag+goodTag+channelTag[1]+"<BR>";
			data.htmlMessage = Helpers.deCodeString(data.htmlMessage);
			_model.addChat(data);
		}
		
		private function __privateChat(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			if(pkg.clientId)
			{
				var cm:ChatData = new ChatData();
				cm.channel = ChatInputView.PRIVATE;
				cm.receiverID = pkg.readInt();
				cm.senderID = pkg.clientId;
				cm.receiver = pkg.readUTF();
				cm.sender = pkg.readUTF();
				cm.msg = pkg.readUTF(); 
				chatCheckSelf(cm);
			}
		}
		
		private function __receiveFace(evt:CrazyTankSocketEvent):void
		{
			var data:Object = {};
			data.playerid = evt.pkg.clientId;
			data.faceid = evt.pkg.readInt();
			dispatchEvent(new ChatEvent(ChatEvent.SHOW_FACE,data));
		}
		
		private function __sBugle(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg as PackageIn;
			var cm:ChatData = new ChatData();
			cm.channel = ChatInputView.SMALL_BUGLE;
			cm.senderID = pkg.readInt();
			cm.receiver = ""
			cm.sender = pkg.readUTF();
			cm.msg = pkg.readUTF();
			chat(cm);
		}
		
		private function __sceneChat(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg as PackageIn;
			var cm:ChatData = new ChatData();
			cm.zoneID = pkg.readInt();
			cm.channel = pkg.readByte();
			if(pkg.readBoolean())
			{
				cm.channel = ChatInputView.TEAM;
			}
			cm.senderID = pkg.clientId;
			cm.receiver = ""
			cm.sender = pkg.readUTF();
			cm.msg = pkg.readUTF();
			chatCheckSelf(cm);
		}
		
		private function __sysNotice(event:CrazyTankSocketEvent):void
		{
			var type:int = event.pkg.readInt();
			var msg:String = event.pkg.readUTF();
			var links:Array;
			
			if(event.pkg.bytesAvailable)
			{
				links=ChatHelper.readGoodsLinks(event.pkg);
			}
			
			var o:ChatData = new ChatData();
			o.type = type;
			o.channel = ChatInputView.SYS_TIP;
			o.msg = StringHelper.rePlaceHtmlTextField(msg);
			o.link=links;
			chat(o);
		}
		private function __goodLinkGetHandler(e:CrazyTankSocketEvent):void
		{
			var info:InventoryItemInfo = new InventoryItemInfo();
			var pkg:PackageIn=e.pkg;
			info.TemplateID=pkg.readInt();
			info.ItemID=pkg.readInt();
			info.StrengthenLevel=pkg.readInt();
			info.AttackCompose=pkg.readInt();
			info.AgilityCompose=pkg.readInt();
			info.LuckCompose=pkg.readInt();
			info.DefendCompose=pkg.readInt();
			info.ValidDate=pkg.readInt();
			info.IsBinds=pkg.readBoolean();
			info.IsJudge=pkg.readBoolean();
			info.IsUsed=pkg.readBoolean();
			if(info.IsUsed)
			{
				info.BeginDate=pkg.readUTF();
			}
			info.Hole1=pkg.readInt();
			info.Hole2=pkg.readInt();
			info.Hole3=pkg.readInt();
			info.Hole4=pkg.readInt();
			info.Hole5=pkg.readInt();
			info.Hole6=pkg.readInt();
			
			info.Hole=pkg.readUTF();
			
			ItemManager.fill(info);
			
			model.addLink(info.ItemID,info);
			
			output.contentField.showLinkGoodsInfo(info,1);
			
		}
		private function chatCheckSelf(data:ChatData):void
		{
			if(data.zoneID!=-1)
			{
				//如果有 zoneID，昵称与自己不同，或不在同一区还能显示聊天
				if((data.sender != PlayerManager.Instance.Self.NickName)||(data.zoneID!=PlayerManager.Instance.Self.ZoneID))
				{
					chat(data);
				}
			}else
			{
				if(data.sender != PlayerManager.Instance.Self.NickName)
				{
					chat(data);
				}
			}
		}
		
		private function initEvent():void
		{
			if(!SHIELD_NOTICE)
			{
				SocketManager.Instance.addEventListener(CrazyTankSocketEvent.S_BUGLE,__sBugle);
				SocketManager.Instance.addEventListener(CrazyTankSocketEvent.B_BUGLE,__bBugle);
				SocketManager.Instance.addEventListener(CrazyTankSocketEvent.C_BUGLE,__cBugle);
				SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_ITEM_MESS, __getItemMsgHandler);
			}
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHAT_PERSONAL,__privateChat);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_CHAT,__sceneChat);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_CHAT,__consortiaChat);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_FACE,__receiveFace);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SYS_NOTICE,__sysNotice);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DEFY_AFFICHE,__defyAffiche);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUG_GOODS, __bugleBuyHandler);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LINKGOODSINFO_GET,__goodLinkGetHandler);
		}
		
		private function initView():void
		{
			ChatFormats.setup();
			_model = new ChatModel();
			_chatView = new ChatView();
			state = CHAT_HALL_STATE;
			inputChannel = ChatInputView.CURRENT;
			outputChannel = ChatOutputView.CHAT_OUPUT_CURRENT;
		}
	}
}