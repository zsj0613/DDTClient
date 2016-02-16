package ddt.view.chatsystem
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import road.comm.PackageOut;
	import road.manager.SoundManager;
	import road.ui.manager.TipManager;
	
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.socket.ePackageType;
	import ddt.manager.ChatManager;
	import ddt.manager.IMEManager;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.SocketManager;
	import ddt.utils.Helpers;
	import ddt.view.bagII.GoodsTipPanel;
	import ddt.view.im.IMView;
	
	use namespace chat_system;
	
	public class ChatOutputField extends Sprite
	{
		public static const GAME_WIDTH:int = 288;
		public static const NORMAL_HEIGHT:int = 128;
		public static const NORMAL_WIDTH:int = 420;
		public static const GAME_STYLE:String = "GAME_STYLE";
		public static const NORMAL_STYLE:String = "NORMAL_STYLE";
		
		private static var _style:String="";
		
		public function ChatOutputField()
		{
			style=NORMAL_STYLE;
		}

		private var _contentField:TextField;
		
		private var _goodTipPos:Sprite = new Sprite();
		/**
		 *首次点击由系统发出，为无效点击，必须过滤 
		 */
		 
		private var _srcollRect:Rectangle;
		private var _tipStageClickCount:int = 0;
		
		public function set contentWidth(value:Number):void
		{
			_contentField.width = value;
			updateScrollRect(value,NORMAL_HEIGHT);
		}
		
		public function isBottom():Boolean
		{
			return _contentField.scrollV == _contentField.maxScrollV;
		}
		
		public function get scrollOffset():int
		{
			return _contentField.maxScrollV - _contentField.scrollV;
		}
		
		public function set scrollOffset(offset:int):void
		{
			_contentField.scrollV = _contentField.maxScrollV - offset;
			onScrollChanged();
		}
		
		public function setChats(chatData:Array):void
		{
			var resultHtmlText:String = "";
			for(var i:int = 0;i<chatData.length;i++)
			{
				resultHtmlText += chatData[i].htmlMessage;
			}
			_contentField.htmlText = resultHtmlText;
		}
		
		public function toBottom():void
		{
			Helpers.delayCall(__delayCall);
			_contentField.scrollV = _contentField.maxScrollV;
			onScrollChanged();
		}
		private function __delayCall():void
		{
			_contentField.scrollV = _contentField.maxScrollV;
			onScrollChanged();
			removeEventListener(Event.ENTER_FRAME,__delayCall);
		}
		private function __onScrollChanged(event:Event):void
		{
			onScrollChanged();
		}
		
		private function __onTextClicked(event:TextEvent):void
		{
			SoundManager.Instance.play("008");
			var data:Object = {};
			var allProperties:Array = event.text.split("|");
			var tipPos:Point;
			for(var i:int = 0; i< allProperties.length;i++)
			{
				if(allProperties[i].indexOf(":"))
				{
					var props:Array = allProperties[i].split(":");
					data[props[0]] = props[1];
				}
			}
			if(int(data.clicktype) == ChatFormats.CLICK_CHANNEL)
			{
				ChatManager.Instance.inputChannel = int(data.channel);
			}
			else if(int(data.clicktype) == ChatFormats.CLICK_USERNAME)
			{
				/**
				*IM列表输入名字时用到
				*/				
				if(IMView.IS_SHOW_SUB)
				{
					dispatchEvent(new ChatEvent(ChatEvent.NICKNAME_CLICK_TO_OUTSIDE,data.tagname));
				}else
				{
					IMEManager.enable();
					ChatManager.Instance.privateChatTo(data.tagname);
				}
			}
			else if(int(data.clicktype) == ChatFormats.CLICK_GOODS)
			{
				tipPos = _contentField.localToGlobal(new Point(_contentField.mouseX,_contentField.mouseY));
				_goodTipPos.x = tipPos.x;
				_goodTipPos.y = tipPos.y;
				var itemInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(data.templeteIDorItemID);
				itemInfo.BindType = data.isBind == "true" ? 0 : 1;
				showLinkGoodsInfo(itemInfo);
			}
			else if(int(data.clicktype) == ChatFormats.CLICK_INVENTORY_GOODS)
			{
				tipPos = _contentField.localToGlobal(new Point(_contentField.mouseX,_contentField.mouseY));
				_goodTipPos.x = tipPos.x;
				_goodTipPos.y = tipPos.y;
//				var info:ItemTemplateInfo=ChatManager.Instance.model.getLink(data.templeteIDorItemID);
//				if(info)
//				{
//					showLinkGoodsInfo(info);
//				}else
//				{
					var pkg:PackageOut = new PackageOut(ePackageType.LINKREQUEST_GOODS);
					pkg.writeInt(2);
					pkg.writeInt(data.templeteIDorItemID);
					SocketManager.Instance.out.sendPackage(pkg);
//				}
			}
			else if(int(data.clicktype) == ChatFormats.CLICK_DIFF_ZONE)
			{
				ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("ddt.view.chatFormat.cross"));
			}
		}
		chat_system function get goodTipPos():Point
		{
			return new Point(_goodTipPos.x,_goodTipPos.y);
		}
		private function __stageClickHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			event.stopPropagation();
			if(_tipStageClickCount > 0)
			{
				TipManager.setCurrentTarget(null,null);
				if(stage)stage.removeEventListener(MouseEvent.CLICK, __stageClickHandler);
			}else
			{
				_tipStageClickCount ++;
			}
		}
		
		private function initEvent():void
		{
//			_contentField.addEventListener(Event.SCROLL,__onScrollChanged);
			_contentField.addEventListener(TextEvent.LINK,__onTextClicked);
		}
		
		private function initView():void
		{
			_contentField = new TextField();
			_contentField.multiline = true;
			_contentField.wordWrap = true;
			_contentField.filters = [new GlowFilter(0x000000,1,4,4,8)];
			_contentField.mouseWheelEnabled = false;
			//Helpers.setTextfieldFormat(_contentField,{size:12});
			updateScrollRect(NORMAL_WIDTH,NORMAL_HEIGHT);
			addChild(_contentField);
		}
		private function disposeView():void
		{
			
			if(_contentField)
			{
				t_text = _contentField.htmlText;
				removeChild(_contentField);
			}
				
			_contentField = null;
		}
