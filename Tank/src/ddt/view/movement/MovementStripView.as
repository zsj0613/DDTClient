package ddt.view.movement
{
	
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import ddt.data.MovementInfo;
	import tank.game.movement.MoveMentLeftStripAsset;
	import ddt.manager.LanguageMgr;

	internal class MovementStripView extends MoveMentLeftStripAsset
	{
		
		private var _select:Boolean;
		internal function set select(value:Boolean):void
		{
			if(_select == value)
			{
				//return;
			}
			_select = value;
			update();
		}
		internal function get select():Boolean
		{
			return _select;
		}
		
		private var _info:MovementInfo;
		
		public function get info():MovementInfo
		{
			return _info;
		}
		public function set info(value:MovementInfo):void
		{
			if(value == _info)
			{
				return;
			}
			_info = value;
			update();
		}
		
		public function MovementStripView()
		{
			initView();
			addEvent();
		}
		
		private function initView():void
		{
			buttonMode = true;
			mouseChildren = false;
			gotoAndStop(1);
		}
		
		private function addEvent():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,__over);
			addEventListener(MouseEvent.MOUSE_OUT,__out);
		}
		
		private function removeEvent():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER,__over);
			removeEventListener(MouseEvent.MOUSE_OUT,__out);
		}
		
		private function update():void
		{
			if(_select)
			{
				gotoAndStop(2);
			}
			else
			{
				gotoAndStop(1);
			}
			updateTitle(_select);			
			type_mc.gotoAndStop(_info.Type + 1);
		}
		
		private var _styleText : TextField = new TextField();
		private function updateTitle(select:Boolean):void
		{
			var format:TextFormat = new TextFormat();
			if(select)
			{
				format.color = 0xFEA700;
				format.size = 14;
				
//				format.font = LanguageMgr.GetTranslation("Arial");
				format.font = LanguageMgr.GetTranslation("ddt.auctionHouse.view.BaseStripView.Font");
				//format.font = "宋体";
				format.bold = true;
			}
			else
			{
				format.color = 0xffffff;
				format.size = 14;
//				format.font = LanguageMgr.GetTranslation("Arial");
				format.font = LanguageMgr.GetTranslation("ddt.auctionHouse.view.BaseStripView.Font");
				//format.font = "宋体";
				format.bold = false;
			}
			
			title_txt.defaultTextFormat = format;
			title_txt.wordWrap = true;
			title_txt.multiline = true;
			title_txt.text = _info.Title;
			
			_styleText.defaultTextFormat = format;
			_styleText.wordWrap = false;
			_styleText.autoSize = TextFieldAutoSize.LEFT;
			_styleText.text = _info.Title;
			
			if((_styleText.textWidth+6) > title_txt.width && title_txt.numLines>1)
			{
				var text : String =  title_txt.getLineText(1);
				_styleText.text = text;
				type_mc.x = title_txt.x + _styleText.textWidth + 20;
				type_mc.y = 30;
			}
			else 
			{
				title_txt.y = 13;
				type_mc.x = title_txt.x + title_txt.textWidth + 20;
				type_mc.y = 21;
			}
//			if(title_txt.textWidth > title_txt.width)
//			{
//				type_mc.x = title_txt.x + title_txt.width + 20;
//			}
//			else
//			{
//				type_mc.x = title_txt.x + title_txt.textWidth + 20;
//			}
			
			var glow : GlowFilter = new GlowFilter(0x000000,1,2,2,10);
			title_txt.filters = [glow];
		}
		
		internal function dispose():void
		{
			removeEvent();
			_info = null;
		}		
	
		private function __over(event:MouseEvent):void
		{
			if(!_select)
			{
				gotoAndStop(2);
				updateTitle(true);
			}
		}
		
		private function __out(event:MouseEvent):void
		{
			if(!_select)
			{
				gotoAndStop(1);
				updateTitle(false);
			}
		}
		
	}
}