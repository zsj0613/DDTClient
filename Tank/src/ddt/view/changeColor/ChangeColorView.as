package ddt.view.changeColor
{
	import flash.display.Sprite;
	
	import road.manager.SoundManager;
	
	import ddt.events.ChangeColorCellEvent;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.SocketManager;
	
	public class ChangeColorView extends Sprite
	{
		private var _model:ChangeColorModel;
		private var _leftView:ChangeColorLeftView;
		private var _rightView:ChangeColorRightView;
		public function ChangeColorView(place:int)
		{
			_model = new ChangeColorModel();
			_model.place = place;
			initView();
			initEvents();
		}
		
		private function initView():void
		{
			_leftView  = new ChangeColorLeftView(_model);
			addChild(_leftView);
			_rightView = new ChangeColorRightView(_model);
			addChild(_rightView);
			_rightView.x = 430;
		}
		
		private function initEvents():void
		{
			_rightView.addEventListener(ChangeColorCellEvent.CLICK,__cellClickHandler);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USE_COLOR_CARD,__useCardHandler);
		}
		
		private function removeEvents():void
		{
			_rightView.removeEventListener(ChangeColorCellEvent.CLICK,__cellClickHandler);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.USE_COLOR_CARD,__useCardHandler);
		}
		
		private function __useCardHandler(evt:CrazyTankSocketEvent):void
		{
			var state:Boolean = evt.pkg.readBoolean();
			if(state)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.im.IMController.success"));
			}else
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.changeColor.failed"));
			}
		}
		
		private function __cellClickHandler(evt:ChangeColorCellEvent):void
		{
			if(evt.data.itemInfo&&evt.data.itemInfo.NeedSex != ((_model.self.Sex==true)? 1 : 2))
			{
				SoundManager.Instance.play("008");
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.changeColor.sexAlert"));
			}else
			{
				if(evt.data!=null)
				{
					_leftView.setCurrentItem(evt.data);
				}
			}
		}
		
		public function dispose():void
		{
			_model.unlockAll();
			removeEvents();
			_leftView.dispose();
			_rightView.dispose();
			_model.clear();
			_model = null;
			if(this.parent)
			{
				parent.removeChild(this);
			}
		}

	}
}