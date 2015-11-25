package ddt.game.animations
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	public class ShockingSetCenterAnimation extends BaseSetCenterAnimation
	{
		private var _shocking:int;
		private var _shockDelay:int;
		private var _x:Number;
		private var _y:Number;
		public function ShockingSetCenterAnimation(cx:Number, cy:Number, life:int=165, directed:Boolean=false, level:int=AnimationLevel.LOW, shocking:int=12)
		{
			super(cx, cy, life, false, level, 48);
			_shocking = shocking;
			_shockDelay = 0;
		}
		private function shockingOffset():Number{
			return Math.random()*_shocking*2 - _shocking;
		}
		public override function update(movie:DisplayObject):Boolean
		{
			_life --;
			if(_life<0)
				_finished = true;
			if(!_finished){
				
				
				var p:Point = new Point(_target.x - movie.x,_target.y - movie.y);
				if(p.length > 192){
					movie.x += p.x / 48;
					movie.y += p.y / 48;
				}else if(p.length >= 4)
				{
					p.normalize(4);
					movie.x += p.x;
					movie.y += p.y;
				}
				else if(p.length>=1)
				{
					movie.x += p.x;
					movie.y += p.y;
					//_finished = true;
				}
				//========shocking
				/*_shockDelay --;
				if(_shockDelay < 0){
					_shockDelay = int(Math.random()*10+30);
				}
				if(_shockDelay < 4){
					_shocking = - _shocking;
					movie.x = movie.x + shockingOffset();
					movie.y = movie.y + _shocking;
				}
				*/
				if(_life%2){
					_shocking = - _shocking;
					//movie.y = movie.y + shockingOffset();
					movie.y = movie.y + _shocking;
				
				}return true;
			}
			return false;
		}
	}
}