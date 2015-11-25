package ddt.data
{
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.ItemManager;
	
	public class BuffInfo
	{
		public static const FREE:int = 15;
		public static const DOUBEL_EXP:int = 13;
		public static const DOUBLE_GESTE:int = 12;
		public static const PREVENT_KICK:int = 11;
		
		public var Type:int;
		public var IsExist:Boolean;
		public var BeginData:Date;
		public var ValidDate:int;
		public var Value:int;
		private var _buffName:String;
		private var _buffItem:ItemTemplateInfo;
		private var _description:String;
		public function BuffInfo(type:int = -1, isExist:Boolean = false, beginData:Date = null, validDate:int = 0, value:int = 0)
		{
			 this.Type = type;
			 this.IsExist = isExist;
			 this.BeginData = beginData;
			 this.ValidDate = validDate;
			 this.Value = value;
			 initItemInfo();
		}
		
		public function get buffName():String
		{
			return _buffItem.Name;
		}
		
		public function get description():String
		{
			return _buffItem.Data;
		}
		
		public function get buffItemInfo():ItemTemplateInfo
		{
			return _buffItem;
		}
		
		public function initItemInfo():void
		{
			switch(Type)
			{
				case PREVENT_KICK:
				    _buffItem = ItemManager.Instance.getTemplateById(EquipType.PREVENT_KICK);
				    break;
				case DOUBLE_GESTE:
				    _buffItem = ItemManager.Instance.getTemplateById(EquipType.DOUBLE_GESTE_CARD);
				    break;
				case DOUBEL_EXP:
				    _buffItem = ItemManager.Instance.getTemplateById(EquipType.DOUBLE_EXP_CARD);
				    break;
				case FREE:
				    _buffItem = ItemManager.Instance.getTemplateById(EquipType.FREE_PROP_CARD);
				    break;
				default:
				    break;
			}
		}
		
		public function dispose():void
		{
//			_buffItem = null;
		}
	}
}