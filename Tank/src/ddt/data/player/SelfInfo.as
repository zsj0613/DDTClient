package ddt.data.player
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import road.data.DictionaryData;
	import road.ui.manager.TipManager;
	
	import ddt.data.BuffInfo;
	import ddt.data.ConsortiaInfo;
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.manager.ChatManager;
	import ddt.manager.ExternalInterfaceManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MailManager;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PVEMapPermissionManager;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ServerManager;
	import ddt.manager.StateManager;
	import ddt.manager.TaskManager;
	import ddt.manager.TimeManager;
	import ddt.request.LoadConsortiaEventList;
	import ddt.request.LoadConsortias;
	import ddt.request.LoadFriendList;
	import ddt.request.LoadSelfConsortiaMemberList;
	import ddt.request.bag.LoadBodyThing;
	import ddt.states.StateType;
	import ddt.utils.StringUtils;
	import ddt.view.bagII.BagEvent;
	import ddt.view.chatsystem.ChatData;
	import ddt.view.chatsystem.ChatInputView;
	import ddt.view.common.AddPricePanel;
	
	
	public class SelfInfo extends PlayerInfo
	{
		
		public function SelfInfo():void
		{
			PropBag = new BagInfo(BagInfo.PROPBAG,48);
			FightBag = new BagInfo(BagInfo.FIGHTBAG,48);
			TempBag = new BagInfo(BagInfo.TEMPBAG,48);
			ConsortiaBag = new BagInfo(BagInfo.CONSORTIA,100);
			StoreBag = new BagInfo(BagInfo.STOREBAG,11);
		}
//		public var ConsortiaAllyList:DictionaryData = new DictionaryData();
		public var CivilPlayerList:Array = new Array();     //bret
		private var _timer:Timer;
		private static const buffScanTime:int = 60;//60分钟到期提示
		private var _questionOne:String;
		private var _questionTwo:String;
		private var _leftTimes:int = 5;
		
		public var IsGM:Boolean;
		private var __VIPLevel:int;
		public override function set VIPLevel(value:int):void
		{
			__VIPLevel = value;
			onPropertiesChanged("VIPLevel");
		}
		public override function get VIPLevel():int
		{
			return __VIPLevel;
		}
		
		private var _ChargedMoney:int;
		public function set ChargedMoney(value:int):void
		{
			_ChargedMoney = value;
			onPropertiesChanged("ChargedMoney");
		}
		public function get ChargedMoney():int
		{
			return _ChargedMoney;
		}
		
		
		
		public var IsNovice:Boolean;
		
				
		/**
		 * 民政中心-登记ID bret
		 */
		 
		private var _marryInfoID:int;
		public function set MarryInfoID(value:int):void
		{
			_marryInfoID = value
			onPropertiesChanged("MarryInfoID");
		}
		public function get MarryInfoID():int
		{
			return _marryInfoID;
		}
		
		/**
		 * 民政中心-个人简介 bret
		 */
		 private var _civilIntroduction:String;
		 public function set Introduction(value:String):void
		 {
		 	_civilIntroduction = value;
		 	onPropertiesChanged("Introduction");
		 }
		 public function get Introduction():String
		 {
		 	if(_civilIntroduction == null)_civilIntroduction = "";
		 	return _civilIntroduction;
		 }
		 
		 /**
		 * 民政中心-装备是否允许查看 bret
		 */
		 private var _isPublishEquit:Boolean;
		 public function set IsPublishEquit(value:Boolean):void
		 {
		 	_isPublishEquit = value;
		 	onPropertiesChanged("IsPublishEquit");
		 }
		 public function get IsPublishEquit():Boolean
		 {
		 	return _isPublishEquit;
		 }
		/**
		 * 0有锁,1无锁,2解锁,3未解锁
		 ***/
		private var _bagPwdState : Boolean;
		public function set bagPwdState($bagpwdstate : Boolean) : void
		{
			_bagPwdState = $bagpwdstate;
		}
		public function get bagPwdState() : Boolean
		{
			return _bagPwdState;
		}
		private var _bagLocked : Boolean;
		public function set bagLocked(b : Boolean) : void
		{
			_bagLocked = b;
			onPropertiesChanged("bagLocked");
		}
		public function get bagLocked() : Boolean
		{
			if(!_bagPwdState)
			{
				return false;
			}
			return _bagLocked;
		}
		
		//是否需要填写密码保护
		private var _shouldPassword:Boolean;
		
		public function get shouldPassword():Boolean{
			return _shouldPassword;
		}
		
		public function set shouldPassword(value:Boolean):void{
			_shouldPassword = value;
		}
		
		//二级密码事件集中派发
		public function onReceiveTypes(value:String):void{
			dispatchEvent(new BagEvent(value,new Dictionary()));
		}
		
		
		/**
		 * 是否在所在的公会被禁言
		 */
		
		public var IsBanChat:Boolean;
		public var _props:DictionaryData;
		public function resetProps():void
		{
			_props = new DictionaryData();
		}
		
		public function findOvertimeItems(lefttime:Number = 0):Array
		{
//			var temp : Array = new Array();
//			temp.push(new Array());
//			temp.push(new Array());
//			copyArray(PropBag.findOvertimeItems(),temp[0]);
//			copyArray(FightBag.findOvertimeItems(),temp[0]);
//			copyArray(TempBag.findOvertimeItems(),temp[0]);
//			copyArray(ConsortiaBag.findOvertimeItems(),temp[0]);
			return getOverdueItems();
		}
//		private function copyArray(arr : Array,arr2:Array) : void
//		{
//			for(var i:int=0;i<arr.length;i++)
//			{
//				arr2.push(arr[i]);
//			}
//		}
		
		public function getOverdueItems():Array
		{
			var betoArr:Array = [];
			var hasArr:Array = [];
			
			var bagA:Array = StringUtils.getOverdueItemsFrom(PropBag.items);
			var bagB:Array = StringUtils.getOverdueItemsFrom(FightBag.items);
			var bagC:Array = StringUtils.getOverdueItemsFrom(Bag.items);
		/* 	var body:Array = StringUtils.getOverdueItemsFrom(ConsortiaBag.items);

			betoArr = betoArr.concat(bagA[0],bagB[0],body[0],bagC[0]);
			hasArr = hasArr.concat(bagA[1],bagB[1],body[1],bagC[1]); 个人保管箱里，不续费 Open 2009,11,09 */ 
			
			var body:Array = StringUtils.getOverdueItemsFrom(ConsortiaBag.items);

			betoArr = betoArr.concat(bagA[0],bagB[0],[],bagC[0]);
			hasArr = hasArr.concat(bagA[1],bagB[1],[],bagC[1]);

			return [betoArr,hasArr];
		}
		
		/**
		 * 是否第一次登陆
		 */		
		private var _isFirst:int;
		public function set IsFirst(b : int) : void
		{
			_isFirst = b;
		}
		public function get IsFirst() :int
		{
			return _isFirst;
		}
		
		
		/**
		 * 查找背包物品的个数 
		 */		
		public function findItemCount(tempId:int):int
		{
			return Bag.getItemCountByTemplateId(tempId);
		}
		
		public function loadPlayerItem():void
		{
			new LoadBodyThing(ID,loadBodyThingComplete).loadSync();
		}
		private var FirstLoaded:Boolean = false;
		public function loadRelatedPlayersInfo():void
		{
			if(FirstLoaded) return;
			FirstLoaded = true;
			new LoadSelfConsortiaMemberList(ConsortiaID).loadSync();
			new LoadFriendList(ID).loadSync();
			MailManager.Instance.loadMail(3);
//			if(ConsortiaID)
//			{
//				new LoadConsortiaAllyList(ConsortiaID,-1,-1,10000).loadSync(__loadAllyConsortiaComplete);
//			}
		}
		
		/**
		 * 公会事件
		 *   */
		 
		private var _consortiaEventList:Array = [];
		public function loadMyConsortiaEventList(page:int,size:int,order:int = -1,consortiaID:int = -1) : void
		{
			new LoadConsortiaEventList(page,size,order,consortiaID).loadSync(__onLoadConsortiaEventListResult);
		}
		private function __onLoadConsortiaEventListResult(loader : LoadConsortiaEventList) : void
		{
			myConsortiaEventList = loader.list;
		}
		
		public function get myConsortiaEventList():Array
		{
			return _consortiaEventList;
		}
		
		public function set myConsortiaEventList(data:Array):void
		{
			_consortiaEventList = data;
			onPropertiesChanged("myConsortiaEventList");
		}
		
		
//		private function __loadAllyConsortiaComplete(loader:LoadConsortiaAllyList):void
//		{
//			for(var i:uint = 0;i<loader.list.length;i++)
//			{
//				ConsortiaAllyList.add(loader.list[i]["ConsortiaID"], loader.list[i]);
//			}
////			trace("AllyListComplete");
//		}
		
		public function refleshSelfConsortiaMemberList():void
		{
			new LoadSelfConsortiaMemberList(ConsortiaID).loadSync();
		}
		
		private function loadBodyThingComplete(itemData:DictionaryData,buffData:DictionaryData):void
		{
			for each(var i:InventoryItemInfo in itemData)
			{
				Bag.addItem(i);
			}
			for each(var j:BuffInfo in buffData)
			{
				super.addBuff(j);
			}
		}
		
		public function refreshConsortiaRelateList():void
		{
			if(ConsortiaID == 0)
			{
				PlayerManager.Instance.consortiaMemberList.clear();
//				ConsortiaAllyList.clear();
				PlayerManager.Instance.consortiaMemberList = new DictionaryData();
//				ConsortiaAllyList = new DictionaryData();
			}else
			{
				new LoadSelfConsortiaMemberList(ConsortiaID).loadSync();
//				new LoadConsortiaAllyList(ConsortiaID,-1,-1,10000).loadSync(__loadAllyConsortiaComplete);
			}
			
		}
		
		public function getPveMapPermission(mapid:int,level:int):Boolean
		{
			return PVEMapPermissionManager.Instance.getPermission(mapid,level,PvePermission);
		}
		
		
		
		public function sendGetMyConsortiaData():void
		{
			if(ConsortiaID != 0)
			{
				new LoadConsortias(1,1,-1,"",-1,ConsortiaID).loadSync(__setMyConsortiaData);
			}
		}
		
		private function __setMyConsortiaData(loader:LoadConsortias):void
		{
			PlayerManager.Instance.SelfConsortia = loader.list[0] as ConsortiaInfo;
			PlayerManager.Instance.SelfConsortia.Placard = loader.list[0].Placard;
			PlayerManager.Instance.Self.beginChanges();
			PlayerManager.Instance.Self.ConsortiaLevel = loader.list[0].Level;
			PlayerManager.Instance.Self.ConsortiaRepute = loader.list[0].Repute;
//			PlayerManager.Instance.Self.ConsortiaRepute = PlayerManager.Instance.SelfConsortia.Repute;
			PlayerManager.Instance.Self.ConsortiaRiches = loader.list[0].Riches;//PlayerManager.Instance.SelfConsortia.LastDayRiches;
			PlayerManager.Instance.Self.ConsortiaHonor  = PlayerManager.Instance.SelfConsortia.Honor;
			PlayerManager.Instance.Self.ConsortiaLevel  = PlayerManager.Instance.Self.ConsortiaLevel;
			PlayerManager.Instance.Self.ShopLevel       = PlayerManager.Instance.SelfConsortia.ShopLevel;
			PlayerManager.Instance.Self.SmithLevel      = PlayerManager.Instance.SelfConsortia.SmithLevel;
			PlayerManager.Instance.Self.StoreLevel      = PlayerManager.Instance.SelfConsortia.StoreLevel;
			PlayerManager.Instance.Self.commitChanges();
			onPropertiesChanged("SelfConsortia");
			if(StateManager.currentStateType != StateType.SERVER_LIST)TaskManager.onGuildUpdate();
		}
		
		
		public var isTryinConsortia:Boolean;
		
		public function canEquip(info:InventoryItemInfo):Boolean
		{
			if(!EquipType.canEquip(info))
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.data.player.SelfInfo.this"));
				//MessageTipManager.getInstance().show("此类物品不能被装备");
			}
			else if(info.getRemainDate() <= 0)
			{
				AddPricePanel.Instance.setInfo(info,true)
				TipManager.AddTippanel(AddPricePanel.Instance,true);
			}
			else if(info.NeedSex != 0 && info.NeedSex != ( Sex ? 1 : 2))
			{
				
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.data.player.SelfInfo.object"));
				//MessageTipManager.getInstance().show("物品所需性别不同，不能装备");
			}
			else if(info.NeedLevel > Grade)
			{
				
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.data.player.SelfInfo.need"));
				//MessageTipManager.getInstance().show("所需等级不够，不能装备");
			}
			else
			{
				return true;
			}
			return false;	
		}
		
		override public function addBuff(buff:BuffInfo):void
		{
			super.addBuff(buff);
			if(!_timer)
			{
				_timer = new Timer(1000*60);
	    		_timer.addEventListener(TimerEvent.TIMER,__refreshSelfInfo);
	     		_timer.start();
			}
		}
		
		private function __refreshSelfInfo(evt:TimerEvent):void
		{
			refreshBuff();
		}
		
		private function refreshBuff():void
		{
			for each(var buff:BuffInfo in _buffInfo)
			{
				if((buff.ValidDate-Math.floor((TimeManager.Instance.Now().time - buff.BeginData.time)/(1000*60))-1) == buffScanTime)
				{
					var msg:ChatData = new ChatData();
	             	msg.channel = ChatInputView.SYS_TIP;
	             	msg.msg = LanguageMgr.GetTranslation("ddt.view.buffInfo.outDate",buff.buffName,buffScanTime);
	            	ChatManager.Instance.chat(msg);
				}
			}
		}
		private var _questList:Array;
		/**
		 * 检查玩家是否完成某一任务
		 * @param 任务ID
		 * @return 是否完成任务的布尔值
		 * */
		public function achievedQuest(id:int):Boolean{
			if(_questList && _questList[id])return true;
			return false;
		}
		
		
		public function unlockAllBag():void
		{
			Bag.unLockAll();
			PropBag.unLockAll();
		}
		
		public function getBag(bagType:int):BagInfo
		{
			switch(bagType)
			{
				case BagInfo.EQUIPBAG:
					return Bag;
				case BagInfo.PROPBAG:
					return PropBag;
				case BagInfo.FIGHTBAG:
					return FightBag;
				case BagInfo.TEMPBAG:
					return TempBag;
				case BagInfo.CONSORTIA:
					return ConsortiaBag;
				case BagInfo.STOREBAG:
					return StoreBag;
			}
			return null;
		}
		
		public function get questionOne():String{
			return _questionOne;
		}
		
		public function set questionOne(value:String):void{
			_questionOne = value;
		}
		
		public function get questionTwo():String{
			return _questionTwo;
		}
		
		public function set questionTwo(value:String):void{
			_questionTwo = value;
		}
		
		public function get leftTimes():int{
			return _leftTimes;
		}
		
		public function set leftTimes(value:int):void{
			_leftTimes = value;	
		}
		
		public function getMedalNum():int
		{
			var value1:int = PropBag.getItemCountByTemplateId(EquipType.MEDAL);
			var value2:int = ConsortiaBag.getItemCountByTemplateId(EquipType.MEDAL);
			return value1+value2;
		}
		
		public var PropBag:BagInfo;
		public var FightBag:BagInfo;
		public var TempBag:BagInfo;
		public var ConsortiaBag:BagInfo;
		
		private var _overtimeList:Array;
		
		public function get OvertimeListByBody():Array
		{
			return PlayerManager.Instance.Self.Bag.findOvertimeItemsByBody();
		}
		
		private var sendedGrade:Array=[];
		override public function set Grade(value:int):void
		{
			super.Grade = value;
			if(IsUpdate && PathManager.solveExternalInterfaceEnabel() &&sendedGrade.indexOf(value)==-1)
			{
				ExternalInterfaceManager.sendToAgent(2,ID,NickName,ServerManager.Instance.zoneName,Grade);
				sendedGrade.push(Grade);
			}	
		}

//		
//		public function set OvertimeListByBody(value:Array):void
//		{
//			_overtimeList = value;
//		}
		public var StoreBag:BagInfo;
	}
}

class DateGeter {
	public static var date:Date;

}