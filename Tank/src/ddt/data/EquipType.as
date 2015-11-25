package ddt.data
{
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	
	public class EquipType
	{
		
		/**	图片层次
		*		7 armB
		*		6 face  (眼睛+头部皮肤）
		*		5 cloth（服装+body皮肤）
		*		4 hair
		*		3 eff
		*		2 head
		*		1 glass
		*		0 armF
		*
		* 部分物品模版ID
		*/		
		public static const T_SBUGLE:int = 11101;
		public static const T_BBUGLE:int = 11102;
		public static const T_CBUGLE:int = 11100;
		
		/**
		 * 右边道具的ID 
		 */		
		public static var RIGHT_PROP:Array = [10001,10003,10002,10004,10005,10006,10007];
		
		/**
		 * 包时道具包 
		 */		
		public static const T_ALL_PROP:int = 10200; 
		
		/**
		 * 变色卡
		 * */
		public static const COLORCARD:int = 11999;
		/**
		 *改名卡 
		 */		
		public static const REWORK_NAME:int = 11994;
		/**
		 *公会改名卡 
		 */
		public static const CONSORTIA_REWORK_NAME:int = 11993;
		/**
		 * 转换道具
		 * */
		public static const TRANSFER_PROP:int = 34101;
		
		/**
		 * 勋章
		 * */
		public static const MEDAL:int = 11408;
		/**
		 *礼金 
		 */	
		public static const GIFT:int = -300;
		
		/**
		 *经验 
		 */	
		public static const EXP:int = 11107;
		
		/**
		 *金币箱 
		 */	
		public static const GOLD_BOX:int = 	11233;
		/**
		 *轮盘宝箱 
		 */		
		public static const ROULETTE_BOX:int = 112019;
		/**
		 *轮盘宝箱的钥匙 
		 */		
		public static const ROULETTE_KEY:int = 11444;
		
		/**
		 * 卡片
		 * */
		public static const FREE_PROP_CARD:int = 11995;
		public static const DOUBLE_EXP_CARD:int = 11998;
		public static const DOUBLE_GESTE_CARD:int = 11997;
		public static const PREVENT_KICK:int = 11996;
		public static const CHANGE_NAME_CARD:int = 11994;
		public static const CONSORTIA_CHANGE_NAME_CARD:int = 11993;
		
		/**
		 * 神符&幸运符25%&强化石四级
		 * */
		public static const SYMBLE:int = 11020;
		public static const LUCKY:int = 11018;
		public static const STRENGTH_STONE4:int = 11023;
		
		public static const WEDDING_RING:int = 9022;
		/**
		 * 物品种类ID
		 */
			
		public static const HEAD:uint = 1;//帽子
		public static const GLASS:uint = 2;//眼镜
		public static const HAIR:uint = 3;//头发
		public static const EFF:uint = 4;//脸饰
		public static const CLOTH:uint = 5;//衣服
		public static const FACE:uint = 6;//眼睛
		public static const ARM:uint = 7;//武器
		public static const ARMLET:uint = 8;//手镯
		public static const RING:uint = 9;//戒指
		public static const FRIGHTPROP:uint = 10;//战斗道具
		public static const UNFRIGHTPROP:uint = 11;//辅助战斗道具
		public static const TASK:uint = 12;//任务道具
		public static const SUITS:uint = 13;//套装
		public static const NECKLACE:uint = 14;//项链
		public static const WING:uint = 15;//翅膀
		public static const CHATBALL:uint = 16;//泡泡
		public static const OFFHAND:int = 17;//副武器
		public static const PET:int = 18;
		public static const ShenQi1:int = 19;
		public static const ShenQi2:int = 20;
		
		public static const CATHARINE:int = 21;
		
		
		
		public static const TYPES:Array = ["","head","glass","hair","eff","cloth","face","arm","armlet","ring","","","","suits","necklace","wing","chatBall"];
		public static const PARTNAME:Array = ["",LanguageMgr.GetTranslation("ddt.data.EquipType.head"),LanguageMgr.GetTranslation("ddt.data.EquipType.glass"),
												LanguageMgr.GetTranslation("ddt.data.EquipType.hair"),LanguageMgr.GetTranslation("ddt.data.EquipType.face"),
												LanguageMgr.GetTranslation("ddt.data.EquipType.clothing"),LanguageMgr.GetTranslation("ddt.data.EquipType.eye"),
												LanguageMgr.GetTranslation("ddt.auctionHouse.view.BrowseLeftMenuView.Weapon"),LanguageMgr.GetTranslation("ddt.data.EquipType.bangle"),
												LanguageMgr.GetTranslation("ddt.data.EquipType.finger"),LanguageMgr.GetTranslation("ddt.data.EquipType.tool"),
												LanguageMgr.GetTranslation("ddt.data.EquipType.normal"),"",LanguageMgr.GetTranslation("ddt.data.EquipType.suit"),
												LanguageMgr.GetTranslation("ddt.data.EquipType.necklace"),LanguageMgr.GetTranslation("ddt.data.EquipType.wing"),
												LanguageMgr.GetTranslation("ddt.data.EquipType.paopao"),LanguageMgr.GetTranslation("ddt.data.EquipType.offhand"),
												"灵宠","神器","神器",LanguageMgr.GetTranslation("ddt.manager.ItemManager.cigaretteAsh")];
		//public static const PARTNAME:Array = ["","头饰","眼镜","发型","脸饰","衣服","眼睛","武器","手鐲","戒指","战斗道具","辅助道具"];
		
		public static function getPropNameByType(type:int):String
		{
			switch(type)
			{
				case 1:return "composestone";
				case 2:return "StrengthStoneCell";
				case 3:return "symbol";
				case 4:return "sbugle";
				case 5:return "bbugle";
				case 6:return "packages";
				case 7:return "symbol";
				case 8:return "other";
				default:return "";
			}
		}
		
		private static const dressAbleIDs:Array = [1,2,3,4,5,6,7,13,15,16];
		public static function dressAble(item:ItemTemplateInfo):Boolean
		{
			if(dressAbleIDs.indexOf(item.CategoryID) != -1)
			{
				return true;
			}
			return false;
		}
		/**
		 * 是否可熔炼
		 * **/
		public static function isRongLing(item:ItemTemplateInfo):Boolean
		{
			return (item.CategoryID == 8||item.CategoryID == 9);
		}
		
		/**
		 * 结婚戒指
		 * */
		public static function isWeddingRing(item:ItemTemplateInfo):Boolean
		{
			switch(item.TemplateID)
			{
				case 9022:
				case 9122:
				case 9222:
				case 9322:
				case 9422:
				case 9522:
					return true;
				default:
					return false;
			}
			return false;
		}
		
		
		/**
		 * 是否可以设置颜色
		 * @param item
		 * @return 
		 * 
		 */		
		public static function isEditable(item:ItemTemplateInfo):Boolean
		{
			if(item.CategoryID <= 6 && item.CategoryID >= 1)
			{
				if(item.Property6 == "0")return true;
				return false;
			}
			return false;
		}
		
		/**
		 * 是否可以使用
		 * */
		public static function canBeUsed(item:ItemTemplateInfo):Boolean
		{
			if(item.CategoryID == 11 && item.Property1 == "21") return true;//经验丹11901-11910
			switch(item.TemplateID)
			{
				case EquipType.TRANSFER_PROP:
				case EquipType.COLORCARD:
				case EquipType.FREE_PROP_CARD:
				case EquipType.DOUBLE_EXP_CARD:
				case EquipType.DOUBLE_GESTE_CARD:
				case EquipType.PREVENT_KICK:
				case EquipType.CHANGE_NAME_CARD:
				case EquipType.CONSORTIA_CHANGE_NAME_CARD:
					return true;
				default:
					return false;
			}
		}
		
		public static function isComposeStone(item:ItemTemplateInfo):Boolean
		{
			if(item.CategoryID != UNFRIGHTPROP)return false;
			if(item.Property1 == "1")return true;
			return false;
		}
		
		public static function isStrengthStone(item:ItemTemplateInfo):Boolean
		{
			if(item.CategoryID != UNFRIGHTPROP)return false;
			if(item.Property1 == "2" || item.Property1 == "35")return true;
			return false;
		}
		
		public static function isSymbol(item:ItemTemplateInfo):Boolean
		{
			if(item.CategoryID != UNFRIGHTPROP)return false;
			if(item.Property1 == "3")return true;
			return false
		}
		
		public static function isBugle(item:ItemTemplateInfo):Boolean
		{
			return item.TemplateID == 11101 || item.TemplateID == 11102;
		}
		
		/**
		 * 是否为服饰
		 */		
		public static function isEquip(item:ItemTemplateInfo):Boolean
		{
			if(item.CategoryID >= 1 && item.CategoryID < 10 && item.CategoryID != 7)
				return true;
			return false;	
		}
		
		/**
		 * 是否为武器 
		 */		
		public static function isArm(item:ItemTemplateInfo):Boolean
		{
			return item.CategoryID == 7;
		}
		
		/**
		 * 是否能装备(包括武器和服饰)
		 */		
		public static function canEquip(item:ItemTemplateInfo):Boolean
		{
			if((item.CategoryID >= 1 && item.CategoryID <= 20) && item.CategoryID != 11 && item.CategoryID != 12 && item.CategoryID != 10)
				return true;
			return false;
		}
		
		
		public static function isProp(item:ItemTemplateInfo):Boolean
		{
			return item.CategoryID == FRIGHTPROP || item.CategoryID == UNFRIGHTPROP;
		}
		
		public static function isTask(item:ItemTemplateInfo):Boolean
		{
			return item.CategoryID == TASK;
		}
		
		public static function isPackage(item:ItemTemplateInfo):Boolean
		{
			return (item.CategoryID == UNFRIGHTPROP && item.Property1 == "6");
		}
		
		/**
		 * 
		 * @return 
		 * 传入位置，转成对应的类型ID
		 */		
	/*	public static function placeToCategeryId(place:int):int
		{
			switch(place)
			{
				case 7:
				case 8:
					return 8;
				case 9:
				case 10:
					return 9;
				case 11:
				case 12:
				case 13:
				case 14:
				case 15:
					return place +2;
				case 16:
					return 9;
				case 17:
					return 18;

				default:
					return place + 1;
			}
		}*/
		
		public static function CategeryIdToPlace(id:int):Array
		{
			switch(id)
			{
				case 8:
					return [7,8];
				case 9:
					return [9,10];
				case 13:
					return [11];
				case 14:
					return [12];
				case 15:
					return [13];
				case 16:
					return [14];
				case 17:
					return [15];
				case 18:
					return [17];
				case 19:
				case 20:
					return [18,19,20,21,22,23,24,25,26,27];
				default:
					return [id -1];
			}
		}
		
		/**
		 * 传入位置，返回物品是否需要性别
		 * @param place
		 * @return 
		 * 
		 */		
		public static function placeNeedSex(place:int):int
		{
			if(PlayerManager.Instance.Self == null)return 1;
			if(place >= 0 && place < 7)return PlayerManager.Instance.Self.Sex ? 1 : 2;
			return 0;
		}
		
		public static function hasSkin(categeryId:int):Boolean
		{
			return categeryId == FACE || categeryId == CLOTH;
		}
		
	}
}