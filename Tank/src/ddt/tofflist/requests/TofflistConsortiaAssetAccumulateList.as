package ddt.tofflist.requests
{
	/**公会，等级，累积财富***/
	import flash.utils.describeType;
	import ddt.manager.PathManager;
	
	import road.serialize.xml.XmlSerialize;
	
	import ddt.loader.CompressTextLoader;
	import ddt.tofflist.TofflistModel;
	import ddt.tofflist.data.TofflistConsortiaData;
	import ddt.tofflist.data.TofflistConsortiaInfo;
	import ddt.tofflist.data.TofflistPlayerInfo;
	import ddt.data.PathInfo;
	public class TofflistConsortiaAssetAccumulateList extends CompressTextLoader
	{
		public var list: Array;
		private var _xml: XML;
		private static const PATH:String = "CelebByConsortiaRiches.xml";
		private var _path:String;
		public function TofflistConsortiaAssetAccumulateList(path:String = "CelebByConsortiaRiches.xml")
		{
			_path = path;
			super(PathManager.solveXMLPath()+_path+"?"+Math.random());
		}
		override protected function onTextReturn(txt:String):void
		{
			_xml = new XML(content);
			list = new Array();
			
			TofflistModel.Instance.lastUpdateTime = _xml.@date;
			
			var xmllist:XMLList = XML(_xml).Item;
			var _tempInfo:TofflistPlayerInfo = new TofflistPlayerInfo();
			var _xmlInfo:XML = describeType(_tempInfo);
			for(var i:int = 0; i < xmllist.length(); i++)
			{
				var info : TofflistConsortiaData = new TofflistConsortiaData();
				info.consortiaInfo = XmlSerialize.decodeType(xmllist[i],TofflistConsortiaInfo);
				
				if(xmllist[i].children().length() > 0)
				{
					var p:TofflistPlayerInfo= new TofflistPlayerInfo();
					p.beginChanges();
					XmlSerialize.decodeObject(xmllist[i].Item[0],p);
					p.commitChanges();
					info.playerInfo = p;
					list.push(info);
				}
				
			}
			
			if(_func != null)
			{
				_func(this);
			}
		}

	}
}