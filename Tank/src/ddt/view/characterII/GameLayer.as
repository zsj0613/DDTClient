package ddt.view.characterII
{
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.PathManager;

	public class GameLayer extends BaseLayer
	{
		public function GameLayer(info:ItemTemplateInfo,color:String,gunback:Boolean = false,hairType:int = 1)
		{
			super(info,color,gunback,hairType);
		}
		
		override protected function getUrl(layer:int):String
		{
			return PathManager.solveGoodsPath(_info.CategoryID,_info.Pic,_info.NeedSex == 1,BaseLayer.GAME,_hairType,String(layer),info.Level,_gunBack,int(_info.Property1));
		}
	}
}