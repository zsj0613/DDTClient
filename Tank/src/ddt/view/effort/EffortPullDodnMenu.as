package ddt.view.effort
{
	import crazytank.view.effort.EffortPullDownMenuAsset;
	
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	
	import ddt.manager.EffortManager;
	import ddt.manager.LanguageMgr;

	public class EffortPullDodnMenu extends EffortPullDownMenuAsset
	{
		private var _upBtn:HBaseButton;
		private const FULL:String  = LanguageMgr.GetTranslation("ddt.view.effort.EffortPullDodnMenu.FULL");
		private const ACQUIRE:String = LanguageMgr.GetTranslation("ddt.view.effort.EffortPullDodnMenu.ACQUIRE");
		private const INCOMPLETE:String = LanguageMgr.GetTranslation("ddt.view.effort.EffortPullDodnMenu.INCOMPLETE");
		private var _controller:EffortController;
		public function EffortPullDodnMenu(controller:EffortController)
		{
			_controller = controller;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			_upBtn = new HBaseButton(this.up_mc);
			addChild(_upBtn);
			mask_mc.buttonMode = true;
			this.option_1.buttonMode = true;
			this.option_2.buttonMode = true;
			this.option_3.buttonMode = true;
			current_txt.text = FULL;
			EffortManager.Instance.setEffortType(0);
			switchVisible();
			currentType();
		}
		
		private function initEvent():void
		{
			_upBtn.addEventListener(MouseEvent.CLICK   , __upBtnClick);
			mask_mc.addEventListener(MouseEvent.CLICK  , __upBtnClick);
			option_1.addEventListener(MouseEvent.CLICK , __optionClick);
			option_2.addEventListener(MouseEvent.CLICK , __optionClick);
			option_3.addEventListener(MouseEvent.CLICK , __optionClick);
			option_1.addEventListener(MouseEvent.MOUSE_OVER , __optionOver);
			option_2.addEventListener(MouseEvent.MOUSE_OVER , __optionOver);
			option_3.addEventListener(MouseEvent.MOUSE_OVER , __optionOver);
			option_1.addEventListener(MouseEvent.MOUSE_OUT , __optionOut);
			option_2.addEventListener(MouseEvent.MOUSE_OUT , __optionOut);
			option_3.addEventListener(MouseEvent.MOUSE_OUT , __optionOut);
		}
		
		private function __upBtnClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			switchVisible();
			currentType();
		}
		
		private function __optionClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			switch(evt.currentTarget.name)
			{
				case"option_1":
					current_txt.text = FULL;
					_controller.currentViewType = 0;
					break;
				case"option_2":
					current_txt.text = ACQUIRE;
					_controller.currentViewType = 1;
					break;
				case"option_3":
					current_txt.text = INCOMPLETE;
					_controller.currentViewType = 2;
					break;
			}
			switchVisible();
			currentType();
		}
		
		private function __optionOver(evt:MouseEvent):void
		{
			switch(evt.currentTarget.name)
			{
				case"option_1":
					option_1.gotoAndStop(2);
					break;
				case"option_2":
					option_2.gotoAndStop(2);
					break;
				case"option_3":
					option_3.gotoAndStop(2);
					break;
			}
		}
		
		private function __optionOut(evt:MouseEvent):void
		{
			switch(evt.currentTarget.name)
			{
				case"option_1":
					option_1.gotoAndStop(1);
					break;
				case"option_2":
					option_2.gotoAndStop(1);
					break;
				case"option_3":
					option_3.gotoAndStop(1);
					break;
			}
		}
		
		private function _stageClick(evt:MouseEvent):void
		{
			if(evt.target.name == "up_mc" || evt.target.name == "mask_mc")return;
			menubg_mc.visible = option_1.visible = option_2.visible = option_3.visible =   false;
			if(stage)stage.removeEventListener(MouseEvent.CLICK , _stageClick);
		}
		
		private function currentType():void
		{
			switch(_controller.currentViewType)
			{
				case 0:
					option_1.gotoAndStop(2);
					option_2.gotoAndStop(1);
					option_3.gotoAndStop(1);
					break;
				case 1:
					option_1.gotoAndStop(1);
					option_2.gotoAndStop(2);
					option_3.gotoAndStop(1);
					break;
				case 2:
					option_1.gotoAndStop(1);
					option_2.gotoAndStop(1);
					option_3.gotoAndStop(2);
					break;
			}
		}
		
		private function switchVisible():void
		{
			if(menubg_mc.visible)
			{
				menubg_mc.visible = option_1.visible = option_2.visible = option_3.visible =   false;
				if(stage)stage.removeEventListener(MouseEvent.CLICK , _stageClick);
			}else
			{
				menubg_mc.visible = option_1.visible = option_2.visible = option_3.visible =   true;
				if(stage)stage.addEventListener(MouseEvent.CLICK , _stageClick);
			}
		}
		
		public function dispose():void
		{
			if(_upBtn)
			{
				_upBtn.removeEventListener(MouseEvent.CLICK , __upBtnClick);
				_upBtn.parent.removeChild(_upBtn);
				_upBtn.dispose();
			}
			_upBtn = null
			mask_mc.removeEventListener(MouseEvent.CLICK  , __upBtnClick);
			option_1.removeEventListener(MouseEvent.CLICK , __optionClick);
			option_2.removeEventListener(MouseEvent.CLICK , __optionClick);
			option_3.removeEventListener(MouseEvent.CLICK , __optionClick);
			option_1.removeEventListener(MouseEvent.MOUSE_OVER , __optionOver);
			option_2.removeEventListener(MouseEvent.MOUSE_OVER , __optionOver);
			option_3.removeEventListener(MouseEvent.MOUSE_OVER , __optionOver);
			option_1.removeEventListener(MouseEvent.MOUSE_OUT , __optionOut);
			option_2.removeEventListener(MouseEvent.MOUSE_OUT , __optionOut);
			option_3.removeEventListener(MouseEvent.MOUSE_OUT , __optionOut);
			if(stage)stage.removeEventListener(MouseEvent.CLICK , _stageClick);
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
	}
}