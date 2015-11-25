package ddt.manager
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import road.data.DictionaryData;
	import road.ui.controls.hframe.HAlertDialog;
	
	import ddt.data.effort.EffortCompleteStateInfo;
	import ddt.data.effort.EffortInfo;
	import ddt.data.effort.EffortProgressInfo;
	import ddt.data.effort.EffortQualificationInfo;
	import ddt.data.effort.EffortRewardInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.events.EffortEvent;
	import ddt.request.effort.GetEffortItemTemplateInfo;
	import tank.view.effort.EffortCategoryTitleAsset;
	import ddt.view.effort.EffortMainFrame;
	import ddt.view.effort.EffortMovieClipView;
	
	public class EffortManager extends EventDispatcher
	{
		/** 成就模板表 */
		private var allEfforts:DictionaryData;
		/**
		 *综合 
		 */		
		private var integrationEfforts:Array;
		/**
		 *角色
		 */		
		private var roleEfforts:Array;
		/**
		 * 任务
		 */		
		private var taskEfforts:Array;
		/**
		 * 副本
		 */		
		private var duplicateEfforts:Array;
		/**
		 * 战斗
		 */		
		private var combatEfforts:Array;
		/**
		 *当前 
		 */		
		private var currentEfforts:Array;
		/**
		 *最近完成 
		 */	
		private var newlyCompleteEffort:Array;

		/**
		 * 前置成就（可显示）
		 */
		private var preEfforts:DictionaryData;
		
		
		/**
		 * 后置成就（不可显示） 
		 */		
		private var nextEfforts:DictionaryData;
		/**
		 *已完成的 
		 */
		private var completeEfforts:DictionaryData;
		
		/**
		 *未完成的 
		 */	
		private var inCompleteEfforts:DictionaryData;
		
		/**
		 * 成就进展
		 */		
		private var progressEfforts:DictionaryData;
		
		/**
		 *称号 
		 */	
		private var honorArray:Array;
		
		/**
		 *  成就模板表II这个模板表用来对照显示别人的成就，不进行赋值的
		 * temp打头的数据用来储存其他玩家
		 **/
		private var allEffortsII:DictionaryData;
		
		private var tempPreEfforts:DictionaryData;
		
		private var tempCompleteEfforts:DictionaryData;
		
		private var tempInCompleteEfforts:DictionaryData;
		
		private var tempIntegrationEfforts:Array;
		
		private var tempRoleEfforts:Array;
		
		private var tempTaskEfforts:Array;
		
		private var tempDuplicateEfforts:Array;
		
		private var tempCombatEfforts:Array;
		
		private var tempNewlyCompleteEffort:Array;
		
		private var tempCompleteID:Array
		
		private var tempAchievementPoint:int;
		
		private var _isSelf:Boolean;
		public function EffortManager()
		{
		}
		
		public function setup():void
		{
			initDictionaryData();
			new GetEffortItemTemplateInfo().loadSync(__loadEffortComplete);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACHIEVEMENT_UPDATE,__updateAchievement);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACHIEVEMENT_FINISH,__AchievementFinish);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACHIEVEMENT_INIT,__initializeAchievement);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACHIEVEMENTDATA_INIT,__initializeAchievementData);
		//	SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOOKUP_EFFORT,__lookUpEffort);
		}
		
		private function initDictionaryData():void
		{
			preEfforts		  = new DictionaryData();
			nextEfforts       = new DictionaryData();
			progressEfforts   = new DictionaryData();
			completeEfforts   = new DictionaryData();
			inCompleteEfforts = new DictionaryData();
		}
		
		private function __loadEffortComplete(loader:GetEffortItemTemplateInfo):void
		{
			if(loader.isSuccess)
			{
				allEfforts = loader.list;
				allEffortsII = loader.list;
			}
			else
			{
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Error"),LanguageMgr.GetTranslation("ddt.manager.EffortManager.loader"),false,__retry);
				//AlertDialog.show("错误","加载成就列表失败,确定后重试!",false,__retry);
			}
		}
		
		private function __retry():void
		{
			setup();
		}
		
		public function  getProgressEfforts():DictionaryData
		{
			return progressEfforts;
		}
		/**由ID获取指定成就模板
		 * @param id 成就ID，与数据库中的数据一致。
		 */ 
		public function getEffortByID(id:int):EffortInfo
		{
			if(!allEfforts)return null;
			return allEfforts[id];
		}
		
		public function getIntegrationEffort():Array
		{
			return integrationEfforts;
		}
		
		public function getRoleEffort():Array
		{
			return roleEfforts;
		}
		
		public function getTaskEffort():Array
		{
			return taskEfforts;
		}
		
		public function getDuplicateEffort():Array
		{
			return duplicateEfforts;
		}
		
		public function getCombatEffort():Array
		{
			return combatEfforts;
		}
		
		public function getNewlyCompleteEffort():Array
		{
			return newlyCompleteEffort;
		}
		
		public function getHonorArray():Array
		{
			honorArray = [];
			for each( var info:EffortInfo in completeEfforts )
			{
				if(!info.effortRewardArray)continue;
				for(var i:int = 0 ; i<info.effortRewardArray.length;i++ )
				{
					if((info.effortRewardArray[i] as EffortRewardInfo).RewardType == 1)
					{
						var tempArray:Array = [];
						tempArray[0] = info.ID
						tempArray[1] = splitTitle((info.effortRewardArray[i] as EffortRewardInfo).RewardPara);
						honorArray.push(tempArray);
					}
				}
			}
			return honorArray;
		}

		public function get completeList():DictionaryData
		{
			return completeEfforts;
		}
		
		public function get fullList():DictionaryData
		{
			return allEfforts;
		}
		
		public function get currentEffortList():Array
		{
			return currentEfforts;
		}
		
		public function set currentEffortList(currentList:Array):void
		{
			currentEfforts = [];
			currentEfforts = currentList;
			dispatchEvent(new EffortEvent(EffortEvent.LIST_CHANGED));
		}
		
		private var currentType:int;
		public function setEffortType(type:int):void
		{
			currentType = type;
			switch(type)
			{
				case 0:
					splitEffort(preEfforts);
					break;
				
				case 1:
					splitEffort(completeEfforts);
					break;
				
				case 2:
					splitEffort(inCompleteEfforts);
					break;
			}
			dispatchEvent(new EffortEvent(EffortEvent.TYPE_CHANGED));
		}
		
		private function splitEffort(dic:DictionaryData):void
		{
			if(!dic)return;
			integrationEfforts  = [];
			roleEfforts 		= [];
			taskEfforts 		= [];
			duplicateEfforts 	= [];
			combatEfforts 		= [];
			for each(var i:EffortInfo in dic)
			{
//				成就显示的位置，0为综合，1为角色，2为任务，3为副本，4为战斗
				if(!i)continue;
				switch(i.PlaceID)
				{
					case 0:
						integrationEfforts.push(i);
						break;
					case 1:
						roleEfforts.push(i);
						break;
					case 2:
						taskEfforts.push(i);
						break;
					case 3:
						duplicateEfforts.push(i);
						break;
					case 4:
						combatEfforts.push(i);
						break;
				}
			}
		}
		/**
		 * 更新成就进展
		 */		
		private  function __updateAchievement(evt:CrazyTankSocketEvent):void
		{
			var info:EffortProgressInfo = new EffortProgressInfo();
			info.RecordID	 	= evt.pkg.readInt();
			info.Total		   	= evt.pkg.readInt();
			progressEfforts[info.RecordID] = info;
			updateProgress(info);
		}
		/**
		 * 初始化成绩进展
		 */		
		private function __initializeAchievement(evt:CrazyTankSocketEvent):void
		{
			var len:int = evt.pkg.readInt();
			for(var i:int = 0 ;i< len ; i++)
			{
				var info:EffortProgressInfo = new EffortProgressInfo();
				info.RecordID = evt.pkg.readInt();
				info.Total = evt.pkg.readInt();
				progressEfforts[info.RecordID] = info;
			}
			trace("初始化成绩进展成功")
			updateWholeProgress();
		}
		/**
		 * 特殊变量只有一个用途判断玩家是否是第一次完成成就，为0的时候则玩家是第一次完成成就
		 */	
		private var count:int;
		/**
		 * 初始化已完成成就
		 */		
		private function __initializeAchievementData(evt:CrazyTankSocketEvent):void
		{
			newlyCompleteEffort = [];
			var len:int = evt.pkg.readInt();
			count = len;
			for(var i:int = 0; i< len ; i++)
			{
				var info:EffortCompleteStateInfo = new EffortCompleteStateInfo();
				info.ID =  evt.pkg.readInt();
				var date:Date = new Date();
				date.fullYearUTC = evt.pkg.readInt();
				date.monthUTC = evt.pkg.readInt();
				date.dateUTC = evt.pkg.readInt();
				info.CompletedDate = date;
				if(allEfforts[info.ID])
				{
					(allEfforts[info.ID] as EffortInfo).CompleteStateInfo = info;
					(allEfforts[info.ID] as EffortInfo).completedDate     = info.CompletedDate;
					if(i<4)newlyCompleteEffort.push(allEfforts[info.ID]);
				}
			}
			splitPreEffort();
			trace("已完成初始化成功")
		}
		
		/**
		 * 拆分前置成就和后续成就
		 */	
		private function splitPreEffort():void
		{
			for each(var info:EffortInfo in allEfforts)
			{
				if(estimateEffortState(info))
				{
					preEfforts[info.ID] = info;
				}else
				{
					nextEfforts[info.ID]= info; 
				}
			}
			splitCompleteEffort();
			splitEffort(preEfforts);
		}
		
		/**
		 * 传入EffortInfo判断该成就是否可以显示出来(前置成就全部完成则可以显示)
		 */	
		private function estimateEffortState(info:EffortInfo):Boolean
		{
			var strArray:Array = [];
			strArray = info.PreAchievementID.split(",");
			if(strArray.length == 2 && strArray[0] == "0")
			{
				return true;
			}
			for(var i:int = 0 ; i <= strArray.length ; i++ )
			{
				if(strArray[i] == "")break;
				if((allEfforts[int(strArray[i])] as EffortInfo).CompleteStateInfo == null)
				{
					return false;
				}
			}
			return true;
		}
		
		/**
		 * 从可显示的字典preEfforts里面拆分已完成的成就和未完成的成就
		 */		
		private function splitCompleteEffort():void
		{
			for each(var info:EffortInfo in preEfforts)
			{
				if(info.CompleteStateInfo != null)
				{
					completeEfforts[info.ID]   = info;
				}else
				{
					inCompleteEfforts[info.ID] = info;
				}
			}
			trace("已完成拆分成功")
		}
		
		
		private function __AchievementFinish(evt:CrazyTankSocketEvent):void
		{
			var info:EffortCompleteStateInfo = new EffortCompleteStateInfo();
			info.ID =  evt.pkg.readInt();
			var date:Date = new Date();
			date.fullYearUTC = evt.pkg.readInt();
			date.monthUTC = evt.pkg.readInt();
			date.dateUTC = evt.pkg.readInt();
			info.CompletedDate = date;
			trace("接受完成"+info.ID)
			EffortMovieClipManager.Instance.addQueue(allEfforts[info.ID] as EffortInfo);
			if(inCompleteEfforts[info.ID])
			{
				(inCompleteEfforts[info.ID] as EffortInfo).CompleteStateInfo = info;
				(inCompleteEfforts[info.ID] as EffortInfo).completedDate = info.CompletedDate;
			}
			if(allEfforts[info.ID])
			{
				(allEfforts[info.ID] as EffortInfo).CompleteStateInfo = info;
				(allEfforts[info.ID] as EffortInfo).completedDate     = info.CompletedDate;
			}
			completeToInComplete(info.ID);
			if(newlyCompleteEffort)newlyCompleteEffort.unshift(completeEfforts[info.ID]);
			dispatchEvent(new EffortEvent(EffortEvent.FINISH));
		}
		
		private static var _instance:EffortManager;
		public static function get Instance():EffortManager
		{
			if(_instance == null)
			{
				_instance = new EffortManager();
			}
			return _instance;
		}
		
		private function updateWholeProgress():void
		{
			for each( var effortInfo:EffortInfo in allEfforts)
			{
				for each(var effortQualificationInfo:EffortQualificationInfo in effortInfo.EffortQualificationList)
				{
					if(!progressEfforts[effortQualificationInfo.CondictionType])trace("成就进展出错，没有" + effortQualificationInfo.CondictionType + "（CondictionType）");
					effortQualificationInfo.para2_currentValue = (progressEfforts[effortQualificationInfo.CondictionType] as EffortProgressInfo).Total
					effortInfo.addEffortQualification(effortQualificationInfo);
				}
				allEfforts[effortInfo.ID] = effortInfo;
			}
			trace("初始化成绩赋值成功")
			if(count == 0)
			{
				var tempArray:Array = [];
				for each(var i:EffortInfo in allEfforts)
				{
					if(testEffortIsComplete(i))
					{
						tempArray.push(i);
					}
				}
				tempArray.sortOn("ID")
				for (var j:int = 0 ; j < tempArray.length ; j++)
				{
					trace("初始化发送已完成"+tempArray[j].ID)
					SocketManager.Instance.out.sendAchievementFinish(tempArray[j].ID);
				}
				
			}
		}
		/**
		 * 传入EffortProgressInfo更新所有相同条件类型（CondictionType）的进展值
		 */		
		private function updateProgress(info:EffortProgressInfo):void
		{
			var tempArray:Array = [];
			for each( var effortInfo:EffortInfo in allEfforts)
			{
				for each(var effortQualificationInfo:EffortQualificationInfo in effortInfo.EffortQualificationList)
				{
					if(effortQualificationInfo.CondictionType == info.RecordID)
					{
						effortQualificationInfo.para2_currentValue = info.Total;
						effortInfo.addEffortQualification(effortQualificationInfo);
					}
				}
			}
			for each( var i:EffortInfo in inCompleteEfforts)
			{
				if(testEffortIsComplete(i))
				{
					tempArray.push(i)
				}
			}
			for each( var j:EffortInfo in nextEfforts)
			{
				if(testEffortIsComplete(j))
				{
					tempArray.push(j)
				}
			}
			if(tempArray && tempArray[0])
			{
				tempArray.sortOn("ID")
			}
			for (var k:int = 0 ; k < tempArray.length ; k++)
			{
				trace("初始化发送已完成"+tempArray[k].ID)
				SocketManager.Instance.out.sendAchievementFinish(tempArray[k].ID);
			}
		}
		/**
		 * 传入成就测试成就是否完成
		 */
		private function testEffortIsComplete(info:EffortInfo):Boolean
		{
			for each(var effortQualificationInfo:EffortQualificationInfo in info.EffortQualificationList)
			{
				if(effortQualificationInfo.para2_currentValue < effortQualificationInfo.Condiction_Para2)
				{
					return false;
				}
			}
			return true;
		}
		
		public function splitTitle(str:String):String
		{
			var strArray:Array = [];
			strArray = str.split("/");
			if(strArray.length > 1 && strArray[1] != "")
			{
				if(PlayerManager.Instance.Self.Sex)
				{
					return strArray[0];
				}else
				{
					return strArray[1];
				}
			}else
			{
				return strArray[0];
			}
			return "";
		}
		
		public function testFunction(id:int):void
		{
			EffortMovieClipManager.Instance.addQueue(currentEffortList[0]);
		}
		
		/**
		 * 把未完成的成就字典添加到已完成的成就字典里
		 */		
		private function completeToInComplete(id:int):void
		{
			completeEfforts.add(id,inCompleteEfforts[id]);
			inCompleteEfforts.remove(id);
			nextToPre();
		}
		
		/**
		 * 把后继成就从不可显示的字典里添加到可现实的字典里 
		 */		
		private function nextToPre():void
		{
			for each(var info:EffortInfo in nextEfforts)
			{
				if(estimateEffortState(info))
				{
					preEfforts.add(info.ID , info);
					if(testEffortIsComplete(info))
					{
						completeEfforts.add(info.ID,info);
					}else
					{
						inCompleteEfforts.add(info.ID,info);
					}
				}
			}
			setEffortType(currentType);
		}
		
		public function lookUpEffort(id:int):void
		{
			SocketManager.Instance.out.sendLookupEffort(id);
		}
		
		private function __lookUpEffort(evt:CrazyTankSocketEvent):void
		{
			tempPreEfforts         = new DictionaryData();
			tempCompleteEfforts    = new DictionaryData();
			tempInCompleteEfforts  = new DictionaryData();
			
			tempNewlyCompleteEffort= [];
			tempCompleteID         = [];
			tempAchievementPoint = evt.pkg.readInt();
			var len:int = evt.pkg.readInt();
			for(var i:int = 0; i< len ; i++)
			{
				if(len == 0)break;
				tempCompleteID[i] =  evt.pkg.readInt();
				tempCompleteEfforts[tempCompleteID[i]] = allEffortsII[tempCompleteID[i]];
				if(i<4)tempNewlyCompleteEffort[i] = allEffortsII[tempCompleteID[i]];
			}
			for each( var info:EffortInfo in allEffortsII)
			{
				if(estimateTempEffortState(info))
				{
					tempPreEfforts[info.ID] = info;
					if(!tempCompleteEfforts[info.ID])
					{
						tempInCompleteEfforts[info.ID] = info;
					}
				}
			}
			setTempEffortType(0);
			isSelf = false;
			EffortMainFrame.Instance.switchVisible();
		}
		
		private function estimateTempEffortState(info:EffortInfo):Boolean
		{
			var strArray:Array = [];
			strArray = info.PreAchievementID.split(",");
			if(strArray.length == 2 && strArray[0] == "0")
			{
				return true;
			}
			for(var i:int = 0 ; i <= strArray.length ; i++ )
			{
				if(strArray[i] == "")break;
				if(tempCompleteEfforts[int(strArray[i])] == null)
				{
					return false;
				}
			}
			return true;
		}
		
		public function setTempEffortType(type:int):void
		{
			switch(type)
			{
				case 0:
					splitTempEffort(tempPreEfforts);
					break;
				
				case 1:
					splitTempEffort(tempCompleteEfforts);
					break;
				
				case 2:
					splitTempEffort(tempInCompleteEfforts);
					break;
			}
			dispatchEvent(new EffortEvent(EffortEvent.TYPE_CHANGED));
		}
		
		private function splitTempEffort(dic:DictionaryData):void
		{
			if(!dic)return;
			tempIntegrationEfforts = [];
			tempRoleEfforts 	   = [];
			tempTaskEfforts        = [];
			tempDuplicateEfforts   = [];
			tempCombatEfforts      = [];
			for each(var i:EffortInfo in dic)
			{
				//				成就显示的位置，0为综合，1为角色，2为任务，3为副本，4为战斗
				if(!i)continue;
				switch(i.PlaceID)
				{
					case 0:
						tempIntegrationEfforts.push(i);
						break;
					case 1:
						tempRoleEfforts.push(i);
						break;
					case 2:
						tempTaskEfforts.push(i);
						break;
					case 3:
						tempDuplicateEfforts.push(i);
						break;
					case 4:
						tempCombatEfforts.push(i);
						break;
				}
			}
		}
		
		public function tempEffortIsComplete(id:int):Boolean
		{
			return tempCompleteEfforts[id]; 
		}
		
		public function getTempIntegrationEffort():Array
		{
			return tempIntegrationEfforts;
		}
		
		public function getTempRoleEffort():Array
		{
			return tempRoleEfforts;
		}
		
		public function getTempTaskEffort():Array
		{
			return tempTaskEfforts;
		}
		
		public function getTempDuplicateEffort():Array
		{
			return tempDuplicateEfforts;
		}
		
		public function getTempCombatEffort():Array
		{
			return tempCombatEfforts;
		}
		
		public function getTempNewlyCompleteEffort():Array
		{
			return tempNewlyCompleteEffort;
		}
		
		public function set isSelf(value:Boolean):void
		{
			_isSelf = value;
		}
		public function get isSelf():Boolean
		{
			return _isSelf;
		}
		
		public function getTempAchievementPoint():int
		{
			return tempAchievementPoint;
		}
	}
}