package ddt.view.characterII
{
	import ddt.data.player.PlayerInfo;
	
	public interface ICharacterLoaderFactory
	{
		function createLoader(info:PlayerInfo,type:String = "show"):ICharacterLoader;
	}
}