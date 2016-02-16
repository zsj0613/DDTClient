package ddt.events
{
	import flash.events.Event;
	
	import road.comm.PackageIn;

	public class CrazyTankSocketEvent extends Event
	{
		/**
		 * 背包锁
		 */
		 public static const BAG_LOCKED : String = "bagLocked";
		/**
		 * 公会设备使用权限
		 */
		 public static const CONSORTIA_EQUIP_CONTROL : String = "consortiaEquipControl";
		/**
		 * 玩家移动位置 
		 */		
		public static const PLAYER_START_MOVE:String = "playerStartMove";
		public static const PLAYER_STOP_MOVE:String = "playerStopMove";
		
		public static const PLAY_FINISH:String = "playeFinished";
		/**
		 * 位置同步 
		 */		
		public static const PLAYER_MOVE:String = "playerMove";
		
		public static const BOMB_DIE:String = "bombDie";
		  /***
		 *     每日奖历
		 */
		 public static const DAILY_AWARD : String = "dailyAward";
		/**
		 * 玩家改变方向 
		 */		
		public static const DIRECTION_CHANGED:String = "playerDirection";
		
		/**
		 * 改变炸弹 
		 */		
		public static const CHANGE_BALL:String = "changeBall";
		
		/**
		 * 枪角度 
		 */		
		public static const PLAYER_GUN_ANGLE:String = "playerGunAngle";
		
		/**
		 * 玩家射击 
		 */		
		public static const PLAYER_SHOOT:String = "playerShoot";
		
		/**
		 * 发弹开始结束标记 
		 */		
		public static const PLAYER_SHOOT_TAG:String = "playerShootTag";
		
		/**
		 * 玩家敲击 
		 */		
		public static const PLAYER_BEAT:String = "playerBeat";
		
		/**
		 * 箱子消失 
		 */		
		public static const BOX_DISAPPEAR:String = "boxdisappear";
		
		/**
		 * 交换攻击玩家 
		 */		
		public static const PLAYER_CHANGE:String = "playerChange";
		
		/**
		 * 玩家血量 
		 */		
		public static const PLAYER_BLOOD:String = "playerBlood";
		
		/**
		 * 冰冻 
		 */		
		public static const PLAYER_FROST:String = "playerFrost";
		
		/**
		 * 无敌 
		 */		
		public static const PLAYER_INVINCIBLY:String = "playerInvincibly";
		
		/**
		 * 隐身 
		 */		
		public static const PLAYER_HIDE:String = "playerHide";
		
		/**
		 * 传送 
		 */		
		public static const PLAYER_CARRY:String = "playerCarry";
		
		/**
		 * 召唤 
		 */		
		public static const PLAYER_BECKON:String = "playerBeckon";
		
		/**
		 * 免坑
		 */
		public static const PLAYER_NONOLE : String 	= "playerNoNole";
		
		/**
		 * 封印
		 * */
		public static const LOCK_STATE:String = "lockState";
		/**
		 * 状态改变
		 * */
		public static const CHANGE_STATE:String = "changeState";
		
		/**
		 * 改变风向 
		 */		
		public static const PLAYER_VANE:String = "playerVane";
		
		/**
		 * 游戏中出箱子 
		 */		
		public static const PLAYER_APK:String = "playerAPK";
		
		/**
		 * 检箱子 
		 */		
		public static const PLAYER_PICK_BOX:String = "playerPick";
		
		/**
		 *  捡箱子
		 */		
		public static const PLAYER_FIGHT_PROP:String = "playerFightProp";
		
		/**
		 * 格子物品 
		 */		
		//public static const PLAYER_GRID_GOODS:String = "playerGridGoods";
		
		/**
		 * 必杀技 
		 */		
		public static const PLAYER_STUNT:String = "playerStunt";
		
		/**
		 * 使用道具 
		 */		
		public static const PLAYER_PROP:String = "playerProp";
		
		/**
		 * 怒气值 
		 */		
		public static const PLAYER_DANDER:String = "playerDander";
		
		/**
		 * 加载进度
		 */		
		public static const LOAD:String = "load";
		
		/**
		 * 增加攻击次数 
		 */		
		public static const PLAYER_ADDATTACK:String = "playerAddAttack";
		
		/**
		 * 增加子弹次数 
		 */		
		public static const PLAYER_ADDBAL:String = "playerAddBall";
		
		/**
		 * 跟踪 
		 */		
		public static const SHOOTSTRAIGHT:String = "shootStaight";
		
		/**
		 * 自杀 
		 */		
		public static const SUICIDE:String = "suicide";
		
		public static const PING:String = "ping";
		public static const NETWORK:String = "netWork";
	
//		/**
//		 * 战得品窗器
//		 */		
//		public static const TEMP_INVENTORY:String = "tempInventory";
		
		public static const GAME_TAKE_TEMP:String = "gameTakeTemp";
		
		/**
		 * 连接成功事件 
		 */		
		public static const CONNECT_SUCCESS:String = "connectSuccess";
        /**
         * 登陆结果事件 
         */		
        public static const LOGIN:String = "login";
        
        
        /**
         * 创建房间
         */        
        public static const GAME_ROOM_CREATE:String = "gameRoomCreate";
        
        /**
         * 更新房间列表 
         */        
        public static const GAME_ROOMLIST_UPDATE:String = "gameRoomListUpdate";
		/**
		 * 弹出输入密码框 
		 */        
		public static const ROOMLIST_PASS:String = "RoomListPass";
        
        /**
         * 返回玩家列表信息 
         */        
        public static const SCENE_ADD_USER:String = "sceneAddUser";
        
        /**
         * 服务器发送指令让玩家进入房间
         */        
        public static const GAME_PLAYER_ENTER:String = "gamePlayerEnter";
        
        /**
         * 房主信息 
         */        
       // public static const GAME_ROOM_HOST:String = "gameRoomHost";
        
        /**
         * 用户被踢下线 
         */        
        public static const KIT_USER:String = "kitUser";
        
        /**
        * 更新所有分数类型
        * 
        * */
        public static const UPDATE_PRIVATE_INFO :String = "updateAllSorce";
        
        
        
       
        /**
         * 踢人或者打开或者关闭 
         */        
        public static const GAME_ROOM_UPDATE_PLACE:String = "gameRoomOpen";
        
        /**
         * 玩家被踢出房间 
         */        
        public static const GAME_ROOM_KICK:String = "gameRoomKick";
        
        /**
         * 玩家退出房间 
         */        
        public static const GAME_PLAYER_EXIT:String = "GamePlayerExit";
        
        //戳和游戏返回
        public static const GAME_WAIT_RECV:String = "recvGameWait";
        
        //戳和游戏失败
        public static const GAME_WAIT_FAILED:String = "GameWaitFailed";
        
        //取消撮合
        public static const GAME_AWIT_CANCEL:String = "GameWaitCancel";
        
        //搓合战类型
        public static const GMAE_STYLE_RECV:String = "GameStyleRecv";
        
        /**
         * 进入房间前　（房间列表中成功或失败） 
         */        
        public static const GAME_ROOM_LOGIN:String = "gameLogin";
        
        /*****************************游戏中**************************************/
        /**
         * 游戏用户换队伍组队 
         */        
        public static const GAME_TEAM:String = "gameTeam";
        
        /**
		 * 玩家准备　和　取消 
		 */		
		public static const GAME_PLAYER_STATE_CHANGE :String = "playerState";
		
		
		/**
		 * 创建游戏 
		 */		
		public static const GAME_CREATE:String = "gameCreate";
		
		/**
		 * 游戏开始 
		 */		
		public static const GAME_START:String = "gameStart";		
		
		/**
		 * 开始加载 
		 */		
		public static const GAME_LOAD:String = "gameLoad";
		
		public static const GAME_MISSION_INFO : String = "gameMissionInfo";
		
		public static const SCENE_CHANNEL_CHANGE:String = "sceneChannelChange";
		public static const SCENE_CHAT:String = "scenechat";
		public static const SCENE_FACE:String = "sceneface";
		
		/**
		 * 场景中用户离开 
		 */		
		public static const SCENE_REMOVE_USER:String = "sceneRemoveUser";
		
		/**
		 * 物品
		 */		
		public static const DELETE_GOODS:String = "deletegoods";
		public static const BUG_GOODS:String = "buggoods";
		public static const CHANGE_GOODS_PLACE:String = "changegoodsplace";
		
		public static const BREAK_GOODS:String = "breakgoods";
		public static const CHAIN_EQUIP:String = "chainequip";
		public static const UNCHAIN_EQUIP:String = "unchainequip";
		
		public static const SELL_GOODS:String = "sellgoods";
		public static const REPAIR_GOODS:String = "repairGoods";
		
		/**
		 * 邮件
		 */
		public static const SEND_EMAIL:String = "sendEmail";
		public static const DELETE_MAIL:String = "deleteMail";
		public static const GET_MAIL_ATTACHMENT:String = "getMailAttachment";
		public static const MAIL_CANCEL:String = "mailCancel";
		
		/**
		 * 游件通知 
		 */		
		public static const MAIL_RESPONSE:String = "mailResponse";
		
		/**
		 * 道具 
		 */		
//		public static const PROP_BUY:String = "propBuy";
//		public static const PROP_SELL:String = "propSell";
		public static const GRID_PROP:String = "gridProp";
		
		/**
		 * 物品格子更新
		 */		
		public static const GRID_GOODS:String = "gridgoods";
		
		/**
		 * 钱，点券 
		 */		
		public static const UPDATE_MONEY:String = "upDateMoney";
		public static const UPDATE_COUPONS:String = "updateCoupons";
		
		/**
		 * 功勋更新
		 */
		public static const UPDATE_OFFER:String = "updateoffer";
		
		/**
		 * 
		 */
		public static const ITEM_STORE : String = "itemStore";

		/**
		 * 验证码
		 *   */
		 public static const CHECK_CODE:String = "checkCode";
		

		/**
		 * 公会
		 */
		public static const CONSORTIA_RESPONSE:String = "consortiaresponse";		
//		public static const CONSORTIA_TRYFOR_CREATE:String = "consortiatryforcreate";
//		public static const CONSORTIA_TRYFOR_IN:String = "consrotiatryforin";
//		public static const CONSORTIA_PASS_TRYFOR_IN:String = "consortiapasstryforin";
//		public static const CONSORTIA_DEL_TRYFOR_IN:String = "consortiadeltryforin";
//		public static const CONSORTIA_MEMBER_CHANGE_REMARK:String = "consortiamemberchangeremark";
		public static const CONSORTIA_USER_GRADE_UPDATE:String = "consortiagradeuodateevent";
//		public static const CONSORTIA_MEMBER_DESGRADE:String = "consortiamemberdesgrade";
//		public static const CONSORTIA_MEMBER_TICKOUT:String = "consortiamembertickout";
//		public static const CONSORTIA_DUTY_EDIT:String = "consrotiadutyedit";
//		public static const CONSORTIA_DISBAND:String = "consortiadisband";
		public static const CONSORTIA_CREATE:String = "consortiacreateevent";
		public static const CONSORTIA_TRYIN:String = "consortiatryinevent";
		public static const CONSORTIA_TRYIN_DEL:String = "consortiatryindelevent"
		public static const CONSORTIA_PLACARD_UPDATE:String = "consortiaPlacardUpdate";
		public static const CONSORTIA_DESCRIPTION_UPDATE:String = "consortiadescriptionupdate";
		public static const CONSORTIA_DISBAND:String = "consortiadisbandevent";
		public static const CONSORTIA_APPLY_STATE : String = "consortiaapplystateevent";
		public static const CONSORTIA_INVITE_PASS:String = "consortiainvatepassevent";
		public static const CONSORTIA_INVITE:String = "consortiainvateevent";
		public static const CONSORTIA_RENEGADE:String = "consortiarenegadeevent";
		public static const CONSORTIA_DUTY_DELETE:String = "consortiadutydeleteevent";
		public static const CONSORTIA_DUTY_UPDATE:String = "consortiadutyupdateevent";
		public static const CONSORTIA_BANCHAT_UPDATE:String = "consortiabanchatupdateevent";
		public static const CONSORTIA_USER_REMARK_UPDATE:String = "consortiauserremarkupdateevent";
		public static const CONSORTIA_CHAT:String = "consortiachatevent";
		public static const CONSORTIA_ALLY_APPLY_UPDATE:String = "consortiaAllyAppleUpdate";
		public static const CONSORTIA_ALLY_UPDATE:String = "consortiaallyupdate";
		public static const CONSORTIA_ALLY_APPLY_DELETE:String = "consortiaallyapplydelete";
		public static const CONSORTIA_ALLY_APPLY_ADD:String = "consortiaallyapplyadd";
		public static const CONSORTIA_LEVEL_UP:String = "consortialevelup";
		public static const CONSORTIA_CHAIRMAN_CHAHGE:String = "consortiachairmanchange";
		
		public static const CONSORTIA_TRYIN_PASS:String = "consortiatryinpass";
		public static const CONSORTIA_RICHES_OFFER:String = "consortiaRichesOffer";
		public static const CONSORTIA_MAIL_MESSAGE:String = "consortiaMailMessage";
		
		    
        public static const CONSORTIA_STORE_UPGRADE : String = "consortiaStoreUpGrade";/**** 公会银行升级*/
        public static const CONSORTIA_SMITH_UPGRADE : String = "consortiaSmithUpGrade";/**** 公会铁匠升级 */
        public static const CONSORTIA_SHOP_UPGRADE : String= "consortiaShopUpGrade";/**公会商城升级**/
		
		
		
		
		public static const GAME_OVER:String = "gameOver";
		
		public static const MISSION_OVE:String = "missionOver";
		public static const MISSION_COMPLETE:String = "missionOver";
		
		public static const GAME_ALL_MISSION_OVER:String = "gameAllMissionOver";
		
		public static const GAME_TAKE_OUT:String  = "gameTakeOut"; 
		
		public static const GAME_ROOM_SETUP_CHANGE:String = "gameRoomSetUp";
		
		public static const EQUIP_CHANGE:String = "equipchange";
		
		/**
		 * 民政中心
		 */
		public static const MARRYINFO_GET:String = "marryinfoget";
		public static const AMARRYINFO_REFRESH:String = "amarryinforefresh";
		
		
		/**
		 * 选择队长
		 */	
		public static const GAME_OPEN_SELECT_LEADER:String = "gameOpenSelectLeader"
		public static const GAME_WANNA_LEADER:String = "gameWannaLeader";
			
		public static const GAME_CAPTAIN_CHOICE:String = "gamecaptionchoice";
		/**
		 * 确认队长
		 */		
		public static const GAME_CAPTAIN_AFFIRM:String = "gamecaptainaffirm";
		
		public static const SCENE_USERS_LIST:String = "sceneuserlist";
		
		/**
		 * 邀请进入游戏
		 */		
		public static const GAME_INVITE:String = "gameinvite";
		
		/**
		 * 更新样式，style,colors,攻防值
		 */		
		public static const UPDATE_PLAYER_INFO:String = "updatestyle";
		
		public static const S_BUGLE:String = "sbugle";
		public static const B_BUGLE:String = "bbugle";
		/**
		 * 跨区喇叭 
		 */		
		public static const C_BUGLE:String = "cbugle";
		public static const UPDATE_GP:String = "upDateGP";
		public static const CHAT_PERSONAL:String = "chatpersonal";
		public static const FRIEND_ADD:String = "friendAdd";
		public static const FRIEND_REMOVE:String = "friendremove";
		public static const FRIEND_UPDATE:String = "friendupdate";
		public static const FRIEND_STATE:String = "friendstate";
		public static const ITEM_COMPOSE:String = "itemCompose";
		public static const ITEM_STRENGTH:String = "itemstrength";
		public static const ITEM_TRANSFER:String = "itemtransfer";
		/**
		 *挑战公告 
		 */		
		public static const DEFY_AFFICHE:String = "DefyAffiche";
		
		
		/**
		 * 熔炼
		 * 
		 */
		 public static const ITEM_FUSION:String = "itemfusion";
		 public static const ITEM_FUSION_PREVIEW : String = "itemfusionpreview";
		 /**
		 * 炼化
		 * */
		 public static const ITEM_REFINERY_PREVIEW:String = "itemRefineryPreview";
		 public static const ITEM_REFINERY:String = "itemRefinery";
		 /**
		 * 镶嵌
		 * */
		 public static const ITEM_EMBED:String = "itemEmbed";
		 /**
		 * 清空隐形背包
		 * */
		 public static const CLEAR_STORE_BAG:String = "clearStoreBag"; 
		 
		
		/**
		 * 系统提示，聊天框显示
		 */		
		public static const SYS_CHAT_DATA:String = "syschatdata";
		
		/**
		 * 系统公告
		 */		
		public static const SYS_NOTICE:String = "sysnotice";
		
		public static const ITEM_CONTINUE:String = "itemContinue";
		
		public static const ITEM_EQUIP:String = "itemEquip";
		
		/**
         * 被添加好友响应
         */        
        public static const FRIEND_RESPONSE:String = "friendresponse";
        
        public static const ITEM_OBTAIN:String = "itemObtain";
        
         public static const SYS_DATE:String = "sysDate";
        
		/**
		 * 任务 
		 */        
		public static const QUEST_UPDATE:String = "quiestUpdate";
		public static const QUEST_OBTAIN:String = "quiestObtain";     
		public static const QUEST_CHECK:String = "quiestCheck";
		public static const QUEST_FINISH:String = "quiestFinish";
		/*
		 * 拍卖行
		 */
		public static const AUCTION_DELETE:String = "auctionDelete";
		public static const AUCTION_UPDATE:String = "auctionUpdate";
		public static const AUCTION_ADD:String = "auctionAdd";
		public static const AUCTION_REFRESH:String = "auctionRefresh";
		
		/**
		 * 身份证验证
		 */
		public static const CID_CHECK:String = "CIDCheck"; 
		public static const ENTHRALL_LIGHT:String = "CIDInfo";
		
		/**
		 * buff信息
		 * */
		public static const BUFF_INFO:String = "buffInfo";
		public static const BUFF_OBTAIN:String = "buffObtain";
		public static const BUFF_ADD:String = "buffAdd";
		public static const BUFF_UPDATE:String = "buffUpdate";
		
		/**
		 * 变色卡使用
		 * */
		public static const USE_COLOR_CARD:String = "useColorCard";
		
	    /**
	     * 结婚系统 
	     */	
	    public static const MARRY_ROOM_CREATE:String = "marry room create";	
		public static const MARRY_ROOM_LOGIN:String = "marry room login";	
		public static const MARRY_SCENE_LOGIN:String = "marry scene login";
		public static const MARRY_SCENE_CHANGE:String = "marry scene change";
		public static const PLAYER_ENTER_MARRY_ROOM:String = "player enter room";
		public static const PLAYER_EXIT_MARRY_ROOM:String = "exit marry room";
		public static const MARRY_APPLY:String = "marray apply";
		public static const MARRY_APPLY_REPLY:String = "marry apply reply";
		public static const DIVORCE_APPLY:String = "divorce apply";	
		public static const MARRY_STATUS:String = "marry status";
		
		public static const MOVE:String = "church move";
		public static const HYMENEAL:String = "hymeneal";
		public static const CONTINUATION:String = "church continuation";
		public static const INVITE:String = "church invite";
		public static const LARGESS:String = "church largess";
		public static const USEFIRECRACKERS:String = "use firecrackers";
		public static const KICK:String = "church kick";
		public static const FORBID:String = "church forbid";
		public static const MARRY_ROOM_STATE:String = "marry room state";
		public static const HYMENEAL_STOP:String = "hymeneal stop";
		public static const MARRY_ROOM_DISPOSE:String = "marry room dispose";
		public static const MARRY_ROOM_UPDATE:String = "marry room update"; 
		public static const MARRYPROP_GET:String = "marryprop get";
		public static const GUNSALUTE:String = "Gun Salute";
		
		
	    /**
	     *民政中心 
	     */		
		public static const MARRYINFO_UPDATE:String = "marryinfo update";
		public static const MARRYINFO_ADD:String = "marryInfo add";
		
		public static const PLAY_MOVIE:String = "playMovie";
		public static const ADD_LIVING:String = "addLiving";
		public static const ADD_MAP_THINGS:String = "addMapThing";
		
		public static const  LIVING_MOVETO:String = "livingMoveTo";
       	public static const  LIVING_FALLING:String = "livingFalling";
       	public static const  LIVING_JUMP:String = "livingJump";
       	public static const  LIVING_BEAT:String = "livingBeat";
       	public static const  LIVING_SAY:String = "livingSay";
       	
       	public static const  LIVING_RANGEATTACKING:String = "livingRangeAttacking";
       	
       	
       	public static const BARRIER_INFO : String = "barrierInfo";//关卡信息
       	public static const ADD_MAP_THING    : String = "addMapThing";//加木板
       	public static const UPDATE_BOARD_STATE : String = "updateBoardState";//修改木板状态
       	public static const GAME_MISSION_START : String = "gameMissionStart";//副本开始下一关
       	public static const GAME_MISSION_PREPARE: String = "gameMissionPrepare";//副本准备
       	public static const SHOW_CARDS : String = "showCard";// 显示所有未翻的奖牌
       	public static const SEND_PICTURE : String = "sendPicture";
       	public static const GEM_GLOW : String = "gemGlow";
       	/**
       	 * 获取物品链接信息
       	 */       	
       	public static const  LINKGOODSINFO_GET:String = "linkGoodsInfo";
       	
       	public static const FOCUS_ON_OBJECT:String = "focusOnObject";
       	
       	/**
       	 * 关卡结算中被邀请进入房间时使用此协议创建游戏信息GameInfo
       	 */       	
       	public static const GAME_ROOM_INFO:String = "gameRoomInfo";
       	
       	/**
       	 *增加提示信息层 
       	 */       	
       	public static const ADD_TIP_LAYER : String = "addTipLayer";
       	
       	/**
       	 * 房间中的玩家信息
       	 */       	
       	public static const PLAY_INFO_IN_GAME:String = "playInfoInGame";
       	
       	/**
       	 * 付费翻牌时点券不足时收到此协议
       	 */       	
       	public static const PAYMENT_TAKE_CARD:String = "playmentTakeCard";
       	
       	/**
       	 * BOSS战付费失败
       	 */       	
       	public static const INSUFFICIENT_MONEY:String = "insufficientMoney";
       	
       	/**
       	 * 关卡失败，再玩一次
       	 */       	
       	public static const GAME_MISSION_TRY_AGAIN:String = "gameMissionTryAgain";
       	
       	/**
       	 * 玩家战斗中获得物品提示信息
       	 */       	
       	public static const GET_ITEM_MESS:String = "getItemMess";
       	
	    /**
	     *回答新手答案 
	     */       	
	    public static const USER_ANSWER : String = "userAnswer";
       	
       	
	    /**
	     *播放音效。 
	     */
	    public static const PLAY_SOUND:String = "playSound";
	    /**
	     *加载资源 
	     */
	    public static const LOAD_RESOURCE:String = "loadResource";	      
	    
	    /**
	     * 播放旁白文字
	     */	    
	    public static const PLAY_ASIDE:String = "playWordTip";  
	    
	     /**
		 * 禁止玩家拖拽右上方的小地图
		 * */
		 public static const FORBID_DRAG:String = "forbidDrag";
		 
		 /**
		 * 把一个东西放到最上层
		 * */
		 public static const TOP_LAYER:String = "topLayer";
		 
		 /**
		 * 商城赠送 
		 */
		 public static const GOODS_PRESENT:String = "goodsPresents";
		 
		 /**
		  *商品数量 （每日限量） 
		  */		 
		 public static const GOODS_COUNT:String = "goodsCount";
		 
		 /**
		 * 控制背景音乐的播放
		 * */   	
		 public static const CONTROL_BGM:String = "controlBGM";
		 
		 /**
		  *作战实验室模型改变 
		  */		 
		 public static const FIGHT_LIB_INFO_CHANGE:String = "fightLibInfoChange";
		 
		 /**
		  * 使用副武器-加血枪
		  * */   	
		 public static const USE_DEPUTY_WEAPON:String = "Use_Deputy_Weapon";
		 
		 /**
		  *作战实验室 弹出答题框 
		  */		 
		 public static const POPUP_QUESTION_FRAME:String = "popupQuestionFrame";
		 
		 /**
		  *剧情动画按钮 
		  */		 
		 public static const SHOW_PASS_STORY_BTN:String = "showPassStoryBtn";
		
		 
		 /**
		  * 改变目标位置
		  * */   	
		 public static const LIVING_BOLTMOVE:String = "livingBoltmove";
		 
		 public static const CHANGE_TARGET:String = "changeTarget";
		 
		 //*********温泉系统开始 *********
		 /**
		  *温泉创建房间成功
		  */		 
		 public static const HOTSPRING_ROOM_CREATE:String = "hotSpringRoomCreate";
		 
		 /**
		  *新增加或更新房间 
		  */		 
		 public static const HOTSPRING_ROOM_ADD_OR_UPDATE:String = "hotSpringListRoomAddOrUpdate";
		 
		 /**
		  *温泉房间列表移除房间 
		  */
		 public static const HOTSPRING_ROOM_REMOVE:String = "hotSpringRoomRemove";
		 
		 /**
		  *取得温泉房间列表 
		  */
		 public static const HOTSPRING_ROOM_LIST_GET:String = "hotSpringRoomListGet";
		 
		 /**
		  *进入房间成功
		  */
		 public static const HOTSPRING_ROOM_ENTER:String = "hotSpringRoomEnter";
		 
		 /**
		  *房间内加入一个玩家
		  */
		 public static const HOTSPRING_ROOM_PLAYER_ADD:String = "hotSpringRoomPlayerAdd";
		 
		 /**
		  *玩家退出房间
		  */
		 public static const HOTSPRING_ROOM_PLAYER_REMOVE:String = "hotSpringRoomPlayerRemove";
		 
		 /**
		  *玩家退出房间后广播给房间内其它玩家
		  */
		 public static const HOTSPRING_ROOM_PLAYER_REMOVE_NOTICE:String = "hotSpringRoomPlayerRemoveNotice";	
		 
		 /**
		  *玩家要移动到的目标点
		  */
		 public static const HOTSPRING_ROOM_PLAYER_TARGET_POINT:String = "hotSpringRoomPlayerTargetPoint";		 
		 
		 /**
		  *通知玩家续费
		  */
		 public static const HOTSPRING_ROOM_RENEWAL_FEE:String = "hotSpringRoomRenewalFee";
		 
		 /**
		  *邀请进入温泉房间
		  */
		 public static const HOTSPRING_ROOM_INVITE:String = "hotSpringRoomInvite";
		 
		 /**
		  *房间时间更新
		  */
		 public static const HOTSPRING_ROOM_TIME_UPDATE:String = "hotSpringRoomTimeUpdate";		
		 
		 /**
		  *房间时间更新
		  */
		 public static const HOTSPRING_ROOM_ENTER_CONFIRM:String = "hotSpringRoomEnterConfirm";
		 
		 /**
		  *系统房间刷新时，针对于玩家的继续提示(扣费)
		  */
		 public static const HOTSPRING_ROOM_PLAYER_CONTINUE:String = "hotSpringRoomPlayerContinue";		 
		 //*********温泉系统结束 *********

		 /**
		  *获得宝箱 
		  */		 
		 public static const GET_TIME_BOX:String = "getTimeBox";

		 
		 //**************成就****************
		/**
		 * 更新成就完成进度 
		 */
		 public static const  ACHIEVEMENT_UPDATE:String = "achievementUpdate";
		 /**
		  * 成就完成
		  */
		 public static const   ACHIEVEMENT_FINISH:String = "achievementFinish";
		 
		/**
		 * 初始化成就进度
		 */
		 public static const ACHIEVEMENT_INIT:String   = "achievementInit"; 
		 /**
		  *初始化 
		  */		 
		 public static const  ACHIEVEMENTDATA_INIT:String   = "achievementDateInit";
		 
		 public static const FIGHT_NPC:String = "fightNpc";
		 
		 /**
		  *投诉反馈回复 
		  */
		 public static const FEEDBACK_REPLY:String = "feedbackReply";		 

		 
		// //***************乱盘宝箱***************
		 /**
		  *备选物品列表 
		  */		 
		 //public static const LOTTERY_ALTERNATE_LIST:String = "lottery_alternate_list";
		 /**
		  *被选中的物品信息 
		  */		
		 //public static const LOTTERY_GET_ITEM:String = "lottery_get_item";
		 

		 
		 //public static const LOOKUP_EFFORT:String = "lookupEffort";

		 
		 //***************VIP***************
		 public static const VIP_UPDATE:String = "VIPUpdate";
		 
		 
		 //世界BOSS
		 public static const WORLDBOSS_JOIN:String = "worldboss_join";

		 
		 
		 
		 
	    private var _pkg:PackageIn;  
        
        public function get pkg():PackageIn
       	{
       		return _pkg;
        }
        
        public var executed:Boolean;
        
		public function CrazyTankSocketEvent(type:String,pkg:PackageIn = null)
		{
			super(type, bubbles, cancelable);
			_pkg = pkg;
		}
	}
}