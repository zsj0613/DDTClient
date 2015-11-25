package ddt.data.socket
{
	import fl.controls.progressBarClasses.IndeterminateBar;
	
	/**
	 * 系统SOCKET(0x00---0x0F)
	 * 场景SOCKET(0x10---0x1F)
	 * 人物SOCKET(0x20---0x2F)
	 * IM好友SOCKET(0x30---0x3F)
	 * 人物SOCKET(0x40---0x4F)
	 * 游戏SOCKET(0x50---0x5F)
	 * 房间SOCKET(0x80---0x8F)
	 * 备用SOCKET(0xc0---0xeF)
	 */
	public class ePackageType
	{
		/**************************************结婚系统*******************************************/
		 /**
		  *新手答题 
		  */	
		public static const USER_ANSWER : int = 0x0f;
	
		/****
		 * 背包锁
		 */
		 public static const BAG_LOCKED : int = 0x19;
		 
		 /** <summary>
        /// 公会设备控制
        */
        public static const CONSORTIA_EQUIP_CONTROL : int = 0xaa;
		
		/**
		 * 礼堂创建
		 */		
		public static const MARRY_ROOM_CREATE:int = 0xf1;
		/**
		 * 进入礼堂 
		 */		
		public static const MARRY_ROOM_LOGIN:int = 0xf2;
		/**
		 * 登录结婚主场景 
		 */		
		public static const MARRY_SCENE_LOGIN:int = 0xf0;
		/**
		 * 玩家进入礼堂 
		 */
		public static const PLAYER_ENTER_MARRY_ROOM:int = 0xf3;
		/**
		 * 玩家退出礼堂 
		 */
		public static const PLAYER_EXIT_MARRY_ROOM:int = 0xf4;
		/**
		 * 求婚 
		 */
		public static const MARRY_APPLY:int = 0xf7;
		/**
		 * 求婚答复 
		 */
		public static const MARRY_APPLY_REPLY:int = 0xfa;		
		/**
		 * 离婚 
		 */
		public static const DIVORCE_APPLY:int = 0xf8;	
		/**
		 * 结婚状态 
		 */		
		public static const MARRY_STATUS:int = 0xf6;
		/**
		 * // 
		 */		
		public static const SCENE_STATE:int = 0xfb;
		/**
		 * 结婚房状态 
		 */		
		public static const MARRY_ROOM_STATE:int = 0xfc;
		/**
		 * 更改房间描述 
		 */		 
		public static const MARRY_ROOM_INFO_UPDATE:int = 0xfd;
		
		public static const MARRYPROP_GET:int = 0xea;
		/**
		 * 房间信息变更 
		 */		
		public static const MARRY_ROOM_UPDATE:int = 0xff;
		public static const MARRY_ROOM_DISPOSE:int = 0xfe;
		/**
		 * 房间父协议
		 */	
		public static const MARRY_CMD:int = 0xf9;
		/**
		 * 结婚动画完成
		 */		
		public static const CHURCH_MOVIE_OVER:int = 0xa7;
		/**
		 * 切换场景 
		 */		
		public static const MARRY_SCENE_CHANGE:int = 0xe9;
		/***************************************************************************************/
		/**
		 * 客户端错误 
		 */		
		public static const CLIENT_LOG:int = 0x08;
				
		/*************************************场景*********************************************

		/**
		 * 场景聊天
		 */		
		public static const SCENE_CHAT:int = 0x13;
		
		/**
		 * 聊天表情
		 */		
		public static const SCENE_FACE:int = 0x14;
		
		/**
		 * 更改场景聊天频道
		 */		
		public static const SCENE_CHANNEL_CHANGE:int = 0x18;
		

		/**************************************人物********************************************
		 * 人物改变状态 
		 */		
		public static const CHANGE_STATE:int = 0x20;
		
		/**
		 * 更改昵称
		 */		
		public static const CHANGE_NICKNAME:int = 0x21;
		
		/**
		 * 改变人物形象 
		 */		
		public static const CHANGE_STYLE:int = 0x22;
		
		/**
		 * 人物动作 
		 */		
		public static const AC_ACTION:int = 0x23;
		
		/**
		 * 同步动作 
		 */		
		public static const SYNCH_ACTION:int = 0x24;
		
		/**
		 * 个人聊天
		 */		
		public static const CHAT_PERSONAL:int = 0x25;
		
		/** 
		 *  更新所有分数类型
		
		 */
		 public static const UPDATE_PRIVATE_INFO:int = 0x26;
		
		
        /**
         * 更新人气度 
         */		
        public static const UPDATE_HOTPOINT:int = 0x27;
		
        /**
         * 查询用户所在场景 
         */		
        public static const USER_SCENE:int = 0x28;
        
        /**
         * 保存用户形象 
         */        
        public static const SAVE_STYLE:int = 0x29;
       
       	/**
       	 * 删除物品 
       	 */       	
       	public static const DELETE_GOODS:int = 0x2a;
       	
        /**
         * 添加物品 
         */       	
      //  public static const ADD_GOODS:int = 0x2b;
		
	
		/**
		 * 公会物品到邮件提醒
		 */		
		public static const CONSORTIA_MAIL_MESSAGE:int = 0x2b;
        
       
        
        /**
         * 补充资料 
         */        
//      public static const RENEW_INFO:int = 0x91;
        
      
        
		
		/**************************************IM好友************************************** 
		 * 加好友验证
		 */	
	
        
        /************************************房间****************************************
          * 保存个人物品
          */
        public static const ROOM_SAVE_OBJECT:int = 0x80;
        
        
        /*******************************备用协议*******************************************
         * 旁观者初始化数据
         */
        public static const GAME_VISITOR_DATA:int = 0xe0;
        
  		/*******************************坦克协议******************************************* 
 
		 /** 
		 * 登陆 
		 */		
		public static const LOGIN:int = 0x01;     
		
		
		/***
		 *     每日奖历
		 */
		 public static const DAILY_AWARD : int = 0x0d;
		 
		/**
         * 用户创建房间 
         */        
        public static const GAME_ROOM_CREATE:int = 0x5e;
        
         /**
         * 房间列表添加/更新房间
         */        
        public static const GAME_ROOMLIST_UPDATE:int = 0x5f;
		/**
		 *房间弹出密码输入 
		 */		
		public static const ROOM_PASS:int = 0x65;
		/**
		 *更新房间列表 
		 */
		public static const ROOMLIST_UPDATE:int = 0x6d;
        /**
         * 玩家进入房间 
         */        
        public static const GAME_ROOM_LOGIN:int = 0x51;  
        
        /**
         * 更新房间的玩家信息
         */        
        public static const GAME_ROOM_ADDPLAYER:int = 0x52; 
        
		/**
		 * 场景中加入用户 
		 */		
		public static const SCENE_ADD_USER:int = 0x12;
        
		/**
		 * 用户被踢下线 
		 */		
		public static const KIT_USER:int = 0x02;
		
		/**
		 * 获取房间列表 
		 */		
		public static const SCENE_LOGIN:int = 0x10;
		
		/**
		 * 玩家退出(退出房间)
		 */		
		public static const GAME_ROOM_REMOVEPLAYER:int = 0x53;
		
		
		/// <summary>
        //准备戳和
        /// </summary>
        public static const GAME_PICKUP_WAIT:int   = 0xd0;
        //戳和失败
        public static const GAME_PICKUP_FAILED:int = 0xd1;
        //取消戳和
        public static const GAME_PICKUP_CANCEL:int = 0xd2;
        
        //工会战或者自由站类型
        public static const GAME_PICKUP_STYLE:int  = 0xd3;
        
		/**
		 * 更新位置
		 */		
		public static const GAME_ROOM_UPDATE_PLACE:int = 0x64;
		
		/**
		 *  踢人
		 */	
		public static const GAME_ROOM_KICK:int = 0x62; 
		
		/**
		 * 游戏用户换队 
		 */		
		public static const GAME_TEAM:int = 0x66;
		
		/**
		 * 游戏中的指令 
		 */		
		public static const GAME_CMD:int = 0x5b;
		
		/**
		 * 玩家状态(0取消准备，准备，加载图片完成) 
		 */		
		public static const GAME_PLAYER_STATE_CHANGE:int = 0x57;
		
		/**
		 * 游戏开始 
		 */		
		public static const GAME_START:int = 0x56;
		
		/**
		 * 选择地图 
		 */		
		public static const GAME_CHANGE_MAP:Number = 0x68;
		
		/**
		 * 场景中离开用户 
		 */		
		public static const SCENE_REMOVE_USER:int = 0x15;
		
		/**
		 * 改变物品位置
		 */		
		public static const CHANGE_PLACE_GOODS:int = 0x31;
		
		/**
		 * 系统回收物品(用户出售物品)
		 */		
		public static const REClAIM_GOODS:int = 0x7f;
		
		/**
		 * 批量整理(改变)物品位置
		 */		
		public static const CHANGE_PLACE_GOODS_ALL:int = 0x7c;
		
		/**
		 * 出售物品
		 */		
		public static const SEll_GOODS:int = 0x30;
		
		
        /**
         * 撮合NPC
         */		
        public static const FIGHT_NPC:int = 0x32;
        /**
         * 更新物品
         */       	
        public static const UPDATE_GOODS:int = 0x33;
        
        /**
         * 更新金钱 
         */        
        public static const UPDATE_MONEY:int = 0x2d;
        /**
         * 更新点卷
         */        
        public static const UPDATE_COUPONS:int = 0x2e;
        
        /**
        * 更新功勋
        */
//        public static const UPDATE_OFFER:int = 0x4f;//取消了
         /**
        * 物品储存
        */
        public static const ITEM_STORE:int = 0x4f;
         /**
         * 购买物品 
         */        
        public static const BUY_GOODS:int = 0x2c;
        
		/**
		 *快速购买金币箱，并直接兑换成金币 
		 */		
		public static const BUY_QUICK_GOLDBOX:int = 0x7e;
        
        /**
        * 购买优惠大礼包
        */
        public static const BUY_GIFTBAG:int = 0x2e;

        /**
         * 穿上装备
         */        
        public static const CHAIN_EQUIP:int = 0x34;
        
        /**
         * 解除装备
         */        
        public static const UNCHAIN_EQUIP:int = 0x2f;
        
        /**
         * 维修装备
         */
        public static const REPAIR_GOODS:int = 0x35;
        
		/************************************邮件****************************************
          * 删除邮件
          */
        public static const DELETE_MAIL:int = 0x70;
        
        /**
         * 获取邮件的附件到背包 
         */        
        public static const GET_MAIL_ATTACHMENT:int = 0x71;
        
        
        /**
         *  修改邮件的已读未读标志
         */        
        public static const UPDATE_MAIL:int = 0x72;
        
        /**
         * 更新邮件
         */        
        public static const UPDATE_NEW_MAIL:int = 0x73;
        
        /**
         * 发送邮件 
         */        
        public static const  SEND_MAIL:int = 0x74;
        
        /**
         * 邮件通知 
         */        
        public static const MAIL_RESPONSE:int = 0x75;
        
        /**
        * 退回邮件
        */
        public static const MAIL_CANCEL:int = 0x76;
        
        
        /************************************道具****************************************/
		/**
		 * 购买道具 
		 */		
		public static const PROP_BUY:int = 0x36;		
		
		/**
		 *  出售道具
		 */		
		public static const PROP_SELL:int = 0x37;
		/**
		 *道具装备 
		 */		
		public static const PROP_CHAIN:int = 0x38;
		
		/**
		 * 赠送物品
		 */		
		public static const GOODS_PRESENT:int = 0x39;
		
		/**
		 *商品数量（每日限量） 
		 */		
		public static const GOODS_COUNT:int = 0xa8;
		
        /**
         * 格子物品
         */		
        public static const GRID_GOODS:int = 0x40;

        /**
         * 格子战斗与辅助道具
         */        
        public static const GRID_PROP:int = 0x41;
        
        /**
         * 更新人物样式
         */        
        public static const UPDATE_PLAYER_INFO:int = 0x43;
		
		
//		/**公会**************************************************************************/
//		/**
//		 * 申请进入公会
//		 */		
//		public static const CONSORTIA_TRYFOR_IN:int = 0x81;
//		/**
//		 * 申请创建公会
//		 */		
//		public static const CONSORTIA_TRYFOR_CREATE:int = 0x82;		
//        /**
//         * 通过申请进入
//         */        
//        public static const CONSORTIA_TRYFOR_IN_PASS:int = 0x85;
//        /**
//         * 删除进入申请
//         */        
//        public static const CONSORTIA_DEL_TRYFOR_IN:int = 0x86;
//        /**
//         * 成员升级
//         */        
//        public static const CONSORTIA_MEMBER_UPGRADE:int = 0x87;
//        /**
//         * 成员降级
//         */        
//        public static const CONSORTIA_MEMBER_DESGRADE:int = 0x88;
//        /**
//         * 踢除成员
//         */        
//        public static const CONSORTIA_MEMBER_TICKOUT:int = 0x89;
//        /**
//         * 成员改变备注 
//         */        
//        public static const CONSORTIA_MEMBER_CHANGE_REMARK:int = 0x8a;
//        /**
//         * 编辑职称
//         */        
//        public static const CONSORTIA_DUTY_EDIT:int = 0x8b;
        
        /**
         * 游戏结束点箱子 
         */        
        public static const GAME_TAKE_OUT:int = 0x6a; 
        
        /**
         * 改变装备
         */        
        public static const EQUIP_CHANGE:int = 0x42;        
        
        /**
         * 房间设置地图 
         */        
        public static const GAME_ROOM_SETUP_CHANGE:int = 0x6b;
        
        public static const PING:int = 0x04;
        /**
         * 网络状态延时 
         */        
        public static const NETWORK:int = 0x06;
        
		/**
		 * 获取战利品 
		 */		
		public static const GAME_TAKE_TEMP:int = 0x6c;
		
		
		/**
		 * 获取全部房间列表
		 */		
		public static const GAME_ROOM_LIST:int = 0x6d;
		
       	/**
       	 * RSA密钥
       	 */        
       	public static const RSAKEY:int = 0x07;
       	
       	/**
       	 * 系统消息 
       	 */       	
       	public static const SYS_MESSAGE :int = 0x03;
		
		
		/**
		 * 物品合成
		 */		
		public static const ITEM_COMPOSE:int = 0x3a;
		
		/**
		 * 物品强化
		 */		
		public static const ITEM_STRENGTHEN:int = 0x3b;
		
        /**
		 * 物品转移
		 */	
		 public static const ITEM_TRANSFER : int = 0x3d;
		
		/**
		 * 队长选择
		 */		
		public static const GAME_CAPTAIN_CHOICE:int = 0x6e;
		
		/**
		 * 确定队长
		 */		
		public static const GAME_CAPTAIN_AFFIRM:int = 0x6f;
		
		/**
		 * 场景用户列表
		 */		
		public static const SCENE_USERS_LIST:int = 0x45;
		
		/**
		 * 刷新经验 
		 */		
		public static const UPDATE_GP:int = 0x44;
		
		/**
		 * 邀请进入游戏
		 */		
		public static const GAME_INVITE:int = 0x46;
		
		/**
		 * 小喇叭
		 */		
		public static const S_BUGLE:int = 0x47;
		
		/**
		 * 大喇叭
		 */		
		public static const B_BUGLE:int = 0x48;
		/**
		 * 跨区喇叭
		 */		
		public static const C_BUGLE:int = 0x49;
        /**
         * 挑战公告 
         */	
        public static const DEFY_AFFICHE:int = 0x7b;
        	
		
		
		
		/**
         *添加好友 
         */        
        public static const FRIEND_ADD:int = 0xa0;
       	/**
       	 * 删除好友
       	 */        
       	public static const FRIEND_REMOVE:int = 0xa1;
        /**
         * 更新好友备注
         */        
        public static const FRIEND_UPDATE:int = 0xa2;
        /**
         * 好友状态
         */   
        public static const FRIEND_STATE:int = 0xa5; 
        
        
        
        /**
         * 被添加好友响应
         */        
        public static const FRIEND_RESPONSE:int = 0xa6;
        
        /**
         * 隐藏装备
         */        
        public static const ITEM_HIDE:int = 0x3c;
        
        /// <summary>
        /// 获取所有物品
        /// </summary>
        public static const ITEM_OBTAIN:int = 0x49;

        /**********************************任务********************************************/
        /**
         * 添加任务 
         */        
        public static const QUEST_ADD:int = 0xb0;
        
        /**
         * 删除任务 
         */        
        public static const QUEST_REMOVE:int = 0xb1;
        
        /**
         * 更新任务 
         */        
        public static const QUEST_UPDATE:int = 0xb2;
        
        /**
         * 完成任务 
         */        
        public static const QUEST_FINISH:int = 0xb3;
        
        /**
         * 获取所有任务 
         */        
        public static const QUSET_OBTAIN:int= 0xb4;   
        
        /**
        * 任务检查
        * */
        public static const QUEST_CHECK:int = 0xb5;
        
        
        /**
         * 续费
         */        
        public static const ITEM_CONTINUE:int = 0x3e;     
        
        
        /**
         * 同步系统时间
         */        
        public static const SYS_DATE:int = 0x05;
        /***********************************************************************************/
        
        /**
         * 获取人物资料
         */        
        public static const ITEM_EQUIP:int = 0x4a;
        
        /**
         * 系统公告
         */        
        public static const SYS_NOTICE:int = 0x0a;
        
		/**
		 * 打开物品包
		 */        
		public static const ITEM_OPENUP:int = 0x3f;
        
        /**
         * 活动领取 
         */        
        public static const ACTIVE_PULLDOWN:int = 0x0b;
        
        /**
        * 版本错误 清楚缓存
        * 
        */
        public static const EDITION_ERROR:int = 0x0c;
        
		/**
		 * 熔炼
		 */        
		public static const ITEM_FUSION:int = 0x4e;
		
		/**
		 * 熔炼/预览
		 */
		 public static const ITEM_FUSION_PREVIEW : int = 0x4c;
		 /**
		 * 炼化
		 * */
		 public static const  ITEM_REFINERY:int = 0x6e;
		 /**
		 * 炼化预览
		 * */
		 public static const ITEM_REFINERY_PREVIEW:int = 0x6f;
		 
		 /**
		 * 镶嵌
		 * */
		 public static const ITEM_INLAY:int = 0x79;
		 
		 /**
		  * 拆除镶嵌
		  * */
		 public static const ITEM_EMBED_BACKOUT:int = 0x7d;
		 
		 /**
		 * 转换
		 * */
		 public static const ITEM_TREND:int = 0x78;
		 
		 /**
		 * 清空铁匠铺隐形背包
		 * */
		 public static const CLEAR_STORE_BAG:int = 0x7a;
		 
		/**
		 * 物品过期
		 */		
		public static const ITEM_OVERDUE:int = 0x4d;
		
		/**************************拍卖行*****************************/
		/**
		 * 填加拍卖 
		 */		
		public static const AUCTION_ADD:int = 0xc0;
		
		/**
		 * 更新拍卖 
		 */		
		public static const AUCTION_UPDATE:int = 0xc1;
		
		/**
		 * 删除拍卖 
		 */		
		public static const AUCTION_DELETE:int = 0xc2;
		
		/**
		 * 刷新拍卖
		 */		
		public static const AUCTION_REFRESH:int = 0xc3;
		
		
		
		/**
		 * 验证码
		 *   */
		 
		 public static const CHECK_CODE:int =  0xc8;
		
		
		/**************************公会*******************************/
		/**
		 * 公会相应
		 */
		public static const CONSORTIA_RESPONSE:int = 0x80;
		
		
		/**
		 * 创建公会
		 */		
		public static const CONSORTIA_CREATE:int = 0x82;
		
		/**
		 * 申请加入公会
		 */		
		public static const CONSORTIA_TRYIN:int = 0x81;
		
		/**
		 * 解散公会
		 */		
		public static const CONSORTIA_DISBAND:int = 0x83;
		
		/**
		 * 是否开放公会,给玩家加入
		 */
		 public static const  CONSORTIA_APPLY_STATE : int = 0x88 ;

		
		/**
		 * 退出公会
		 */		
		public static const CONSORTIA_RENEGADE:int = 0x84;
		
		/**
		 * 通过申请进入
		 */		
		public static const CONSORTIA_TRYIN_PASS:int = 0x85;
		
		/**
		 * 删除进入申请
		 */		
		public static const CONSORTIA_TRYIN_DEL:int = 0x86;
		
		/* 上交财富 */
		public static const  CONSORTIA_RICHES_OFFER:int = 0x87;

        /**
         * 删除职称
         */
        public static const CONSORTIA_DUTY_DELETE:int = 0x8a;
        /**
         * 编辑职称
         */        
        public static const CONSORTIA_DUTY_UPDATE:int = 0x8b;
		
		/**
		 * 公会邀请
		 */		
		public static const CONSORTIA_INVITE:int = 0x8c;
		
		/**
		 * 通过邀请
		 */		
		public static const CONSORTIA_INVITE_PASS:int = 0x8e;
		
		/**
		 * 删除邀请
		 */		
		public static const CONSORTIA_INVITE_DELETE:int = 0x8f;
		
		/// <summary>
        /// 添加盟友申请
        /// </summary>
        public static const CONSORTIA_ALLY_APPLY_ADD:int = 0x90;
        /// <summary>
        /// 盟友申请更新
        /// </summary>
        public static const CONSORTIA_ALLY_APPLY_UPDATE:int = 0x91;
        /// <summary>
        /// 盟友申请删除
        /// </summary>
        public static const CONSORTIA_ALLY_APPLY_DELETE:int =0x92;
        /// <summary>
        /// 添加盟友
        /// </summary>
        public static const CONSORTIA_ALLY_UPDATE:int = 0x93;
        /// <summary>
        /// 盟友删除
        /// </summary>
        public static const CONSORTIA_ALLY_DELETE:int = 0x94;
        /// <summary>
        /// 更新公会介绍
        /// </summary>
        public static const CONSORTIA_DESCRIPTION_UPDATE:int = 0x95;
        /// <summary>
        /// 更新公会公告
        /// </summary>
        public static const CONSORTIA_PLACARD_UPDATE:int = 0x96;
		/**
		 * 禁言
		 */        
		public static const CONSORTIA_BANCHAT_UPDATE:int = 0x97;
        /**
         * 更新用户备注
         */		
        public static const CONSORTIA_USER_REMARK_UPDATE:int = 0x98;
        /// <summary>
        /// 用户职位
        /// </summary>
        public static const CONSORTIA_USER_GRADE_UPDATE:int = 0x99;
        /// <summary>
        /// 转让会长
        /// </summary>
        public static const CONSORTIA_CHAIRMAN_CHAHGE:int = 0x9a;
        
        /**
         * 公会聊天
         */        
        public static const CONSORTIA_CHAT:int = 0x9b;
        /**
         * 公会升级
         */
        public static const CONSORTIA_LEVEL_UP:int = 0x9f;
        
        /***
        * 公会银行升级
        */
        public static const CONSORTIA_STORE_UPGRADE : int = 0x9c;

        /***
        * 公会铁匠升级
        */
        public static const CONSORTIA_SMITH_UPGRADE : int = 0x9d;

        /**
        * 公会商城升级
        */
        public static const CONSORTIA_SHOP_UPGRADE : int= 0x9e;
        /**
         * 弹出/隐藏身份证验证框
         */
        public static const CID_CHECK:int = 0xe0;
        /**
         * 显示/关闭防沉迷灯
         */
        public static const ENTHRALL_LIGHT:int = 0xe3;
        /**
         * 防沉迷开关（已弃用）
         */
        public static const ENTHRALL_SWITCH:int = 0xe1;
        /**
         * 身份证是否合法（已弃用）
         */
        public static const CID_INFO_VALID:int = 0xe2;
        /**
        * buff信息
        * */
        public static const BUFF_INFO:int = 0;
        /**
        * 使用变色卡
        * */
        public static const USE_COLOR_CARD:int = 0xb6;
        /**
        * 使用卡片
        * */
        public static const CARD_USE:int = 0xb7;
        /**
         *使用改名卡 
         */
         public static const USE_REWORK_NAME:int = 0xab;
        /**
        *使用公会改名卡 
        */
        public static const USE_CONSORTIA_REWORK_NAME:int = 0xbc;                
        /**
        * 增加buff
        * */
        public static const BUFF_ADD:int = 0xb8;
        /**
        * 更新buff
        * */
        public static const BUFF_UPDATE:int = 0xb9;
        /**
        * 获取全部buff
        * */
        public static const BUFF_OBTAIN:int =0xba;

        
        /**************************婚姻*******************************/
		/**
		* 民政中心-获取登记信息
		*/  
		public static const MARRYINFO_GET:int = 0xeb;
		
		/**
		* 添加征婚信息
		*/  
		public static const MARRYINFO_ADD:int = 0xec;
		
		/**
		* 修改征婚信息
		*/  
		public static const MARRYINFO_UPDATE:int = 0xed;
		
		/**
		* 撤消征婚信息
		*/  
		public static const MARRYINFO_DELETE:int = 0xee;
		
		
		/**
		* 刷新征婚信息
		*/  
		public static const AMARRYINFO_REFRESH:int = 0xef;
		
		/**
		 * 点击物品链接请求物品信息
		 */		
		public static const LINKREQUEST_GOODS:int = 0x77;
		
		/**
		 * 玩家战斗中获得物品提示信息
		 */		
		public static const GET_ITEM_MESS:int = 0x0e;
		
		/**
		 * 提示服务器保存数据库
		 * */
		public static const SAVE_DB:int = 0xac;
		
//		/**
//		 * 用于游戏中关卡结算页面的邀请
//		 */		
//		public static const GAME_ROOM_INFO:int = 0x65;
//		
//		/**
//		 * 广播游戏信息中的玩家信息
//		 */		
//		public static const PLAY_INFO_IN_GAME:int = 0x67;
		
		
		//*********温泉系统开始  *********
		/**
		 * 温泉父协议
		 */	
		public static const HOTSPRING_CMD:int = 0xbf;
		
		/**
		 *进入温泉模块 
		 */
		public static const HOTSPRING_ENTER:int = 0xbb;
		
		/**
		 *当前玩家创建房间 
		 */		 
		public static const HOTSPRING_ROOM_CREATE:int = 0xaf;	
		
		/**
		 *温泉房间列表移除房间 
		 */
		public static const HOTSPRING_ROOM_REMOVE:int = 0xae;
		
		/**
		 *温泉房间列表新增加/更新房间 
		 */		 
		public static const HOTSPRING_ROOM_ADD_OR_UPDATE:int = 0xad;
		
		/**
		 *取得温泉房间列表
		 */
		public static const HOTSPRING_ROOM_LIST_GET:int = 0xc5;
		
		/**
		 *快速进入房间 
		 */
		public static const HOTSPRING_ROOM_QUICK_ENTER:int = 0xbe;
		
		/**
		 *进入房间 
		 */
		public static const HOTSPRING_ROOM_ENTER:int = 0xca;
		
		/**
		 *玩家进入房间视图成功
		 */
		public static const HOTSPRING_ROOM_ENTER_VIEW:int = 0xc9;
		
		/**
		 *房间内加入一个玩家 
		 */
		public static const HOTSPRING_ROOM_PLAYER_ADD:int = 0xc6;
		
		/**
		 *玩家退出房间
		 */
		public static const HOTSPRING_ROOM_PLAYER_REMOVE:int = 0xa9;
		
		/**
		 *玩家退出房间/被移出房间后广播给房间内其它玩家
		 */
		public static const HOTSPRING_ROOM_PLAYER_REMOVE_NOTICE:int = 0xc7;
		
		/**
		 *进入房间前的确认
		 */
		public static const HOTSPRING_ROOM_ENTER_CONFIRM:int = 0xd4;
		//*********温泉系统结束*********

		
		public static const GET_TIME_BOX:int = 0x35;

		//*********成就系统 ***********
		
		/**
		 *成就完成 
		 */		
		public static const ACHIEVEMENT_FINISH:int = 0xe6;
		/**
		 *更新成就进度 
		 */		
		public static const ACHIEVEMENT_UPDATE:int = 0xe5;
		/**
		 * 初始化成就进度
		 */		
		public static const ACHIEVEMENT_INIT:int   = 0xe4;
		/**
		 * 初始化成就完成时间
		 */		
		public static const ACHIEVEMENTDATA_INIT:int   = 0xe7;
		
		/**
		 *修改称号 
		 */		
		public static const USER_CHANGE_RANK:int = 0xbd;
		/**
		 *查看他人成就 
		 */		
		public static const LOOKUP_EFFORT:int = 0xcb;

		
		//*********海外宝箱*************
		/**
		 *开启宝箱 
		 */		
		//public static const LOTTERY_OPEN_BOX:int = 0x1a;
		/**
		 *开始抽奖 
		 */		
		//public static const LOTTERY_RANDOM_SELECT:int = 0x1b;
		/**
		 *结束抽奖 
		 */		
		//public static const LOTTERY_FINISH:int = 0x1c;
		/**
		 * 下发备选物品列表
		 */		
		//public static const LOTTERY_ALTERNATE_LIST:int = 0x1d;
		/**
		 *下发抽中物品信息
		 */		
		//public static const LOTTERY_GET_ITEM:int = 0x1e;
		
		//****************海外宝箱结束*************
		/**
		 *投诉反馈回复 
		 */
		public static const FEEDBACK_REPLY:int = 0xd5;
		
		
		
		public static const VIP_UPDATE:int = 0x1a;
		
		public static const WORLDBOSS_CMD:int = 0x1b;
	}
}

		















