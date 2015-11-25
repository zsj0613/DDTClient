package ddt.consortia.request
{
	import flash.net.URLVariables;
	
	import ddt.data.player.ConsortiaPlayerInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.loader.RequestLoader;

	public class LoadConsortiaMemberList extends RequestLoader
	{
		private static const PATH:String = "ConsortiaUsersList.ashx";
		
		public var list:Array;
		public var page:int;
		public var count:int;
		public var totalCount:int;
	
		public function LoadConsortiaMemberList(page:int,size:int,order:int = -1,consortiaID:int = -1,userID:int = -1,state:int = -1)
		{
			this.page = page;
			this.count = size;
			var paras:URLVariables = new URLVariables();
			paras["page"] = page;
			paras["size"] = size;
			paras["order"] = order;
			paras["consortiaID"] = consortiaID;
			paras["userID"] = userID;
			paras["state"] = state;
			super(PATH,paras);
		}
		override protected function onRequestReturn(xml:XML):void
		{
//			trace(xml.toXMLString());
			list = new Array();
			totalCount = int(xml.@total);
			var xmllist:XMLList = XML(xml)..Item;
			for(var i:int = 0; i < xmllist.length(); i++)
			{
				var player:PlayerInfo = new PlayerInfo();
				var info:ConsortiaPlayerInfo = new ConsortiaPlayerInfo(player);
				info.ID = xmllist[i].@ID;
				info.ConsortiaID = xmllist[i].@ConsortiaID;
				info.DutyID = xmllist[i].@DutyID;
				info.DutyName = xmllist[i].@DutyName;
				info.info.GP = xmllist[i].@GP;
				info.info.Grade = xmllist[i].@Grade;
				info.IsChat = converBoolean(xmllist[i].@IsChat);
				info.IsDiplomatism = converBoolean(xmllist[i].@IsDiplomatism);
				info.IsDownGrade = converBoolean(xmllist[i].@IsDownGrade);
				info.IsEditorDescription = converBoolean(xmllist[i].@IsEditorDescription);
				info.IsEditorPlacard = converBoolean(xmllist[i].@IsEditorPlacard);
				info.IsEditorUser = converBoolean(xmllist[i].@IsEditorUser);
				info.IsExpel = converBoolean(xmllist[i].@IsExpel);
				info.IsInvite = converBoolean(xmllist[i].@IsInvite);
				info.IsManageDuty = converBoolean(xmllist[i].@IsManageDuty);
				info.IsRatify = converBoolean(xmllist[i].@IsRatify);
				info.IsUpGrade = converBoolean(xmllist[i].@IsUpGrade);
				info.IsBanChat = converBoolean(xmllist[i].@IsBanChat);
				info.Level = xmllist[i].@Level;
				info.info.Offer = xmllist[i].@Offer;
				info.RatifierID = xmllist[i].@RatifierID;
				info.RatifierName = xmllist[i].@RatifierName;
				info.Remark = xmllist[i].@Remark;
				info.info.Repute = xmllist[i].@Repute;
				info.State = xmllist[i].@State;
				info.LastDate = xmllist[i].@LastDate;
				info.UserId = info.info.ID = xmllist[i].@UserID;
				info.info.NickName =info.NickName = xmllist[i].@UserName;
				info.info.ConsortiaName = xmllist[i].@ConsortiaName;
				info.info.Style = xmllist[i].@Style;
				info.info.Colors = xmllist[i].@Colors;
				info.info.Hide = xmllist[i].@Hide;
				info.info.Sex = converBoolean(xmllist[i].@Sex);
//				
				info.info.EscapeCount =  xmllist[i].@EscapeCount;
				info.info.Right = xmllist[i].@Right;
				info.info.WinCount = xmllist[i].@WinCount;

				info.info.TotalCount =  xmllist[i].@TotalCount;
				info.info.RichesOffer = info.RichesOffer = xmllist[i].@RichesOffer;
				info.info.RichesRob = info.RichesRob = xmllist[i].@RichesRob;

				list.push(info);
			}
		}
		private function converBoolean(b:String):Boolean
		{
			if(b == "true"){
				return true
			}else{
				return false;
			}
		}
	}
}