package ddt.game.animations
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import game.asset.bijouGlow.BossBgAsset;
	import game.asset.bijouGlow.GlowAsset;
	
	import phy.object.PhysicalObj;
	
	import ddt.game.GameView;
	import ddt.game.map.MapView;
	import ddt.game.objects.GamePlayer;

	public class GemGlowAnimation extends EventDispatcher implements IAnimate
	{
		private var _player   : GamePlayer;
		private var _gameview : GameView;
		private var _glow     : PhysicalObj;
		private var _bg       : PhysicalObj;
		private var _finished : Boolean;
		private var _life     : int;
		public function GemGlowAnimation(player:GamePlayer,gameview:GameView)
		{
			_player   = player;
			_gameview = gameview;
			_finished = false;
			_glow     = new PhysicalObj(5555,1);
			_glow.addChild(new GlowAsset());
			_bg       = new PhysicalObj(6666,1);
			_bg.addChild(new BossBgAsset());
			_life     = 0;
			
		}
		
		public function get level():int
		{
			return AnimationLevel.HIGHT;
		}
		
		public function prepare(aniset:AnimationSet):void
		{
		}
		
		public function canAct():Boolean
		{
			return !_finished;
		}
		
		public function update(movie:DisplayObject):Boolean
		{
			var map:MapView = movie as MapView;
			_life ++ ;
			if(_life == 2)
			{
				map.addPhysical(_bg);
				map.addPhysical(_player);
			}
			else if(_life == 20)
			{
				map.addPhysical(_glow);
				_glow.x = _player.x;
				_glow.y = _player.y;
			}
			else if(_life == 50)
			{
				map.removePhysical(_glow);
				map.removePhysical(_bg);
			}
			else if(_life > 50)
			{
				_finished = true;
				dispatchEvent(new Event(Event.COMPLETE));
			}
			return true;
		}
		
		public function canReplace(anit:IAnimate):Boolean
		{
			return false;
		}
		
		public function cancel():void
		{
			if(_glow)
			{
				_glow.visible = false;
				if(_glow.parent)_glow.parent.removeChild(_glow);
				_glow.dispose()
			}
			if(_bg)
			{
				_bg.visible   = false;
				if(_bg.parent)_bg.parent.removeChild(_bg);
				_bg.dispose()
			}
			_glow = null;
			_bg   = null;
		}
		
	}
}