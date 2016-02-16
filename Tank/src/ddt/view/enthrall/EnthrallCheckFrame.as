package ddt.view.enthrall
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.utils.StringHelper;
	
	import ddt.manager.LanguageMgr;
	import ddt.manager.SocketManager;
	import tank.view.enthrall.EnthrallCheckFrameAsset;

	public class EnthrallCheckFrame extends HConfirmFrame
	{
		private var _bg:EnthrallCheckFrameAsset;
		public function EnthrallCheckFrame()
		{
			super();
			init();
		}
	
		private function init():void
		{
			setSize(440,305);
			_bg = new EnthrallCheckFrameAsset();
			_bg.x = 10;
			_bg.y = 18;
			_bg.ID_txt.restrict = "0-9 x";
			_bg.ID_txt.maxChars = 18;
			_bg.invalid.visible = false;
			_bg.name_null.visible = false;
			_bg.invalid.mouseEnabled = false;
			_bg.name_null.mouseEnabled = false;
			this.addContent(_bg);
			titleText = LanguageMgr.GetTranslation("ddt.view.enthrallCheckFrame.checkTitle");
			okLabel = LanguageMgr.GetTranslation("ddt.view.enthrallCheckFrame.checkBtn");
			centerTitle = true;
			showCancel = false;
			okFunction = check;
		}
		
		override protected function __onKeyDownd(e:KeyboardEvent):void
		{
			super.__onKeyDownd(e);
			if(e.keyCode == Keyboard.ESCAPE)
			{
				clear();
			}
			e.stopImmediatePropagation();
		}
	
		private function check():void
		{
			if(_bg.name_txt.text==null||_bg.name_txt.text=="")
			{
				_bg.invalid.visible = false;
				_bg.name_null.visible = true;
			}else if(StringHelper.cidCheck(_bg.ID_txt.text))
			{
				SocketManager.Instance.out.sendCIDInfo(_bg.name_txt.text,_bg.ID_txt.text);
				clear();
			}else
			{
				_bg.name_null.visible = false;
			    _bg.invalid.visible = true;
			}
		}
				
		
		private function clear():void
		{
			_bg.ID_txt.text = "";
			_bg.name_txt.text = "";
			_bg.name_null.visible = false;
			_bg.invalid.visible   = false;
		}
		
		override protected function __closeClick(e:MouseEvent):void
		{
			close();
			clear();
			SoundManager.Instance.play("008");
//			SocketManager.Instance.out.sendCIDInfo(true);
		}
	}
}