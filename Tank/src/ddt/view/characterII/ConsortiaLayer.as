package ddt.view.characterII
{
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.PathManager;

	public class ConsortiaLayer extends BaseLayer
	{
		public function ConsortiaLayer(info:ItemTemplateInfo,color:String = "",gunback:Boolean = false,hairType:int = 1)
		{
			super(info,color,gunback,hairType);
		}
		
		override protected function getUrl(layer:int):String
		{
			return PathManager.solveGoodsPath(_info.CategoryID,_info.Pic,_info.NeedSex == 1,BaseLayer.CONSORTIA,_hairType,String(layer),_info.Level,_gunBack,int(_info.Property1));
		}
	}
}