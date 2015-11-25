package ddt.manager
{
	import flash.utils.Dictionary;
	
	import ddt.utils.BitArray;
	
	public class PVEMapPermissionManager
	{
		private var allPermission:Dictionary = new Dictionary();
		public function PVEMapPermissionManager()
		{
		}
		
		private static var _instance:PVEMapPermissionManager;
		public static function get Instance():PVEMapPermissionManager
		{
			if(_instance == null)
			{
				_instance = new PVEMapPermissionManager();
			}
			return _instance;
		}
		
		public function getPermisitonKey(mapid:int,level:int):int
		{
			var key:Array = [String(mapid),String(level)];
			var keyString:String = key.join("|");
			return allPermission[keyString];
		}
		
		public function getPermission(mapid:int,level:int,mapPermission:String):Boolean
		{
			var right : String = mapPermission.substr(mapid-1,1);
			if(right == "")
			{
				return false;
//				throw new Event("副本难度字段不在范围之内");
			}
			if(level == 0)
			{
				return true;
			}
			if(level == 1)
			{
				return right != "1" ? true : false;
			}
			if(level == 2)
			{
				if(right == "F" || right == "7")
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			if(level == 3)
			{
				return right == "F" ? true : false;
			}
			return false;
//			var data:BitArray = new BitArray();
//			data.writeUTFBytes(mapPermission);
//			data.position = 0;
//			if(mapid > data.length * 2) return false;
//			var index :int = (mapid -1)/2;
//			var offset:int = mapid % 2 == 0 ? 4 + level : level;
//			var result:int = data[index] & (0x01 << offset);
//			return result != 0;
		}

	}
}