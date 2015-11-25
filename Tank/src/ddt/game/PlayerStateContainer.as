package ddt.game
{
	import flash.display.DisplayObject;
	
	import game.crazyTank.view.SpecialSkillAsset;
	
	import road.ui.controls.SimpleGrid;
	
	import ddt.data.EquipType;
	import ddt.data.game.TurnedLiving;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.events.LivingEvent;
	import ddt.manager.ItemManager;
	import ddt.manager.PlayerManager;
	import ddt.view.items.ItemCellView;
	import ddt.view.items.PropItemView;

	public class PlayerStateContainer extends SimpleGrid
	{
		private var _info:TurnedLiving;
		public function PlayerStateContainer(column:Number = 10)
		{
			super(40,40,column);
			
			horizontalScrollPolicy = "off";
			verticalScrollPolicy = "off";
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		public function get info():TurnedLiving
		{
			return _info;
		}
		
		public function set info(value:TurnedLiving):void
		{
			if(_info)
			{
				_info.removeEventListener(LivingEvent.ADD_STATE,__addingState);
			}
			_info = value;
			if(_info)
			{
				_info.addEventListener(LivingEvent.ADD_STATE,__addingState);
			}
		}
		
		private function __addingState(event:LivingEvent):void
		{
			if(visible == false)
				visible = true;
			if(!_info.isLiving)
			{
				visible = false;
				return;
			}
			if(event.value > 0)
			{
				var temp:InventoryItemInfo = new InventoryItemInfo();
				temp.TemplateID = event.value;
				ItemManager.fill(temp);
				if(temp.CategoryID != EquipType.OFFHAND)
				{
					appendItem(new ItemCellView(0,PropItemView.createView(temp.Pic,40,40)));
				}
				else
				{
					var dis:DisplayObject = PlayerManager.Instance.getDeputyWeaponIcon(temp,1);
					appendItem(new ItemCellView(0,dis));
				}
			}
			else
			{
				if(event.value == -1)
				{
					var special:SpecialSkillAsset = new SpecialSkillAsset();
					special.width = 40; 
					special.height = 40;
					appendItem(new ItemCellView(0,special));
				}else if(event.value == -2)
				{
					appendItem(new ItemCellView(0,PropItemView.createView(event.paras[0],40,40)));
				}
			}
		}
		
		public function setVisible(value:Boolean):void
		{
			if(value == false)
			{
			  clearItems();
			}
			visible = value;
		}
		
		public function dispose():void
		{
			info = null;
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		
	}
}