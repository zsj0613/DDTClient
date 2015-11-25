package ddt.view.characterII
{
	import ddt.data.EquipType;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.player.PlayerInfo;

	public class ConsortiaCharacterLoader extends BaseCharacterLoader
	{
		public function ConsortiaCharacterLoader(info:PlayerInfo)
		{
			super(info);
		}
		
		
		override protected function getCharacterLoader(value:ItemTemplateInfo,color:String = ""):ILayer
		{
			if(value.CategoryID == EquipType.HAIR)
				return layerFactory.createLayer(value,color,BaseLayer.CONSORTIA,false,info.getHairType());
			else return layerFactory.createLayer(value,color,BaseLayer.CONSORTIA);
		}
	}
}