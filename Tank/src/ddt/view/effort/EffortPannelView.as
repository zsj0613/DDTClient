package ddt.view.effort
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ddt.manager.EffortManager;
	import ddt.manager.SocketManager;
	import tank.view.effort.MainFrameAsset;
	
	public class EffortPannelView extends MainFrameAsset
	{
		private var effortLeftView:EffortLeftView
		private var effoetRigthView:EffortRightView;
		private var _effoetFullView:EffortFullView;
		private var _controller:EffortController;
		public function EffortPannelView(controller:EffortController)
		{
			_controller = controller;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			effortLeftView = new EffortLeftView(_controller);
			effortLeftView.x = pos1.x
			effortLeftView.y = pos1.y
			addChild(effortLeftView);
			_effoetFullView = new EffortFullView(_controller);
			_effoetFullView.x = pos2.x
			_effoetFullView.y = pos2.y - 4;
			addChild(_effoetFullView);
		}

		private function initEvent():void
		{
			_controller.addEventListener(Event.CHANGE , __rightChange);
		}
		
		private function __rightChange(evt:Event):void
		{
			if(_controller.currentRightViewType == 0)
			{
				if(effoetRigthView)
				{
					removeChild(effoetRigthView);
					effoetRigthView.dispose();
					effoetRigthView = null;
				}
				if(!_effoetFullView)
				{
					_effoetFullView = new EffortFullView(_controller);
					_effoetFullView.x = pos2.x;
					_effoetFullView.y = pos2.y - 4;
					addChild(_effoetFullView);
				}
			}else
			{
				if(_effoetFullView)
				{
					removeChild(_effoetFullView);
					_effoetFullView.dispose();
				}
				_effoetFullView = null;
				if(!effoetRigthView)
				{
					effoetRigthView = new EffortRightView(_controller);
					effoetRigthView.x = pos2.x;
					effoetRigthView.y = pos2.y;
					addChild(effoetRigthView);
				}
			}
		}
		
		public function dispose():void
		{
			if(effoetRigthView)
			{
				removeChild(effoetRigthView);
				effoetRigthView.dispose();
				effoetRigthView = null;
			}
			if(effortLeftView)
			{
				effortLeftView.removeEventListener(Event.CHANGE , __rightChange);
				removeChild(effortLeftView);
				effortLeftView.dispose();
				effortLeftView = null
			}
			
			if(_effoetFullView)
			{
				removeChild(_effoetFullView);
				_effoetFullView.dispose();
				_effoetFullView = null;
			}
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
			_controller.removeEventListener(Event.CHANGE , __rightChange);
		}
	}
}