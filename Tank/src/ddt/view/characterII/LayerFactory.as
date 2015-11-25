package ddt.view.characterII
{
	import ddt.data.EquipType;
	import ddt.data.goods.ItemTemplateInfo;
	
	public class LayerFactory implements ILayerFactory
	{
		public static const ICON:String = "icon";
		public static const SHOW:String = "show";
		public static const GAME:String = "game";
		
		private static var _instance:ILayerFactory;
		
		public function LayerFactory()
		{
		}

		public function createLayer(info:ItemTemplateInfo, color:String = "", type:String = "show",gunBack:Boolean = false,hairType:int = 1):ILayer
		{
			var _layer:ILayer;
			switch(type)
			{
				case ICON:
					_layer = new IconLayer(info,color,gunBack,hairType);
					break;
				case SHOW:
					if(info)
					{
						if(info.CategoryID == EquipType.WING)
						{
							_layer = new BaseWingLayer(info);
						}else
						{
							_layer = new ShowLayer(info,color,gunBack,hairType);
						}
					}
					break;
				case GAME:
					if(info)
					{
						if(info.CategoryID == EquipType.WING)
						{
							_layer = new BaseWingLayer(info,BaseWingLayer.GAME_WING);
						}else
						{
							_layer = new GameLayer(info,color,gunBack,hairType);
						}
					}
					break;
				default:
					break;
			}
			return _layer;
		}
		
		public static function get instance():ILayerFactory
		{
			if(_instance == null)
				_instance = new LayerFactory();
			return _instance;
		}
	}
}