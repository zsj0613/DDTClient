package ddt.civil.view
{
	import ddt.civil.CivilDataEvent;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import road.manager.SoundManager;
	import road.utils.ComponentHelper;
	
	import tank.civil.playerItemAesse;
	import ddt.data.player.CivilPlayerInfo;
	import ddt.view.common.LevelIcon;

	public class CivilPlayerItemFrame extends playerItemAesse
	{
		private var _info:CivilPlayerInfo;
		private var _level:int = 1;
		
		private var _levelIcon:LevelIcon;
		private var _isSelect : Boolean;
		
		public function CivilPlayerItemFrame()
		{
			super();
			init();
		}
		private function init():void
		{
			setTextField(name_txt);
//			setTextField(online_txt);
			
			_levelIcon = new LevelIcon("s",1,0,0,0,0);
			_levelIcon.level = _level;
			ComponentHelper.replaceChild(this,levelPos,_levelIcon);
			levelPos.visible = false;
			
			
			this.buttonMode = true;
			selectEffect.visible = false;
		}
		
		public function set info(info:CivilPlayerInfo):void
		{
			_info = info;
			upView();
			addEvent();
		}
		public function get info():CivilPlayerInfo
		{
			return _info;
		}
		
		private function addEvent():void
		{
			addEventListener(MouseEvent.CLICK,__clickHandle);
			addEventListener(MouseEvent.MOUSE_OVER,__overHandle);
			addEventListener(MouseEvent.MOUSE_OUT,__outHandle);
		}
		private function removeEvent():void
		{
			removeEventListener(MouseEvent.CLICK,__clickHandle);
			removeEventListener(MouseEvent.MOUSE_OVER,__overHandle);
			removeEventListener(MouseEvent.MOUSE_OUT,__outHandle);
		}
		private function __clickHandle(e:MouseEvent):void
		{
			SoundManager.instance.play("008");
			dispatchEvent(new CivilDataEvent(CivilDataEvent.SELECT_CLICK_ITEM,this));
		}
		private function __overHandle(e:MouseEvent):void
		{
			if(!_isSelect)selectEffect.visible = true;
		}
		private function __outHandle(e:MouseEvent):void
		{
			selectEffect.visible = _isSelect;
		}
		
		private function setTextField(txt:TextField) : void
		{
			txt.selectable = false;
			txt.mouseEnabled = false;
			txt.text = "";
		}
		
		public function isSelect(b:Boolean):void
		{
			selectEffect.visible = _isSelect = b;
		}
		
		
		private function upView():void
		{
			name_txt.text = _info.info.NickName;
			_levelIcon.level = _level = _info.info.Grade;
			_levelIcon.setRepute(_info.info.Repute);
			_levelIcon.setRate(_info.info.WinCount,_info.info.TotalCount);
			_levelIcon.Battle = _info.info.FightPower;
			if(_info.info.Sex)
			{
				state_mc.gotoAndStop(_info.info.State ? 1 : 3);
			}
			else
			{
				state_mc.gotoAndStop(_info.info.State ? 2 : 3);
			}
		}
		
		public function dispose():void
		{
			_info = null;
			if(_levelIcon)
			{
				_levelIcon.dispose();
				_levelIcon = null;
			}
			removeEvent();
			if(parent)parent.removeChild(this);
		}
	}
}