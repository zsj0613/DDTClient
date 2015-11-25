package ddt.manager
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.sendToURL;
	
	import ddt.view.chatsystem.ChatChannelListView;
	import ddt.view.chatsystem.ChatData;

	/**
	 *  1．加入彈彈堂“serviceName”，你也快來與他(她)並肩作戰啦～
		接口访问：
		URL?op=1&uid=XX&role=roleName&ser= serviceName
		
		2．在彈彈堂“serviceName”已經達到“N”級
		接口访问：
		URL?op=2&uid=XX&role=roleName&ser= serviceName&num=N
		
		3．在彈彈堂“serviceName”把裝備提升到了+ “N” 
		接口访问：
		URL?op=3&uid=XX&role=roleName&ser= serviceName&num=N
		
		4．在彈彈堂“serviceName”中建立了公會：“pname(公會名字
		)”
		接口访问：
		URL?op=4&uid=XX&role=roleName&ser= serviceName&pn= pname
		
		5．在彈彈堂“serviceName”中加入了公会：“pname(公会名字)”
		接口访问：
		URL?op=5&uid=XX&role=roleName&ser= serviceName&pn= pname
		
		7．在彈彈堂“serviceName”中佳偶天成~大家快來祝賀一下。
		接口访问：
		URL?op=7&uid=XX&role=roleName&ser= serviceName&role2=roleName2
		这个由客户端做没有问题.
		
		
		8．在彈彈堂“serviceName”結婚禮堂舉行婚禮~大家快去祝福吧！
		接口访问：
		URL?op=8&uid=XX&role=roleName&ser= serviceName&role2=roleName2
		这个由客户端做没有问题.
		
		
		9．在彈彈堂“serviceName”通過了“pname(副本名稱)”， 掌聲鼓掌一下！！
		接口访问：
		URL?op=9&uid=XX&role=roleName&ser= serviceName &pn= pname
		这个由客户端做没有问题.
		
		
		10．在彈彈堂“serviceName”中的挑戰賽獲得了勝利！
		接口访问： 
		URL?op=10&uid=XX&role=roleName&ser= serviceName
		这个由客户端做没有问题.
	 * @author wickiLA
	 * 
	 */	
	
	public class ExternalInterfaceManager
	{
		private static var loader:URLLoader;
		public function ExternalInterfaceManager()
		{
		}
		/**
		 * 
		 * @param op 操作类型
		 * @param userID 玩家ID
		 * @param nickName 玩家昵称
		 * @param serverName 服务器名
		 * @param num 数量
		 * @param pName 其他的名字（ex：公会名，副本名etc）
		 * 
		 */		
		public static function sendToAgent(op:int,userID:int=-1,nickName:String="",serverName:String="",num:int=-1,pName:String="",nickName2:String=""):void
		{
			var ur:URLRequest = new URLRequest(PathManager.solveExternalInterfacePath());
			var variable:URLVariables = new URLVariables();
			variable["op"]=op;
			if(userID > -1) variable["uid"] = userID;
			if(nickName!="") variable["role"] = nickName;
			if(serverName != "") variable["ser"] = serverName;
			if(num > -1) variable["num"] = num;
			if(pName != "") variable["pn"] = pName;
			if(nickName2 != "") variable["role2"] = nickName2;
			ur.data = variable;
			sendToURL(ur);
//			loader = new URLLoader();
//			loader.addEventListener(Event.COMPLETE,completeHandler);
//			loader.load(ur);
		}
		
//		private static function completeHandler(evt:Event):void
//		{
//			var cd:ChatData = new ChatData();
//			cd.msg = String(loader.data);
//			ChatManager.Instance.chat(cd);
//		}
	}
}