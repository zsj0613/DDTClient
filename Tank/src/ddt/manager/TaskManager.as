package ddt.manager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import road.comm.PackageIn;
	import road.data.DictionaryEvent;
	import road.ui.controls.hframe.HAlertDialog;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.data.player.SelfInfo;
	import ddt.data.quest.*;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.events.TaskEvent;
	import ddt.request.task.GetTaskItemTemplateInfo;
	import ddt.states.StateType;
	import ddt.utils.BitArray;
	import ddt.view.bagII.BagEvent;
	import ddt.view.common.BellowStripViewII;
	import ddt.view.taskII.TaskMainFrame;
	
	
	
	[Event(name="changed",type="ddt.events.TaskEvent")]
	[Event(name="add",type="ddt.events.TaskEvent")]
	[Event(name="remove",type="ddt.events.TaskEvent")]
	public class TaskManager
	{
		
		public static const achievementQuestNo:int = 256;
		public static var itemAwardSelected:int;
		public static var selectedQuest:QuestInfo;
		
		
		/****
		 * 事件控制
		 */
		private static var _dispatcher:EventDispatcher = new EventDispatcher();
		public static function addEventListener(type:String,listener:Function):void
		{
			_dispatcher.addEventListener(type,listener);
		}
		public static function removeEventListener(type:String,listener:Function):void
		{
			_dispatcher.removeEventListener(type,listener);
		}
		
		
		
		
		
		/************************************************************
		 * **********************************************************
		 *                 启动任务模块
		 * **********************************************************
		 * **********************************************************
		 */
		
		/** 
		 * 初始化任务管理
		 * 获取任务模板
		 * */
		public static function setup():void
		{
			new GetTaskItemTemplateInfo().loadSync(__loadTaskComplete,3);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QUEST_UPDATE,__updateAcceptedTask);//
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QUEST_FINISH,__questFinish);//
		}
		private static function __loadTaskComplete(loader:GetTaskItemTemplateInfo):void
		{
			if(loader.isSuccess)
			{
				allQuests = loader.list;
			}
			else
			{
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Error"),LanguageMgr.GetTranslation("ddt.manager.TaskManager.loader"),false,__retry);
				//AlertDialog.show("错误","加载任务列表失败,确定后重试!",false,__retry);
			}
		}
		private static function __retry():void
		{
			setup();
		}
	
		
		
		
		/** 二进制保存的任务完成历史记录 */
		private static var _questLog:BitArray;
		
		/** 加载任务历史记录 */
		public static function loadQuestLog(value:ByteArray):void{
			value.position = 0;
			if(_questLog == null)
				_questLog = new BitArray();
			for(var i:int = 0;i<value.length;i++){
				_questLog.writeByte(value.readByte());
			}
		}
		/** 从任务历史记录中查看任务是否曾经完成 */
		private static function IsQuestFinish(questId:int):Boolean
        {
        	if(!_questLog){
        		return false;
        	}
            if (questId > _questLog.length * 8 || questId < 1)
                return false;
            questId--;
            var index:int = questId / 8;
            var offset:int = questId % 8;
            var result:int = _questLog[index] & (0x01 << offset);
            return result != 0;
        }

		/************************************************************
		 * **********************************************************
		 *                 任务数据逻辑
		 * **********************************************************
		 * **********************************************************
		 */		
		
		/** 任务模板表 */
		public static var allQuests:Dictionary;
		
		/**由ID获取指定任务模板
		 * @param id 任务ID，与数据库中的数据一致。
		 */ 
		public static function getQuestByID(id:int):QuestInfo
		{
			if(!allQuests)return null;
			return allQuests[id];
		}
		/**由ID获取指定任务数据
		 * @param id 任务ID，与数据库中的数据一致。
		 */ 
		public static function getQuestDataByID(id:int):QuestDataInfo
		{
			if(!getQuestByID(id))return null;
			return getQuestByID(id).data;
		}
		
		/**获取所有可接受的任务列表
		 * @param type 过滤任务类型，默认为-1时不过滤,0为主线任务(main)，1为支线任务(side)，2为日常任务(daily)。
		 * @default -1
		 * @return 包含所有可以接受的任务模板的数组
		 */ 
		public static function getAvailableQuests(type:int = -1,onlyExist:Boolean = true):QuestCategory{
			var cate:QuestCategory = new QuestCategory();
			
			
			for each(var info:QuestInfo in allQuests){
				if(type>-1&&type!=info.Type){
					continue;
				}
				if(onlyExist && info.data && !info.data.isExist){
					requestQuest(info);
					continue;
				}
				if(isAvailableQuest(info,true)){
					if(info.Id == achievementQuestNo){
						continue;
					}
					if(info.isCompleted){
						cate.addCompleted(info);
						continue;
					}
					if(info.data && info.data.isNew){
						cate.addNew(info);
						continue;
					}
					cate.addQuest(info);
				}
			}
			return cate;
		}
		
		public static function getQuestCategory():void{
			
		}
		
		/** 所有可用任务 */
		public static function get allAvailableQuests():Array{
			return getAvailableQuests(-1,false).list;
		}
		/** 所有可用主线任务 */
		public static function get mainQuests():Array{
			return getAvailableQuests(0,true).list;
		}
		/** 所有可用支线任务 */
		public static function get sideQuests():Array{
			return getAvailableQuests(1,true).list;
		}
		/** 所有可用日常任务 */
		public static function get dailyQuests():Array{
			return getAvailableQuests(2,true).list;
		}
		
		
		public static var _newQuests:Array = new Array();
		public static function get newQuests():Array{
			var tempArr:Array = new Array();
			for each(var info:QuestInfo in allAvailableQuests){
				if(info.data && info.data.needInformed && info.Type != 2){
					tempArr.push(info);
				}
			}
			_newQuests = tempArr;
			return tempArr;
		}
		
		public static var _currentCategory:int = 0;
		public static function set currentCategory(value:int):void{
			_currentCategory = value;
		}
		public static function get currentCategory():int{
			if(selectedQuest){
				return selectedQuest.Type;
			}
			return _currentCategory;
		}
		public static var currentQuest:QuestInfo;
		//每日引导使用的任务列表
		/**每日引导获取每日任务列表,其中元素为QuestInfo类，可用属性title:String和isCompleted:Boolean。
		 * 未完成任务排在前面。
		 * @return 任务数组
		 */ 
		public static function get welcomeQuests():Array{
			var tempArr:Array = new Array;
			for each(var info:QuestInfo in dailyQuests){
				if(info.otherCondition != 1){
					tempArr.push(info);
				}
			}
			tempArr = tempArr.reverse();
			return tempArr;
		}
		/**每日引导获取每日公会任务列表,其中元素为QuestInfo类，可用属性title:String和isCompleted:Boolean。
		 * 未完成任务排在前面。
		 * @return 任务数组
		 */ 
		public static function get welcomeGuildQuests():Array{
			var tempArr:Array = new Array;
			for each(var info:QuestInfo in dailyQuests){
				if(info.otherCondition == 1){
					tempArr.push(info);
				}
			}
			tempArr = tempArr.reverse();
			return tempArr;
		}

		
		/** 读取已经接受的可用的任务列表
		 */ 

		public static function getTaskData(id:int):QuestDataInfo
		{
			if(getQuestByID(id)){
				return getQuestByID(id).data
			}else{
				return null;
			}
		}

		
		
		
		/*************************************************************
		 * ***********************************************************
		 * ***********************************************************
		 *                   对任务的检查
		 * ***********************************************************
		 * ***********************************************************/
		
		/**判断任务是否可用
		 * @param info 任务模板
		 * @param checkExist 是否限定服务器已接受
		 * @return 任务是否可用
		 * 
		 */
		private static function isAvailableQuest(info:QuestInfo,checkExist:Boolean=false):Boolean
		{
			//为系统禁用
			if(info.disabled){
				return false;
			}
			
			//检查等级
			
			var self:SelfInfo = PlayerManager.Instance.Self;
			
			if(info.NeedMinLevel > self.Grade || info.NeedMaxLevel < self.Grade)
			{
				return false;
			}
			//检查前置任务
			if(info.PreQuestID !="0,")
			{
				var preArr:Array = [];
				preArr = info.PreQuestID.split(",");
				for each(var preId:int in preArr){
					if(preId == 0)continue;
					if(getQuestByID(preId)){
						var preQuest:QuestInfo = getQuestByID(preId)
						if(!preQuest)return false						
						if(!isAchieved(preQuest)){
							return false;
						}
					}
				}
			}
			//检查日期，公会，结婚
			if(!(isValidateByDate(info)&&isAvailableByGuild(info)&&isAvailableByMarry(info)))
			{
				return false;
			}
			//检查重复任务时间限制
			if(haveLog(info)){
				return false;
			}
			if(!info.isAvailable)
			{
				return false;
			}
			if((!info.data || !info.data.isExist)&& info.CanRepeat){
				requestQuest(info);
				if(checkExist){
					return false;	
				}
			}
			return true;
		}
		
		public static function isAchieved(info:QuestInfo):Boolean{
			if(info.isAchieved){
				return true;
			}
			if(IsQuestFinish(info.Id)){
				return true;
			}
			return false;
		}
		private static function haveLog(info:QuestInfo):Boolean{
			if(info.CanRepeat){
				return false;
			}
			if(IsQuestFinish(info.Id))
			{
				return true;
			}
			return false;
		}
		
		
		/**检查任务是否过期***/
		public static function isValidateByDate(info:QuestInfo):Boolean
		{
			if(!info) return false;
			return !info.isTimeOut();
		}
		/**检查公会任务**/
		public static function isAvailableByGuild(info : QuestInfo) : Boolean
		{
			if(!info)return false;
			return (info.otherCondition != 1 || PlayerManager.Instance.Self.ConsortiaID != 0);
		}
		/**检查结婚任务**/
		public static function isAvailableByMarry(info : QuestInfo) : Boolean
		{
			if(!info)return false;
			return (info.otherCondition != 2 || PlayerManager.Instance.Self.IsMarried);
		}
		
		
		
		
		
		
		
		
		
		
		/***********************************************************************
		 * *********************************************************************
		 * *********************************************************************
		 *                   任务的Socket
		 * *********************************************************************
		 * ********************************************************************/

		/**获取个人任务信息*/
		private static function __updateAcceptedTask(event:CrazyTankSocketEvent):void{
			/**Package结构
				length
					questDataInfo[id,isCompleted,con0,con1,con2,con3,date]
			* */
			var pkg:PackageIn = event.pkg;
			var length:int = pkg.readInt();
			for(var i:int = 0;i<length;i++){
				var id:int = pkg.readInt();
				var info:QuestInfo = new QuestInfo();
				if(getQuestByID(id)){
					info = getQuestByID(id);
				}else{
					continue;
				}
				
				var data:QuestDataInfo;
				if(info.data){
					data = info.data;
				}else{
					data = new QuestDataInfo(id);
					if(info.required){
						data.isNew = true;
					}
				}
				data.isAchieved = pkg.readBoolean();
				var con0:int = pkg.readInt();
				var con1:int = pkg.readInt();
				var con2:int = pkg.readInt();
				var con3:int = pkg.readInt();
				data.setProgress(con0,con1,con2,con3);
				data.CompleteDate = pkg.readDate();
				data.repeatLeft = pkg.readInt();
				data.quality = pkg.readInt();
				data.isExist = pkg.readBoolean();
				info.data = data;
				if(data.isNew){
					addNewQuest(info);
				}
				_dispatcher.dispatchEvent(new TaskEvent(TaskEvent.CHANGED,info,data));
			}
			loadQuestLog(pkg.readByteArray());
			checkHighLight();
		}
		private static function addNewQuest(info:QuestInfo):void{
			if(!_newQuests){
				_newQuests = new Array();
			}
			_newQuests.push(info);
			BellowStripViewII.Instance.newQuest();
			//TaskMainFrame.Instance.newQuest(info);
		}
		public static function clearNewQuest():void{
			for each(var info:QuestInfo in allAvailableQuests){
				if(info.data)info.data.isNew = false;
			}
		}
		private static function __questFinish(evt:CrazyTankSocketEvent):void{
			var pkg:PackageIn = evt.pkg;
			var id:int = pkg.readInt();
			if(id == TaskManager.achievementQuestNo){
				return;
			}
			onFinishQuest(id);

		}
		private static function onFinishQuest(id:int):void{
			var info:QuestInfo = getQuestByID(id);
			if(info.isAvailable || info.NextQuestID){
				requestCanAcceptTask();
			}
			_dispatcher.dispatchEvent(new TaskEvent(TaskEvent.FINISH,info,info.data));
		}
		
		/**在未打开任务窗口的情况下弹出该窗口,并发出聊天信息**/
		private static function popTaskFrame() : void
		{
			if(!TaskMainFrame.Instance.parent)
			{
				var state : String = StateManager.currentStateType;
				if(StateManager.currentStateType == StateType.SERVER_LIST)return;
				if(StatisticManager.Instance().IsNovice == true)
				{
					if(StatisticManager.loginRoomListNum <= 1)
					{
						if(StateManager.currentStateType == StateType.ROOM_LIST)
						{
							return;/**新手被弹入到房间列表时,不弹出窗口**/
						}
					}
				}
				else
				{
					if(StateManager.currentStateType != StateType.FIGHTING)
					{
						MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.TaskManager.ChannelListSelectView"));
						TaskMainFrame.Instance.switchVisible();
					}
					var str : String = LanguageMgr.GetTranslation("ddt.manager.TaskManager.ChannelListSelectView");
			        //msg.msg = "您领取了新任务，请及时查看。";
					ChatManager.Instance.sysChatRed(str);
				}
						
			}
		}
		
		
		public static function jumpToQuest(info:QuestInfo):void{
			if(TaskMainFrame.Instance.posView){
				TaskMainFrame.Instance.posView.jumpToQuest(info);
			}
		}
		
		/*****************************************************
		 * ***************************************************
		 *      客户端自动检查任务的逻辑
		 * ***************************************************
		 * **************************************************/
		
		 
		/**背包更新时,对任务的检查**/
		public static function onBagChanged():void//无引用
		{
			checkHighLight();
		}
		
		/**
		 *公会设施任务的检查 
		 *  
		 */		
		 public static function onGuildUpdate() : void
		 {
		 	checkHighLight();
		 }
		/**玩家升级时,对任务的检查**/
		public static function onPlayerLevelUp():void//无引用
		{
			checkHighLight();
		}
			
			
			
		
		
		
	
		/*************************************************************
		 * ***********************************************************
		 * ***********************************************************
		 *                    特殊任务
		 * ***********************************************************
		 * ***********************************************************/
		
		/**完成结婚任务**/
		public static function finshMarriage():void
		{
			//判断升级的任务
			for each(var info:QuestInfo in allQuests)
			{
				var data:QuestDataInfo = info.data;
				if(!data){
					continue;
				}
				if(!data.isAchieved)
				{
					if(info.Condition == 21)
					{
						showTaskHightLight();
					}
				}
			}
			requestCanAcceptTask();
		}
		
		/*************************************************************
		 * 					成就任务相关
		 * 
		 * ***********************************************************/
	
		public static function get achievementQuest():QuestInfo{
			return TaskManager.getQuestByID(achievementQuestNo);
		}
		/**
		 * 成就任务领奖
		 * */
		public static function requestAchievementReward():void{
			SocketManager.Instance.out.sendQuestFinish(achievementQuestNo,0);
		}
		/*********************************************************
		 * *******************************************************
		 * *******************************************************
		 *                     请求任务
		 * *******************************************************
		 * ******************************************************/
		
		/**请求可接受的任务**/
		public static function requestCanAcceptTask() : void
		{
			if(StateManager.currentStateType == StateType.SERVER_LIST || StateManager.currentStateType == StateType.LOGIN){
				return
			};
			var temp:Array = allAvailableQuests;
			if(temp.length != 0)
			{
				var arr : Array = new Array();
				for each(var info:QuestInfo in temp)
				{
					if(info.data && info.data.isExist){
						continue;
					}
					arr.push(info.QuestID);
					info.required = true;
					
				}
				
				socketSendQuestAdd(arr);
			}
		}
		public static function requestQuest(info:QuestInfo):void{
			if(StateManager.currentStateType == StateType.SERVER_LIST || StateManager.currentStateType == StateType.LOGIN){
				return
			};
			var arr : Array = new Array();
			arr.push(info.QuestID);
			info.required = true;
			socketSendQuestAdd(arr);
		}
		

		/**请求公会任务**/
		public static function requestClubTask() : void
		{
			var temp : Array = new Array();
			for each(var info:QuestInfo in allAvailableQuests)
			{
				if(info.otherCondition == 1)
				{
					if(isAvailableQuest(info))temp.push(info.QuestID);
				}
			}
			if(temp.length>0)socketSendQuestAdd(temp);
			
		}
		

		/**客户端监听*/
		/**物品改变*/
		private static var _itemListenerArr:Array;
		public static function addItemListener(itemId:int):void{
			if(!_itemListenerArr){
				_itemListenerArr = new Array();
			}
			_itemListenerArr.push(itemId);
			
			var self:SelfInfo = PlayerManager.Instance.Self;
			self.getBag(BagInfo.EQUIPBAG).addEventListener(BagEvent.UPDATE,__onBagUpdate);
			self.getBag(BagInfo.PROPBAG).addEventListener(BagEvent.UPDATE,__onBagUpdate);
			
		}
		private static function __onBagUpdate(evt:BagEvent):void{
			for each(var item:InventoryItemInfo in evt.changedSlots){
				for each(var id:int in _itemListenerArr){
					if(id == item.TemplateID){
						checkHighLight()
					};
				}
			}
		}
		/**监听结婚*/
		public static function addGradeListener():void{
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPlayerPropertyChange);
		}
		private static function __onPlayerPropertyChange(e:PlayerPropertyEvent):void{
			if(e.changedProperties["Grade"]){
				checkHighLight();
			}
		}
		
		public static function onMarriaged():void{
			checkHighLight();
		}
		/**公会人数改变*/
		public static function addGuildMemberListener():void{
			
		}
		/**邮寄物品*/
		private static var _annexListenerArr:Array
		private static var _usingDesktopApp:Boolean = false;
		private static var _desktopCond:QuestCondition;
		public static function addAnnexListener(cond:QuestCondition):void{
			if(!_annexListenerArr){
				_annexListenerArr = new Array();
			}
			_annexListenerArr.push(cond);
		}
		public static function addDesktopListener(cond:QuestCondition):void{
			_desktopCond = cond;
			if(_usingDesktopApp){
				checkQuest(_desktopCond.questID,_desktopCond.ConID,0)
			}
		}
		public static function onDesktopApp():void{
			_usingDesktopApp = true;
			if(_desktopCond){
				checkQuest(_desktopCond.questID,_desktopCond.ConID,0)
			}
		}
		public static function onSendAnnex(itemArr:Array):void{
			for each(var item:InventoryItemInfo in itemArr){
				for each(var cond:QuestCondition in _annexListenerArr){
					if(cond.param2 == item.TemplateID){
						if(isAvailableQuest(getQuestByID(cond.questID),true)){
							checkQuest(cond.questID,cond.ConID,0);
						}
					};
				}
			}
		}
		private static var _friendListenerArr:Array
		public static function addFriendListener(cond:QuestCondition):void{
			if(!_friendListenerArr){
				_friendListenerArr = new Array();
			}
			_friendListenerArr.push(cond);
			PlayerManager.Instance.addEventListener(PlayerManager.FRIENDLIST_COMPLETE,__onFriendListComplete);
			addEventListener(TaskEvent.CHANGED,__onQuestChange);
		}
		private static function __onQuestChange(evtObj:TaskEvent):void{
			for each(var cond:QuestCondition in _friendListenerArr){
				if(evtObj.info.Id  == cond.questID){
					checkQuest(cond.questID,cond.ConID,cond.param2 - PlayerManager.Instance.friendList.length)
				}
			}
		}
		private static function __onFriendListComplete(e:Event):void{
			PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.ADD,__onFriendListUpdated);
			PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.REMOVE,__onFriendListUpdated);
			for each(var cond:QuestCondition in _friendListenerArr){
				checkQuest(cond.questID,cond.ConID,cond.param2 - PlayerManager.Instance.friendList.length)
			}
		}
		private static function __onFriendListUpdated(e:DictionaryEvent):void{
			for each(var cond:QuestCondition in _friendListenerArr){
				checkQuest(cond.questID,cond.ConID,cond.param2 - PlayerManager.Instance.friendList.length)
			}
		}
		
		public static function HighLightChecked(info:QuestInfo):void{
				if(info.isCompleted){
					info.hadChecked = true;
				}
		}
		
		
		
		
		//Helper Functions
		private static function checkQuest(id:int,conID:int,value:int):void{
			SocketManager.Instance.out.sendQuestCheck(id,conID,value)
		}
		private static function socketSendQuestAdd(arr:Array):void{
			SocketManager.Instance.out.sendQuestAdd(arr);
		}
		public static function checkHighLight():void{
			var count:int = 0;
			for each(var info:QuestInfo in allAvailableQuests){
				if(!info.isAchieved || info.CanRepeat){
					if(info.isCompleted){
						count++;
						/* if(!info.hadChecked){
							count++;
						} */
					}
				}
			}
			if(count>0){
				showTaskHightLight();
			}else{
				if(!TaskMainFrame.Instance.parent)BellowStripViewII.Instance.hideTaskHightLight();
			}
		}
		private static function showTaskHightLight():void{
			var s:String = StateManager.currentStateType;
			if(!TaskMainFrame.Instance.parent)BellowStripViewII.Instance.showTaskHightLight();
		}
	}
}