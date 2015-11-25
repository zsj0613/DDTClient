package ddt.data.game.mirarieffecticon
{
	import flash.display.Sprite;
	
	import game.crazyTank.view.NotDigAsset;
	
	public class NoHoleEffectIcon extends BaseMirariEffectIcon
	{
		public function NoHoleEffectIcon()
		{
			super();
		}
		
		override public function get MirariType():int
		{
			return 5;
		}
		
		override public function getEffectIcon():Sprite
		{
			return new NotDigAsset();
		}
	}
}