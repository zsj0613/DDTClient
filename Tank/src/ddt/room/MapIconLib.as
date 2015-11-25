package ddt.room
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	public final class MapIconLib
	{
		public function MapIconLib()
		{
		}
		
		private static var _lib_Big:Dictionary = new Dictionary();
		private static var _lib_Small:Dictionary = new Dictionary();
		private static var _lib_Show:Dictionary = new Dictionary();
		private static var _lib_Small_S : Dictionary = new Dictionary();
		
		public static function addBigIcon(id:int,map:Bitmap):void
		{
			_lib_Big[id] = map;
		}
		public static function addSmallMinIcon(id:int,map:Bitmap) : void
		{
			_lib_Small_S[id] = map;
		}
		
		public static function addSmallIcon(id:int,map:Bitmap):void
		{
			_lib_Small[id] = map;
		}
		
		public static function addShowIcon(id:String,map:Bitmap):void
		{
			_lib_Show[id] = map;
		}
		
		public static function getBigIcon(id:int):Bitmap
		{
			var bitmap:Bitmap
			if(_lib_Big[id])
			{
				bitmap = new Bitmap();
				bitmap.bitmapData = (_lib_Big[id] as Bitmap).bitmapData.clone();
				bitmap.smoothing = true;
			}
			return bitmap
		}
		
		public static function getSmallMinIcon(id:int):Bitmap
		{
			var bitmap:Bitmap
			if(_lib_Small_S[id])
			{
				bitmap = new Bitmap();
				bitmap.bitmapData = (_lib_Small_S[id] as Bitmap).bitmapData.clone();
				bitmap.smoothing = true;
			}
			return bitmap
		}
		
		public static function getShowIcon(id:String):Bitmap
		{
			var bitmap:Bitmap
			if(_lib_Show[id])
			{
				bitmap = new Bitmap();
				bitmap.bitmapData = (_lib_Show[id] as Bitmap).bitmapData.clone();
				bitmap.smoothing = true;
			}
			return bitmap
		}
		
		public static function hasSmallIcon(id:int):Boolean
		{
			if(_lib_Small[id])
			{
				if(_lib_Small[id] is Bitmap && _lib_Small[id].bitmapData)
				{
					return true;
				}else
				{
					return false;
				}
			}else
			{
				return false;
			}
		}
		
		public static function hasBigIcon(id:int):Boolean
		{
			if(_lib_Big[id])
			{
				if(_lib_Big[id] is Bitmap && _lib_Big[id].bitmapData)
				{
					return true;
				}else
				{
					return false;
				}
			}else
			{
				return false;
			}
		}
		
		
		public static function hasSmallMinIcon(id:int):Boolean
		{
			if(_lib_Small_S[id])
			{
				if(_lib_Small_S[id] is Bitmap && _lib_Small_S[id].bitmapData)
				{
					return true;
				}else
				{
					return false;
				}
			}else
			{
				return false;
			}
		}
		public static function hasShowIcon(id:String):Boolean
		{
			if(_lib_Show[id])
			{
				if(_lib_Show[id] is Bitmap && _lib_Show[id].bitmapData)
				{
					return true;
				}else
				{
					return false;
				}
			}else
			{
				return false;
			}
		}
		
		public static function getSmallIcon(id:int):Bitmap
		{
			var bitmap:Bitmap
			if(_lib_Small[id])
			{
				bitmap = new Bitmap();
				try{
					bitmap.bitmapData = (_lib_Small[id] as Bitmap).bitmapData.clone();
				}catch(e:Error)
				{
//					trace("errorsssssss");
				}
				bitmap.smoothing = true;
			}
			return bitmap
		}
		
	}
}