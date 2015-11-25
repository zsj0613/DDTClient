package ddt.data.quest
{
	/**
	 * 任务数据
	 * @author JustinLong
	 * 
	 */	
	public class QuestDataInfo
	{
		public var repeatLeft:int;
		
		public var hadChecked:Boolean;
		
		public var quality:int;
		
		private var _questID:int;
		
		private var _progress:Array;
		
		public var CompleteDate:Date;
		
		private var _isAchieved:Boolean;
		
		private var _isNew:Boolean;
		
		private var _informed:Boolean;
		
		private var _isExist:Boolean;
		
		public function set isExist(value:Boolean):void{
			_isExist = value;
		}
		public function get isExist():Boolean{
			return _isExist;
		}
		
		//public var isNew : Boolean = false;//是不是新任务
		
		public function QuestDataInfo(id:int):void{
			_questID = id;
			hadChecked = false;
			_isNew = false;
			_informed = false;
		}
		
		public function get id():int{
			return _questID;
		}
		
		public function set isNew(value:Boolean):void{
			_isNew = value;
		}
		public function get isNew():Boolean{
			return _isNew;
		}
		public function set informed(value:Boolean):void{
			_informed = value;
		}
		public function get needInformed():Boolean{
			if(!_informed && _isNew){
				return true;
			}
			return false;
		}
		public function get isAchieved():Boolean{
			if(CompleteDate.fullYear<2001){
				return false;
			}
			return true;
		}
		public function set isAchieved(isAchieved:Boolean):void{
			_isAchieved = isAchieved;
		}
		public function setProgress(con0:int,con1:int = 0,con2:int = 0,con3:int = 0):void{
			if(!_progress){
				_progress = new Array();
			}
			_progress[0] = con0;
			_progress[1] = con1;
			_progress[2] = con2;
			_progress[3] = con3;
			
		}
		public function get progress():Array{
			return _progress;
		}
		public function get isCompleted():Boolean{
			if(!_progress){
				return false;
			}
			if(_progress[0]<=0&&_progress[1]<=0&&_progress[2]<=0&&_progress[3]<=0){
				return true;
			}
			return false;
		}
		public function get ConditionCount():int{
			if(_progress[0])return _progress[0];
			return 0
		}
		public function set ConditionCount(i:int):void{
		}
	}
}