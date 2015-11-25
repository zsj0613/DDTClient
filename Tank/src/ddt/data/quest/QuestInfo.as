package ddt.data.quest
{
	import road.data.DictionaryData;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.data.player.SelfInfo;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.TaskManager;
	import ddt.manager.TimeManager;
	
	public class QuestInfo
	{
		public var QuestID:int;
		
		/*
		 * 任务描述 
		 */		
		public var data:QuestDataInfo;
		public var Detail:String;
		public var Objective:String;
		
		/**
		 * 其他条件 0为无，1为公会，2为结婚 */
		public var otherCondition:int;
		
		public var Level:int;
		public var NeedMinLevel:int;
		public var NeedMaxLevel:int;
		public var required:Boolean = false;
		public var Type:int;/*0主线任务　1支线任务 2公会任务*/
		
		
		public var PreQuestID:String;/*前置任务 不为0时未完成*/
		public var NextQuestID:String;
		public var CanRepeat:Boolean;
		public var RepeatInterval:int;
		public var RepeatMax:int;
		public var Title:String;
	
		public var disabled:Boolean = false;
		/**
		 * 任务目标列表
		 */ 
		public var _conditions:Array;		
		/**
		 * 奖励物品列表
		 */ 
		private var _itemRewards:Array;	
		
		
		public var StrengthenLevel:int;
		public var FinishCount:int;
			
		public var ReqItemID:int;	
		public var ReqKillLevel:int;
		public var ReqBeCaption:Boolean;
		public var ReqMap:int;
		public var ReqFightMode:int;
		public var ReqTimeMode:int;
		
		
		public var RewardGold:int;
		/**
		 * 奖励点券 
		 */		
		public var RewardMoney:int;
		public var RewardGP:int;
		
		/**
		 * 奖励功勋 
		 */		
		public var RewardOffer:int;
		/**
		 * 奖励财富 
		 */		
		public var RewardRiches:int;
		public var RewardGiftToken:int;
		
		public var RewardBuffID:int;
		public var RewardBuffDate:int;
		
		public function get RewardItemCount():int{
			return this._itemRewards[0].count;
		}
		public function get RewardItemValidate():int{
			return this._itemRewards[0].count;
		}
		public function get itemRewards():Array{
			return _itemRewards
		}
		public function get Id():int{
			return QuestID;
		}
		public function get hadChecked():Boolean{
			if(data && data.hadChecked){
				return true;
			}
			return false;
		}
		public function set hadChecked(value:Boolean):void{
			if(data){
				data.hadChecked = value;
			}
		}
		/**
		 * 些任务是否有时间限制 
		 */		
		public var TimeLimit:Boolean;
		public var StartDate:Date;
		public var EndDate:Date;
		
		/**
		 * 任务奖励的Buff
		 */
		public var BuffID : int;
		public var BuffValidDate : int;
		public function BuffName() : String
		{
			return ItemManager.Instance.getTemplateById(this.BuffID).Name;
		}
		
		public function addCondition(condition:QuestCondition):void{
			if(!_conditions)_conditions = new Array();
			_conditions.push(condition);
		}
		public function addReward(reward:QuestItemReward):void{
			if(!_itemRewards)_itemRewards = new Array();
			_itemRewards.push(reward);
		}
		
		
		
		/**
		 * 是否过期 
		 * @return 
		 * 
		 */		
		public function isTimeOut():Boolean
		{
			if(TimeLimit)
			{
				var nt:Number = TimeManager.Instance.Now().time;
				if(nt < StartDate.time || nt > EndDate.time)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
			
		}
		public function get id():int{
			return QuestID;
		}
		public function get Condition():int{
			return _conditions[0].type;
		}
		public function get RewardItemID():int{
			return _itemRewards[0].itemID;
		}
		public function get RewardItemValidateTime():int{
			return _itemRewards[0].time;
		}
		public function isAvailableFor(self:SelfInfo):Boolean{
			return false;
		}
		public function get isAvailable():Boolean{
			
			if(!isAchieved){//从未完成->true
				return true;
			}
			if(!CanRepeat){//不可重复完成->false
				return false;
			}
			if(TimeManager.Instance.TotalDaysToNow2(data.CompleteDate) < RepeatInterval){//可重复，已超过时间段
				if(data.repeatLeft<1 && !data.isExist){//可重复，未超过时间段
					return false;//不可再接，不在进行中。->false
				}
			}
			return true;
		}
		public function get isAchieved():Boolean{
			if(!data || !data.isAchieved){
				return false;
			}
			return true;
		}
		public function get progress():Array{
			var self:SelfInfo = PlayerManager.Instance.Self;
			var tempArr:Array = new Array();
			for(var i:int=0;_conditions[i];i++){
				var cond:QuestCondition = _conditions[i]
				var prog:int = 0;
				
				switch(cond.type){
					case 1://升级
						prog = self.Grade;
						break;
					case 2://装备指定装备/装备ID/1
						prog = 0;
						var tempItem:InventoryItemInfo = self.getBag(BagInfo.EQUIPBAG).findEquipedItemByTemplateId(cond.param,false);//self.Bag.findFistItemByTemplateId(cond.param,false);
						if(tempItem && tempItem.Place <= 30){
							prog = 1;
						}
						break;
					//case 3://使用指定道具/道具ID/数量
					//case 4://击杀玩家若干人次/房间模式（-1不限，0撮合，1自由，2练级，3副本）/数量
					//case 5://完成战斗（无论胜败）/房间模式/数量
					//case 6://战斗胜利/房间模式/数量
					//case 7://完成副本（无论胜败）/副本ID/次数
					//case 8://通关副本（要求胜利）/副本ID/次数
					case 9://强化/装备类型/强化等级
						prog = 0;
						var equips:Array =  self.getBag(BagInfo.EQUIPBAG).findItemsForEach(cond.param);
						var storeBag:Array = self.getBag(BagInfo.STOREBAG).findItemsForEach(cond.param);
						for each(var item:InventoryItemInfo in equips){
							if(item.StrengthenLevel>=cond.target){
								prog = cond.target;
								break;
							}
						}
						for each(var storeItem:InventoryItemInfo in storeBag){
						if(storeItem.StrengthenLevel>=cond.target){
							prog = cond.target;
							break;
						}
					}
						break;
					//case 10://购买/货币类型/1
					//case 11://熔炼成功/熔炼类型/次数
					//case 12://炼化/装备类型/炼化等级
					//case 13://击杀怪物/怪物ID/数量
					case 14://拥有道具（完成任务道具不消失）/道具ID/数量
					case 15://上缴道具（完成任务道具消失）/道具ID/数量
						var count1:int = self.getBag(BagInfo.EQUIPBAG).getItemCountByTemplateId(cond.param,false);
						var count2:int = self.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(cond.param,false);
						var count3:int = self.getBag(BagInfo.CONSORTIA).getItemCountByTemplateId(cond.param,false);
						prog = count1+count2+count3;
						break;
					case 16://直接完成/空/1
						prog = 1;
						break;
					case 17://结婚/空/1
						prog = self.IsMarried?1:0;
						break;
					case 18://公会人数/空/具体人数
						switch(cond.param){
							case 0://人数
								if(PlayerManager.Instance.consortiaMemberList){
									prog = PlayerManager.Instance.consortiaMemberList.length;
								}
								break;
							case 1://贡献度
								if(PlayerManager.Instance.Self.RichesOffer || PlayerManager.Instance.Self.RichesRob){
									prog = PlayerManager.Instance.Self.RichesOffer+PlayerManager.Instance.Self.RichesRob;
								}
								break;
							case 2://铁匠铺
								if(PlayerManager.Instance.Self.SmithLevel){
									prog = PlayerManager.Instance.Self.SmithLevel;
								}
								break;
							case 3://商城
								if(PlayerManager.Instance.Self.ShopLevel){
									prog = PlayerManager.Instance.Self.ShopLevel;
								}
								break;
							case 4://保管箱
								if(PlayerManager.Instance.Self.StoreLevel){
									prog = PlayerManager.Instance.Self.StoreLevel;
								}
								break;
						}
						break;	
						case 20:/**客户端处理*/
							if(cond.param == 3){
								prog = PlayerManager.Instance.friendList.length;
								break;
							}
							break;
						/**case 27:温泉
							if(!PlayerManager.Instance.Self.LastSpaDate){
								prog = 0;
								break;
							}
							if((PlayerManager.Instance.Self.LastSpaDate as Date).fullYear<2010){
								prog = 0;
							}else{
								prog = 1;
							}
							break;*/
							//
					default:
						if(data==null || data.progress[i]==null){
							prog = 0
						}else{
							prog = cond.target - data.progress[i];
						}
					}
				tempArr[i] = cond.target - prog;
				if(tempArr[i]<0)
					tempArr[i] = 0;
			}
			return tempArr;
		}
		public function get conditionStatus():Array{
			var tempArr:Array = new Array();
			for(var i:int=0;_conditions[i];i++){
				var pro:int = progress[i];
				if(pro <= 0){
					tempArr[i] = LanguageMgr.GetTranslation("ddt.view.task.TaskCatalogContentView.over");;
					continue;
				}
				if(_conditions[i].type == 9 || _conditions[i].type == 12 || _conditions[i].type == 17 ||_conditions[i].type == 21){
					tempArr[i] =  LanguageMgr.GetTranslation("ddt.view.task.Taskstatus.onProgress")
					continue;
				}
				if(_conditions[i].type == 20 && _conditions[i].param == 2){
					tempArr[i] =  LanguageMgr.GetTranslation("ddt.view.task.Taskstatus.onProgress")
					continue;
				}
				tempArr[i] = "("+ String(_conditions[i].target - pro)+"/"+String(_conditions[i].target)+")";
				
			}
			return tempArr;
		}
		public function get conditionDescription():Array{
			var tempArr:Array = new Array();
			for(var i:int=0;_conditions[i];i++){
				var pro:int = progress[i];
				if(pro <= 0){
					tempArr[i] = _conditions[i].description + LanguageMgr.GetTranslation("ddt.view.task.TaskCatalogContentView.over");;
					continue;
				}
				if(_conditions[i].type == 9 || _conditions[i].type == 12 || _conditions[i].type == 21){
					tempArr[i] = _conditions[i].description + LanguageMgr.GetTranslation("ddt.view.task.Taskstatus.onProgress")
					continue;
				}
				if(_conditions[i].type == 20 && _conditions[i].param == 2){
					tempArr[i] = _conditions[i].description + LanguageMgr.GetTranslation("ddt.view.task.Taskstatus.onProgress")
					continue;
				}
				tempArr[i] = _conditions[i].description + "("+ String(_conditions[i].target - pro)+"/"+String(_conditions[i].target)+")";
					
			}
			return tempArr;
		}
		public function get isCompleted():Boolean{
			if(!CanRepeat && isAchieved){
				return false;
			}
			for(var i:int=0;_conditions[i]!= null;i++){
				if( progress[i] > 0)
					return false
			}
			return true;
		}
		
		/**
		 * 从XML创建任务模板对象
		 * 
		 * @return 创建的任务模板对象
		 * */
		public static function createFromXML(xml:XML):QuestInfo{
			//build a quest
			var quest:QuestInfo = new QuestInfo();
			quest.QuestID = xml.@ID;
			quest.Type = xml.@QuestID;
			quest.Detail = xml.@Detail;
			quest.Title = xml.@Title;
			quest.Objective = xml.@Objective;
			
			quest.NeedMinLevel = xml.@NeedMinLevel;
			quest.NeedMaxLevel = xml.@NeedMaxLevel;
			quest.PreQuestID = xml.@PreQuestID
			quest.NextQuestID = xml.@NextQuestID;
			quest.CanRepeat = xml.@CanRepeat=="true"? true:false;
			quest.RepeatInterval = xml.@RepeatInterval;
			quest.RepeatMax = xml.@RepeatMax;
			
			quest.RewardGold = xml.@RewardGold;
			quest.RewardGP = xml.@RewardGP;
			quest.RewardMoney = xml.@RewardMoney;
			quest.RewardOffer = xml.@RewardOffer;
			quest.RewardRiches = xml.@RewardRiches;
			quest.RewardGiftToken = xml.@RewardGiftToken;
			quest.TimeLimit = xml.@TimeMode;
			
			quest.RewardBuffID = xml.@RewardBuffID;
			quest.RewardBuffDate = xml.@RewardBuffDate;
			
			quest.otherCondition = xml.@IsOther;
			
			quest.StartDate = new Date((String(xml.@StartDate).substr(5,2)+"/"+String(xml.@StartDate).substr(8,2)+"/"+String(xml.@StartDate).substr(0,4)));
			quest.EndDate = new Date(String(xml.@EndDate).substr(5,2)+"/"+String(xml.@EndDate).substr(8,2)+"/"+String(xml.@EndDate).substr(0,4))
			
			//fill the conditions
			var conditions:XMLList = xml..Item_Condiction;
			for(var i:int = 0; i < conditions.length(); i ++){
				var tempCondXML:XML = conditions[i];
				var tempCondition:QuestCondition = new QuestCondition(quest.QuestID,tempCondXML.@CondictionID,tempCondXML.@CondictionType,tempCondXML.@CondictionTitle,tempCondXML.@Para1,tempCondXML.@Para2);
				//增加客户端本地监听
				switch(tempCondition.type){
					case 1:
						TaskManager.addGradeListener();
						break;
					case 2:
					case 14:
					case 15://监听物品
						TaskManager.addItemListener(tempCondition.param);
						break;
					case 18://公会人数
						break;
					case 20://客户端处理
						switch(tempCondition.param){
							case 1://登陆器
								TaskManager.addDesktopListener(tempCondition);
								break;
							case 2://邮寄
								TaskManager.addAnnexListener(tempCondition);
								break;
							case 3://
								TaskManager.addFriendListener(tempCondition);
								break;
						}
						break;
					default:
				}
				quest.addCondition(tempCondition);
			}
			
			//fill the rewards
			var rewards:XMLList = xml..Item_Good;
			for(var j:int = 0; j < rewards.length(); j ++){
				var tempItemXML:XML = rewards[j];
				var tempReward:QuestItemReward = new QuestItemReward(tempItemXML.@RewardItemID,tempItemXML.@RewardItemCount,tempItemXML.@IsSelect);
				tempReward.time = tempItemXML.@RewardItemValid;
				tempReward.AttackCompose = tempItemXML.@AttackCompose;
				tempReward.DefendCompose = tempItemXML.@DefendCompose;
				tempReward.AgilityCompose = tempItemXML.@AgilityCompose;
				tempReward.LuckCompose = tempItemXML.@LuckCompose;
				tempReward.StrengthenLevel = tempItemXML.@StrengthenLevel;
				tempReward.IsCount = tempItemXML.@IsCount;
				quest.addReward(tempReward);
			}
			
			//deal with the preQuests;
			
			return quest;
		}
	}
}