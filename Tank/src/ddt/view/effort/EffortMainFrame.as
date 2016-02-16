package ddt.view.effort
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HFrame;
	import road.ui.manager.UIManager;
	
	import ddt.manager.EffortManager;
	import ddt.manager.PlayerManager;

	public class EffortMainFrame extends HFrame
	{
		private var _asset:EffortPannelView;
		private var _pullDownMenu:EffortPullDodnMenu;
		private var _controller:EffortController;
		private var _effortTaskView:EffortTaskView;
		public function EffortMainFrame()
		{
			super();
//			switchVisible();
		}
		
		private function init():void
		{
			blackGound = false;
			alphaGound = false;
			mouseEnabled = false;
			showBottom = false;
			fireEvent = false;
			moveEnable = false;
			IsSetFouse = true;
			
			setSize(860,570);
			EffortManager.Instance.currentEffortList = EffortManager.Instance.getIntegrationEffort();
			_controller = new EffortController();
			_controller.isSelf = EffortManager.Instance.isSelf;
			_asset = new EffortPannelView(_controller);
			this.addContent(_asset,false);
			_asset.x = 6;
			_asset.y = 34;
			if(EffortManager.Instance.isSelf)
			{
				_asset.achievementPoint_txt.text = String(PlayerManager.Instance.Self.AchievementPoint);
			}else
			{
				_asset.achievementPoint_txt.text = String(EffortManager.Instance.getTempAchievementPoint());
			}
			_pullDownMenu = new EffortPullDodnMenu(_controller);
			_pullDownMenu.x = 605;
			_pullDownMenu.y = 38;
			_pullDownMenu.visible = false;
			addChild(_pullDownMenu);
			if(EffortManager.Instance.isSelf)
			{
				_effortTaskView = new EffortTaskView();
				_effortTaskView.x = _asset.effortTaskView_pos.x;
				_effortTaskView.y = _asset.effortTaskView_pos.y;
				addChild(_effortTaskView);
			}
			initEvent();
		}
		
		private function initEvent():void
		{
			_controller.addEventListener(Event.CHANGE , __rightChange);
		}
		
		private function __addStage(evt:Event):void
		{
			if(this.stage)
			{
				this.stage.focus = this;
			}
		}
		
		private function __rightChange(evt:Event):void
		{
			if(_controller.currentRightViewType == 0)
			{
				if(_pullDownMenu)_pullDownMenu.visible = false;
			}else
			{
				if(_pullDownMenu)_pullDownMenu.visible = true;
			}
		}
		
		private function playMovie():void
		{
			
		}
		
		private function __onKeyDownHandler(evt : KeyboardEvent) : void
		{
			if(evt.keyCode == Keyboard.ESCAPE && visible)
			{
				evt.stopImmediatePropagation();
				close();
			}
		}
		
		public function switchVisible(isSelf:Boolean = true) : void
		{
			if(this.parent){
				SoundManager.Instance.play("008");
				close();
				if(parent)parent.removeEventListener(KeyboardEvent.KEY_DOWN,   __onKeyDownHandler);
				removeEventListener(MouseEvent.CLICK     , __addStage);
			}else{
				if(!_asset){
					init();
				}
				UIManager.AddDialog(this,true);
				if(parent)parent.addEventListener(KeyboardEvent.KEY_DOWN,   __onKeyDownHandler);
				this.stage.focus = this;
				addEventListener(MouseEvent.CLICK     , __addStage);
			}
		}
				
		private static var instance : EffortMainFrame;
		public static function get Instance():EffortMainFrame
		{
			if(instance == null)
			{
				instance = new EffortMainFrame();
			}
			return instance;
		}
		
		override public function close():void
		{
			if(this.parent){
				SoundManager.Instance.play("008");
				if(_pullDownMenu && _pullDownMenu.parent)
				{
					_pullDownMenu.parent.removeChild(_pullDownMenu)
					_pullDownMenu.dispose();
					_pullDownMenu = null;
				}
				if(_effortTaskView && _effortTaskView.parent)
				{
					_effortTaskView.parent.removeChild(_effortTaskView)
					_effortTaskView.dispose();
					_effortTaskView = null;
				}
				if(_asset && _asset.parent)
				{
					_asset.parent.removeChild(_asset);
					_asset.dispose();
					_asset = null;
				}
				if(this.parent)
				{
					this.parent.removeChild(this);
				}
				UIManager.RemoveDialog(this);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			_controller.removeEventListener(Event.CHANGE , __rightChange);
			if(parent)parent.removeEventListener(KeyboardEvent.KEY_DOWN,   __onKeyDownHandler);
			removeEventListener(MouseEvent.CLICK     , __addStage);
		}
	}
}