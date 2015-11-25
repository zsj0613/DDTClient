package ddt.view.sceneCharacter
{
	import flash.geom.Point;

	/**
	 * 人物方向
	 * @author Devin
	 */	
	public class SceneCharacterDirection
	{
		/**
		 *背面-右上
		 */		
		public static const RT:SceneCharacterDirection = new SceneCharacterDirection("RT", false);
		
		/**
		 *背面-左上 
		 */		
		public static const LT:SceneCharacterDirection = new SceneCharacterDirection("LT", true);
		
		/**
		 *正面-右下 
		 */		
		public static const RB:SceneCharacterDirection = new SceneCharacterDirection("RB", true);
		
		/**
		 *正面-左下 
		 */		
		public static const LB:SceneCharacterDirection = new SceneCharacterDirection("LB", false);
		
		/**
		 *是否镜像形象
		 */		
		private var _isMirror:Boolean;
		
		public function get isMirror():Boolean
		{
			return _isMirror;
		}
		
		/**
		 *动作类型
		 */		
		private var _type:String;
		
		/**
		 *动作类型 
		 */		
		public function get type():String
		{
			return _type;
		}
		
		public function SceneCharacterDirection(type:String, isMirror:Boolean)
		{
			_type=type;
			this._isMirror = isMirror;
		}
		
		/**
		 * 取得方向
		 */		
		public static function getDirection(thisP:Point,nextP:Point):SceneCharacterDirection
		{
			var degrees:Number = getDegrees(thisP,nextP);
			
			if(degrees>=0&&degrees<90)
			{
				return SceneCharacterDirection.RT;
			}
			else if(degrees>=90&&degrees<180)
			{
				return SceneCharacterDirection.LT;
			}
			else if(degrees>=180&&degrees<270)
			{
				return SceneCharacterDirection.LB;
			}
			else if(degrees>=270&&degrees<360)
			{
				return SceneCharacterDirection.RB;
			}
			else
			{
				return SceneCharacterDirection.RB;
			}
		}
		
		private static function getDegrees(thisP:Point,nextP:Point):Number
		{
			var degrees:Number = Math.atan2(thisP.y-nextP.y,nextP.x-thisP.x)*180/Math.PI;
			
			if(degrees<0)
			{
				degrees+=360;
			}
			return degrees;
		}
	}
}