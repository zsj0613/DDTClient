package ddt.data.game.mirarieffecticon
{
	import flash.display.Sprite;
	
	import game.cazyTank.view.ShieldAsset;

	
	public class DefendEffectIcon extends BaseMirariEffectIcon
	{
		public function DefendEffectIcon()
		{
			super();
		}
		override public function get MirariType():int
		{
			return 6;
		}
		
		override public function getEffectIcon():Sprite
		{
			return new ShieldAsset();
		}
	}
}