package ddt.view.characterII
{
	import ddt.data.EquipType;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.manager.ItemManager;

	public class GameCharacterLoader extends BaseCharacterLoader
	{
		public function GameCharacterLoader(info:PlayerInfo)
		{
			super(info);
		}
	
		override protected function initLoaders():void
		{			
			loaders = [];
			_recordStyle = info.Style.split(",");
			_recordColor = info.Colors.split(",");
			
			loaders.push(layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[7])),_recordColor[7],BaseLayer.GAME));
			loaders.push(layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[1])),_recordColor[1],BaseLayer.GAME));
			loaders.push(layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[0])),_recordColor[0],BaseLayer.GAME));
			loaders.push(layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[3])),_recordColor[3],BaseLayer.GAME));
			loaders.push(layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[4])),_recordColor[4],BaseLayer.GAME));
			loaders.push(layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[2])),_recordColor[2],BaseLayer.GAME,false,info.getHairType()));
			loaders.push(layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[5])),_recordColor[5],BaseLayer.GAME));
			loaders.push(layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[6])),_recordColor[6],BaseLayer.GAME,true));
			loaders.push(layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[8])),_recordColor[8],BaseLayer.GAME));
//			loaders.push(layerFactory.createLayer(ItemManager.Instance.getTemplateById(15002),_recordColor[8],BaseLayer.GAME));
			
		}
		
		override protected function getIndexByTemplateId(id:String):int
		{
			switch(id.charAt(0))
			{
				case "1": 
				if(id.charAt(1) == String(3))
				{
					return 0;
				}else if(id.charAt(1) == String(5))
				{
					return 8
				}else
				{
					return 2;
				}
				case "2": return 1;
				case "3": return 5;
				case "4": return 3;
				case "5": return 4;
				case "6": return 6;
				case "7": return 7;
				default:return -1;
			}
		}
		
		override protected function getCharacterLoader(value:ItemTemplateInfo,color:String = ""):ILayer
		{
			if(value.CategoryID == EquipType.HAIR)
				return layerFactory.createLayer(value,color,BaseLayer.GAME,false,info.getHairType());
			else return layerFactory.createLayer(value,color,BaseLayer.GAME);
		}
	}
}