//		private var isStyleChange:Boolean = false;
		private var t_text:String;
		chat_system function set style(value:String):void
		{
			if(_style!=value)
			{
				_style = value;
				disposeView();
				initView();
				initEvent();
				switch(value)
				{
					case NORMAL_STYLE:
						_contentField.styleSheet = ChatFormats.styleSheet;
						_contentField.width = NORMAL_WIDTH;
						_contentField.height = NORMAL_HEIGHT;
					break;
					case GAME_STYLE:
						_contentField.styleSheet = ChatFormats.gameStyleSheet;
						_contentField.width = GAME_WIDTH;
						_contentField.height = NORMAL_HEIGHT;
					break;
				}
				_contentField.htmlText = t_text||"";
			}
		}
		private function onScrollChanged():void
		{
			dispatchEvent(new ChatEvent(ChatEvent.SCROLL_CHANG));
		}
		/**
		 *	显示物品tips
		 * @param item
		 * @param synchronized 一般为0
		 * 
		 */
		chat_system function showLinkGoodsInfo(item:ItemTemplateInfo,tipStageClickCount:uint=0):void
		{
			var good:GoodsTipPanel = new GoodsTipPanel(item);
			TipManager.setCurrentTarget(null,null);
			TipManager.setCurrentTarget(_goodTipPos,good);
			stage.addEventListener(MouseEvent.CLICK, __stageClickHandler);
			_tipStageClickCount = tipStageClickCount;
		}
		
		private function updateScrollRect($width:Number,$height:Number):void
		{
			_srcollRect = new Rectangle(0,0,$width,$height);
			_contentField.scrollRect = _srcollRect;
		}
	}
}