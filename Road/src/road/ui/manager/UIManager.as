package road.ui.manager
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import road.ui.controls.IResizeable;
	import road.ui.controls.hframe.HFrame;
	import road.ui.events.UIMouseEvent;
	
	
	public class UIManager
	{
		private static var dialogLayer:SpriteLayer = new SpriteLayer();
		private static var _width:Number;
		private static var _height:Number;
		private static var _enableRightClick:Boolean;
		private static var _resizeAble:Boolean;
		
		public static function setup(root:Sprite,width:Number = 1000,height:Number = 600,resizeable:Boolean = false):void
		{
			dialogLayer.addEventListener(Event.ADDED_TO_STAGE,__addToStage);
			root.addChild(dialogLayer);
			_resizeAble = resizeable;
			_width = width;
			_height = height;
		}
		
		public static function get stageCenterX():Number
		{
			return _width / 2;
		}
		
		public static function get stageCenterY():Number
		{
			return _height / 2;
		}
		
		public static function set enableRightClick(val:Boolean):void
		{
			if(val == _enableRightClick) return;
			if(ExternalInterface.available)
			{
				ExternalInterface.addCallback("rightClick",rightClick);
			}
		}
		
		private static function rightClick():void
		{
			if(_enableRightClick)
			{
				dialogLayer.dispatchEvent(new UIMouseEvent(UIMouseEvent.RIGHT_CLICK,dialogLayer.stage.mouseX,dialogLayer.stage.mouseY));
			}
		}
		
		public static function setChildCenter(child : DisplayObject) : void 
		{
			child.x = (_width - child.width) / 2;
			child.y = (_height - child.height) / 2;
			child.y = child.y < 0 ? 0 : child.y;
			child.x = child.x < 0 ? 0 : child.x;
		}
		
		private static function __addToStage(event:Event):void
		{
			if(_resizeAble)
			{
				dialogLayer.stage.addEventListener(Event.RESIZE,__stageResize);
				__stageResize(null);
			}
		}
		
		private static function __stageResize(event:Event):void
		{
			_width = dialogLayer.stage.stageWidth;
			_height = dialogLayer.stage.stageHeight;
			var len:Number = dialogLayer.numChildren;
			for(var i:int = 0; i < len; i++)
			{
				var rs:IResizeable = dialogLayer.getChildAt(i) as IResizeable
				if(rs)
				{
					rs.resize(_width,_height);
				}
			}
		}
		
		public static function AddDialog(dialog:Sprite,setCenter:Boolean = true,shouldBuffering:Boolean = false):void
		{
			if(dialog)
			{
				if(shouldBuffering && BufferManager.Instance.isBuffering && dialog is HFrame)
				{
					BufferManager.Instance.pushToBuffer(dialog as HFrame);
					return;
				}
				if(dialog.parent == dialogLayer)
				{
					dialogLayer.setChildIndex(dialog,dialogLayer.numChildren -1);
				}
				else
				{
					if(setCenter)
						setChildCenter(dialog);
					dialogLayer.addChild(dialog);
					if(dialog is IResizeable)
					{
						IResizeable(dialog).resize(_width,_height);
					}
				}
			}
		}
		
		public static function RemoveDialog(dialog:Sprite):void
		{
			if(dialog.parent == dialogLayer)
			{
				dialogLayer.removeChild(dialog);
			}
		}
		
		public static function getTopDialog():Sprite
		{
			return dialogLayer.getChildAt(dialogLayer.numChildren-1) as Sprite;
		}
		
		 /**
        * 允许拖动
        * */
        public static function setDragEnable(sprite:Sprite,enable:Boolean):void
        {
        	if(enable)
        	{
	        	sprite.addEventListener(MouseEvent.MOUSE_DOWN,__startDragging);
	        	sprite.addEventListener(MouseEvent.MOUSE_UP,__stopDragging);
        	}
        	else
        	{
        		sprite.stopDrag();
        		sprite.removeEventListener(MouseEvent.MOUSE_DOWN,__startDragging);
        		sprite.removeEventListener(MouseEvent.MOUSE_UP,__stopDragging);
        	}
        }
        
        private static function __startDragging(evt:MouseEvent):void
        {
        	Sprite(evt.currentTarget).startDrag();
        }
        private static function __stopDragging(evt:MouseEvent):void
        {
        	Sprite(evt.currentTarget).stopDrag();
        }
        
        public static function addEventListener(type:String,listener:Function):void
		{
			dialogLayer.addEventListener(type,listener);
		}
		
		public static function removeEventListener(type:String,listener:Function):void
		{
			dialogLayer.removeEventListener(type,listener);
		}
		
		public static function clear():void
		{
			while(dialogLayer.numChildren > 0)
			{
				dialogLayer.removeChildAt(0);
			}
		}

	}
}