package ddt.manager
{
	import ddt.states.StateType;
	
	/***************************************
	 *    控制发言时间
	 * 两次发言时间相差三秒
	 * 10秒内发言四次,视为刷屏,禁言一分钟
	 * ************************************/
	 
	public class CharTimerManager
	{
		private static var _instance : CharTimerManager;
		private var _currentTime : Date;//当前时间
		private var _lastTime    : Date;
		private var _stopwatch   : Number;//秒表
		
		public function CharTimerManager()
		{
		}
		
		
		
		public function checkTimeLock(time : Number=3) : Boolean
		{
			if(StateManager.currentStateType != StateType.ROOM_LIST)
			return true;
			if(_lastTime == null)
			{
				_lastTime = new Date();
				return true;
			}
			_currentTime = new Date(); 
			_stopwatch = Math.ceil((_currentTime.getTime() - _lastTime.getTime())/1000);
			if(_stopwatch >= time)
			{
                _lastTime = _currentTime;
				return true;
			}
			else
			{
				
//				ChatManager.instance.appendSysChatData(LanguageMgr.GetTranslation("ddt.manager.CharTimerManager.say",time));
				//ChatManager.instance.appendSysChatData("重复发言需间隔 3 秒");
				//MessageTipManager.getInstance().show("两次发言必须大于3秒!");
				return false;
			}
			
		}
		
		
		/*********************************************
		 *        消毁
		 * ******************************************/
		public function dispose():void
		{
			_instance      = null;
		}
		
		
		
		
		
		
		/*********************************************
		 *            单例模式
		 * ******************************************/
		public static function get instance() : CharTimerManager
		{
			if(_instance == null)
			{
				_instance = new CharTimerManager();
			}
			return _instance;
		}
	}
}