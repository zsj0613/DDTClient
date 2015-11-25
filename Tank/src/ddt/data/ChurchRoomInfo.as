package ddt.data
{
	import flash.events.EventDispatcher;
	
	import ddt.events.ChurchRoomEvent;
	
	public class ChurchRoomInfo extends EventDispatcher
	{
		/*未开始*/
		public static const WEDDING_NONE:String = "wedding_none";
		/*进行中*/
		public static const WEDDING_ING:String = "wedding_ing";

		/* 房间ID */
		public var id:int;
		/* 房间名 */
		public var roomName:String = "";
		/* 新娘ID */
		public var brideID:int;
		public var brideName:String;
		/* 新郎ID */
		public var groomID:int;
		public var groomName:String;
		/* 创建者ID */
		public var createID:int;
		public var createName:String;
		/* 地图ID */
		public var mapID:int;
		/* 是否锁定 */
		public var isLocked:Boolean;
		/* 密码 */
		public var password:String = "";
		/*描述  */
		public var discription:String = "";
		/* 宾客邀请好友 */
		public var canInvite:Boolean;
		/* 是否已燃放过礼炮 */
		public var isUsedSalute:Boolean; 
		/* 创建时间 */
		public var creactTime:Date;
		/* 有效期 */
		private var _validTimes:uint;
		/* 最大人数 */
		public var maxNum:uint = 200;
		/*婚礼状态*/
		private var _status:String = WEDDING_NONE;
		/* 当前人数 */
		private var _currentNum:uint;
		/* 是否已开始 */
		private var _isStarted:Boolean;
		
		public function get isStarted():Boolean
		{
			return _isStarted;
		}
		
		public function set isStarted(value:Boolean):void
		{
			_isStarted = value;
		}
		
		public function get valideTimes():uint
		{
			return _validTimes;
		}
		
		public function set valideTimes(value:uint):void
		{
			_validTimes = value;
			
			dispatchEvent(new ChurchRoomEvent(ChurchRoomEvent.ROOM_VALIDETIME_CHANGE,this));
		}
		
		public function get currentNum():uint
		{
			return _currentNum;
		}
		
		public function set currentNum(value:uint):void
		{
			_currentNum = value;
		}

		public function get status():String
		{
			return _status;
		}

		public function set status(value:String):void
		{
			if(_status == value)return;
			
			_status = value;
			
			dispatchEvent(new ChurchRoomEvent(ChurchRoomEvent.WEDDING_STATUS_CHANGE,this));
		}

		public function ChurchRoomInfo()
		{
			
		}
	}
}