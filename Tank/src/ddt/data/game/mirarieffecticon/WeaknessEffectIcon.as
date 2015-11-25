package ddt.data.game.mirarieffecticon
{
	import flash.display.Sprite;
	
	import game.crazyTank.view.WeaknessAsset;
	
	public class WeaknessEffectIcon extends BaseMirariEffectIcon
	{
		public function WeaknessEffectIcon()
		{
			super();
		}
		
		override public function get MirariType():int
		{
			return 4;
		}
		
		override public function getEffectIcon():Sprite
		{
			return new WeaknessAsset();
		}
	}
}