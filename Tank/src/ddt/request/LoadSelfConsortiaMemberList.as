package ddt.request
{
	import flash.net.URLVariables;
	
	import road.data.DictionaryData;
	
	import ddt.data.player.ConsortiaPlayerInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.loader.RequestLoader;
	import ddt.manager.PlayerManager;
	import ddt.manager.TaskManager;

	public class LoadSelfConsortiaMemberList extends RequestLoader
	{
		public static const PATH:String = "ConsortiaUsersList.ashx";
		private var list:DictionaryData;
		
		public function LoadSelfConsortiaMemberList(id:int)
		{

			var paras:URLVariables = new URLVariables();
			paras["page"] = 1;
			paras["size"] = 10000;
			paras["order"] = -1;
			paras["consortiaID"] = id;
			paras["userID"] = -1;
			paras["state"] = -1;
			paras["rnd"] = Math.random();
			super(PATH,paras);
			
		}
		override protected function onRequestReturn(xml:XML):void
		{
//			trace(xml.toXMLString());
			list = PlayerManager.Instance.consortiaMemberList;
//			totalCount = int(xml.@total);
			var xmllist:XMLList = XML(xml)..Item;
			for(var i:int = 0; i < xmllist.length(); i++)
			{
				var player:PlayerInfo = new PlayerInfo();
				player.beginChanges();
				var info:ConsortiaPlayerInfo = new ConsortiaPlayerInfo(player);
				info.ID = xmllist[i].@ID;
				info.info.ConsortiaID = info.ConsortiaID = PlayerManager.Instance.Self.ConsortiaID;
				info.DutyID = xmllist[i].@DutyID;
				info.info.DutyName = info.DutyName = xmllist[i].@DutyName;
				info.info.GP = xmllist[i].@GP;
				info.Grade = info.info.Grade = xmllist[i].@Grade;
				info.info.FightPower = xmllist[i].@FightPower;
				info.info.AchievementPoint =  xmllist[i].@AchievementPoint;
				info.info.honor =  xmllist[i].@Rank;
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
				info.info.IsBandChat = info.IsBanChat = converBoolean(xmllist[i].@IsBanChat);
				info.Level = xmllist[i].@Level;
				info.info.Offer = xmllist[i].@Offer;
				info.RatifierID = xmllist[i].@RatifierID;
				info.RatifierName = xmllist[i].@RatifierName;
				info.Remark = xmllist[i].@Remark;
				info.info.Repute = xmllist[i].@Repute;
				info.State = xmllist[i].@State;
				info.LastDate = xmllist[i].@LastDate;
				info.CurrentDate = XML(xml).@currentDate;
				info.UserId = info.info.ID = xmllist[i].@UserID;
				info.info.NickName =info.NickName = xmllist[i].@UserName;
				info.info.ConsortiaName = PlayerManager.Instance.Self.ConsortiaName;
				info.info.Style = xmllist[i].@Style;
				info.info.Colors = xmllist[i].@Colors;
				info.info.LoginName = xmllist[i].@LoginName;
				info.info.Hide = xmllist[i].@Hide;
				info.Sex = info.info.Sex = converBoolean(xmllist[i].@Sex);
//				
				info.info.EscapeCount =  xmllist[i].@EscapeCount;
				info.info.Right = xmllist[i].@Right;
				info.info.WinCount = xmllist[i].@WinCount;
				info.info.TotalCount =  xmllist[i].@TotalCount;
				info.info.RichesOffer = info.RichesOffer = xmllist[i].@RichesOffer;
				info.info.RichesRob = info.RichesRob = xmllist[i].@RichesRob;
				
				info.DutyLevel= info.info.DutyLevel = xmllist[i].@DutyLevel;
				player.commitChanges();
				list.add(info.ID,info);
			}
			TaskManager.onGuildUpdate();
//			PlayerManager.Instance.consortiaMemberList = list;
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