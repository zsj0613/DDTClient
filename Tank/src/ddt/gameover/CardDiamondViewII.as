package ddt.gameover
{
	import flash.events.MouseEvent;
	
	import ddt.manager.MessageTipManager;
	import ddt.socket.GameInSocketOut;
	
	public class CardDiamondViewII extends CardDiamondView
	{
		public function CardDiamondViewII(index:int)
		{
			super(index);
		}
		
		override protected function __click(event:MouseEvent):void
		{
			if(allowClick)
			{
				GameInSocketOut.sendBossTakeOut(_index);
				canClick(false);
			}
			else
			{
				MessageTipManager.getInstance().show(msg);
			}
		}
	}
}