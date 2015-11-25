package ddt.data.game.mirarieffecticon
{
	import flash.display.Sprite;
	
	import game.crazyTank.view.FiringAsset;
	
	public class FiringEffectIcon extends BaseMirariEffectIcon
	{
		public function FiringEffectIcon()
		{
			super();
		}
		
		override public function get MirariType():int
		{
			return 2;
		}
		
		override public function getEffectIcon():Sprite
		{
			return new FiringAsset();
		}
	}
}