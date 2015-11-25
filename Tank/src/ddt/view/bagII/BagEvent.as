package ddt.view.bagII
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import game.crazyTank.view.bagII.TextBgAsset;

	public class BagEvent extends Event
	{
		public static const UPDATE:String = "update";
		public static const PSDPRO:String = "password protection";
		public static const BACK_STEP:String = "backStep";
		public static const CHANGEPSW:String = "changePassword";
		public static const DELPSW:String = "deletePassword";
		public static const AFTERDEL:String = "afterDel";   //删除后事件
		public static const NEEDPRO:String = "needprotection";  //需要弹出密码保护
		public static const UPDATE_SUCCESS:String = "updateSuccess"; //更新成功
		public static const CLEAR:String = "clearSuccess";   //解锁成功
		public static const PSW_CLOSE:String = "passwordClose" //二级密码窗口关闭 
		private var _flag:Boolean;
		private var _needSecond:Boolean;   //是否该二级
		
		private var _changedSlot:Dictionary;
		private var _passwordArray:Array;
		private var _data:TextBgAsset;
		
		public function get changedSlots():Dictionary
		{
			return _changedSlot;
		}
		public function BagEvent(type:String,changedSlots:Dictionary)
		{
			_changedSlot = changedSlots;
			super(type);
		}
		
		public function get data():TextBgAsset{
			return _data;
		}
		
		public function set data(value:TextBgAsset):void{
			_data = value;
		}
		
		public function get passwordArray():Array{
			return _passwordArray;
		}
		
		public function set passwordArray(value:Array):void{
			_passwordArray = value;
		}
		
		public function get flag():Boolean{
			return _flag;
		}
		
		public function set flag(value:Boolean):void{
			this._flag = value;
		}
		
		public function get needSecond():Boolean{
			return _needSecond;
		}
		
		public function set needSecond(value:Boolean):void{
			_needSecond = value;
		}
		
	}
}