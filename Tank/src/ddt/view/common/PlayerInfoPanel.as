package ddt.view.common
{
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HFrame;
	
	import ddt.data.player.PlayerInfo;
	import ddt.view.personalinfoII.IPersonalInfoIIController;
	import ddt.view.personalinfoII.PersonalInfoIIController;

	public class PlayerInfoPanel extends HFrame
	{
		private var _info:PlayerInfo;
		private var _personal:IPersonalInfoIIController;
		private var _readFromDB:Boolean;
	
		public function PlayerInfoPanel()
		{
			super();
			showBottom = false;
			blackGound = false;
			alphaGound = false;
			fireEvent = false;
			setContentSize(421,440);
	
			addEventListener(KeyboardEvent.KEY_DOWN,__onKeyDown);
		}
		
		private function __onKeyDown(e:KeyboardEvent):void
		{
			e.stopImmediatePropagation();
			if(e.keyCode == Keyboard.ESCAPE)
			{
				SoundManager.Instance.play("008");
				close();
			}
		}
		
		override public function close():void
		{
			if(stage) stage.focus = null;
			super.close();
		}

	
		override public function dispose():void
		{
			super.dispose();
			removeEventListener(KeyboardEvent.KEY_DOWN,__onKeyDown);
			if(_personal)
			{
				_personal.dispose();
				_personal = null;
			}
			_info = null;
			if(parent)parent.removeChild(this);
		}
		
		public function set info(value:PlayerInfo):void
		{
			_info = value;
			if(_info == null)return;
			_personal = new PersonalInfoIIController(_info,false,_readFromDB);
			_personal.setEnabled(false);
			var infoView:DisplayObject = _personal.getView();
			infoView.x = -6;
			addContent(infoView);
		}
		
		public function get info():PlayerInfo
		{
			return _info;
		}
	}
}