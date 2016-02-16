package road.utils
{
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	public class StringHelper
	{
	 	
	 	/**
	 	 * remove only the blankspace on targetString's left
	 	 */
	 	public static function trimLeft(targetString:String):String
	 	{
	 		return targetString.replace(/^\s*/g,"");
	 	}
	 	
	 	public static function trim(str:String):String
	 	{
	 		return str.replace(/(^\s*)|(\s*$)/g,"");
	 	}
 		
 		
 		private static var blankSpaceType:Array = [9,32,61656,59349,59350,59351,59352,59353,59354,59355,59355,59356,59357,59358,59359,59360,59361,59362,59363,59364,59365];
 		public static function trimAll(str:String):String
 		{
 			var s:String = trim(str);
 			
 			var newStr:String = "";
			for (var i:uint = 0; i<s.length; i++) {
				if (blankSpaceType.indexOf(s.charCodeAt(i)) <= -1)
				{
					newStr += s.charAt(i);
				}
			}
			return newStr;
 		}
 		
	 	/**
	 	 * remove only the blankspace on targetString's right
	 	 */
	 	public static function trimRight(targetString:String):String
	 	{
	 		return targetString.replace(/\s*$/g,"");
	 	}
	 	
	 	/**
	 	 * replace sourceWords to targetWords
	 	 * @param str
	 	 * @param sourceWord
	 	 * @param targetWord
	 	 * @return 
	 	 * 
	 	 */	 	
	 	public static function replaceStr(str:String,sourceWord:String,targetWord:String):String
	 	{
	 		return str.split(sourceWord).join(targetWord);
	 	}
	 	
		public static function IsNullOrEmpty(str:String):Boolean
		{
			return str == null || str == "";
		}
		public static function stringToPath(pathString:String):Array
        {
        	var path:Array = new Array ();
        	for(var i:int =0; i< pathString.length;i+=2)
        	{
        		var x:int = pathString.charCodeAt(i);
        		var y:int = pathString.charCodeAt(i+1);
        		//trace("x:"+x +" y:"+y);
        		path.push(new Point(x-OFFSET,y-OFFSET));
        	}
            return path;
        }
        public static function stringToPoint(str:String):Point
        {
        	return new Point(str.charCodeAt(0)-OFFSET,str.charCodeAt(1)-OFFSET);
        }
        public static function pathToString(path:Array):String
        {
        	if (path == null || path.length <= 0) 
        	{
                return "";
            }
            var pathString:String = "";
            for(var i:int =0;i<path.length;i++)
            {
            	pathString += String.fromCharCode(Math.round(path[i].x+OFFSET));
            	pathString += String.fromCharCode(Math.round(path[i].y+OFFSET));
            }
            return pathString;
        }
        public static function pointToString(point:Point):String
        {
            var result:String = "";
            result += String.fromCharCode(Math.round(point.x+OFFSET));
            result += String.fromCharCode(Math.round(point.y+OFFSET));
            return result;
        }     
        public static function numberToString(number:Number):String
        {
        	return String.fromCharCode(Math.round(number + OFFSET));
        }
        public static function stringToNumber(str:String):Number
        {
        	return str.charCodeAt(0) - OFFSET;
        }
        public static function getIsBiggerMaxCHchar(str:String,max:uint):Boolean
        {
        	var b:ByteArray = new ByteArray();
        	b.writeUTF(trim(str));
        	
        	if(b.length >max*3+2)
        	{
        		return true;
        	}
        	else
        	{
        		return false;
        	}
        }
        
        public static function getRandomNumber():String
        {
        	var n:uint = Math.round(Math.random()*1000000);
        	return n.toString();
        }
        
        
		private static const OFFSET:Number=2000;
		
		private static const reg:RegExp = /[^\x00-\xff]{1,}/g;
		public static function checkTextFieldLength(textfield:TextField,max:uint,input:String = null):void
		{
			var ulen1:uint = textfield.text ? textfield.text.match(reg).join("").length : 0;
			var ulen2:uint = input ? input.match(reg).join("").length : 0;
			
	        textfield.maxChars = max > ulen1 + ulen2 ? max - ulen1 - ulen2 : (max > ulen2 ? max - ulen2 : max /2);
		}
		
		public static const _leftReg:RegExp = /</g;
		public static const _rightReg:RegExp = />/g;
		
		public static function rePlaceHtmlTextField(s:String):String
		{
			s = s.replace(_leftReg,"&lt;");
			s = s.replace(_rightReg,"&gt;");
			return s;
		}
		
		/**  
		 *时间处理函数  
		  * res  2009-06-09 11:56:22
 		  * len  7
		 */
		public static function parseTime(res:String,len:uint):String {
			var str:String = res;
	
			var mlk:Date = new Date(Number(str.substr(0,4)),Number(str.substr(5,2))-1,Number(str.substr(8,2)));
	
			var targetDate:Date = new Date();
			targetDate.setTime(mlk.getTime()+(len+1)*24*60*60*1000);
	
			str = String(targetDate.getUTCFullYear())+"-"+(targetDate.getUTCMonth()+1)+"-"+(targetDate.getUTCDate());
	
			return str;
		}
		
		private static var idR1:RegExp = /^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$/; 
		private static var idR2:RegExp = /^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{4}$/; 
		
 
		public static function cidCheck(id:String):Boolean
		{
			if(idR1.test(id) || idR2.test(id))
			{
				return true
			}
			return false;

		}
		
				/**
		 * 移除掉简单HTML标签 
		 * @param str HTML字符串
		 * @return 
		 * 移除HTML标签后的字符串
		 */		
		public static function replaceHtmlTag(str:String):String
		{
			str = str.replace(/<(\S*?)[^>]*>|<.*? \/>/g,"");
			return str;
		}
		
		/**
		 * 将字符串转换为HTML字符串，转义特殊字符串
		 * @param s
		 * @return 
		 * 
		 */		
		public static function replaceToHtmlText(s:String):String
		{
			var txt:TextField = new TextField();
			
			txt.text = s;
			
			s = replaceHtmlTag(txt.htmlText);
			
			return s;
		}
		
		/**
		 * 获取转义后的HTML字符数组
		 * @param str
		 * @return 
		 * 
		 */		
		public static function getConvertedHtmlArray(str:String):Array
		{
			return str.match(/&[a-z]*?;/g);
		}
		
		/**
		 * @param str
		 * @param args
		 * @return 
		 * 返回格式化后的字符串
		 */		
		public static function format(str:String,...args):String
		{
			if(args == null || args.length <= 0)
			{
				return str;
			}
			
			for(var i:uint = 0; i < args.length; i++)
			{
				str = replaceStr(str,"{"+i.toString()+"}",args[i]);
			}
			
			return str;
		}
		
        public static function getConvertedLst(fromCharCode:String) : Array
        {
            return fromCharCode.match(/&[a-z]*?;/g);
        }// end function

	}
}