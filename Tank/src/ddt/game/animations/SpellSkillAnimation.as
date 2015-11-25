package ddt.game.animations
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import road.math.interpolateNumber;
	import ddt.game.GameViewBase;
	import ddt.game.map.MapView;
	import ddt.game.objects.GamePlayer;

	public class SpellSkillAnimation extends EventDispatcher implements IAnimate
	{
		private var _begin:Point;
		private var _end:Point;
		private var _scale:Number;
		
		private var _life:int;
		private var _backlist:Array;
		private var _finished:Boolean;
		private var _player:GamePlayer;
		private var _gameView:GameViewBase;	
		private var _skill:Sprite;
		private var _skillAsset:MovieClip;
		
		public function SpellSkillAnimation(x:Number,y:Number,stageWidth:Number,stageHeight:Number,mapWidth:Number,mapHeight:Number,player:GamePlayer,gameview:GameViewBase)
		{
			_scale = 1.5;
			var _minX:Number = - mapWidth * _scale + stageWidth;
			var _minY:Number = - mapHeight * _scale + stageHeight;
			
			var m:Matrix = new Matrix(_scale,0,0,_scale);
			_end = new Point(x,y);
			_end = m.transformPoint(_end);
			_end.x = stageWidth/2 - _end.x;
			_end.y = stageHeight/4 * 3 - _end.y;
			_end.x = _end.x > 0 ? 0 :( _end.x < _minX ? _minX : _end.x);
			_end.y = _end.y > 0 ? 0 :( _end.y < _minY ? _minY : _end.y);
		
			_player = player;
			_gameView = gameview;
			_skill = createSkillCartoon(player.player.currentWeapInfo.specialSkillMovie);
			_skillAsset = new RadialAsset();
			_skill.mouseChildren = _skill.mouseEnabled = _skillAsset.mouseChildren = _skillAsset.mouseEnabled = false;
			_life  = 0;
			_backlist = new Array();
			_finished = false;
		}
		
		public function get level():int
		{
			return AnimationLevel.HIGHT;
		}
		
		public function canAct():Boolean
		{
			return !_finished;
		}
		
		public function canReplace(anit:IAnimate):Boolean
		{
			return false;
		}
		
		public function prepare(aniset:AnimationSet):void
		{
		}
		
		public function cancel():void
		{
			_skill.visible = false;
			_skillAsset.visible = false;
			_skillAsset.stop();
			if(_skill.parent)_skill.parent.removeChild(_skill);
			if(_skillAsset.parent)_skillAsset.parent.removeChild(_skillAsset);
		}
		
		public function update(movie:DisplayObject):Boolean
		{
			var map:MapView = movie as MapView;
			var a:Number;
			_life ++;
			if(_life < 5)
			{
				if(_backlist.length == 0)
				{
					_gameView.addChild(_skillAsset);
					_begin = new Point(movie.x,movie.y);
					_backlist.push(movie.transform.matrix.clone());
				}
				
				var tp:Point = Point.interpolate(_end,_begin,_life/5);
				var s:Number = interpolateNumber(0,1,1,_scale,_life/5);
				var m:Matrix = new Matrix();
				m.scale(s,s);
				m.translate(tp.x,tp.y);
				movie.transform.matrix = m;
				_backlist.push(m);
			}
			else if(_life == 6)
			{
				_gameView.addChildAt(_skill,0);
				map.hidePhysical(_player);
				map.sky.visible = false;
			}
			else if (_life < 16)
			{
				a = (16 - _life)/10;
				if(map.ground)
					map.ground.alpha = a;
				if(map.stone)
					map.stone.alpha = a;
			}
			else if(_life >16 && _life < 26)
			{
				a = (_life - 16)/10;
				if(map.ground)
					map.ground.alpha = a;
				if(map.stone)
					map.stone.alpha = a;
			}
			else if(_life == 32)
			{
				if(map.ground)
					map.ground.alpha = 1;
				if(map.stone)
					map.stone.alpha = 1;
				map.sky.visible = true;
				map.showPhysical();
				cancel();
			}
			else if(_life > 32)
			{
				if(_backlist.length > 0)
				{
					movie.transform.matrix = _backlist.pop();	
				}
				else
				{
					_finished = true;
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
			return true;
		}
		
		private function createSkillCartoon(id:int):Sprite
		{
			switch(id)
			{
				case 1:
					//虎
					return new SpellSkillCartoon1Asset();
				case 2:
					//朱雀
					return new SpellSkillCartoon2Asset();
				case 3:
				    //青龙
				    return new SpellSkillCartoon3Asset();
				case 4:
					//玄武
					return new SpellSkillCartoon4Asset();				
			}
			return new SpellSkillCartoon1Asset();
		}
	}
}