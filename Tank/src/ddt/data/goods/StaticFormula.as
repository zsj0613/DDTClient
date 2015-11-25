package ddt.data.goods
{
	import ddt.data.game.Living;
	import ddt.data.player.PlayerInfo;
	import ddt.manager.GameManager;
	import ddt.manager.ItemManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.StateManager;
	import ddt.states.StateType;
	
	public class StaticFormula
	{
		/**
		 * 获取强化后的附加伤害
		 * @param baseHert
		 * @param strengthenLevel
		 * @return 
		 * 
		 */		
		public static function getHertAddition(baseHert:int,strengthenLevel:int):Number
		{
			var val:Number = baseHert * (Math.pow(1.1,(strengthenLevel))) - baseHert;
			
			return Math.round(val);
		}
		
		/**
		 * 获取强化后的附加护甲
		 * @param baseDefense
		 * @param strengthenLevel
		 * @return 
		 * 
		 */		
		public static function getDefenseAddition(baseDefense:int,strengthenLevel:int):Number
		{
			var val:Number = baseDefense * (Math.pow(1.1, (strengthenLevel))) - baseDefense;
			
			return Math.round(val);
		}
		
		/**
		 * 获取强化后的附加恢复量(副武器)
		 * @param baseRecover
		 * @param strengthenLevel
		 * @return 
		 * 
		 */		
		public static function getRecoverHPAddition(baseRecover:int,strengthenLevel:int):Number
		{
			var val:Number = baseRecover * (Math.pow(1.1, (strengthenLevel))) - baseRecover;
			
			return Math.floor(val);
		}
		
		/**
		 * 获取强化后的免伤,结果为百分数,如：
		 * 计算后的数值为95
		 * 则真实值为95%
		 * @param allDefense
		 * @return 
		 * 
		 */		
		public static function getImmuneHertAddition(allDefense:int):Number
		{
			var val:Number = 0.95 * allDefense / (allDefense + 500);
			
			val = val * 100;
			
			return Number(val.toFixed(1));
		}
		
		/**
		 * 是否为副武器
		 * @param $info
		 * @return 
		 * 
		 */		
		public static function isDeputyWeapon($info:ItemTemplateInfo):Boolean
		{
			if($info.TemplateID >= 17001 && $info.TemplateID <= 17999)
				return true;
			return false;
		}
		
		public static function getActionValue(info:PlayerInfo):int
		{
			var ActionValue:int
			ActionValue = (info.Attack + info.Agility + info.Luck +info.Defence + 1000)
						* (Math.pow(getDamage(info),3)+ Math.pow(getRecovery(info),3) * 3.5)
						/ 100000000 + getMaxHp(info)*0.95 -950;
			return ActionValue;
		}
		
		/**
		 * 
		 * 计算玩家的总伤害值
		 * 
		 */		
		public static function getDamage(info:PlayerInfo):int
		{
			if(info.ZoneID != 0 && StateManager.currentStateType == StateType.FIGHTING && info.ZoneID != PlayerManager.Instance.Self.ZoneID)
			{
				return -1;
			}
			var damage:int;
			
			if(info.Bag.items[6])		
			{
				damage = getHertAddition((int)(info.Bag.items[6].Property7),info.Bag.items[6].StrengthenLevel)
					   + (int)(info.Bag.items[6].Property7);
			}
			
			for (var i:int = 0; i<=27 ; i++)
			{
				if(info.Bag.items[i]!=null)
				{
					damage += getJewelDamage(info.Bag.items[i]);
					if((info.Bag.items[i] as InventoryItemInfo).CategoryID == 19||(info.Bag.items[i] as InventoryItemInfo).CategoryID == 18)
						damage += getHertAddition((int)(info.Bag.items[i].Property7),info.Bag.items[i].StrengthenLevel)
								+ (int)(info.Bag.items[i].Property7);
				}
			}
			return damage;
		}
		
		public static function getRecovery(info:PlayerInfo):int
		{
			if(info.ZoneID != 0 && StateManager.currentStateType == StateType.FIGHTING && info.ZoneID != PlayerManager.Instance.Self.ZoneID)
			{
				return -1;
			}
			var recovery:int;
			if(info.Bag.items[0])
			{
				recovery = getDefenseAddition((int)(info.Bag.items[0].Property7),info.Bag.items[0].StrengthenLevel)
						 + (int)(info.Bag.items[0].Property7)
			}
			if(info.Bag.items[4])
			{
				recovery += getDefenseAddition((int)(info.Bag.items[4].Property7),info.Bag.items[4].StrengthenLevel)
						  + (int)(info.Bag.items[4].Property7)
			}
			for (var i:int = 0; i<=27 ; i++)
			{
				if(info.Bag.items[i]!=null)
				{
					recovery += getJewelRecovery(info.Bag.items[i]);
					if((info.Bag.items[i] as InventoryItemInfo).CategoryID == 20)
						recovery += (int)(getDefenseAddition((int)(info.Bag.items[i].Property7),info.Bag.items[i].StrengthenLevel)+(int)(info.Bag.items[i].Property7));
				}
			}
			return recovery;
		}
		
		public static function getMaxHp(info:PlayerInfo):int
		{
			if(info.ZoneID != 0 && StateManager.currentStateType == StateType.FIGHTING&&info.ZoneID!=PlayerManager.Instance.Self.ZoneID)
			{
				var living:Living = GameManager.Instance.Current.findLivingByPlayerID(info.ID,info.ZoneID);
				if(living)
				return living.maxBlood;
			}
			var Hp:int = 0;
			Hp = 950 + 50 *info.Grade + info.Defence/10;
			for(var i:int;i <= 8;i++)
			{
				if(info.Grade - (10+ 10*i)>0)
					Hp += (30+i*10)*(info.Grade - (10+ 10*i));
				else
					break;
			}
			if(info.Bag.items[12])
			{
				Hp *= 1+((int)(info.Bag.items[12].Property1)/100);
			}
			return Hp;
		}
		/**
		 *	计算人物体力值; 
		 * @param info
		 * @return 
		 * 
		 */		
		public static function getEnergy(info:PlayerInfo):int
		{
			if(info.ZoneID != 0 && StateManager.currentStateType == StateType.FIGHTING && info.ZoneID != PlayerManager.Instance.Self.ZoneID)
			{
				return -1;
			}
			var value:int=0;
			value=240+info.Agility/30;
			return value;	
		}
		/**
		 * 获得宝珠的伤害
		 */
		public static function getJewelDamage(itemInfo:InventoryItemInfo):int
		{
			var value:int = 0;
			if(!itemInfo)return 0;
			if(itemInfo.Hole1 != -1 && itemInfo.Hole1 != 0 )
			{
				value += (int)(ItemManager.Instance.getTemplateById(itemInfo.Hole1).Property7);//CategoryID=14 项链;
			}
			if(itemInfo.Hole2 != -1 && itemInfo.Hole2 != 0 )
			{
				value += (int)(ItemManager.Instance.getTemplateById(itemInfo.Hole2).Property7);
			}
			if(itemInfo.Hole3 != -1 && itemInfo.Hole3 != 0 )
			{
				value += (int)(ItemManager.Instance.getTemplateById(itemInfo.Hole3).Property7);
			}
			if(itemInfo.Hole4 != -1 && itemInfo.Hole4 != 0 )
			{
				value += (int)(ItemManager.Instance.getTemplateById(itemInfo.Hole4).Property7);
			}
			if(itemInfo.Hole5 != -1 && itemInfo.Hole5 != 0 )
			{
				value += (int)(ItemManager.Instance.getTemplateById(itemInfo.Hole5).Property7);
			}
			if(itemInfo.Hole6 != -1 && itemInfo.Hole6 != 0 )
			{
				value += (int)(ItemManager.Instance.getTemplateById(itemInfo.Hole6).Property7);
			}
			return value;
		}
		/**
		 * 获得宝珠的防御
		 */		
		public static function getJewelRecovery(itemInfo:InventoryItemInfo):int
		{
			var value:int = 0;
			if(!itemInfo)return 0;
			if(itemInfo.Hole1 != -1 && itemInfo.Hole1 != 0 )
			{
				value += (int)(ItemManager.Instance.getTemplateById(itemInfo.Hole1).Property8);//CategoryID=14 项链;
			}
			if(itemInfo.Hole2 != -1 && itemInfo.Hole2 != 0 )
			{
				value += (int)(ItemManager.Instance.getTemplateById(itemInfo.Hole2).Property8);
			}
			if(itemInfo.Hole3 != -1 && itemInfo.Hole3 != 0 )
			{
				value += (int)(ItemManager.Instance.getTemplateById(itemInfo.Hole3).Property8);
			}
			if(itemInfo.Hole4 != -1 && itemInfo.Hole4 != 0 )
			{
				value += (int)(ItemManager.Instance.getTemplateById(itemInfo.Hole4).Property8);
			}
			if(itemInfo.Hole5 != -1 && itemInfo.Hole5 != 0 )
			{
				value += (int)(ItemManager.Instance.getTemplateById(itemInfo.Hole5).Property8);
			}
			if(itemInfo.Hole6 != -1 && itemInfo.Hole6 != 0 )
			{
				value += (int)(ItemManager.Instance.getTemplateById(itemInfo.Hole6).Property8);
			}
			return value;
		}
	}
}