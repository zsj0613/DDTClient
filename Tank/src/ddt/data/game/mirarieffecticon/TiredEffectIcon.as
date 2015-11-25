package ddt.data.game.mirarieffecticon
{
	import flash.display.Sprite;
	
	import game.crazyTank.view.TiredAsset;
	
	public class TiredEffectIcon extends BaseMirariEffectIcon
	{
		public function TiredEffectIcon()
		{
			super();
		}
		
		override public function get MirariType():int
		{
			return 1;
		}
		
		override public function getEffectIcon():Sprite
		{
			return new TiredAsset();
		}
	}
}