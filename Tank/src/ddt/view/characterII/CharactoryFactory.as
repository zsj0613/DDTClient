package ddt.view.characterII
{
	import ddt.data.player.PlayerInfo;

	public class CharactoryFactory
	{
		public static const SHOW:String = "show";
		public static const GAME:String = "game";
		public static const CONSORTIA:String = "consortia";
		
		private static var _characterloaderfactory:ICharacterLoaderFactory = new CharacterLoaderFactory();
		
		public static function createCharacter(info:PlayerInfo,type:String = "show"):ICharacter
		{
			var _character:ICharacter;
			switch(type)
			{
				case SHOW:
					_character = new ShowCharacter(info);
					break;
				case GAME:
					_character = new GameCharacter(info);
					break;
				default:
					break;
			}
			if(_character != null)
				_character.setFactory(_characterloaderfactory);
			return _character;
		}
		
	}
}