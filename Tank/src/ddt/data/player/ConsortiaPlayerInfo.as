package ddt.data.player
{
	import flash.events.EventDispatcher;
	
	import ddt.events.PlayerEvent;
	import ddt.view.character.Direction;
	
	public class ConsortiaPlayerInfo extends EventDispatcher
	{
		private var _info:PlayerInfo;
		
		public function get State():int
		{
			return _state;
		}

		public function set State(value:int):void
		{
			_state = value;
			dispatchEvent(new PlayerEvent(PlayerEvent.ONLINE));
		}

		public function get info():PlayerInfo
		{
			return _info;
		}
		
		public var PosX:int = 300;
		public var PosY:int = 300;
		public var DutyLevel:int;
		public var Direct:Direction = Direction.getDirectionFromAngle(2);
		
		public function ConsortiaPlayerInfo(info:PlayerInfo)
		{
			_info = info;
		}
		
//		public var LastLoginDate:String;
//		public var ApplyDate:String;
//		
//		private var _duty:String;
//		public function get Duty():String
//		{
//			return _duty;
//		}
//		public function set Duty(value:String):void
//		{
//			if(_duty == value)return;
//			_duty = value;
//			dispatchEvent(new ConsortiaPlayerEvent(ConsortiaPlayerEvent.PROPERTY_CHANGE,"Duty",_duty));
//		}
//		
//		private var _offer:int;
//		public function get Offer():int
//		{
//			return _offer;
//		}
//		public function set Offer(value:int):void
//		{
//			if(_offer == value)return;
//			_offer = value;
//			dispatchEvent(new ConsortiaPlayerEvent(ConsortiaPlayerEvent.PROPERTY_CHANGE,"Offer",_offer));
//		}
//		
//		private var _remark:String;
//		public function get Remark():String
//		{
//			return _remark;
//		}
//		public function set Remark(value:String):void
//		{
//			if(_remark == value)return;
//			_remark = value;
//			dispatchEvent(new ConsortiaPlayerEvent(ConsortiaPlayerEvent.PROPERTY_CHANGE,"Remark",_remark));
//		}
		
		
		public var ID:int;
		public var ConsortiaID:int;
		public var DutyID:int;
		public var DutyName:String;
		public var IsChat:Boolean;
		public var IsDiplomatism:Boolean;
		public var IsDownGrade:Boolean;
		public var IsEditorDescription:Boolean;
		public var IsEditorPlacard:Boolean;
		public var IsEditorUser:Boolean;
		public var IsExpel:Boolean;
		public var IsInvite:Boolean;
		public var IsManageDuty:Boolean;
		public var IsRatify:Boolean;
		public var IsUpGrade:Boolean;
		public var Level:int;
		public var Offer:int;
		public var RatifierID:int;
		public var RatifierName:String;
		public var Remark:String;
		private var _state:int;
		public var UserId:int;
		public var IsBanChat:Boolean;
		public var LastDate:String; //离线时间
		public var CurrentDate:String; //系统时间
		public var ConsortiaLevel:int = 0;
		
		public var NickName    : String;
		public var RichesRob   : int;
		public var RichesOffer : int;
		public var Grade:int;
		public var Sex:Boolean;
		
	}
}