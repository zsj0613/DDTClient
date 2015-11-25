package ddt.data.game.mirarieffecticon
{
	import flash.display.Sprite;
	
	import game.crazyTank.view.LockAngleAsset;
	
	import ddt.data.game.Living;
	
	public class LockAngleEffectIcon extends BaseMirariEffectIcon
	{
		public function LockAngleEffectIcon()
		{
			super();
		}
		
		override public function get MirariType():int
		{
			return 3;
		}
		
		override public function getEffectIcon():Sprite
		{
			return new LockAngleAsset();
		}
		
		override public function excuteEffect(live:Living):void
		{
			live.isLockAngle = true;
		}
		
		override public function unExcuteEffect(live:Living):void
		{
			live.isLockAngle = false;
		}
	}
}