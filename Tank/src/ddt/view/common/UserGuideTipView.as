package ddt.view.common
{
	import com.trainer.asset.QuestionOverAsset;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.aswing.KeyboardManager;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmFrame;
	
	import ddt.manager.LanguageMgr;

	public class UserGuideTipView extends HConfirmFrame
	{
		private var _tip   : QuestionOverAsset;
		public function UserGuideTipView()
		{
			super();
			init();
		}
		private function init() : void
		{
			_tip = new QuestionOverAsset();
			this.addContent(_tip);
			_tip.gotoAndStop(1);
			_tip.x = -16;
			_tip.y = -2;
			this.showCancel = false;
			this.showClose = false;
			this.moveEnable = false;
			this.titleText = LanguageMgr.GetTranslation("ddt.view.common.newAnwserTitle");
			this.okFunction = __okFunction;
			this.setContentSize(346,328);
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		public function set gotoAndStopTip(frame : int) : void
		{
			if(_tip)_tip.gotoAndStop(frame);
		}
		private function __okFunction() : void
		{
			SoundManager.instance.play("008");
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		override protected function __onKeyDownd(e:KeyboardEvent):void
		{
			KeyboardManager.getInstance().reset();
			if(e.keyCode != Keyboard.ESCAPE)return;
			e.stopImmediatePropagation();
			this.dispatchEvent(new Event(Event.CLOSE));
		}	
		override public function dispose():void
		{
			this.okFunction = null;
			if(_tip)
			{
				if(_tip.parent)_tip.parent.removeChild(_tip);
			}
			_tip = null;
			super.dispose();
			
		}
	}
}