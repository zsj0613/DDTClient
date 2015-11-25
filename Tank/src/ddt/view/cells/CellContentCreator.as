package ddt.view.cells
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.view.characterII.BaseLayer;
	import ddt.view.characterII.IColorEditable;
	import ddt.view.characterII.ILayer;
	import ddt.view.characterII.ILayerFactory;
	import ddt.view.characterII.LayerFactory;
	import ddt.view.items.PropItemView;

	public class CellContentCreator implements IColorEditable
	{
		private var _factory:ILayerFactory;
		private var _loader:ILayer;
		private var _loaderContent:Sprite;
		private var _callBack:Function;
		private var _timer:Timer;
		private var _info:ItemTemplateInfo;
		
		public function CellContentCreator()
		{
			_factory = LayerFactory.instance;
		}
		
		public function createContent(info:ItemTemplateInfo,callBack:Function):Sprite
		{
			if(info == null)return new Sprite();
			_info = info;
			_callBack = callBack;
			_loaderContent = new Sprite();
			if(info.CategoryID == EquipType.FRIGHTPROP)
			{
				_timer = new Timer(50,1);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
				_timer.start();
			}
			else
			{
				if(info is InventoryItemInfo)
				{
					var color:String = InventoryItemInfo(info).Color == null ? "" : InventoryItemInfo(info).Color;
					_loader = _factory.createLayer(info,color,BaseLayer.ICON);
				}
				else _loader = _factory.createLayer(info,"",BaseLayer.ICON);
				_loader.load(loadComplete);
			}
			return _loaderContent;
		}
		
		public function clearLoader():void
		{
			if(_loader != null)
			{
				_loader.dispose();
				_loader = null;
			}
		}
		
		private function __timerComplete(evt:TimerEvent):void
		{
			if(_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
				_timer.stop();
			}
			if(_loaderContent)_loaderContent.addChild(PropItemView.createView(_info.Pic) as Bitmap);
			_callBack();
		}
		
		private function loadComplete(layer:ILayer):void
		{
			_loaderContent.addChild(layer.getContent());
			_callBack();
		}
		
		public function setColor(color:*):Boolean
		{
			if(_loader != null)
			{
				return _loader.setColor(color);
			}
			return false;
		}
		
		public function get editLayer():int
		{
			if(_loader == null)return 1;
			return _loader.currentEdit;
		}
		
		public function dispose():void
		{
			if(_loader != null)_loader.dispose();
			_loader = null;
			if(_timer != null)
			{
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
				_timer.stop();
				_timer = null;
			}
			_callBack = null;
		}
	}
}