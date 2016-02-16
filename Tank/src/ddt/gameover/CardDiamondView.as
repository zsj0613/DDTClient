package ddt.gameover
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.CardDiamondAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmDialog;
	
	import ddt.data.game.Player;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.ChatManager;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.socket.GameInSocketOut;
	import ddt.view.cells.BagCell;

	public class CardDiamondView extends CardDiamondAsset
	{
		protected var _index:int;
		private var _goodsItemII:BagCell;		
		private var _info:Player;
		
		private var _templateID:int;
		private var _count:int;
		
		public function CardDiamondView(index:int)
		{
			_index = index;
			card_mc.stop();
			card_mc.addFrameScript(card_mc.totalFrames - 1,showResult);
			initView();
			canClick(true);
		}
		
		private function initView():void
		{
			_templateID = 0;
			
			gold_mc.visible = false;
			goods_mc.visible = false;
			nickName.visible = false;	
			_goodsItemII = new BagCell(0);
			_goodsItemII.x = goods_mc.goodsPos.x;
			_goodsItemII.y = goods_mc.goodsPos.y;
			_goodsItemII.BGVisible = false;
			goods_mc.addChild(_goodsItemII);
			cardBorder_mc.visible = false;
			goods_mc.goodsPos.visible = false;
			cardBorder_mc.mouseEnabled = false;
			gold_mc.mouseEnabled = false;
			goods_mc.mouseEnabled = false;
		}
		
		public function canClick(b:Boolean):void
		{
			buttonMode = b;
			mouseEnabled = b;
			mouseChildren = b;
			if(b)
			{
				card_mc.addEventListener(MouseEvent.CLICK,__click);
				card_mc.addEventListener(MouseEvent.MOUSE_OVER,__over);
				card_mc.addEventListener(MouseEvent.MOUSE_OUT,__out);
			}
			else
			{
				card_mc.removeEventListener(MouseEvent.CLICK,__click);
				card_mc.removeEventListener(MouseEvent.MOUSE_OVER,__over);
				card_mc.removeEventListener(MouseEvent.MOUSE_OUT,__out);
			}
		}
		
		public function paymentTakeout():void
		{
			if(_info == null)
			{
				buttonMode = true;
				mouseEnabled = true;
				mouseChildren = true;
				card_mc.addEventListener(MouseEvent.CLICK, __payClick);
				card_mc.addEventListener(MouseEvent.MOUSE_OVER,__over);
				card_mc.addEventListener(MouseEvent.MOUSE_OUT,__out);
			}
		}
		
		public function setNoPaymentTakeout():void
		{
			buttonMode = false;
			mouseEnabled = false;
			mouseChildren = false;
			allowClick = false;
			card_mc.removeEventListener(MouseEvent.CLICK, __payClick);
			card_mc.removeEventListener(MouseEvent.MOUSE_OVER,__over);
			card_mc.removeEventListener(MouseEvent.MOUSE_OUT,__out);
			MessageTipManager.getInstance().show("您的翻牌次数已经用完");
		}
		
		private function __payClick(e:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			MessageTipManager.getInstance().show("您的翻牌次数已经用完，您可以通过升级VIP获得更多翻牌次数");
//			HConfirmDialog.show("购买1次翻牌机会", "本次购买翻牌将扣除您100点券,确定要购买吗?", true, paymentTakeCard);
		}
		
		private function paymentTakeCard():void
		{
			GameInSocketOut.sendPaymentTakeCard(_index);
//			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function start(info:Player, tid:int, count:int):void
		{
			_info = info;
			_templateID = tid;
			_count = count;
			 
			card_mc.gotoAndPlay(3);
			SoundManager.Instance.play("048");
			canClick(false);
		}
		
		private function showResult():void
		{
			canClick(false);
			card_mc.stop();
			if(_info)
			{
				nickName.visible = true;
				nickName.text = _info.playerInfo.NickName;
				if(_info.isSelf)
				{
					cardBorder_mc.visible = true;
				}
				else
				{
					nickName.textColor = 0xFF00FF;
				}
			}
			
			if(_templateID > 0)
			{
				goods_mc.visible = true;
				var item:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_templateID);
				if(item && _goodsItemII)
				{
					_goodsItemII.info = item;
					goods_mc.name_txt.text = item.Name;
				}
			}
			else if(_templateID == -100)
			{
				gold_mc.visible = true;
				gold_mc.gold_txt.text = _count;
				gold_mc.gold_mc.gotoAndStop(1);//金币
				if(_info && _info.isSelf)
				{
					ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("ddt.gameover.takecard.getgold",_count));
				}
			}
			else if(_templateID == -200)
			{
				goods_mc.visible = true;
				goods_mc.name_txt.text = LanguageMgr.GetTranslation("ddt.gameover.takecard.money");
//				goods_mc.name_txt.text = "点券";
				gold_mc.visible = true;
				gold_mc.gold_txt.text = _count;
				gold_mc.gold_mc.gotoAndStop(2);//点券
			}
			else if(_templateID == -300)
			{
				goods_mc.visible = true;
				goods_mc.name_txt.text = LanguageMgr.GetTranslation("ddt.gameover.takecard.gifttoken");
//				goods_mc.name_txt.text = "礼券";
				gold_mc.visible = true;
				gold_mc.gold_txt.text = _count;
				gold_mc.gold_mc.gotoAndStop(3);//礼券
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public var allowClick:Boolean = true;
		public var msg:String = "";
		
		protected function __click(event:MouseEvent):void
		{
			if(allowClick)
			{
				SoundManager.Instance.play("008");
				GameInSocketOut.sendGameTakeOut(_index);
				canClick(false);
			}
			else
			{
				MessageTipManager.getInstance().show(msg);
			}
		}
		
		private function __over(event:MouseEvent):void
		{
			card_mc.gotoAndStop(2);
		}
		
		private function __out(event:MouseEvent):void
		{
			card_mc.gotoAndStop(1);
		}
		
		public function dispose():void
		{
			card_mc.addFrameScript(card_mc.totalFrames - 1,null);
			card_mc.removeEventListener(MouseEvent.CLICK,__click);
			card_mc.removeEventListener(MouseEvent.CLICK,__payClick);
			card_mc.removeEventListener(MouseEvent.MOUSE_OVER,__over);
			card_mc.removeEventListener(MouseEvent.MOUSE_OUT,__out);
			if(_goodsItemII)
			{
				_goodsItemII.dispose();
			}
			_goodsItemII = null;
			_info = null;
			if(parent)
				parent.removeChild(this);
		}
	}
}