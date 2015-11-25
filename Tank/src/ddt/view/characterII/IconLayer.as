package ddt.view.characterII
{
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.loader.BitmapLoader;
	import ddt.manager.PathManager;

	public class IconLayer extends BaseLayer
	{
		public function IconLayer(info:ItemTemplateInfo, color:String="", gunback:Boolean=false, hairType:int=1)
		{
			super(info, color, gunback, hairType);
		}
		
		override protected function initLoaders():void
		{
			if(_info != null)
			{
				var url:String = getUrl(1);
				var l:BitmapLoader = new BitmapLoader(url);
				_loaders.push(l);
				_defaultLayer = 0;
				_currentEdit = _info.Property8.length;
			}
		}
		override protected function getUrl(layer:int):String
		{
			return PathManager.solveGoodsPath(_info.CategoryID,_info.Pic,_info.NeedSex == 1,BaseLayer.ICON,_hairType,String(layer),_info.Level,_gunBack,int(_info.Property1));
		}
	}
}