package ddt.room
{
	import road.ui.controls.hframe.HConfirmFrame;
	
	import game.crazyTank.view.roomII.BoGuTiShiView;
	
	public class RoomDupSimpleTipFram extends HConfirmFrame
	{
		private var _view:BoGuTiShiView;
		
		public function RoomDupSimpleTipFram()
		{
			super();
			
			_view = new BoGuTiShiView();
			setSize(_view.width+40,_view.height+90);
			addContent(_view);
			showCancel = false;
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_view) _view = null;
			if(this.parent)this.parent.removeChild(this);
		}
	}
}