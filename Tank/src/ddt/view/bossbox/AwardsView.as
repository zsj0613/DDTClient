package ddt.view.bossbox
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.controls.hframe.HFrame;
	
	import tank.game.movement.AwardsViewAsset;

	public class AwardsView extends HFrame
	{
		private var _list:AwardsGoodsList;
		private var _goodsList:Array;
		private var _view:AwardsViewAsset;
		private var _getBoxButton:HBaseButton;
		private var _boxType:int;
		
		public function AwardsView(boxType:int, templateIds:Array)
		{
			super();
			_goodsList = new Array();
			_view = new AwardsViewAsset();
			if(templateIds != null)
				_goodsList = templateIds;
			_boxType = boxType;
			init();
			initEvents();
		}
		
		private function init():void
		{
			setSize(_view.width+32,_view.height+20);
			addContent(_view, true);
			showClose = false;
			showBottom = false;
			moveEnable=false;
			
			if(_boxType == 0)
			{
				_view._tipTimeText.visible = true;
				_view._tipGradeText.visible = false;
			}
			else
			{
				_view._tipTimeText.visible = false;
				_view._tipGradeText.visible = true;
			}
			
			_list = new AwardsGoodsList(_goodsList);
			_list.x = _view._listPos.x;
			_list.y = _view._listPos.y;
			_view.addChild(_list);
			
			_getBoxButton = new HBaseButton(_view._getBoxButton);
			_view.addChild(_getBoxButton);
		}
		
		private function initEvents():void
		{
			_getBoxButton.addEventListener(MouseEvent.CLICK,_haveBtnClick);
		}
		
		public static const HAVEBTNCLICK:String = "_haveBtnClick";
		
		private function _haveBtnClick(e:MouseEvent):void
		{
			SoundManager.instance.play("008");
			dispatchEvent(new Event(AwardsView.HAVEBTNCLICK));
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(_list)
			{
				_list.dispose();
				_list = null;
			}
			
			if(_view) _view = null;
			
			if(this.parent)
				this.parent.removeChild(this);
		}
	}
}






















