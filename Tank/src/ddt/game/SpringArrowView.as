package  ddt.game
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.HandHotAsset;
	import game.crazyTank.view.SpringArrowAsset;
	import game.crazyTank.view.SpringArrowRectAsset;
	
	import ddt.data.Config;
	import ddt.data.Direction;
	import ddt.game.animations.DirectionMovingAnimation;
	import ddt.game.map.MapView;

	/**
	 *  
	 * @author devil
	 * 触发场景移动箭头
	 */
	public class SpringArrowView extends Sprite
	{
		private var _rect:SpringArrowRectAsset;
		private var _arrow:SpringArrowAsset;	
		private var _map:MapView;
		private var _direction:String;	
		/**
		 * 地图要移动的目标点 
		 */		
		private var _anit:DirectionMovingAnimation;
		
		private var _hand:HandHotAsset;
		
		private var _allowDrag:Boolean;
		
		public function SpringArrowView(direction:String,map:MapView = null)
		{
			_direction = direction;
			initView();			
			initEvent();
			_map = map;
		}
		
		public function set allowDrag(value:Boolean):void
		{
			_allowDrag = value;
		}
		
		private function initView():void
		{
			_rect = new SpringArrowRectAsset();
			_rect.alpha = 0;
			addChild(_rect);
			
			_arrow = new SpringArrowAsset();
			_arrow.visible = false;
			addChild(_arrow);
			
			_hand = new HandHotAsset();
			_hand.visible = false;
			_hand.mouseChildren = false;
			_hand.mouseEnabled = false;
			addChild(_hand);
			
			buttonMode = true;
			useHandCursor = true;
			
			switch(_direction)
			{
				case Direction.LEFT:
					_arrow.rotation = 180;
					_hand.x = _arrow.x - 10;
					_hand.y = _arrow.y - 14;
					x = width / 2;
					y = Config.GAME_HEIGHT / 2;
					break;
				case Direction.RIGHT:
					x = Config.GAME_WIDTH - width / 2 - 60;
					y = Config.GAME_HEIGHT / 2;
					_hand.x = _arrow.x - 14;
					_hand.y = _arrow.y - 14;
					break;
				case Direction.UP:
					_arrow.rotation = -90;
					_rect.rotation = -90;
					x = Config.GAME_WIDTH / 2;
					y = height / 2 + 30;
					_hand.x = _arrow.x - 14;
					_hand.y = _arrow.y - 10;
					break;
				case Direction.DOWN:
					_arrow.rotation = 90;
					_rect.rotation = 90;
					x =  Config.GAME_WIDTH / 2;
					y = Config.GAME_HEIGHT - height / 2 - 30;
					_hand.x = _arrow.x - 12;
					_hand.y = _arrow.y - 14;
					break;
				default:
					break;
			}
		}
		
		private function initEvent():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,__over,false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT,__out,false,0,true);
			addEventListener(MouseEvent.MOUSE_DOWN,__down,false,0,true);
			addEventListener(MouseEvent.MOUSE_UP,__up,false,0,true);
		}
		
		private function __over(event:MouseEvent):void
		{
			_arrow.visible = true;
			_hand.visible = true;
		}
		
		private function __out(event:MouseEvent):void
		{
			_arrow.visible = false;
			_hand.visible = false;
			if(_anit)
			{
				_anit.cancel();
				_anit = null;
			}
		}
		
		private function __up(event:MouseEvent):void
		{
			_arrow.visible = false;
			if(_anit)
			{
				_anit.cancel();
				_anit = null;
			}
			_hand.visible = true;
		}
		
		private function __down(event:MouseEvent):void
		{
			if(_allowDrag)
			{
				_anit = new DirectionMovingAnimation(_direction);
				_map.animateSet.addAnimation(_anit);
				_hand.visible = false;
			}
		}
		
		public function dispose():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER,__over);
			removeEventListener(MouseEvent.MOUSE_OUT,__out);
			removeEventListener(MouseEvent.MOUSE_DOWN,__down);
			removeEventListener(MouseEvent.MOUSE_UP,__up);
			if(parent)
				parent.removeChild(this);
			_map = null;
			_anit = null;
		}
	}
}