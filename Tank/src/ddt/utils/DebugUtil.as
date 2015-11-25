package ddt.utils
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	//import road.model.ModelManager;
	
	public final class DebugUtil
	{
		private static var _debugText:TextField;
		private static var _debugTextContainer:Sprite;
		public static function debugText(msg:String):void
		{
			if(_debugText == null) 
			{
				_debugText = new TextField();
				_debugTextContainer = new Sprite();
				_debugTextContainer.addChild(_debugText);
				_debugText.contextMenu = creatRightMenu();
			}
			_debugText.autoSize = "left";
			_debugText.width = 300;
			_debugText.multiline = true;
			_debugText.wordWrap = true;
			_debugText.appendText(msg+"\n");
			if(_debugText.height <= 600)
			{
				_debugText.y = 0;
			}else
			{
				_debugText.y = 600 - _debugText.height;
			}
			_debugTextContainer.graphics.clear();
			_debugTextContainer.graphics.beginFill(0x00ff00,1);
			_debugTextContainer.graphics.drawRect(0,0,_debugText.width,600);
			_debugTextContainer.graphics.endFill();
		}
		
		private static function creatRightMenu():ContextMenu
		{
			var myContextMenu:ContextMenu = new ContextMenu();
            myContextMenu.hideBuiltInItems();
			var item:ContextMenuItem = new ContextMenuItem("清除");
			item.separatorBefore = true;
            myContextMenu.customItems.push(item);
            item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,clearnClick);
            return myContextMenu;
		}
		
		private static function clearnClick(event:Event):void
		{
			_debugText.text = "";
		}
		
		public static function showDebugText(stage:Stage):void
		{
			clearnClick(null);
			debugText("===========stageSetup==============");
			_debugTextContainer.x = 1000;
			stage.addChild(_debugTextContainer);
//			TipManager.AddTippanel(_debugTextContainer,false);
		}
		
		//public static function debugLoginText(msg:String):void
		//{
		//	var registerState:Object = ClassUtils.getDefinition("ddt.register.RegisterState");
		//	registerState.debugText(msg);
		//}
	}
	
	
}