package ddt.game.objects
{
	import ddt.data.game.TurnedLiving;
	import ddt.events.LivingEvent;
	
	public class GameTurnedLiving extends GameLiving
	{
		public function GameTurnedLiving(info:TurnedLiving)
		{
			super(info);
		}
		
		public function get turnedLiving():TurnedLiving
		{
			return _info as TurnedLiving;
		}
		
		override protected function initListener():void
		{
			super.initListener();
			turnedLiving.addEventListener(LivingEvent.ATTACKING_CHANGED,__attackingChanged);
		}
		
		override protected function removeListener():void
		{
			super.removeListener();
			turnedLiving.removeEventListener(LivingEvent.ATTACKING_CHANGED,__attackingChanged);
		}
		
		protected function __attackingChanged(event:LivingEvent):void
		{
			
		}
		override public function die():void
		{
			turnedLiving.isAttacking = false;
			super.die();
		}
		
	}
}