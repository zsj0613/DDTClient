package road.utils
{
	import flash.utils.ByteArray;
	
	public class ByteUtils
	{
		/// <summary>
        /// Converts a byte array into a hex dump
        /// </summary>
        /// <param name="description">Dump description</param>
        /// <param name="dump">byte array</param>
        /// <param name="start">dump start offset</param>
        /// <param name="count">dump bytes count</param>
        /// <returns>the converted hex dump</returns>
        public static function ToHexDump(description:String,dump:ByteArray, start:int, count:int):String
        {
            var hexDump:String = "";
            if (description != null)
            {
            	hexDump += description;
            	hexDump += "\n";
            }
            var end:int = start + count;
            for (var i:int = start; i < end; i += 16)
            {
                var text:String = "";
                var hex:String = "";

                for (var j:int = 0; j < 16; j++)
                {
                    if (j + i < end)
                    {
                        var val:Number = dump[j + i];
                        if(val < 16)
                        {
                        	hex += "0" + val.toString(16)+" ";
                        }
                        else
                        {
                         	hex += val.toString(16) + " ";
                        }
                        
                        if (val >= 32 && val <= 127)
                        {
                            text += String.fromCharCode(val);
                        }
                        else
                        {
                            text += ".";
                        }
                    }
                    else
                    {
                        hex += "   ";
                        text += " ";
                    }
                }
                hex +="  ";
                hex += text;
                hex += '\n';
                hexDump += hex;
            }
            return hexDump;
        }
	}
}