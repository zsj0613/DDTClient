package ddt.request
{
	import flash.net.URLVariables;
	
	import ddt.data.player.CivilPlayerInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.loader.RequestLoader;
	import ddt.view.common.SimpleLoading;

	public class LoadCivilMemberList extends RequestLoader
	{
		public static const PATH:String = "MarryInfoPageList.ashx";
		
		public var civilMemberList:Array;
		public var _page:int;
		public var _name:String;
		public var _sex:Boolean;
		public var _totalPage:int;
		
		public function LoadCivilMemberList(page:int,sex:Boolean = false,name:String="")
		{
			/* 通过传入的参数向服务器请求需要返回的信息 */
			var param:URLVariables = new URLVariables();
			_page = page;
			_name = name;
			_sex = sex;
			
			param["page"] = page;
			param["name"] = name;
			param["sex"]  = sex;
			
			super(PATH,param);
			SimpleLoading.instance.show();
		}
		
		/* 服务器收到上面的请求后，返回 xml文档 */
		override protected function onRequestReturn(xml:XML):void
		{
//			trace(xml.toXMLString());
			civilMemberList = [];
			
			_totalPage = Math.ceil(int(xml.@total)/12);
			var xmllist:XMLList = XML(xml)..Info;
			
			for(var i:int = 0; i < xmllist.length(); i++)
			{
				var player:PlayerInfo = new PlayerInfo();
				player.beginChanges();
				player.ID = xmllist[i].@UserID;
				player.NickName = xmllist[i].@NickName;
				player.ConsortiaID =  xmllist[i].@ConsortiaID;
				player.ConsortiaName = xmllist[i].@ConsortiaName;
				player.Sex = converBoolean(xmllist[i].@Sex);
				player.WinCount = xmllist[i].@Win;
				player.TotalCount = xmllist[i].@Total;
				player.EscapeCount = xmllist[i].@Escape;
				player.GP = xmllist[i].@GP;
				player.Style = xmllist[i].@Style;
				player.Colors = xmllist[i].@Colors;
				player.Hide = xmllist[i].@Hide;
				player.Grade = xmllist[i].@Grade;
				player.State = xmllist[i].@State;
				player.Repute = xmllist[i].@Repute;
				player.Skin =  xmllist[i].@Skin;
				player.Offer =  xmllist[i].@Offer;
				player.IsMarried = converBoolean(xmllist[i].@IsMarried);
				player.Nimbus =   int(xmllist[i].@Nimbus);
				player.DutyName = xmllist[i].@DutyName;
				player.FightPower = xmllist[i].@FightPower;
				player.AchievementPoint = xmllist[i].@AchievementPoint;
				player.honor = xmllist[i].@Rank;
				
				var civilPlayer:CivilPlayerInfo = new CivilPlayerInfo();
				civilPlayer.UserId = player.ID;
				civilPlayer.MarryInfoID = xmllist[i].@ID;
				civilPlayer.IsPublishEquip = converBoolean(xmllist[i].@IsPublishEquip);
				civilPlayer.Introduction = xmllist[i].@Introduction;
				civilPlayer.IsConsortia = converBoolean(xmllist[i].@IsConsortia);
				civilPlayer.info = player;
				civilMemberList.push(civilPlayer);
				player.commitChanges();
			}
			
			SimpleLoading.instance.hide();
			
//			PlayerManager.Instance.civilPlayerList = civilMemberList;  //bret 09.8.10 playerManage 是存放个人信息的，不能存放民政中心的所有玩家数据
		}
		private function converBoolean(str:String):Boolean
			{
				if(str == "true")
				{
					return true;
				}
				return false;
			}
	}
}