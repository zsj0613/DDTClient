package ddt.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import ddt.manager.FightLibManager;
	import ddt.manager.PlayerManager;
	
	/**
	 * 
	 * @author WickiLA
	 * @time 0526/2010
	 * @description 作战实验室的数据模型
	 */	
	
	public class FightLibInfo extends EventDispatcher
	{
		public static const MEASHUR_SCREEN:int = 1;
		public static const TWENTY_DEGREE:int = 2;
		public static const SIXTY_FIVE_DEGREE:int = 3;
		public static const HIGH_THROW:int = 4;
		public static const HIGH_GAP:int = 5;
		
		public static const EASY:int = 0;
		public static const NORMAL:int = 1;
		public static const DIFFICULT:int = 2;
		/**
		 *作战实验室的奖励，写死在客户端了，三个难度分别对应三个奖励，跟关卡无关，只跟难度有关 
		 */		
		private static const AWARD_GIFTS:Array = [100,300,500];//奖励的礼券
		private static const AWARD_EXP:Array = [2000,5000,8000];//奖励的经验
		private static const AWARD_ITEMS:Array = [[{id:11021,number:4},{id:11002,number:4},{id:11006,number:4},{id:11010,number:4},{id:11014,number:4},{id:11408,number:4}],
													[{id:11022,number:4},{id:11003,number:4},{id:11007,number:4},{id:11011,number:4},{id:11015,number:4},{id:11408,number:4}],
													[{id:11023,number:4},{id:11004,number:4},{id:11008,number:4},{id:11012,number:4},{id:11016,number:4},{id:11408,number:4}]];
		
		private var _id:int;
		private var _name:String;
		private var _difficulty:int;
		private var _requiedLevel:int;
		private var _description:String;
		private var _mapID:int;
		
		private var _commit:int=0;
		
		public function FightLibInfo()
		{
			super();
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function set id(value:int):void
		{
			_id = value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}

		public function get difficulty():int
		{
			return _difficulty;
		}

		public function set difficulty(value:int):void
		{
			_difficulty = value;
			if(_commit<=0)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		public function get requiedLevel():int
		{
			return _requiedLevel;
		}

		public function set requiedLevel(value:int):void
		{
			_requiedLevel = value;
			if(_commit<=0)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		public function get description():String
		{
			return _description;
		}

		public function set description(value:String):void
		{
			_description = value;
		}

		public function get mapID():int
		{
			return _mapID;
		}

		public function set mapID(value:int):void
		{
			_mapID = value;
		}

		public function beginChange():void
		{
			_commit++;
		}
		
		public function commitChange():void
		{
			_commit--;
			dispatchEvent(new Event(Event.CHANGE));
		}
		/**
		 * 
		 * @return 奖励的礼券 
		 * 
		 */		
		public function getAwardGiftsNum():int
		{
			if(difficulty>-1 && difficulty<3)
			{
				var awardItems:Array = getAwardInfoItems();
				for each(var item:Object in awardItems)
				{
					if(item.id == EquipType.GIFT)
					{
						return item.count;
					}
				}
			}
			return 0;
		}
		/**
		 * 
		 * @return 奖励的经验
		 * 
		 */		
		public function getAwardEXPNum():int
		{
			if(difficulty>-1 && difficulty<3)
			{
				var awardItems:Array = getAwardInfoItems();
				for each(var item:Object in awardItems)
				{
					if(item.id == EquipType.EXP)
					{
						return item.count;
					}
				}
			}
			return 0;
		}
		/**
		 * 
		 * @return 奖励的物品
		 * 
		 */		
		public function getAwardItems():Array
		{
			var result:Array = [];
			if(difficulty>-1 && difficulty<3)
			{
				var awardItems:Array = getAwardInfoItems();
				for each(var item:Object in awardItems)
				{
					if(item.id != EquipType.GIFT && item.id != EquipType.EXP)
					{
						result.push(item);
					}
				}
			}
			return result;
		}
		
		private function getAwardInfoItems():Array
		{
			var result:Array;
			var awardInfo:FightLibAwardInfo = FightLibManager.Instance.getFightLibAwardInfoByID(id);
			switch(difficulty)
			{
				case EASY:
					result = awardInfo.easyAward;
					break;
				case NORMAL:
					result = awardInfo.normalAward;
					break;
				case DIFFICULT:
					result = awardInfo.difficultAward;
					break;
				default:
					break;
			}
			return result;
		}
		
		/**
		 * 
		 * @return 战斗实验室的任务完成情况
		 * 
		 */		
		private var value1:int;
		private var value2:int;
		
		private function initMissionValue():void
		{
			var info:String = PlayerManager.Instance.Self.fightLibMission.substr((id-5)*2,2);
			value1 = int(info.substr(0,1));
			value2 = int(info.substr(1,1));
		}
		
		public function get InfoCanPlay():Boolean
		{
			initMissionValue();
			return value1>0;
		}
		
		public function get easyCanPlay():Boolean
		{
			return InfoCanPlay;
		}
		
		public function get normalCanPlay():Boolean
		{
			initMissionValue();
			return value1>1;
		}
		
		public function get difficultCanPlay():Boolean
		{
			initMissionValue();
			return value1>2;
		}
		
		public function get easyAwardGained():Boolean
		{
			initMissionValue();
			return value2>0;
		}
		
		public function get normalAwardGained():Boolean
		{
			initMissionValue();
			return value2>1;
		}
		
		public function get difficultAwardGained():Boolean
		{
			initMissionValue();
			return value2>2;
		}
	}
}