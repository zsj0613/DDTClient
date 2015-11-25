package ddt.manager
{
	import com.hurlant.math.bi_internal;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import road.comm.PackageIn;
	
	import ddt.command.fightLibCommands.script.BaseScript;
	import ddt.data.DungeonInfo;
	import ddt.data.FightLibAwardInfo;
	import ddt.data.FightLibInfo;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.loader.RequestLoader;
	import ddt.request.LoadFightLibAwardInfo;
	
	/**
	 * 
	 * @author WickiLA
	 * @time 0526/2010
	 * @description 作战实验室管理器
	 */	
	
	public class FightLibManager extends EventDispatcher
	{
		private static var _instance:FightLibManager;
		private var _awardList:Array;
		private var _currentInfo:FightLibInfo;
		private var _script:BaseScript;
		
		private var _reAnswerNum:int;
		
		public function FightLibManager(singletonFocer:SingletonFocer)
		{
			initEvents();
		}
		
		private function initEvents():void
		{
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHT_LIB_INFO_CHANGE,__infoChange);
		}
		
		public static function get Instance():FightLibManager
		{
			if(_instance == null)
			{
				_instance = new FightLibManager(new SingletonFocer());
			}
			return _instance;
		}
		
		public function setup():void
		{
			new LoadFightLibAwardInfo().loadSync(initAwardInfo);
		}
		
		private function initAwardInfo(loader:LoadFightLibAwardInfo):void
		{
			_awardList = loader.list;
		}
		
		public function get currentInfo():FightLibInfo
		{
			return _currentInfo;
		}

		public function set currentInfo(value:FightLibInfo):void
		{
			_currentInfo = value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function set currentInfoID(value:int):void
		{
			if(currentInfo && currentInfo.id == value)
			{
				return;
			}
			var info:DungeonInfo = findDungInfoByID(value);
			if(info)
			{
				var fightInfo:FightLibInfo = new FightLibInfo();
				fightInfo.beginChange();
				fightInfo.id = info.ID;
				fightInfo.description = info.Description;
				fightInfo.name = info.Name;
				fightInfo.difficulty = -1;
				fightInfo.requiedLevel = info.LevelLimits;
				fightInfo.mapID = int(info.Pic);
				fightInfo.commitChange();
				currentInfo = fightInfo;
			}
		}
		
		public function getFightLibInfoByID(id:int):FightLibInfo
		{
			var info:DungeonInfo = findDungInfoByID(id);
			if(info)
			{
				var fightInfo:FightLibInfo = new FightLibInfo();
				fightInfo.beginChange();
				fightInfo.id = info.ID;
				fightInfo.description = info.Description;
				fightInfo.name = info.Name;
				fightInfo.difficulty = -1;
				fightInfo.requiedLevel = info.LevelLimits;
				fightInfo.mapID = int(info.Pic);
				fightInfo.commitChange();
				return fightInfo;
			}
			return null;
		}
		
		public function getFightLibAwardInfoByID(id:int):FightLibAwardInfo
		{
			for each(var awardItem:FightLibAwardInfo in _awardList)
			{
				if(awardItem.id == id)
					return awardItem;
			}
			return null;
		}
		
		private function __infoChange(evt:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = evt.pkg;
			var id:int = pkg.readInt();
			var difficulty:int = pkg.readInt();
			currentInfoID = id;
			currentInfo.beginChange();
			currentInfo.difficulty = difficulty;
			var info:DungeonInfo = findDungInfoByID(id);
			
			currentInfo.commitChange();
		}
		
		private function findDungInfoByID(id:int):DungeonInfo
		{
			for each(var info:DungeonInfo in MapManager.getFightLibList())
			{
				if(info.ID == id)
				{
					return info;
				}
			}
			return null;
		}

		public function reset():void
		{
			currentInfo = null;
			reAnswerNum = 1;
			if(_script)
			{
				_script.dispose();
			}
			_script = null;
		}

		public function get script():BaseScript
		{
			return _script;
		}
		
		public function set script(value:BaseScript):void
		{
			_script = value;
		}

		public function get reAnswerNum():int
		{
			return _reAnswerNum;
		}

		public function set reAnswerNum(value:int):void
		{
			_reAnswerNum = value;
		}


	}
}

class SingletonFocer{}