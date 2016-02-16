package ddt.view.movement
{
	import flash.events.Event;
	
	import road.manager.SoundManager;
	import road.ui.controls.FrameEvent;
	import road.ui.controls.hframe.HConfirmFrame;
	
	import tank.game.movement.MoveMentLeftAsset;
	import ddt.manager.LanguageMgr;

	public class MovementLeftView extends HConfirmFrame
	{
		private var _asset:MoveMentLeftAsset;
		
		
		private var _list:LeftListView;
		
		private var _right:MovementRightView;
		
		private var _model:MovementModel;
		public function get model():MovementModel
		{
			return _model;
		}
		
		private static var instance:MovementLeftView;
		
		public function MovementLeftView()
		{
			initView();
			addEvent();
		}
		
		public function setup():void
		{
			if(MovementModel.Instance.actives)
			{
				setActives();
			}
			else
			{
				_model.getActiveInfo();
			}
		}
		
		private function initView():void
		{
			_model = new MovementModel();
			_model = MovementModel.Instance;
//			_model.getActiveInfo();
//			MovementModel.checkNewMovement(); //bret 09.8.20
			this.titleText = LanguageMgr.GetTranslation("ddt.view.movement.MovementLeftView.action");
//			this.titleText = "活动";
			blackGound = false;
			alphaGound = false;
			fireEvent = false;
			setContentSize(280,391);

			_asset = new MoveMentLeftAsset();
			this.addContent(_asset);
			
			this.showCancel = false;
//			okBtn.visible = false;
			okLabel = LanguageMgr.GetTranslation("close");
			//okLabel = "关 闭";
			this.okFunction = close;
//			_close = new Button();
//			
//			_close.label = LanguageMgr.GetTranslation("ddt.invite.InviteView.close");
//			//_close.label = "关闭";
//			ComponentHelper.replaceChild(_asset,_asset.closePos_mc,_close);
//			_asset.closePos_mc.visible = false;
			_list = new LeftListView(100,50);
			_list.move(_asset.listPos_mc.x,_asset.listPos_mc.y);
//			_list.verticalScrollPolicy = "on";
			_list.verticalScrollPolicy = "on";
			_list.setSize(288,360);
			_asset.listPos_mc.visible = false;
			_asset.addChild(_list);
			
			_right = new MovementRightView();
			addEventListener(FrameEvent.STOP_DRAG,__stopDrag);
			
		}
		
		private function addEvent():void
		{
//			_close.addEventListener(MouseEvent.CLICK,__close);
//			MovementModel.Instance.addEventListener(Event.COMPLETE,__compelte);
			MovementModel.Instance.addEventListener(Event.CHANGE,__change);
		}
		
		private function removeEvent():void
		{
//			_close.removeEventListener(MouseEvent.CLICK,__close);
//			MovementModel.Instance.removeEventListener(Event.COMPLETE,__compelte);
			MovementModel.Instance.removeEventListener(Event.CHANGE,__change);
		}
		
		private function __stopDrag(event:Event):void
		{
			if(_right.parent)
			{
				_right.info = _model.currentInfo;
			}
		}
				
		public static function get Instance():MovementLeftView
		{
			if(instance == null)
			{
				instance = new MovementLeftView();
			}
			return instance;
		}
		

		public function open():void
		{
//			if(parent == null)
//			{
//				UIManager.AddDialog(this);
//				x = 212;
//				y = 90;
//			}
            if(parent)
			{
				hide();
			}	
			else
			{
				show();
			}
		}
		override public function show():void
		{
			super.show();
			addEvent();
			x = 212;
			y = 90;
		}
		override public function hide():void
		{
//			if(this.parent)
//			{
//				UIManager.RemoveDialog(this);
//			}
//			dispose();
//			instance = null;
            super.hide();
            removeEvent();
            if(this.parent)this.parent.removeChild(this);
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			
			if(_list.parent)
			{
				_asset.removeChild(_list);
			}
			_list.dispose();
			_list = null;
			
			if(_asset.parent)
			{
				_asset.parent.removeChild(_asset);
			}
			_asset = null;
			
			if(_right.parent)
			{
				_right.hide();
			}
			if(_right)_right.dispose();
			_right = null;
			
			_model = null;

		}
		
		override public function close():void
		{
			SoundManager.Instance.play("008");
			super.close();
			removeEvent();
			_right.close();
			
		}
		
//		private function __compelte(event:Event):void
//		{
////			setActives();
//			if(MovementModel.Instance.actives.length > 0)
//			{
////				_model.currentInfo = _model.actives[0];
//			}
//		}
		public function setActives():void
		{
			_list.actives = MovementModel.Instance.actives;
		}
		
		private function __change(event:Event):void
		{
			_right.info = MovementModel.Instance.currentInfo;
		}
		
//		protected function doClosing():void
//		{
//			SoundManager.instance.play("008");
//			this.close();
//			hide();
//		}
		
	}
}