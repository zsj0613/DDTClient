package ddt.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class ConsortiaInfo extends EventDispatcher
	{
		public static const DESCRIPTION_CHANGE:String = "descriptionchange";
		public static const PLACARD_CHANGE:String = "placardchange";
		public static const RICHES_CHANGE : String = "richeschange";
		
		public var ConsortiaID:int;
		public var ConsortiaName:String="";
		public var CreatorID:int;
		public var CreatorName:String="";
		public var ChairmanID:int;
		public var ChairmanName:String="";
		public var Level:int;
		public var MaxCount:int;
		public var CelebCount:int;
		public var BuildDate:String="";
		public var IP:String;
		public var Port:int;
		
		public var Count:int;
		public var Repute:int;
		
		public var IsApply:Boolean;
		public var State : int;
		
		public var DeductDate:String;
		public var Honor : int;
		public var LastDayRiches : int;
		public var OpenApply : Boolean;
		
		public var FightPower:int;
		
		//公会保管箱等级
		private var _storeLevel : int;
		public function set StoreLevel($level : int) : void
		{
			_storeLevel = $level;
			dispatchEvent(new Event(RICHES_CHANGE,true));
		}
		public function get StoreLevel() : int{
			return _storeLevel;
		}
		
		//公会铁匠铺等级
		public var SmithLevel : int;
		
		//公会商城等级
		public var ShopLevel  : int;

		
		private var _riches:int;
		public function set Riches(i : int) : void
		{
			this._riches = i;
			dispatchEvent(new Event(RICHES_CHANGE,true));
		}
		public function get Riches() : int
		{
			return this._riches;
		}
		private var _description:String;
		public function get Description():String
		{
			return _description;
		}
		public function set Description(value:String):void
		{
			if(_description == value)return;
			_description = value;
			dispatchEvent(new Event(DESCRIPTION_CHANGE));
		}
		
		private var _placard:String = "";
		public function get Placard():String
		{
			return _placard;
		}
		public function set Placard(value:String):void
		{
			if(_placard == value)return;
			_placard = value;
			dispatchEvent(new Event(PLACARD_CHANGE));
		}
		
		
		
		
	}
}