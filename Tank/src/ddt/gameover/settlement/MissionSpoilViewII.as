package ddt.gameover.settlement
{
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import ddt.data.GameInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.gameover.CardDiamondViewII;
	import ddt.manager.LanguageMgr;
	import ddt.manager.SocketManager;
	import ddt.socket.GameInSocketOut;

	public class MissionSpoilViewII extends MissionSpoilView
	{
		public function MissionSpoilViewII(game:GameInfo)
		{
			super(game);
		}
		
		override protected function initEvent():void
		{
			_cardTimeII.addEventListener(Event.COMPLETE,__timerCompleted);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_TAKE_OUT,__takeOut);
		}
		
		override protected function __timerCompleted(event:Event):void
		{
			_cardTimeII.removeEventListener(Event.COMPLETE,__timerCompleted);
			
			if(!_isSelect && (_self.BossCardCount > 0))
			{
				GameInSocketOut.sendBossTakeOut(100);
				_timeHnd = setTimeout(takeComplete, 5000);
			}
			else
			{
				takeComplete();
			}
		}
		
		override protected function createCards(tx:int, ty:int):void
		{
			for(var i:uint = 0; i < 8; i++)
			{
				var diamond:CardDiamondViewII = new CardDiamondViewII(i);
				diamond.y = ty;
				diamond.x = tx;
				diamond.allowClick = _self.BossCardCount > 0;
				diamond.msg = LanguageMgr.GetTranslation("ddt.gameover.DisableGetCard");
				addChild(diamond);
				_cards.push(diamond);
				tx = diamond.x + diamond.width - 15;
			}
		}
	}
}