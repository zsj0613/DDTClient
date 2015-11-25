package ddt.view.characterII
{
	import ddt.data.goods.ItemTemplateInfo;
	
	public interface ILayerFactory
	{
		function createLayer(info:ItemTemplateInfo,color:String = "",type:String = "show",gunBack:Boolean = false,hairType:int = 1):ILayer;
	}
}