package ddt.utils
{
	import flash.utils.ByteArray;
	/**
	 * 对位集合进行存储和操作。
	 * @version 1.0
	 * @author Welly
	 */ 
	public class BitArray extends ByteArray
	{
		public function BitArray()
		{
			super();
		}
		/**
		 * 设定指定位的值
		 * @param position:uint 位索引
		 * @param value:Boolean 设定值
		 * @return 所设定的值
		 */
		public function setBit(position:uint,value:Boolean):Boolean{
			var index:uint = position>>3;
			var offset:uint = position&7;
			var tempByte:uint = this[index];
			tempByte |= (1<<offset);
			this[index] = tempByte;
			return true;
		}
		/**
		 * 获取指定位的值
		 * @param position:uint 位索引
		 * @return 指定位的值
		 */
		public function getBit(position:uint):Boolean{
			var index:int = position>>3;
			var offset:int = position&7;
			var tempByte:int = this[index];
			var result:uint = tempByte & (1<<offset);
			if(result)return true;
			return false;
		}
		public function loadBinary(str:String):void{
			for(var i:Number=0;i<str.length*32;i++){
				setBit(i,str && (1>>i));
			}
		}
		/**
		 * 以字符串可视化输出一个位的值
		 * @param position:uint 位索引
		 * @return position所在字节所有位值的字符串
		 */ 
		public function traceBinary(position:uint):String{
			var index:uint = position>>3;
			var offset:int = position&7;
			var tempByte:int = this[index];
			var tempStr:String = "";
			for(var i:uint=0;i<8;i++){
				if(i == offset){
					if(tempByte & (1<<i)){
						tempStr+="[1]";
					}else{
						tempStr+="[0]";
					}
					continue
				}
				if(tempByte & (1<<i)){
						tempStr+=" 1 ";
					}else{
						tempStr+=" 0 ";
					}
			}
			return tempStr;
		}
		
	}
}