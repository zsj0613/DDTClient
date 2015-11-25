package ddt.view.chatsystem
{
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import road.utils.StringHelper;
	
	import ddt.data.QualityType;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.utils.Helpers;

	public class ChatFormats
	{
		public static const CHAT_COLORS:Array = [0x23FAFF,0xFF9B00,0xFF6EFA,0x4BD750,0x8089DD,0xFFFFFF,0xFFFF00,0xFFFF00,0xFFFF00,0xFFFFFF,0x4CD551,0xFF3333,0xff00a8,0xFFFFFF];
		
		public static const CLICK_CHANNEL:int = 0;
		public static const CLICK_GOODS:int = 2;
		public static const CLICK_USERNAME:int = 1;
		public static const CLICK_DIFF_ZONE:int = 4;
		public static const CLICK_INVENTORY_GOODS:int = 3;
		
		public static const Channel_Set:Object = {
			0:LanguageMgr.GetTranslation("ddt.view.chat.ChannelListSelectView.big"),
			1:LanguageMgr.GetTranslation("ddt.view.chat.ChannelListSelectView.small"),
			2:LanguageMgr.GetTranslation("ddt.view.chat.ChannelListSelectView.private"),
			3:LanguageMgr.GetTranslation("ddt.view.chat.ChannelListSelectView.consortia"),
			4:LanguageMgr.GetTranslation("ddt.view.chat.ChannelListSelectView.ream"),
			5:LanguageMgr.GetTranslation("ddt.view.chat.ChannelListSelectView.current"),
			9:LanguageMgr.GetTranslation("ddt.view.chat.ChannelListSelectView.current"),
			12:LanguageMgr.GetTranslation("ddt.view.chat.ChannelListSelectView.cross"),
			13:LanguageMgr.GetTranslation("ddt.view.chat.ChannelListSelectView.current")
		};
		
		public static var hasYaHei:Boolean;
		
		private static var _formats:Dictionary;
		private static var _styleSheet:StyleSheet;
		private static var _gameStyleSheet:StyleSheet;
		private static var _styleSheetData:Dictionary;
		
		public static function formatChatStyle(data:ChatData):void
		{
			if(data.htmlMessage != "")return;
			data.msg=StringHelper.rePlaceHtmlTextField(data.msg);
			var channelTag:Array = getTagsByChannel(data.channel);
			var channelClickTag:String = creatChannelTag(data.channel);
			var senderClickTag:String = creatSenderTag(data);
			var contentClickTag:String = creatContentTag(data);
			data.htmlMessage = channelTag[0]+channelClickTag+senderClickTag+contentClickTag+channelTag[1]+"<BR>";
//			data.htmlMessage = decodeURI(decodeURI(data.htmlMessage));
		}
		public static function creatBracketsTag(source:String,clickType:int,args:Array = null):String
		{
			var namesRec:RegExp = /\[([^\]]*)]*/g;
			var srr:Array = source.match(namesRec);
			var argString:String = "";
			if(args)argString = args.join("|");
			for (var i:int = 0; i<srr.length; i++) {
				var tagname:String = srr[i].substr(1,srr[i].length-2);
				if(clickType != CLICK_USERNAME || tagname != PlayerManager.Instance.Self.NickName)
				{
					source = source.replace("["+tagname+"]","<a href=\"event:"+"clicktype:"+clickType.toString()+"|tagname:"+tagname+"|"+argString+"\">"+Helpers.enCodeString("["+tagname+"]")+"</a>");
				}else
				{
					source = source.replace("["+tagname+"]",Helpers.enCodeString("["+tagname+"]"));
				}
			}
			return source;
		}
		
		public static function creatGoodTag(source:String,clickType:int,templeteIDorItemID:int,quality:int,isBind:Boolean):String
		{
			var qualityTag:Array = getTagsByQuality(quality);
			var namesRec:RegExp = /\[([^\]]*)]*/g;
			var srr:Array = source.match(namesRec);
			for (var i:int = 0; i<srr.length; i++) {
				var tagname:String = srr[i].substr(1,srr[i].length-2);
				source = source.replace("["+tagname+"]",qualityTag[0]+"<a href=\"event:"+"clicktype:"+clickType.toString()+"|tagname:"+tagname+"|isBind:"+isBind.toString()+"|templeteIDorItemID:"+templeteIDorItemID.toString()+"\">"+Helpers.enCodeString("["+tagname+"]")+"</a>"+qualityTag[1]);
			}
			return source;
		}
		
		public static function getColorByChannel(channel:int):int
		{
			return CHAT_COLORS[channel];
		}
		
		public static function getTagsByChannel(channel:int):Array
		{
			return ["<CT"+channel.toString()+">","</CT"+channel.toString()+">"];
		}
		
		public static function getTagsByQuality(quality:int):Array
		{
			return ["<QT"+quality.toString()+">","</QT"+quality.toString()+">"];
		}
		
		
		public static function getTextFormatByChannel(channelid:int):TextFormat
		{
			return _formats[channelid];
		}
		
		public static function setup():void
		{
			setupFormat();
			setupStyle();
		}
		
		public static function get styleSheet():StyleSheet
		{
			return _styleSheet;
		}
		public static function get gameStyleSheet():StyleSheet
		{
			return _gameStyleSheet;
		}
		
		private static function creatChannelTag(channel:int):String
		{
			var result:String = "";
			if(Channel_Set[channel] && channel != ChatInputView.PRIVATE)
			{
				result = creatBracketsTag("["+Channel_Set[channel]+"]",CLICK_CHANNEL,["channel:"+channel.toString()]);
			}
			return result;
		}
		
		private static function creatContentTag(data:ChatData):String
		{
			var result:String = data.msg;
			var offset:uint=0;
			
			if(data.link)
			{	
				data.link.sortOn("index");
				for each(var i:Object in data.link)
				{
					var ItemID:Number=i.ItemID;
					var TemplateID:int=i.TemplateID;
					var info:ItemTemplateInfo=ItemManager.Instance.getTemplateById(TemplateID);
					var index:uint=i.index+offset;
					var tag:String;
					if(ItemID<=0)
					{
						tag=creatGoodTag("["+info.Name+"]",CLICK_GOODS,info.TemplateID,info.Quality,true);
					}else
					{
						tag=creatGoodTag("["+info.Name+"]",CLICK_INVENTORY_GOODS,ItemID,info.Quality,true);
					}
					result=result.substring(0,index)+tag+result.substring(index);
					offset+=tag.length;
				}
			}
			result = creatBracketsTag(result,CLICK_USERNAME);
			return result;
		}
		
		private static function creatSenderTag(data:ChatData):String
		{
			var result:String = "";
			if(data.sender == "") return result;
			if(data.channel == ChatInputView.PRIVATE)
			{
				if(data.sender == PlayerManager.Instance.Self.NickName)
				{ 
					result = creatBracketsTag(LanguageMgr.GetTranslation("ddt.view.chatsystem.sendTo")+"["+data.receiver+"]: ",CLICK_USERNAME);
				}else
				{
					result = creatBracketsTag("["+data.sender+"]" + LanguageMgr.GetTranslation("ddt.view.chatsystem.privateSayToYou"),CLICK_USERNAME);
				}
			}else
			{
				if(data.zoneID==PlayerManager.Instance.Self.ZoneID||data.zoneID<=0)
				{
					result = creatBracketsTag("["+data.sender+"]: ",CLICK_USERNAME);
				}
				else
				{
					result = creatBracketsTag("["+data.sender+"]: ",CLICK_DIFF_ZONE);
				}
			}
			return result;
		}
		
		public static function replaceUnacceptableChar(source:String):String
		{
			for(var i:int = 0;i<unacceptableChar.length;i++)
			{
				source = source.replace(unacceptableChar[i],"");
			}
			return source;
		}
		
		private static const unacceptableChar:Array = ["\"","\'","<",">"];
		
		/**
		 * 获得聊天输出框的styleObject 
		 * @param color
		 * @param type 0为通常,1为游戏中的
		 * @return 
		 * 
		 */		
		private static function creatStyleObject(color:int,type:uint=0):Object
		{
			var styleObject:Object
			var fontSize:String;
			switch(type){
				case 0:
					fontSize="13";
				break;
				case 1:
					fontSize="12"
				break;
			}
			if(hasYaHei)
			{
				styleObject = {color:"#"+color.toString(16),leading:"1",fontFamily:"微软雅黑",display: "inline",fontSize:fontSize};
			}else
			{
				styleObject = {color:"#"+color.toString(16),leading:"5",fontFamily:"宋体",display: "inline",fontSize:fontSize};
			}
			return styleObject;
		}
		
		private static function setupFormat():void
		{
			_formats = new Dictionary();
			for(var i:int = 0;i<CHAT_COLORS.length;i++)
			{
				var format:TextFormat = new TextFormat();
				format.font = "宋体";
				format.size = 13;
				format.color = CHAT_COLORS[i];
				_formats[i] = format;
			}
		}
		
		
		private static function setupStyle():void
		{
			_styleSheetData = new Dictionary();
			_styleSheet = new StyleSheet();
			_gameStyleSheet = new StyleSheet();
			for(var i:int = 0;i<QualityType.QUALITY_COLOR.length;i++)
			{
				var ct:Object = creatStyleObject(QualityType.QUALITY_COLOR[i]);//品质颜色
				var gct:Object = creatStyleObject(QualityType.QUALITY_COLOR[i],1);
				_styleSheetData["QT"+i] = ct;
				_styleSheet.setStyle("QT"+i,ct);
				_gameStyleSheet.setStyle("QT"+i,gct);
			}
			
			for(var j:int = 0;j<=CHAT_COLORS.length;j++)
			{
				var ct1:Object = creatStyleObject(CHAT_COLORS[j]);//频道颜色
				var gct1:Object = creatStyleObject(CHAT_COLORS[j],1);
				_styleSheetData["CT"+String(j)] = ct1;
				_styleSheet.setStyle("CT"+String(j),ct1);
				_gameStyleSheet.setStyle("CT"+String(j),gct1);
			}
		}
	}
}