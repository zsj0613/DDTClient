package ddt.hall
{
	import fl.controls.TextArea;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.ConsortiaInfoAeest;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.bitmap.BlackFrameBG;
	import road.ui.controls.hframe.bitmap.BlackFrameBottom;
	
	import ddt.data.ConsortiaInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.view.common.MyConsortiaEventItem;

	public class HallConsortiaInfo extends Sprite
	{
		private var _bg:BlackFrameBG;
		private var _buttonBg:BlackFrameBottom;
		private var _consortiaInfo:ConsortiaInfoAeest;
		private var _current:MovieClip;
		private var _button:HLabelButton;
		
		private var _eventListData:Array = [];
		private var _text:TextArea;
		
		public function HallConsortiaInfo()
		{
			super();
			initUI();
			addEvent();
		}
		private function initUI():void
		{
			_bg = new BlackFrameBG();
			_bg.setSize(250,272);
			_bg.alpha = .5;
			_bg.x = 745;
			addChild(_bg);
			
			_buttonBg = new BlackFrameBottom();
			_buttonBg.setSize(245,35);
			_buttonBg.x = _bg.x + 3;
			_buttonBg.y = _bg.y + _bg.height - 40;
			addChild(_buttonBg);
			
			_consortiaInfo = new ConsortiaInfoAeest();
			_consortiaInfo.x = _bg.x + 5;
			_consortiaInfo.y = _bg.y + 5;
			_consortiaInfo.affiche.gotoAndStop(1);
			_consortiaInfo.event.gotoAndStop(1);
			_consortiaInfo.affiche.buttonMode = true;
			_consortiaInfo.event.buttonMode = true;
			addChild(_consortiaInfo);
			
			_button = new HLabelButton();
			_button.label = LanguageMgr.GetTranslation("close");
			//_button.label = "关 闭";
			_button.x = _buttonBg.x + _buttonBg.width/2 - _button.width/2;
			_button.y = _buttonBg.y + _buttonBg.height/2 - _button.height/2;
			addChild(_button);
			
			_eventListData = PlayerManager.Instance.Self.myConsortiaEventList;
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPopChange);
			PlayerManager.Instance.SelfConsortia.addEventListener(ConsortiaInfo.PLACARD_CHANGE,__onPlaceCardChange);
			
			
			/* 事件数据初始化 */
			_list = new SimpleGrid(225,65,1);
			_list.setSize(244,204);
			_list.horizontalScrollPolicy = "off";
			_list.verticalScrollPolicy   = "on";
			_list.visible = false;
			addChild(_list);
			_list.x = 748;
			_list.y = 27;
			_items = new Array();
			initEventView();
			
			/* 公告栏 bret 09.6.2 */
			_text = new TextArea();
			_text.verticalScrollPolicy = "on";
			_text.horizontalScrollPolicy = "off";
			if(PlayerManager.Instance.SelfConsortia)
			{
				_text.textField.text = PlayerManager.Instance.SelfConsortia.Placard;
			}else
			{
				_text.textField.text = "";
			}
			_text.setStyle("upSkin",new Sprite());
//			_text.setStyle("disabledSkin",new Sprite());
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.size = 16;
			format.color = 0x013465;
			format.leading = 4;
//			_text.setStyle("disabledTextFormat",format);
			_text.setStyle("textFormat",format);
			_text.setSize(236,204);
//			_text.textField.selectable = false;
//			_text.textField.mouseEnabled = false;
			_text.editable = false;
			
			var filterA:Array = [];
			var glowFilter:GlowFilter = new GlowFilter(0xffffff,1,4,4,10);
			filterA.push(glowFilter);
			_text.textField.filters = filterA;
			addChild(_text);
			_text.x = 752;
			_text.y = 27;
			/* ************************************************************ */
			
		}
		private function addEvent():void
		{
			_consortiaInfo.affiche.addEventListener(MouseEvent.CLICK,__click);
			_consortiaInfo.event.addEventListener(MouseEvent.CLICK,__click);
			_button.addEventListener(MouseEvent.CLICK,__close);
//			PlayerManager.Instance.addEventListener(PlayerManager.CONSORTIA_PLACARD_UPDATE, __upMyConsortiaPlacard);
		}
		private function removeEvent():void
		{
			_consortiaInfo.affiche.removeEventListener(MouseEvent.CLICK,__click);
			_consortiaInfo.event.removeEventListener(MouseEvent.CLICK,__click);
			_button.removeEventListener(MouseEvent.CLICK,__close);
//			PlayerManager.Instance.removeEventListener(PlayerManager.CONSORTIA_PLACARD_UPDATE, __upMyConsortiaPlacard);
		}
		
		private function __click(e:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if((e.currentTarget as MovieClip).name == "affiche")
			{
				_list.visible = false;
				_consortiaInfo.affiche.gotoAndStop(1);
				_consortiaInfo.event.gotoAndStop(1);
				_text.visible = true;
				_text.text = PlayerManager.Instance.SelfConsortia.Placard;
			}
			else
			{
				_list.visible = true;
				_consortiaInfo.affiche.gotoAndStop(2);
				_consortiaInfo.event.gotoAndStop(2);
				_text.visible = false;
//				_text.text = "";
			}
		}
		
		private function __close(e:MouseEvent):void
		{
			__visible();
			SoundManager.Instance.play("008");
		}
		
		private function __onPopChange(e:PlayerPropertyEvent) : void
		{
			if(e.changedProperties["myConsortiaEventList"])
			{
				_eventListData = PlayerManager.Instance.Self.myConsortiaEventList;
				
				/* 事件数据初始化 */
				initEventView();
			}else if(e.changedProperties["SelfConsortia"])
			{
				_text.text = PlayerManager.Instance.SelfConsortia.Placard;
				PlayerManager.Instance.SelfConsortia.addEventListener(ConsortiaInfo.PLACARD_CHANGE,__onPlaceCardChange);
			}
			
		}
		
		private function __onPlaceCardChange(e:Event):void
		{
			_text.text = PlayerManager.Instance.SelfConsortia.Placard;
		}
		
		private var _items:Array;
		private var _list :SimpleGrid;
		private function initEventView():void
		{
			clearList();
			for(var i:int=0;i<_eventListData.length;i++)
			{
				var item:MyConsortiaEventItem = new MyConsortiaEventItem();
				item.bg.alpha = .4;
				item.info = _eventListData[i];
				_items.push(item);
				_list.appendItem(item);
			}
		}
		private function clearList() : void
		{
			for(var i:int=0;i<_items.length;i++)
			{
				var item: MyConsortiaEventItem = _items[i] as MyConsortiaEventItem;
				_list.removeItem(item);
				item.dispose();
				item = null;
			}
			_items = new Array();
		}
		
		public function dispose():void
		{
			removeEvent();
			
			clearList();
			
			if(_list.parent)_list.parent.removeChild(_list);
			_list = null;
			
			if(_buttonBg.parent)_buttonBg.parent.removeChild(_buttonBg);
			_buttonBg = null;
			
			if(_button.parent)_button.parent.removeChild(_button);
			_button = null;
			
			if(_consortiaInfo.parent)_consortiaInfo.parent.removeChild(_consortiaInfo);
			_consortiaInfo = null;
			
			if(_text.parent)_text.parent.removeChild(_text);
			_text = null;
			
			if(_bg.parent)_bg.parent.removeChild(_bg);
			_bg = null;
			
			_items = null;
			
			if(this.parent)this.parent.removeChild(this);
		}
		
		private function __visible():void
		{
			_bg.visible = false;
			_buttonBg.visible = false;
			_button.visible = false;
			_consortiaInfo.visible = false;
			_text.visible = false;
			_list.visible = false;
		}
	}
}