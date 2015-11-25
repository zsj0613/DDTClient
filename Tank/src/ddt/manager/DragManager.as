package ddt.manager
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	import road.ui.manager.TipManager;
	
	import ddt.interfaces.IAcceptDrag;
	import ddt.interfaces.IDragable;
	import ddt.view.cells.DragEffect;
	
	public class DragManager
	{
		private static var _isDraging:Boolean;
		private static var _proxy:Sprite;
		private static var _dragEffect:DragEffect;
		private static var _source:IDragable;
		private static var _throughAll:Boolean;
		
		public static function get isDraging():Boolean{
			return _isDraging
		}
	
		/**
		 * 
		 * @param source
		 * @param data
		 * @param image
		 * @param stageX
		 * @param stageY
		 * @param action
		 * @param mouseMask
		 * @param mouseDown 是否支持mouseDown事件
		 * @return 
		 * 
		 */		
		public static function startDrag(source:IDragable,data:Object,image:DisplayObject,stageX:int,stageY:int,action:String = "none",mouseMask:Boolean=true, mouseDown:Boolean=false, throughAll:Boolean = false):Boolean
		{
			if(!_isDraging && image)
			{
				_isDraging = true;
				_proxy = new Sprite();
				image.x = - image.width / 2;
				image.y = - image.height / 2;
				_proxy.addChild(image);
				Mouse.hide();
				_proxy.x = stageX;
				_proxy.y = stageY;
				_proxy.mouseEnabled = mouseMask;
				_proxy.mouseChildren = false;
				_proxy.startDrag();
				_throughAll = throughAll;
				
				_dragEffect = new DragEffect(source.getSource(),data,action);
				_source = source;
				TipManager.AddTippanel(_proxy);
				if(mouseMask)
				{
					_proxy.addEventListener(MouseEvent.CLICK,__stopDrag);
				}
				else
				{
					if(!mouseDown)
					{
						/**
						 *	由于设置了TipManager的容器层为不响应鼠标事件，所以阻止掉mousedown事件，以免引起背包中的点击发生一些异常 
						 */
						_proxy.stage.addEventListener(MouseEvent.MOUSE_DOWN,__stageMouseDown,true);
					}
					_proxy.stage.addEventListener(MouseEvent.CLICK,__stopDrag,true);
					_proxy.parent.mouseEnabled=false;
					//_proxy.parent.mouseChildren=false;
				}
				_proxy.addEventListener(Event.REMOVED_FROM_STAGE,__removeFromStage);
				return true;
			}
			return false;
		}
		private static function __stageMouseDown(e:Event):void{
			e.stopImmediatePropagation();
			_proxy.stage.removeEventListener(MouseEvent.MOUSE_DOWN,__stageMouseDown,true);
		}
		private static function __removeFromStage(event:Event):void
		{
			_proxy.removeEventListener(MouseEvent.CLICK,__stopDrag);
			_proxy.removeEventListener(Event.REMOVED_FROM_STAGE,__removeFromStage);
			Mouse.show();
			acceptDrag(null);
		}
		
		
		
		private static function __stopDrag(evt:MouseEvent):void
		{
			try
			{
				var list:Array =  _proxy.stage.getObjectsUnderPoint(new Point(evt.stageX,evt.stageY));
				var _stage:Stage = _proxy.stage;
				var ex:Boolean = true;
				if(hasTutorialStepAsset(list))return;
				Mouse.show();
				if(_stage)
				{
					_stage.removeEventListener(MouseEvent.CLICK,__stopDrag);
					_proxy.parent.mouseEnabled=true;
					_proxy.parent.mouseChildren=true;
				}
				_proxy.removeEventListener(MouseEvent.CLICK,__stopDrag);
				_proxy.removeEventListener(Event.REMOVED_FROM_STAGE,__removeFromStage);
				
				
				
				TipManager.RemoveTippanel(_proxy);
				list = list.reverse();
				for each(var ds:DisplayObject in list)
				{
					if(_proxy.contains(ds)) continue;
					var temp:DisplayObject = ds;
					var flag:Boolean = false;
					while(temp && temp != _stage)
					{
						if( temp == _source)
						{
							_dragEffect.action = DragEffect.NONE;
							flag = true;
							break;
						}
						else
						{
							var ad:IAcceptDrag = temp as IAcceptDrag;
							if(ad)
							{
								if(ex){
									ad.dragDrop(_dragEffect);
									if(_throughAll == false) {
										ex = false;
									}
								}
								if(!_isDraging)
								{
									flag = true;
									break;
								}
								//return;
							}
						}
						temp = temp.parent;
					}
					if(flag)
					{
						break;
					}
				}
			}
			catch(e:Error){
				
			}
			if(_source)
			{
				acceptDrag(null);
			}
		}
		
		private static function hasTutorialStepAsset(list:Array):Boolean
		{
			for(var i:int = 0;i<list.length;i++)
			{
				if(UserGuideManager.guideMC.contains(list[i]))
				{
					return true;
				}
			}
			return false;
		}
		
		public static function acceptDrag(target:IAcceptDrag,action:String = null):void
		{
			//global.traceStr("OnacceptDrag");
			_isDraging = false;
			var source:IDragable = _source;
			var effect:DragEffect = _dragEffect;
			try
			{
				effect.target = target;
				if(action)
				{
					
					effect.action = action;					
				}
				//global.traceStr(effect.action);
				source.dragStop(effect);
			}
			catch(e:Error) {}
			_source = null;
			_dragEffect = null;
		}


	}
}