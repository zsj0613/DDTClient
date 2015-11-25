package ddt.request.email
{
	import flash.utils.describeType;
	
	import road.serialize.xml.XmlSerialize;
	import road.utils.MD5;
	
	import ddt.data.EmailInfo;
	import ddt.data.EmailInfoOfSended;
	import ddt.data.PathInfo;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.loader.CompressTextLoader;
	import ddt.manager.ItemManager;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
		;
	public class GetEmailAction extends CompressTextLoader
	{
		public var list:Array;
		public static var PATH_ALL:String="UserMail.ashx";
		public static var PATH_SENDED:String="MailSenderList.ashx";
		private var _type:String;
		
		public function GetEmailAction(id:int, type:String)
		{
			_type=type;
			var mailKey:String = MD5.hash(PlayerManager.Instance.Account.Password);
			super(PathManager.solveRequestPath(_type), {id: id,key:mailKey,rnd:Math.random()});
		}

		override protected function onTextReturn(xml:String):void
		{
			list=new Array();
			if (_type == PATH_ALL)
			{
				parseMails(new XML(xml));
			}
			else if (_type == PATH_SENDED)
			{
				parseSendedMails(new XML(xml));
			}
			list.sortOn("SendTime").reverse();
			super.onTextReturn(xml);
		}

		private function parseSendedMails(xml:XML):void
		{
			var xmllist:XMLList=xml.Item;
			var ecInfo:XML=describeType(new EmailInfoOfSended());
			for (var i:int=0; i < xmllist.length(); i++)
			{
				var info:EmailInfoOfSended=XmlSerialize.decodeType(xmllist[i], EmailInfoOfSended, ecInfo);
				list.push(info);
			}
		}

		private function parseMails(xml:XML):void
		{
			var xmllist:XMLList=xml.Item;
			var ecInfo:XML=describeType(new EmailInfo());
			var icInfo:XML=describeType(new InventoryItemInfo());
			for (var i:int=0; i < xmllist.length(); i++)
			{
				var info:EmailInfo=XmlSerialize.decodeType(xmllist[i], EmailInfo, ecInfo);
				var subXmllist:XMLList=xmllist[i].Item;
				for (var j:int=0; j < subXmllist.length(); j++)
				{
					var temp:InventoryItemInfo;
					temp=XmlSerialize.decodeType(subXmllist[j], InventoryItemInfo, icInfo);
					 var itemInfo:InventoryItemInfo = ItemManager.fill(temp);
					var aaa:Number=getAnnexPos(info, temp);
					info["Annex" + getAnnexPos(info, temp)]=temp;
					info.UserID = itemInfo.UserID;
				}
				list.push(info);
			}
		}

		/**
		 * 得到附件位置
		 *
		 */
		private function getAnnexPos(info:EmailInfo, itempInfo:InventoryItemInfo):int
		{
			for (var i:uint=1; i <= 5; i++)
			{
				if (info["Annex" + i + "ID"] == itempInfo.ItemID)
				{
					return i;
				}
			}
			return 1;
		}

	}
}