package ddt.view.characterII
{
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.PathManager;

	public class ShowLayer extends BaseLayer
	{
		public function ShowLayer(info:ItemTemplateInfo,color:String = "",gunBack:Boolean = false,hairType:int = 1)
		{
			super(info,color,gunBack,hairType);
		}
		
		override protected function getUrl(layer:int):String
		{
			return PathManager.solveGoodsPath(_info.CategoryID,_info.Pic,_info.NeedSex == 1,SHOW,_hairType,String(layer),_info.Level,_gunBack,int(_info.Property1));
		}
	}
}