package ddt.manager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.LocalConnection;
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	
	import road.manager.SoundManager;
	import road.ui.manager.TipManager;
	
	import ddt.data.EquipType;
	import ddt.utils.DebugUtil;
	
	[Event(name = "change",type="flash.events.Event")]
	public class SharedManager extends EventDispatcher
	{
		public var allowMusic:Boolean = true;
		public var allowSound:Boolean = true;
		public var showTopMessageBar:Boolean = true;
		private var _showInvateWindow:Boolean = true;
		public var showParticle:Boolean = true;
		
		public var showOL:Boolean = true;
		
		public var showCI:Boolean = true;
		
		/* bret 09.7.31 */
		public var showHat:Boolean = true;
		public var showGlass:Boolean = true;
		public var showSuit:Boolean = true;
		
		//音乐音量 0 - 100;
		public var musicVolumn:int = 80;
		//音效音量 0 - 100;
		public var soundVolumn:int = 80;
		
		public var StrengthMoney:int = 1000;
		public var ComposeMoney:int = 1000;
		public var FusionMoney:int = 1000;
		public var TransferMoney:int = 1000;
		public var KeyAutoSnap:Boolean = true;
		public var ShowBattleGuide:Boolean = true;
		//是否显示码头提示
//		public var isShowPierHint:Boolean = true; 
		/**
		 *是否提示无限道具卡到期 
		 */		
		public var isHintPropExpire:Boolean = true;
		
		public var AutoReady:Boolean = true;
		public var GameKeySets:Dictionary = new Dictionary();
		//玩家的拍卖信息
		public var AuctionInfos:Dictionary = new Dictionary();
		//玩家的被超出的竞拍物品信息wick
		public var AuctionIDs:Dictionary = new Dictionary();
		/**背包按钮提示只显示在没点击前,状态数据保存在本地**/
		public var setBagLocked : Boolean = false;
		/**是否强化到3级**/
		public var hasStrength3:Dictionary = new Dictionary();

		public static const KEY_SET_ABLE:Array = [10001,10003,10002,10004,10005,10006,10007,10008];
		
		public var StoreBuyInfo:Dictionary = new Dictionary();
		
		/** 死亡提示 */
		public var deadtip:int = 0;
		
		public var hasCheckedOverFrameRate:Boolean = false;
		
		public var hasEnteredFightLib:Dictionary = new Dictionary();
		/**
		 *确认强九
		 */		
		public var isAffirm:Boolean = true;

		public function get showInvateWindow():Boolean
		{
			return _showInvateWindow;
		}

		public function set showInvateWindow(value:Boolean):void
		{
			_showInvateWindow = value;
		}

		public function setup():void
		{
			load();
		}
	
		private function load():void
		{
			try
			{
				var so:SharedObject = SharedObject.getLocal("road");
				AuctionInfos  = new Dictionary();
				if(so && so.data)
				{
					if(so.data["allowMusic"]!= undefined)
						allowMusic = so.data["allowMusic"];
					if(so.data["allowSound"] != undefined)
						allowSound = so.data["allowSound"];
					if(so.data["showTopMessageBar"] != undefined)
						showTopMessageBar = so.data["showTopMessageBar"];
					if(so.data["showInvateWindow"] != undefined)
						showInvateWindow = so.data["showInvateWindow"];
					if(so.data["showParticle"] != undefined)
						showParticle = so.data["showParticle"];
						
					if(so.data["showOL"] != undefined)
						showOL = so.data["showOL"];
					if(so.data["showCI"] != undefined)
						showCI = so.data["showCI"];
					
					/* bret 09.7.31 */	
					if(so.data["showHat"] != undefined)
						showHat = so.data["showHat"];
					if(so.data["showGlass"] != undefined)
					    showGlass = so.data["showGlass"];
					if(so.data["showSuit"] != undefined)
						showSuit = so.data["showSuit"];
					//=========================================
					
					if(so.data["musicVolumn"] != undefined)
						musicVolumn = so.data["musicVolumn"];
					if(so.data["soundVolumn"] != undefined)
						soundVolumn = so.data["soundVolumn"];
					if(so.data["KeyAutoSnap"] != undefined)
						KeyAutoSnap = so.data["KeyAutoSnap"];
					if(so.data["AutoReady"] != undefined)
						AutoReady = so.data["AutoReady"];
					if(so.data["ShowBattleGuide"] != undefined)
						ShowBattleGuide = so.data["ShowBattleGuide"];
					//是否显示码头提示
//					if(so.data["isShowPierHint"] != undefined)
//						isShowPierHint = so.data["isShowPierHint"];
					if(so.data["isHintPropExpire"] != undefined)
						isHintPropExpire = so.data["isHintPropExpire"];
					if(so.data["hasCheckedOverFrameRate"] != undefined)
						hasCheckedOverFrameRate = so.data["hasCheckedOverFrameRate"];
					
					if(so.data["hasStrength3"] != undefined)
					{
						for(var key:String in so.data["hasStrength3"])
						{
							hasStrength3[key] = so.data["hasStrength3"][key];
						}					
					}
					
					
					if(so.data["GameKeySets"] != undefined)
					{
						for(var i:int = 1;i<KEY_SET_ABLE.length+1;i++)
						{
							GameKeySets[String(i)] = so.data["GameKeySets"][String(i)];
						}
					}else
					{
						for(var j:int = 0;j<KEY_SET_ABLE.length;j++)
						{
							GameKeySets[String(j+1)] = KEY_SET_ABLE[j];
						}
						
					}
					
					if(so.data["AuctionInfos"] != undefined)
					{
//						AuctionInfos = new Dictionary();
						for(var k:String in so.data["AuctionInfos"])
						{
							AuctionInfos[k] = so.data["AuctionInfos"][k];
						}
					}
					
					if(so.data["AuctionIDs"] != undefined)
					{
						AuctionIDs = so.data["AuctionIDs"];
						for(var id:String in so.data["AuctionInfos"])
						{
							AuctionIDs[id] = so.data["AuctionInfos"][id];
						}
					}
					if(so.data["setBagLocked"+PlayerManager.Instance.Self.ID] != undefined)
					{
						setBagLocked = so.data["setBagLocked"];
					}
					if(so.data["deadtip"] != undefined)
					{
						deadtip = so.data["deadtip"];
					}
					
					if(so.data["StoreBuyInfo"] != undefined)
					{
						for(var key1:String in so.data["StoreBuyInfo"])
						{
							StoreBuyInfo[key1] = so.data["StoreBuyInfo"][key1];
						}					
					}
					
					if(so.data["hasEnteredFightLib"] != undefined)
					{
						for(var key2:String in so.data["hasEnteredFightLib"])
						{
							hasEnteredFightLib[key2] = so.data["hasEnteredFightLib"][key2];
						}					
					}
					if(so.data["isAffirm"] != isAffirm)
					{
						isAffirm = so.data["isAffirm"];
					}
					
				}
			}
			catch(e:Error)
			{
				//trace(e.toString());
			}finally
			{
				changed();
			}
		}
		
		public function save():void
		{
			try
			{
				var so:SharedObject = SharedObject.getLocal("road");
				so.data["allowMusic"] = allowMusic;
				so.data["allowSound"] = allowSound;	
				/* 喇叭 */
				so.data["showTopMessageBar"] = showTopMessageBar;
				/* 邀请 */
				so.data["showInvateWindow"] = showInvateWindow;
				/* 武器特效 */
				so.data["showParticle"] = showParticle;
				/* 好友上线提示 */
				so.data["showOL"] = showOL;
				
				so.data["showCI"] = showCI;
				
				/* bret 09.7.31 */
				so.data["showHat"] = showHat;
				so.data["showGlass"] = showGlass;
				so.data["showSuit"] = showSuit;
				//=================================
				
				so.data["musicVolumn"] = musicVolumn;
				so.data["soundVolumn"] = soundVolumn;
				so.data["KeyAutoSnap"] = KeyAutoSnap;
				
				so.data["AutoReady"] = AutoReady;
				so.data["ShowBattleGuide"] = ShowBattleGuide;
				//是否显示码头提示
//				so.data["isShowPierHint"] = isShowPierHint;
				so.data["isHintPropExpire"] = isHintPropExpire;
				so.data["hasCheckedOverFrameRate"] = hasCheckedOverFrameRate;
				so.data["isAffirm"] = isAffirm;
				var obj:Object = {};
				for (var i:String in GameKeySets)
				{
					obj[i] = GameKeySets[i];
				}
				so.data["GameKeySets"] = obj;
				
				if(AuctionInfos)
				{
					so.data["AuctionInfos"] = AuctionInfos;
				}
				
				if(hasStrength3)
				{
					so.data["hasStrength3"] = hasStrength3;
				}
				
				if(hasEnteredFightLib)
				{
					so.data["hasEnteredFightLib"] = hasEnteredFightLib;
				}
				
				so.data["AuctionIDs"] = AuctionIDs;
				so.data["setBagLocked"] = setBagLocked;
				so.data["deadtip"] = deadtip;
				so.data["StoreBuyInfo"] = StoreBuyInfo;
				so.flush(20 * 1024 * 1024);
			}
			catch(e:Error)
			{
//				trace("Load shared object error:",e);
			}
			changed();
		}
		
		public function changed():void
		{
			SoundManager.Instance.setConfig(allowMusic,allowSound,musicVolumn,soundVolumn);
			for(var i:String in GameKeySets)
			{
				if(EquipType.RIGHT_PROP[int(int(i)-1)])
				{
					EquipType.RIGHT_PROP[int(int(i)-1)] = GameKeySets[i];
				}
			}
			

			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public var boxType:int = 1;
	
		private static var instance:SharedManager = new SharedManager();
		
		public static function get Instance():SharedManager
		{
			return instance;
		}
	}
}