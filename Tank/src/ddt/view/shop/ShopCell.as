package ddt.view.shop
{
	import game.crazyTank.view.bagII.BagIICellAsset;
	
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.view.cells.BaseCell;

	public class ShopCell extends BaseCell
	{
		public function ShopCell($width:int,$height:int, info:ItemTemplateInfo=null, showLoading:Boolean=true)
		{
			var bg : BagIICellAsset = new BagIICellAsset();
			bg.width = $width;
			bg.height =  $height;
			bg["figure_pos"].width = 65;
			bg["figure_pos"].height = 65;
			bg.count_txt.text = "";
			bg.count_txt.visible = false;
			bg.count_txt.mouseEnabled = bg.count_txt.selectable = false;
			super(bg, info, showLoading);
			bg.width = $width;
			bg.height =  $height;
			bg["figure_pos"].width = 65;
			bg["figure_pos"].height = 65;
//			mouseChildren = mouseEnabled = false;
			bg.cellbg.visible = false;
			bg.overdate_bg.visible = false;
			bg.bg_mc.visible = false;
		}
		
	}
}