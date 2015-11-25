package ddt.data.goods
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import road.utils.DateUtils;
	
	import ddt.manager.SocketManager;
	import ddt.manager.StateManager;
	import ddt.manager.TimeManager;
	import ddt.states.StateType;
	
	/**
	 *  
	 * @author SYC
	 * 身上物品模板
	 */	
	public class InventoryItemInfo extends ItemTemplateInfo
	{
		private var _checkTimeOutTimer:Timer;
				
		public var ItemID:Number;
		
		public var UserID:Number;
		/**
		 * 是否绑定 
		 */		
		public var IsBinds:Boolean;
		
		/**
		 * 是否删除 
		 */		
		public var isDeleted:Boolean;
		
		/**
		 * 背包，0,1，2
		 * 0：(0--30)身上物品(11--)装备
		 * 1:道具
		 * 2:任务
		 * 11:铁匠铺
		 * 12：隐藏
		 */		
		public var BagType:int;
		
		
		public var type:int;
		
		/**
		 * 是否有效 
		 */		
		public var isInvalid:Boolean;

		/**
		 * 背包操作时锁定
		 */		
		public var lock:Boolean = false;
		
		
		/**
		 * 当前物品颜色 多层由 | 分隔,例如 |234343,标示两层，第二次颜色值为234343。
		 */		
		public var Color:String;
		
		public var Skin:String;
		
		/**
		 *　是否使用过 
		 */		
		private var _isUsed:Boolean;
		public function get IsUsed():Boolean
		{
			return _isUsed;
		}
		public function set IsUsed(value:Boolean):void
		{
			if(_isUsed == value) return;
			_isUsed = value;
			if(_isUsed&&_isTimerStarted)
			{
				updateRemainDate();
			}
		}
		private static var _isTimerStarted:Boolean=false;
		private static var _temp_Instances:Array=new Array;
		public function InventoryItemInfo()
		{
			if(!_isTimerStarted)
			{
				_temp_Instances.push(this);
			}
		}
		/**
		 *	开始计时，以便装备在快捷续费关闭后再计算是否应从身上扒下来 
		 * 
		 */		
		public static function startTimer():void
		{
			if(!_isTimerStarted)
			{
				_isTimerStarted=true;
				for each(var i:InventoryItemInfo in _temp_Instances)
				{
					i.updateRemainDate();
				}
				_temp_Instances=null
			}
		}
		public var BeginDate:String;
		protected var _ValidDate:Number;
		public function set ValidDate(value:Number):void
		{
			_ValidDate=value;	
		}
		public function get ValidDate():Number
		{
			return _ValidDate;	
		}
		
		public function getRemainDate():Number
		{
			if(ValidDate ==0)
			{
				return int.MAX_VALUE;
			}
			else
			{
				if(!_isUsed)
					return ValidDate;
				else
				{
					var bg:Date = DateUtils.getDateByStr(BeginDate);
					var diff:Number = TimeManager.Instance.TotalDaysToNow(bg);
					diff = diff < 0  ? 0 : diff ;
					/* 返回带小数的天数 */
					
					
					
					return (ValidDate - diff);
				}
			}
		}
		
		private var atLeastOnHour:Boolean;
		
		private function updateRemainDate():void
		{
			if(ValidDate != 0 && _isUsed)
			{
				var bg:Date = DateUtils.getDateByStr(BeginDate);
				var diff:Number = TimeManager.Instance.TotalDaysToNow(bg);
				var remainDate:Number = ValidDate - diff;
				if(remainDate > 0 )
				{
					//TODO 临时
//					showOnlyOneHourAlarm();
					//
					if(_checkTimeOutTimer != null)
					{
						_checkTimeOutTimer.stop();
						_checkTimeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
						_checkTimeOutTimer = null;
					}
					
					atLeastOnHour = (remainDate*24>1);
					var tempDelay:uint = atLeastOnHour?(remainDate * TimeManager.DAY_TICKS-1*60*60*1000):(remainDate * TimeManager.DAY_TICKS);
					
					_checkTimeOutTimer = new Timer(tempDelay,1);
					
					_checkTimeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
					_checkTimeOutTimer.start();
				}else
				{
					SocketManager.Instance.out.sendItemOverDue(BagType,Place);
				}
			}
		}
		
		private function __timerComplete(evt:TimerEvent):void
		{
			_checkTimeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
			_checkTimeOutTimer.stop();
			if(!IsBinds)return;
			
			if(atLeastOnHour)
			{
				_checkTimeOutTimer.delay = 10000+1*60*60*1000;
				
//				showOnlyOneHourAlarm();
			}else
			{
				_checkTimeOutTimer.delay = 10000;
			}
			
			_checkTimeOutTimer.reset();	
			_checkTimeOutTimer.addEventListener(TimerEvent.TIMER,__sendGoodsTimeOut);
			_checkTimeOutTimer.start();
		}
		
		private function __sendGoodsTimeOut(evt:TimerEvent):void
		{
			if(StateManager.currentStateType != StateType.FIGHTING && StateManager.currentStateType != StateType.ROOM)
			{
				if(SocketManager.Instance.out != null)
				{
					SocketManager.Instance.out.sendItemOverDue(BagType,Place);
					_checkTimeOutTimer.removeEventListener(TimerEvent.TIMER,__sendGoodsTimeOut);
					_checkTimeOutTimer.stop();
				}
			}
		}
		
		/**
		 * 单元格叠加数量
		 */		
		private var _count:int = 1;
		public function get Count():int
		{
			return _count;
		}
		public function set Count(value:int):void
		{
			if(_count == value)return;
			_count = value;
			dispatchEvent(new GoodsEvent(GoodsEvent.PROPERTY_CHANGE,"Count",_count));
		}
		
		/**
		 * 是否鉴定
		 */		
		public var IsJudge:Boolean;
		
		/**
		 * 物品位置，摆位,区分装备或者道具
		 */		
		public var Place:int;
		
		/**
		 * 强化等级
		 */		
		public var StrengthenLevel:int;
		/**
		 * 合成属性
		 */		
		public var AttackCompose:int;
		public var DefendCompose:int;
		public var LuckCompose:int;
		public var AgilityCompose:int;
		
		/**
		 * 0:不锁
		 * 1:强化锁定
		 * 2:合成锁定
		 * 3:熔练锁定
		 */
		public var lockType:int;
		
		/**
		 * 六个镶嵌用的孔：
		 * -1：未开启
		 * 0：开启
		 * 物品ID：镶嵌的宝石
		 * */
		public var Hole1:int = -1;
		public var Hole2:int = -1;
		public var Hole3:int = -1;
		public var Hole4:int = -1;
		public var Hole5:int = -1;
		public var Hole6:int = -1;
		public var Hole7:int = -1;
	}
}