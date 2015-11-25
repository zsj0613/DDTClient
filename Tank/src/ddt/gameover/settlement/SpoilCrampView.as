package ddt.gameover.settlement
{
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import game.crazyTank.view.gameOverSettle.spoilCrampAsset;
	
	import road.comm.PackageIn;
	import road.ui.manager.TipManager;
	
	import ddt.data.GameInfo;
	import ddt.data.game.LocalPlayer;
	import ddt.data.game.Player;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.game.CountDownView;
	import ddt.gameover.CardDiamondView;
	import ddt.manager.LanguageMgr;
	import ddt.manager.RoomManager;
	import ddt.manager.SocketManager;
	import ddt.socket.GameInSocketOut;

	public class SpoilCrampView extends spoilCrampAsset
	{
		/**
		 * 战利品抽取时间
		 */		
		private static const CARD_TIME:uint = 15;
		
		private var _cards:Array;
		private var _cardTimeII:CountDownView;
		private var _resuldCards:Array;
		private var _showAllCard:Array;
		private var _game:GameInfo;
		private var _self:LocalPlayer;
		private var _isSelect:Boolean = false;
		private var _selectedCount:uint = 0;
		private var _allCardItem:Array;
		protected var _timeHnd:uint;
		
		public function SpoilCrampView(game:GameInfo)
		{
			super();
			
			_game = game;
			
			init();
			
			initEvent();
		}
		
		private function init():void
		{
			_cards = new Array();
			
			_cardTimeII = new CountDownView(CARD_TIME);
			_cardTimeII.x = cardtimer_pos.x;
			_cardTimeII.y = cardtimer_pos.y;
			addChild(_cardTimeII);
			
			_resuldCards = _game.resultCard.splice(0,_game.resultCard.length);
			_showAllCard = _game.showAllCard.splice(0,_game.showAllCard.length);
			
			_self = _game.selfGamePlayer;
			
			createCards();
			
			for each(var event:CrazyTankSocketEvent in _resuldCards)
			{
				__takeOut(event);
			}
			
			clearMC();
		}
		
		private function initEvent():void
		{
			_cardTimeII.addEventListener(Event.COMPLETE,__timerCompleted);
			_cardTimeII.startCountDown();
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_TAKE_OUT,__takeOut);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SHOW_CARDS, __showAllCard);
			RoomManager.Instance.addEventListener(RoomManager.PAYMENT_TAKE_CARD, __paymentFailed);
			
			for each(var e:CrazyTankSocketEvent in _showAllCard)
			{
				__showAllCard(e);
			}
		}
		
		private function __paymentFailed(e:Event):void
		{
			_setNoTakeout();
		}
		
		private function createCards():void
		{
			for(var i:uint = 0; i < 21; i++)
			{
				var diamond:CardDiamondView = new CardDiamondView(i);
			
				diamond.x = this["card"+i.toString()].x;
				diamond.y = this["card"+i.toString()].y;
				diamond.allowClick = _self.GetCardCount > 0;
				diamond.msg = LanguageMgr.GetTranslation("ddt.gameover.DisableGetCard");
				addChild(diamond);
				_cards.push(diamond);
			}
		}
		
		private var _checkSysTake:Boolean = true;
		private function __takeOut(e:CrazyTankSocketEvent):void
		{
			if(_cards.length > 0) //卡片还没有初始化
			{
				var pkg:PackageIn = e.pkg;
				
				var isSysTake:Boolean = pkg.readBoolean();
				if(_checkSysTake && isSysTake)
				{
					_checkSysTake = false;//收到系统翻牌后将禁止玩家翻牌
					_setNoTakeout();
				}
				
				var place:Number = pkg.readByte();
				
				if(place == 50) return;
				
				var templateID:int = pkg.readInt();
				var count:int = pkg.readInt();
				
				var info:Player = _game.findPlayer(pkg.extend1);
				
				if(pkg.clientId == _self.playerInfo.ID)
				{
					info = _self;
				}
				
				if(info)
				{
					_cards[place].start(info, templateID, count);
					if(info.isSelf)
					{
						_selectedCount++;
						_isSelect = (_selectedCount >= info.GetCardCount);
						
						if(_selectedCount >= 5)
						{
							_setNoTakeout();
							return;
						}
						
						if(_isSelect)
						{
							_setPaymentTakeout();
						}
					}
				}
			}
			else
			{
				_resuldCards.push(e);
			}
		}
		private function _setPaymentTakeout():void
		{
			for each(var card:CardDiamondView in _cards)
			{
				card.canClick(false);
				card.paymentTakeout();
			}
		}
		private function _setNoTakeout():void
		{
			for each(var card1:CardDiamondView in _cards)
			{
				card1.canClick(false);
				card1.setNoPaymentTakeout();
			}
		}
		/**
		 * 展示事件
		 * @param e
		 * 
		 */		
		private function __showAllCard(e:CrazyTankSocketEvent):void
		{
			_setNoTakeout();
			if(_cardTimeII)
			{
				_cardTimeII.removeEventListener(Event.COMPLETE,__timerCompleted);
				_cardTimeII.dispose();
			}
			_cardTimeII = null;
			
			var pkg:PackageIn = e.pkg;
			
			var count:int = pkg.readInt();
			
			_allCardItem = [];
			
			for(var i:uint = 0; i < count; i++)
			{
				var obj:Object = new Object();
				
				obj.index = pkg.readByte();
				obj.templateID = pkg.readInt();
				obj.count = pkg.readInt();
				_allCardItem.push(obj);
			}
			TipManager.clearTipLayer();
			if(_checkSysTake == false)
			{
				setTimeout(showAllCard,1800);
			}
			else
			{
				showAllCard();
			}
		}
		
		private function __timerCompleted(event:Event):void
		{
			if(!_isSelect && (_selectedCount >= _self.GetCardCount))
			{
				GameInSocketOut.sendGameTakeOut(100);
				_setNoTakeout();
				_timeHnd = setTimeout(showTrophyDialog, 2500);
			}
		}
		
		private function showAllCard():void
		{
			for each(var card1:CardDiamondView in _cards)
			{
				card1.setNoPaymentTakeout();
			}
			if(_allCardItem && _allCardItem.length > 0)
			{
				for(var i:uint = 0; i < _allCardItem.length; i++)
				{
					_cards[uint(_allCardItem[i].index)].start(null,int(_allCardItem[i].templateID),_allCardItem[i].count);
				}
				setTimeout(showTrophyDialog,4500);
			}
		}
		
		private function showTrophyDialog():void
		{
			_game.resetResultCard();
			clearTimeout(_timeHnd);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function clearMC():void
		{
			for(var i:uint = 0; i < 21; i++)
			{
				removeChild(this["card"+i.toString()]);
				this["card"+i.toString()] = null;
			}
			if(cardtimer_pos && cardtimer_pos.parent)
			{
				cardtimer_pos.parent.removeChild(cardtimer_pos);
			}
			cardtimer_pos = null;
		}
		
		public function dispose():void
		{
			
			clearTimeout(_timeHnd);
			_game.showAllCard = [];
			_game.resultCard = [];
			RoomManager.Instance.removeEventListener(RoomManager.PAYMENT_TAKE_CARD, __paymentFailed);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_TAKE_OUT,__takeOut);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SHOW_CARDS, __showAllCard);
			
			if(_cardTimeII)
			{
				_cardTimeII.removeEventListener(Event.COMPLETE,__timerCompleted);
				_cardTimeII.dispose();
			}
			_cardTimeII = null;
			
			if(_cards)
			{
				for each(var i:CardDiamondView in _cards)
				{
					i.dispose();
					i = null;
				}
			}
			_cards = null;
			
			_resuldCards = null;
			_game = null;
			_self = null;
			
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}