package ddt.data.game.mirarieffecticon
{
	import flash.display.Sprite;
	
	import ddt.data.game.Living;
	
	public class BaseMirariEffectIcon
	{
		public function BaseMirariEffectIcon()
		{
		}
		
		public function get MirariType():int
		{
			return 0;
		}
		
		public function getEffectIcon():Sprite
		{
			return null;
		}
		
		public function excuteEffect(live:Living):void
		{
			
		}
		
		public function unExcuteEffect(live:Living):void
		{
			
		}
	}
}