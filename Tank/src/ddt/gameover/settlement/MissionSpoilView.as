package ddt.gameover.settlement
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import road.comm.PackageIn;
	
	import ddt.data.GameInfo;
	import ddt.data.game.LocalPlayer;
	import ddt.data.game.Player;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.game.CountDownView;
	import ddt.gameover.CardDiamondView;
	import ddt.manager.LanguageMgr;
	import ddt.manager.SocketManager;
	import ddt.manager.UserGuideManager;
	import ddt.socket.GameInSocketOut;
	import ddt.manager.RoomManager;
	public class MissionSpoilView extends Sprite
	{
		/**
		 * 战利品抽取时间
		 */		
		protected static const CARD_TIME:uint = 6;
		
		protected static const MAX_SELECTCOUNT:uint = 1;
		
		protected var _cards:Array;
		protected var _resuldCards:Array;
		protected var _isSelect:Boolean;
		protected var _selectedCount:uint;
		protected var _game:GameInfo;
		protected var _self:LocalPlayer;
		protected var _cardTimeII:CountDownView;
		protected var _timeHnd:uint;
		private var _userguideDelay:int;
		public static var NORMAL_TAKECARD_LEAVE_TIME:int = 2000;
		public static var TUTORIAL_TAKECARD_LEAVE_TIME:int = 10000;
		
		public function MissionSpoilView(game:GameInfo)
		{
			super();
			
			_game = game;
			_self = _game.selfGamePlayer;
			
			initialize();
			initEvent();
			if(!UserGuideManager.Instance.getIsFinishTutorial(28)){
				_cardTimeII.visible = false;
				_cardTimeII.removeEventListener(Event.COMPLETE,__timerCompleted);
				_userguideDelay = 65;
				UserGuideManager.Instance.setupStep(28,UserGuideManager.CONTROL_GUIDE,null,checkUserGuide28);
			}
		}
		private function checkUserGuide28():Boolean{
			if(this._isSelect){
				_userguideDelay--;
				if(_userguideDelay <= 0){
					return true;
				}
				return false;
			}
			_userguideDelay = 25;
			return false;
		}
		private function initialize():void
		{
			_cards = [];
			_resuldCards = _game.resultCard.splice(0,_game.resultCard.length);
			
			_isSelect = false;
			_selectedCount = 0;
			
			_cardTimeII = new CountDownView(CARD_TIME);
			_cardTimeII.x = 492;
			_cardTimeII.y = 271;
			_cardTimeII.startCountDown();
			addChild(_cardTimeII);
			
			createCards(35, 84);
			
			for each(var event:CrazyTankSocketEvent in _resuldCards)
			{
				__takeOut(event);
			}
		}
		
		protected function initEvent():void
		{
			_cardTimeII.addEventListener(Event.COMPLETE,__timerCompleted);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_TAKE_OUT, __takeOut);
		}
		
		protected function createCards(tx:int, ty:int):void
		{
			for(var i:uint = 0; i < 8; i++)
			{
				var diamond:CardDiamondView = new CardDiamondView(i);
				diamond.y = ty;
				diamond.x = tx;
				diamond.allowClick = _self.GetCardCount > 0;
				diamond.msg = LanguageMgr.GetTranslation("ddt.gameover.DisableGetCard");
				addChild(diamond);
				_cards.push(diamond);
				tx = diamond.x + diamond.width - 15;
			}
		}
		
		protected function __timerCompleted(event:Event):void
		{
			_cardTimeII.removeEventListener(Event.COMPLETE,__timerCompleted);
			
			if(!_isSelect && (_self.GetCardCount > 0))
			{
				GameInSocketOut.sendGameTakeOut(100);
				_timeHnd = setTimeout(takeComplete, leaveTakeCardTime);
			}
			else
			{
				takeComplete();
			}
		}
		
		protected function __takeOut(e:CrazyTankSocketEvent):void
		{
			if(_cards.length > 0) //卡片还没有初始化
			{
				var pkg:PackageIn = e.pkg;
				
				var isSysTake:Boolean = pkg.readBoolean();
				
				var place:Number = pkg.readByte();
				
				if(place == 50) return;
				
				var templateID:int = pkg.readInt();
				var count:int = pkg.readInt();
				
				var info:Player = _game.findPlayer(pkg.extend1);
				if(info)
				{
					_cards[place].start(info, templateID, count);
					
					if(info.isSelf)
					{
						_selectedCount++;
						
						_isSelect = (_selectedCount >= MAX_SELECTCOUNT);
						
						if(_isSelect)
						{
							for each(var card:CardDiamondView in _cards)
							{
								card.canClick(false);
							}
							clearTimeout(_timeHnd);
							_timeHnd = setTimeout(takeComplete, leaveTakeCardTime);
						}
					}
				}
			}
			else
			{
				_resuldCards.push(e);
			}
		}
		
		private function get leaveTakeCardTime():int
		{
			if(RoomManager.Instance.current.roomType == 10)
			{
				return TUTORIAL_TAKECARD_LEAVE_TIME;
			}
			return NORMAL_TAKECARD_LEAVE_TIME;
		}
		
		protected function takeComplete():void
		{
			if(_game)
			{
				_game.resetResultCard();
			}
			if(_resuldCards)
			{
				_resuldCards.splice(0,_resuldCards.length);
				_resuldCards = null;
			}
			clearTimeout(_timeHnd);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function dispose():void
		{
			clearTimeout(_timeHnd);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_TAKE_OUT,__takeOut);
			
			if(_cardTimeII)
			{
				_cardTimeII.removeEventListener(Event.COMPLETE,__timerCompleted);
				_cardTimeII.dispose();
			}
			_cardTimeII = null;
			
			while(_cards.length > 0)
			{
				var card:CardDiamondView = _cards.shift() as CardDiamondView;
				
				card.dispose();
				card = null;
			}
			_cards = null;
			
			_game = null;
			_self = null;
			
			_resuldCards = null;
			
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}