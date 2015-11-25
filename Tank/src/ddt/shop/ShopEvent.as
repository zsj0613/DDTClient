package ddt.shop
{
	import flash.events.Event;
	
	import ddt.data.player.PlayerInfo;

	public class ShopEvent extends Event
	{
		public static const ADD_CAR_EQUIP:String = "addcarequip";
		public static const REMOVE_CAR_EQUIP:String = "removecarequip";
		public static const UPDATE_CAR:String = "updateCar";
	
		public static const ADD_TEMP_EQUIP:String = "addTempEquip";
		public static const REMOVE_TEMP_EQUIP:String = "removetempequip";
		public static const CLEAR_TEMP:String = "cleartemp";
		
		public static const FITTINGMODEL_CHANGE:String = "fittingmodelchange";

		public static const SELECTEDEQUIP_CHANGE:String = "selectedequipchange";
		
		public static const STYLE_CHANNGE:String = "stylechannge";
		
		public static const COST_UPDATE:String = "costChange";
		
		public static const COLOR_SELECTED:String = "colorSelected";
		
		public static const ITEMINFO_CHANGE:String = "itemInfoChange";
		
		public static const CLOSE_SAVEPANEL:String = "closeSavePanel";
		
		public static const ENABLE_SVAEBTN:String = "enableSaveBtn";
		
		public var param:Object;
		
		public var model:PlayerInfo;
		
		public function ShopEvent(type:String,obj:Object = null, model:PlayerInfo = null)
		{
			this.param = obj;
			this.model = model;
			super(type, bubbles, cancelable);
		}
		
	}
}