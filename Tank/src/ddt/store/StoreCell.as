package ddt.store
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.crazyTank.view.storeII.cellShine;
	
	import road.manager.SoundManager;
	
	import ddt.data.player.BagInfo;
	import ddt.manager.SocketManager;
	import ddt.view.bagII.BagIIEquipListView;
	import ddt.view.cells.BagCell;
	import ddt.view.common.ShineObject;
	
	/**
	 * @author wicki LA
	 * @time 11/26/2009
	 * @description 铁匠铺操作用的通用的格子
	 * */

	public class StoreCell extends BagCell
	{
		protected var _shiner:ShineObject;
		protected var _index:int;
		private var _timer:Timer = new Timer(BagIIEquipListView.DoubleClickSpeed,1);
		public var DoubleClickEnabled:Boolean = true;
		
		public function StoreCell(bg:Sprite,$index:int)
		{
			super(0,null,false,bg);
			_index = $index;
			_shiner = new ShineObject(new cellShine());
			addChild(_shiner);
			_shiner.mouseChildren = _shiner.mouseEnabled = false;
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,__timer);
			addEventListener(MouseEvent.MOUSE_DOWN,__onMouseDown);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,__timer);
			removeEventListener(MouseEvent.MOUSE_DOWN,__onMouseDown);
		}
		
		protected function __onMouseDown(evt:MouseEvent):void
		{
			if(!DoubleClickEnabled)return;
			if(info == null) return;
			if((evt.currentTarget as BagCell).info!=null){
			    if(_timer.running)
		    	{
			    	if((evt.currentTarget as BagCell).info != null)
				    {
				    	_timer.stop();
						SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,index,itemBagType,-1);
				    	if(!mouseSilenced)SoundManager.Instance.play("008");
				    }
			    }
		    	else
		    	{
			    	_timer.reset();
				    _timer.start();
			    }
			}
		}
		
		private function __timer(evt:TimerEvent):void
		{
			if(_info && !locked && stage && allowDrag)
			{
				SoundManager.Instance.play("008");
			}
			dragStart();
		}
		
		private function get itemBagType():int
		{
			if(info && (info.CategoryID == 10 || info.CategoryID == 11 || info.CategoryID == 12)) return BagInfo.PROPBAG;
			else return BagInfo.EQUIPBAG;
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function startShine():void
		{
			_shiner.shine();
		}
		
		public function stopShine():void
		{
			_shiner.stopShine();
		}
		
		override public function dispose():void
		{
			_shiner.dispose();
			super.dispose();
		}
		
	}
}