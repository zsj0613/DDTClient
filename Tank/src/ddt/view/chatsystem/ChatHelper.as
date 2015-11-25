package ddt.view.chatsystem
{
	import flash.utils.ByteArray;

	
	public class ChatHelper
	{
		chat_system static function readGoodsLinks(byte:ByteArray):Array
		{
			var re_arr:Array=[];
			var count:uint=byte.readUnsignedByte();
			for(var i:int=0;i<count;i++)
			{
				var obj:Object=new Object;
				obj.index=byte.readInt();
				obj.TemplateID=byte.readInt();
				obj.ItemID=byte.readInt();
				re_arr.push(obj);
			}
			return re_arr;
		}
	}
}