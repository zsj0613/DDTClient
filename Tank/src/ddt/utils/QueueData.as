package ddt.utils
{
	public class QueueData
	{		
		private var _data:*;
		public function get data():*
		{
			return _data;
		}
		
		/**
		 * 是否阻塞 
		 */		
		private var _block:Boolean;
		public function get block():Boolean
		{
			return _block;
		}
		public function set block(value:Boolean):void
		{
			_block = value;
		}
		
		public function QueueData(data: *,block:Boolean = false)
		{
			_data = data;
			_block = block;
		}
	}
}