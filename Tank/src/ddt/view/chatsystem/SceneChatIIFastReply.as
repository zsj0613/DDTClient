package ddt.view.chatsystem
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.controls.ScrollPolicy;
	import game.crazyTank.view.FastReplyBgAsset;
	import road.ui.controls.SimpleGrid;
	import road.utils.ComponentHelper;
	import ddt.manager.LanguageMgr;
	public class SceneChatIIFastReply extends FastReplyBgAsset
	{
		public static const SELECTED_INGAME:String  ="selectedingame";
		
		private static const FASTREPLYS:Array = [LanguageMgr.GetTranslation("ddt.view.scenechatII.SceneChatIIFastReply.say1"),
												LanguageMgr.GetTranslation("ddt.view.scenechatII.SceneChatIIFastReply.say2"),
												LanguageMgr.GetTranslation("ddt.view.scenechatII.SceneChatIIFastReply.say3"),
												LanguageMgr.GetTranslation("ddt.view.scenechatII.SceneChatIIFastReply.say4"),
												LanguageMgr.GetTranslation("ddt.view.scenechatII.SceneChatIIFastReply.say5"),
												LanguageMgr.GetTranslation("ddt.view.scenechatII.SceneChatIIFastReply.say6"),
												LanguageMgr.GetTranslation("ddt.view.scenechatII.SceneChatIIFastReply.say7"),
												LanguageMgr.GetTranslation("ddt.view.scenechatII.SceneChatIIFastReply.say8"),
												LanguageMgr.GetTranslation("ddt.view.scenechatII.SceneChatIIFastReply.say9"),
												LanguageMgr.GetTranslation("ddt.view.scenechatII.SceneChatIIFastReply.say10"),
												LanguageMgr.GetTranslation("ddt.view.scenechatII.SceneChatIIFastReply.say11"),
												LanguageMgr.GetTranslation("ddt.view.scenechatII.SceneChatIIFastReply.say12")];
		
		public function SceneChatIIFastReply(inGame:Boolean = false)
		{
			_inGame = inGame;
			super();
			init();
		}

		private var _inGame:Boolean;
		private var _items:Array;
		private var _list:SimpleGrid;
		private var _selected:String;
		
		public function dispose():void
		{
			if(_list)
			{
				for each(var i:SceneChatIIFastReplyItem in _list.items)
				{
					i.removeEventListener(MouseEvent.CLICK,__itemClick,false);
					i.dispose();
					i = null;
				}
				if(_list.parent)
					_list.parent.removeChild(_list);
				_list.clearItems();
			}
			_list = null;
			_items = null;
			if(parent)parent.removeChild(this);
		}
		
		public function get selectedWrod():String
		{
			return _selected;
		}
		
		public function setVisible(b:Boolean):void
		{
			visible = b;
		}
		
		private function __itemClick(evt:MouseEvent):void
		{
			var t:SceneChatIIFastReplyItem = evt.currentTarget as SceneChatIIFastReplyItem;
			_selected = t.word;
			if(_inGame)
			{
				dispatchEvent(new Event(SELECTED_INGAME));
			}
			else
			{
				dispatchEvent(new Event(Event.SELECT));
			}
		}
		
		private function __mouseClick(evt:MouseEvent):void
		{
			setVisible(false);
		}
		
		private function init():void
		{
			graphics.beginFill(0x000000,0);
			graphics.drawRect(-3000,-3000,6000,6000);
			graphics.endFill();

			_items = [];
			_list = new SimpleGrid(175,19);
			_list.verticalScrollPolicy = _list.horizontalScrollPolicy = ScrollPolicy.OFF;
			ComponentHelper.replaceChild(this,list_pos,_list);
			for(var i:int = 0; i < FASTREPLYS.length; i++)
			{
				var item:SceneChatIIFastReplyItem = new SceneChatIIFastReplyItem(FASTREPLYS[i]);
				_items.push(item);
				_list.appendItem(item);
				item.addEventListener(MouseEvent.CLICK,__itemClick,false,0,true);
			}
			this.addEventListener(MouseEvent.CLICK,__mouseClick);
			_selected = "";
		}
	}
}