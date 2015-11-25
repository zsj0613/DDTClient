package ddt.view.characterII
{
	import ddt.data.player.PlayerInfo;

	public class CharacterLoaderFactory implements ICharacterLoaderFactory
	{
		public static const SHOW:String = "show";
		public static const GAME:String = "game";
		public static const CONSORTIA:String = "consortia";
		
		
		public function CharacterLoaderFactory()
		{
		}

		public function createLoader(info:PlayerInfo, type:String="show"):ICharacterLoader
		{
			var _loader:ICharacterLoader;
			switch(type)
			{
				case SHOW:
					_loader = new ShowCharacterLoader(info);
					break;
				case GAME:
					_loader = new GameCharacterLoader(info);
					break;
				default:
					break;
			}
			if(_loader != null)
				_loader.setFactory(LayerFactory.instance);
			return _loader;
		}
		
	}
}