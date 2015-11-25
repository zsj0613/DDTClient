package ddt.utils
{
	/**
	 * 队列 (FIFO)
	 * @author SYC
	 * 
	 */	
	public class Queue
	{
		private var _queues:Array;
		
		
		public function Queue()
		{
			resetQueue();
		}
		
		/**
		 * 重置队列 
		 * (置空队。构造一个空队列)
		 */		
		public function resetQueue():void
		{
			_queues = new Array();
		}
		
		public function queueLength():int
		{
			return _queues.length;
		}
		
		/**
		 * 是否空队列 
		 * @return 
		 * 
		 */		
		public function isEmptyQueue():Boolean
		{
			var result:Boolean = (_queues.length == 0) ? true : false;
			return result;
		}
		
		/**
		 * 入队 
		 * 
		 */		
		public function enQueues(queue: *,block:Boolean = false):void
		{
			var data:QueueData = new QueueData(queue,block);
			_queues.push(data);
		}
		
		/**
		 * 出队 
		 * 
		 */		
		public function outQueues():void
		{
			isEmptyQueue() ? null : _queues.shift();
		}
		
		/**
		 * 头队列 
		 * @return 
		 * 
		 */		
		public function topQueue():QueueData
		{
			var result:QueueData = isEmptyQueue() ? null : _queues[0];
			return result;
		}

	}
}