package ddt.manager
{
	import flash.display.Stage;
	import flash.events.Event;
	
	import ddt.data.socket.CrazyTankPackageType;
	import ddt.events.CrazyTankSocketEvent;
	
	/**
	 *  
	 * @author SYC
	 * 队列
	 */	
	public class QueueManager
	{
		/**
		 * 可以执行的事件 
		 */		
		private static var _executable:Array = new Array();
		/**
		 * 等待执行的事件队列
		 */		
		private static var _waitlist:Array = new Array();
		
		private static var _lifeTime:int = 0;
		
		private static var _running:Boolean = true;
		
		private static var _diffTimeValue:int = 0;
		
		
		
		/**
		 *时间轴加速时的速度 
		 */		
		private static var _speedUp:int = 2;
		
		public static function get lifeTime():int
		{
			return _lifeTime;
		}
		
		public static function setup(stage:Stage):void
		{
			stage.addEventListener(Event.ENTER_FRAME,frameHandler);
		}
	
		public static function pause():void
		{
			_running = false;
		}
		
		public static function resume():void
		{
			_running = true;
		}
		
		public static function setLifeTime(value:int):void
		{
			_lifeTime = value;
			//把以前的事件放入立即执行的队列
			_executable.concat(_waitlist);
		}
		
		public static function addQueue(e:CrazyTankSocketEvent):void
		{
			_waitlist.push(e);
			if(e.type == CrazyTankSocketEvent.LIVING_BEAT)
			{
				trace("addQueue");
			}
		}		
		
		private static function frameHandler(event:Event):void
		{		
			_lifeTime ++;
			if(_running)
			{
				//执行所有lifetime已过期的事件
				var count:int = 0;
				for(var i:int =0; i <_waitlist.length; i ++)
				{
					var evt:CrazyTankSocketEvent = _waitlist[i];
					if(evt.pkg.extend2 <= _lifeTime)
					{
						_executable.push(evt);
						count ++;
					}
					else
					{
						break;
					}
				}
				_waitlist.splice(0,count);
				
				count = 0;
				for(var j:int = 0; j < _executable.length; j ++)
				{
					if(_running)
					{
						dispatchEvent(_executable[j]);
						if((_executable[j] as CrazyTankSocketEvent).type == CrazyTankSocketEvent.LIVING_BEAT)
						{
							trace("frameHandler");
						}
						count ++;
					}
				}
				_executable.splice(0,count);
			}
		}
		
		
		private static function dispatchEvent(event:Event):void
		{
			try
			{
//				trace(">>>>>>>>>>>>>>>>>>",event.type,_lifeTime);
				SocketManager.Instance.dispatchEvent(event);
			}
			catch(err:Error)
			{
				SocketManager.Instance.out.sendErrorMsg("type:"+event.type+"msg:"+err.message +"\r\n"+err.getStackTrace());
//				trace(event.type,err.message,err.getStackTrace());
			}	
		}
	}
}