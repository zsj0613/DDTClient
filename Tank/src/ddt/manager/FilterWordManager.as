package ddt.manager
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import road.utils.StringHelper;
	
	public class FilterWordManager
	{
		//标点符号
		private static var unableChar:String = "";
		private static var CHANNEL_WORDS:Array = ["当前","公会","组队","私聊","小喇叭","大喇叭","跨区大喇叭"]
		//政治、官方禁用的词汇
		private static var NICKADDWORDS:Array = [];
		//骂人的词汇
		private static var WORDS:Array = [];
		//用于替换骂人词汇的符号
		private static var REPLACEWORD:String = "~!@#$@#$%~!@#$@#%^&@~!@#$@##$%*~!@#$$@#%^&@~!@#$@#@#";
		
		public static function loadWord():void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,__loadWordComplete);
			loader.load(new URLRequest(PathManager.SITE_MAIN+"illegal/illegal.txt"+"?"+Math.random()));
		}
		
		private static function __loadWordComplete(evt:Event):void
		{
			var arr:Array = String((evt.target as URLLoader).data).toLocaleLowerCase().split("\n"); //"\n" 回车换行
			unableChar = arr[0];
			NICKADDWORDS = arr[1].split("|");
			WORDS = arr[2].split("|");
			clearnUpNaN_Char(WORDS);
			clearnUpNaN_Char(NICKADDWORDS);
		}
		private static function clearnUpNaN_Char(source:Array):void
		{
			var i:int = 0;
			while(i < source.length)
			{
				if(source[i].length == 0)
				{
					source.splice(i,1);
				}else
				{
					i++;
				}
			}
		}
		
		/**
		 * 检测是否含有标点符号 bret 09.5.15
		 * @param s
		 * @return 
		 * 
		 */		
		
		public static function containUnableChar(s:String):Boolean
		{
			var len:int = s.length;
			for(var i:int = 0; i < len; i++)
			{
				if(unableChar.indexOf(s.charAt(i)) > -1)return true;  //含有标点符号 返回true
			}
			return false;
		}

		

		/**
		 *判断字符串是否包含有非法字符 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function isGotForbiddenWords(str:String,level:String = "chat"):Boolean
		{
			var temS:String = StringHelper.trimAll(str.toLocaleLowerCase());
			var count:uint = WORDS.length;
			for(var i:int = 0 ; i < count; i++)
			{
				if(temS.indexOf(WORDS[i]) > -1){
					return true;
				}
			}
			if(level=="name"){
				return false;
			} else if(level == "chat"){
				count = NICKADDWORDS.length;
				for(i= 0 ; i < count; i++)
				{
					if(temS.indexOf(NICKADDWORDS[i]) > -1){
						return true;
					}
				}
			}
			
			return false;
		}
		
		/**
		 *格式化非法字符 
		 * @param str
		 * @param arr
		 * @return 
		 * 
		 */		
		//add by Freeman
		private static function formatForbiddenWords(str:String, arr:Array):String
		{
			var temS:String = StringHelper.trimAll(str.toLocaleLowerCase());
			var count:int = arr.length;
			var isGotForbiddenWord:Boolean = false;
			
			for(var i:int = 0 ; i < count; i++)
			{
				if(temS.indexOf(arr[i]) > -1){
					isGotForbiddenWord = true;
					var obj:Object = new Object;
					obj["word"] = arr[i];
					obj["idx"] = temS.indexOf(arr[i]);
					obj["length"] = obj["word"].length;
					temS = replaceUpperOrLowerCase(temS,obj);
					str = replaceUpperOrLowerCase(str,obj);
					i = 0;
				}
			}
			if(isGotForbiddenWord && str)
				return str;
			else
				return undefined;
		}
		//add by Freeman

		
		/**
		 *过滤可能引起会引起误会的频道用语 
		 * @param str
		 * @return 
		 * 
		 */		
		//added by Freeman
		private static function formatChannelWords(str:String):String
		{
			if(!str)return undefined;
			var count:int = CHANNEL_WORDS.length;
			var isGotChannelWord:Boolean = false;
			for(var i:int = 0 ; i < count; i++)
			{
				var idx:uint  = str.indexOf(CHANNEL_WORDS[i]);
				var idx1:uint = idx - 1;
				var idx2:uint = idx + CHANNEL_WORDS[i].length;
				if(idx > -1){
					if(idx1>-1 && idx2<=str.length-1){
						if(str.slice(idx1,idx1+1)=="[" && str.slice(idx2,idx2+1)=="]")
						{
							isGotChannelWord = true;
							str = str.slice(0,idx) + getXXX(CHANNEL_WORDS[i].length) + str.slice(idx2);
						}
					}
				}
			}
			
			if(isGotChannelWord && str)
				return str;
			else
				return undefined;
		}
		//added by Freeman
		/**
		 *替换脏字(包括全角和半角) 
		 * @param str
		 * @param obj
		 * @return 
		 * 
		 */		
		//包括半角和全角, 大写和小写的替换函数  add by Freeman
		private static function replaceUpperOrLowerCase(str:String,obj:Object):String
		{
			var startIdx:int = obj["idx"];
			var len:int = obj["length"];
			var s:String;
			if( startIdx+len>=str.length)
			{
				s = str.slice(startIdx);
			} else{
				s = str.slice(startIdx,startIdx+len);
			}
			var reg:RegExp=new RegExp(s);
			str = str.replace(reg,getXXX(len));
			return str;
		}
		//包括半角和全角, 大写和小写的替换函数  add by Freeman
		
		/**
		 * 过滤骂人的词汇
		 * @param s
		 * @return 
		 * 
		 */		
		//modified by Freeman
		public static function filterWrod(s:String):String
		{
			var temS:String = StringHelper.trimAll(s);
			var re_str:String = formatChannelWords(temS);
			var re_str1:String;
			var re_str2:String;
			if(re_str){
				re_str1 = formatForbiddenWords(re_str,WORDS);
			} else {
				re_str1 = formatForbiddenWords(temS,WORDS);
			}
			if(re_str1){
				re_str2 = formatForbiddenWords(re_str1,NICKADDWORDS);
			} else if(re_str){
				re_str2 = formatForbiddenWords(re_str,NICKADDWORDS);
			}else {
				re_str2 = formatForbiddenWords(temS,NICKADDWORDS);
			}

			if(re_str2)return re_str2;
			if(re_str1)return re_str1;
			if(re_str)return re_str;
			return s;
		}
		//modified by Freeman
		

		
		public static function IsNullorEmpty(str:String):Boolean
		{
			str = StringHelper.trim(str);
			return StringHelper.IsNullOrEmpty(str);
		}
		
		/**
		 * 获取过滤字符
		 * @param len
		 * @return 
		 * 
		 */		
		
		//modified by Freeman
		private static function getXXX(len:int):String
		{
			var startIdx:uint = Math.round(Math.random()*(REPLACEWORD.length/4));
			var str:String = REPLACEWORD.slice(startIdx,startIdx + len);
			return str;
		}
		//modified by Freeman
		
		
	}
}