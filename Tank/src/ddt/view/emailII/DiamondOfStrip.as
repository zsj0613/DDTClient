package ddt.view.emailII
{
	import ddt.data.goods.InventoryItemInfo;
	/**
	 * 邮件列表中的附件缩略图 
	 * @author Administrator
	 */	
	public class DiamondOfStrip extends DiamondBase
	{
		public function DiamondOfStrip(index:int)
		{
			super(index);
			count_txt.visible = false;
		}
		
		override protected function update():void
		{
			var annex:* = _info.getAnnexByIndex(_index);
			if(annex && annex is String)
			{
				_cell.visible = false;
				click_mc.visible = true;
				mouseEnabled = true;
				if(annex == "gold")
				{
					click_mc.gotoAndStop(3);
					count_txt.text = String(_info.Gold);					
				} 
				else if(annex == "money")
				{
					click_mc.gotoAndStop(2);
					count_txt.text = String(_info.Money);
				}else if(annex == "gift")
				{
					click_mc.gotoAndStop(6);
					count_txt.text = String(_info.GiftToken);
				}
			}
			else if(annex)
			{
				_cell.visible = true;
				click_mc.visible = false;
				_cell.info = (annex as InventoryItemInfo);
				mouseEnabled = true;
			}
			else
			{
				click_mc.visible = true;
				_cell.visible = false;
				if(_info.IsRead)
				{
					click_mc.gotoAndStop(5)
				}
				else
				{
					click_mc.gotoAndStop(4);
				}
				mouseEnabled = false;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}