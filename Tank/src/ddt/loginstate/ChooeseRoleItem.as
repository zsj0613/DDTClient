package ddt.loginstate
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import road.manager.SoundManager;
	
	import tank.loading.ChooeseRoleItemAsset;
	import ddt.view.common.LevelIcon;

	public class ChooeseRoleItem extends ChooeseRoleItemAsset
	{
		private var _info:Object;
		private var _text:TextField;
		private var _textFormat:TextFormat;
		private var _lvIcon:LevelIcon;
		public function ChooeseRoleItem(info:Object)
		{
			gotoAndStop(1);
			this._info = info;
			_info.NameChange = !_info.Rename;
			_info.ConsortiaNameChanged = !_info.ConsortiaRename;
			super();
			init();
			initListener();
		}
		
		public function get info():Object
		{
			return _info;
		}
		
		private function init():void
		{
			_text = new TextField();
			_textFormat = new TextFormat(null,14,0x5f3014,true);
			_text.defaultTextFormat = _textFormat;
			_text.autoSize = TextFieldAutoSize.LEFT;
			_text.text = _info.NickName;
			_text.x = (210-_text.width)/2+88;
			_text.y = (40-_text.height)/2+10;
			_text.selectable = false;
			_text.mouseEnabled = false;
			addChild(_text);
			
			_lvIcon = new LevelIcon("big",_info.Grade,_info.Repute,_info.WinCount,_info.TotalCount,_info.FightPower);
			_lvIcon.topLayer = true;
			_lvIcon.x = 22;
			_lvIcon.y = 10;
			addChild(_lvIcon);
			buttonMode = true;
		}
		
		private function initListener():void
		{
			addEventListener(MouseEvent.CLICK,clickHandler);
			addEventListener(MouseEvent.ROLL_OUT,outHandler);
			addEventListener(MouseEvent.ROLL_OVER,overHandler);
		}
		
		private function removeListener():void
		{
			removeEventListener(MouseEvent.CLICK,clickHandler);
			removeEventListener(MouseEvent.ROLL_OUT,outHandler);
			removeEventListener(MouseEvent.ROLL_OVER,overHandler);
		}
		
		
		private function clickHandler(e:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(!_selected)
			{
				dispatchEvent(new Event(Event.SELECT));
			}
		}
		
		private function outHandler(e:MouseEvent):void
		{
			if(_selected)return; 
			gotoAndStop(1);
		}
		
		private function overHandler(e:MouseEvent):void
		{
			if(_selected)return;
			gotoAndStop(2);
		}
		
		private var _selected:Boolean = false;
		public function set selected (isSelect:Boolean):void
		{
			if(_selected == isSelect) return;
			_selected = isSelect;
			if(_selected)
			{
			 	gotoAndStop(2); 
			}else
			{
				gotoAndStop(1);
			}
		}
		
		
		public function dispose ():void
		{
			removeListener();
			
			removeChild(_lvIcon);
			_lvIcon.dispose();
			_lvIcon = null;
			
			removeChild(_text);
			_info = null;
			
		}
		
	}
}