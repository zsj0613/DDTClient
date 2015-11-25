package ddt.data.socket
{
	public class CrazyTankPackageType
	{
		/**
		 * 玩家位置
		 */		
		public static const MOVE:int = 0x01;
		
		/**
		 * 射击 
		 */		
		public static const FIRE:int = 0x02;
		
		/**
		 * 爆炸 
		 */		
		public static const BLAST:int = 0x03;
		
		/**
		 *  换攻击玩家 
		 */		
		public static const TURN:int = 0x06;
		
		/**
		 * 改变方向 
		 */		
		public static const DIRECTION:int = 0x07;
		
		/***
		 * 方向锁定
		 */
		public static const SEND_PICTURE : int = 0x80;
		
		/**
		 *  枪的角度
		 */		
		public static const GUN_ROTATION:int = 0x08;

		/**
		 * 开始走 
		 */		
		public static const MOVESTART:int = 0x09;
		
		/**
		 * 生物状态改变
		 * */
		public static const CHANGE_STATE:int = 0x76;
		
		/**
		 * 停止走 
		 */		
		public static const MOVESTOP:int = 0x0a;		

		/**
		 * (血) 
		 */		
		public static const HEALTH:int = 0x0b;
		
		/**
         * 跳过 
         */        
        public static const SKIPNEXT:int = 0x0c;
        
        /**
         * 必杀技 
         */        
        public static const STUNT:int = 0x0f;
		
		/**
		 * 怒气值 
		 */		
		public static const DANDER:int = 0x0e;
		/**
		 * delay值 
		 */		
		public static const DELAY:int = 0x0d;
		
		/**
		 * 游戏玩家加载进度
		 */		
		public static const LOAD:int = 0x10;
		
		/**
		 * 掉到地图外
		 */		
		public static const SUICIDE:int = 0x11;
		
		/**
		 * 跟踪 
		 */		
		public static const CHANGEBALL:int = 0x13;
		
		/**
		 * 改变子弹 
		 */		
		public static const CHANGE_BALL:int = 0x14;
		
		/**
		 * 自杀 
		 */		
		public static const KILLSELF:int = 0x15; 
		
		/**
		 * 近战攻击 
		 */		
		public static const BEAT:int = 0x16;
		
        /**
         * 使用道具 
         */        
        public static const USEPROP:int = 0x2a;
        
        /**
         * 增加攻击率 
         */        
        public static const ATTACKUP:int = 0x2b;
       	/**
       	 *  描准
       	 */        
       	public static const SHOOTSTRAIGHT:int = 0x2c;
		/**
		 * 增加伤害 
		 */       	
		public static const  ADDWOUND:int = 0x2d;     
		/**
		 *  增加攻击次数
		 */		  	
		public static const  ADDATTACK:int = 0x2e; 
		
		/**
		 * 增加子弹数量 
		 */		
		public static const ADDBALL:int = 0x2f;      
		
		/**
		 *  道具
		 */		
		public static const PROP:int = 0x20;
		
		/**
		 * 冰冻 
		 */		
		public static const FROST:int = 0x21;
		
		/***
		 * 免坑
		 */
		public static const NONOLE : int = 0x52;
		
		/**
		 * 封印
		 * */
		public static const LOCK_STATE : int = 0x29;

		/**
		 * 无敌 
		 */		
		public static const INVINCIBLY:int = 0x22;
		
		/**
		 * 隐藏 
		 */		
		public static const HIDE:int = 0x23;
		
		/**
		 * 传送 
		 */				
		public static const CARRY:int = 0x24;
		
		/**
		 * 召唤
		 */		
		public static const BECKON:int = 0x25;

		/**
		 * 改变风向 
		 */		
		public static const VANE:int = 0x26;
		
		/**
		 * 飞机（传送） 
		 */		
		public static const AIRPLANE:int = 0x28;
		/**
		 *加血抢 
		 */		
//		public static const ADD_BLOOD:int = 0x54;
		/**
		 *使用副武器 
		 */		
		public static const USE_DEPUTY_WEAPON : int = 0x54;
		/**
		 * 珠宝攻击,珠宝防御
		 */
		public static const GEM_GLOW : int = 0x81;
		
		/**
		 *增加提示信息层 
		 */		
		public static const ADD_TIP_LAYER : int = 0x44;
		
		
		/**
		 * 游戏中出箱子 
		 */		
		public static const ADD_MAP_THINGS:int = 0x30;
        /**
         * 发送服务器捡箱子
         */		
        public static const PICK:int = 0x31;
        
        /**
         * 子弹飞行中的点 
         */        
        public static const ARKPOINT:int = 0x32;
        
        /**
         * 结束面板 
         */        
        public static const TAKEOUT:int = 0x33;
        
        /**
         * 服务器发送客户端 
         */        
        public static const FIGHTPROP:int = 0x34;

        /**
         * 箱子消失 
         */        
        public static const DISAPPEAR:int = 0x35;
        
         /**
         * 鬼魂目标 
         */        
        public static const GHOST_TARGET:int = 0x36;
		/**
		 * 战利品容器 
		 */		
//		public static const TEMP_INVENTORY:int  = 0x40;
		
		/**
		 * 游戏中扔道具 
		 */		
		public static const PROP_DELETE:int = 0x4b;
		
		/**
		 * 开始发射炮弹和结束 
		 */		
		public static const FIRE_TAG:int = 0x60;
		
		public static const WANNA_LEADER:int = 0x61;
		
		public static const TAKE_CARD:int = 0x62;
		
		public static const START_GAME:int = 0x63;

        public static const GAME_OVER:int = 0x64;

        public static const GAME_CREATE:int = 0x65;

        public static const GAME_CAPTAIN_AFFIRM:int = 0x66;

        public static const GAME_LOAD:int = 0x67;
        
        public static const MISSION_OVE:int = 0x70;
        public static const GAME_ALL_MISSION_OVER:int = 0x73;
        
        public static const PLAY_MOVIE:int = 0x3c;
        public static const PLAY_SOUND:int = 0x3f;
        public static const LOAD_RESOURCE:int = 0x43;
		public static const ADD_LIVING:int = 0x40;
		
		public static const  LIVING_MOVETO:int = 0x37;
       	public static const  LIVING_FALLING:int = 0x38;
       	public static const  LIVING_JUMP:int = 0x39;
       	public static const  LIVING_BEAT:int = 0x3a;
       	public static const  LIVING_SAY:int = 0x3b;
       	public static const  LIVING_RANGEATTACKING:int = 0x3d;
       	public static const  FOCUS_ON_OBJECT:int = 0x3e;
       	
       	
       	/**
       	 * 关卡信息
       	 */
       	 public static const BARRIER_INFO : int = 0x68;
		 
		 /**
		  *作战实验室信息 
		  */		 
		 public static const FIGHT_LIB_INFO_CHANGE:int = -1;
		 
		 /**
		  *跳过剧情动画 
		  */		 
		 public static const PASS_STORY:int = 0x85;
       	 
       	 /**
       	 * 加木板
       	 */
       	 public static const ADD_MAP_THING : int = 0x41;
       	 /**
       	 * 木板状态改变
       	 */
       	 public static const UPDATE_BOARD_STATE : int = 0x42;
       	 
       	 /***
       	 * 关卡信息
       	 */
       	 public static const GAME_MISSION_INFO : int = 0x71;
       	 
       	 /**
       	  * 付费翻牌
       	  */       	 
       	 public static const PAYMENT_TAKE_CARD : int = 0x72;
       	 
       	 /**
       	  * BOSS战付费失败
       	  */       	 
       	 public static const INSUFFICIENT_MONEY : int = 0x58;
       	 
       	 /**
       	  * 展示所有未翻的奖牌
       	  */       	 
       	 public static const SHOW_CARDS : int = 0x59;
       	 
       	 /***
       	 * 开始下一关
       	 */
       	 public static const GAME_MISSION_START : int = 0x75;
       	 
       	 /***
       	 * 关卡准备
       	 */
       	 public static const GAME_MISSION_PREPARE : int = 0x74;
       	 
       	 /**
       	  * 再玩一次
       	  */       	 
       	 public static const GAME_MISSION_TRY_AGAIN:int = 0x77;
       	 
		 public static const  LIVING_DIR_CHANGED:int = 0x17;
		 
		 /**
		  * 被邀请玩家的游戏信息
		  */		 
		 public static const PLAY_INFO_IN_GAME:int = 0x78;
		 
		 /**
		  * 创建GameInfo
		  */		 
		 public static const GAME_ROOM_INFO:int = 0x79;
		 
		 /**
		  * BOSS翻牌
		  */		 
		 public static const BOSS_TAKE_CARD:int = 0x82;
		 
		 /**
		  * BOSS翻牌
		  */		 
		 public static const SYNC_LIFETIME:int = 0x83;
		 
		 /**
		  * 播放旁白文字
		  */		 
		 public static const PLAY_ASIDE:int = 0x84;
		 
		 /**
		 * 禁止玩家拖拽右上方的小地图
		 * */
		 public static const FORBID_DRAG:int = 0x45;
		 
		 /**
		 * 把一个东西放到最上层
		 * */
		 public static const TOP_LAYER:int = 0x46;
		 
		 /**
		 * 控制背景音乐的播放
		 * */
		 public static const CONTROL_BGM:int = 0x47;
		 
		 
		 /**
		  * 目标改变位置
		  * */
		 public static const LIVING_BOLTMOVE :int = 0x48;

		 
		 /**
		 * 改变显示目标
		 */
		 public static const CHANGE_TARGET:int = 0x49;
		 /**
		  * 作战实验室通用命令 
		  * type 0 产生小怪
		  * type 
		  */		 
		 public static const GENERAL_COMMAND:int = 0x17;
		 
		 /**
		  *战斗实验室 弹出答题框 
		  */		 
		 public static const POPUP_QUESTION_FRAME:int = 0x18;
	}
}