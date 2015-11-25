package road.ui.manager
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import road.ui.controls.hframe.HFrame;
	
	public class TipManager
	{
		private static var tipLayer:DisplayObjectContainer;
		
		private static var _currentTarget:DisplayObject;
		private static var _currentTip:DisplayObject;
		private static var _layerNoAutoClear:DisplayObjectContainer;
		
		private static var _stagewidth:int;
		private static var _stageheight:int;
		
		private static var _stageLayer:DisplayObjectContainer;
		public static function setup(root:Sprite,stageLayer:DisplayObjectContainer,stagewidth:int = 1000,stageheight:int = 600):void
		{
			_stageLayer = stageLayer;
			_stageheight = stageheight;
			_stagewidth = stagewidth;
			tipLayer = new Sprite();
			_layerNoAutoClear = new Sprite();
			_layerNoAutoClear.mouseEnabled = false;
			root.addChild(_layerNoAutoClear);
			root.addChild(tipLayer);
		}
		
		public static function addToStageLayer(target:DisplayObject,center:Boolean = false):void
		{
			if(center)
			{
				target.x = (_stagewidth - target.width) / 2;
				target.y = (_stageheight - target.height) /2;
			}
			_stageLayer.addChild(target);
		}
		
		public static function setCurrentTarget(target:DisplayObject,tip:DisplayObject,offsetX:int = 0,offsetY:int = 0):void
		{
			if(_currentTarget == target) return;
			if(_currentTip)
			{
				RemoveTippanel(_currentTip);
			}
			
			_currentTarget = target;
			_currentTip = tip;
			
			if(_currentTarget && tip)
			{
				if(tip is Sprite)
				{
					Sprite(tip).mouseChildren = false;
					Sprite(tip).mouseEnabled = false;
				}
				var pos:Point = _currentTarget.localToGlobal(new Point(0,0));
				var rect:Rectangle = new Rectangle(pos.x,pos.y,_currentTarget.width,_currentTarget.height);
				var h:Number = _currentTip.height;
				var w:Number = _currentTip.width;
				if(rect.right + w < _stagewidth)
				{
					_currentTip.x = rect.right + offsetX;
				}
				else
				{
					_currentTip.x = rect.left - w - offsetX;
				}
				if(rect.bottom + h < _stageheight)
				{
					_currentTip.y = rect.bottom + offsetY;
				}
				else
				{
					_currentTip.y = rect.top - h - offsetY;
					_currentTip.y = _currentTip.y < 20 ? 20 :_currentTip.y;
				}
				AddTippanel(_currentTip);
			}
		}
		
		public static function clearNoclearLayer():void
		{
			while(_layerNoAutoClear.numChildren)
			{
				_layerNoAutoClear.removeChildAt(0);
			}
		}
		
		public static function clearTipLayer():void
		{
			while(tipLayer.numChildren > 0)
			{
				tipLayer.removeChildAt(0);
			}
		}

		public static function AddTippanel(tip:DisplayObject,center:Boolean = false,shouldBuffering:Boolean = false):void
		{
			if(shouldBuffering && BufferManager.Instance.isBuffering && tip is HFrame)
			{
				BufferManager.Instance.pushToBuffer(tip as HFrame);
				return;
			}
			if(tip == null) return;
			if(center)
			{
				tip.x = (_stagewidth - tip.width) / 2;
				tip.y = (_stageheight - tip.height) /2;
			}
			if(tip.parent == tipLayer)
			{
				tipLayer.setChildIndex(tip,tipLayer.numChildren -1);
			}
			else
			{
				tipLayer.addChild(tip);
			}
			
		}
		
		public static function RemoveTippanel(tip:DisplayObject):void
		{
			if(tip.parent == tipLayer)
			{
				tipLayer.removeChild(tip);
			}
		}
		
		public static function AddToLayerNoClear(layer:DisplayObject,center:Boolean = false):void
		{
			if(layer == null) return;
			if(center)
			{
				layer.x = (_stagewidth - layer.width) / 2;
				layer.y = (_stageheight - layer.height) /2;
			}
			
			if(layer.parent == _layerNoAutoClear)
			{
				_layerNoAutoClear.setChildIndex(layer,_layerNoAutoClear.numChildren -1);
			}
			else
			{
				_layerNoAutoClear.addChild(layer);
			}
			
		}
		
		public static function RemoveLayerFromNoClear(layer:DisplayObject):void
		{
			if(layer.parent == _layerNoAutoClear)
			{
				_layerNoAutoClear.removeChild(layer);
			}
		}
	}
}