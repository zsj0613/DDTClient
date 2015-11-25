package ddt.request
{
	import flash.events.TimerEvent;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	


	import ddt.data.ConsortiaInfo;
	import ddt.loader.RequestLoader;
	import ddt.view.common.SimpleLoading;

	public class LoadConsortiaAllyList extends RequestLoader
	{
		private static const PATH:String = "ConsortiaAllyList.ashx";
		
		public var list:Array;
		public var totalCount:int;
		public var page:int;
		public var count:int;
		/**
		 * 
		 * @param consortiaID
		 * @param state  0:中立，1：友好，2：敌对
		 * @param order
		 * @param page
		 * @param size
		 * 
		 */	
		 private var descriptTypeTime:Timer;	
		public function LoadConsortiaAllyList(consortiaID:int,state:int = -1,order:int = -1,page:int = 1,size:int = 10000,name:String="")
		{
			var paras:URLVariables = new URLVariables();
			this.page = page;
			this.count = size;
			paras["page"] = page;
			paras["size"] = size;
			paras["order"] = order;
			paras["consortiaID"] = consortiaID;
			paras["state"] = state;
			paras["name"] = name;
			paras["rnd"] = Math.random();
			super(PATH,paras);
//			SimpleLoading.instance.show();
		}
		private var currentIndex:int = 0;
		private var xmllist:XMLList;
		override protected function onCompleted():void
		{
			var xml:XML = new XML(content);
			list = new Array();
			totalCount = int(xml.@total);
			xmllist = XML(xml)..Item;
			descriptTypeTime = new Timer(30);
			descriptTypeTime.addEventListener(TimerEvent.TIMER,startDescriptType);
			descriptTypeTime.start();
		}
		
		private function startDescriptType(e:TimerEvent = null):void
		{
			for(var i:int = 0; i < 50; i++)
			{
				if(currentIndex >= xmllist.length())
				{
					descriptTypeTime.removeEventListener(TimerEvent.TIMER,startDescriptType);
					descriptTypeTime.stop();
					_func(this);
					SimpleLoading.instance.hide();
					return;
				}
				var info:ConsortiaInfo = new ConsortiaInfo();
				info.ChairmanName=xmllist[currentIndex].@ChairmanName;
				info.ConsortiaID=xmllist[currentIndex].@ConsortiaID;
				info.ConsortiaName=xmllist[currentIndex].@ConsortiaName;
				info.Count=xmllist[currentIndex].@Count;
				info.Honor=xmllist[currentIndex].@Honor;
				info.State=xmllist[currentIndex].@State;
				info.Level=int(xmllist[currentIndex].@Level);
				info.IsApply= (xmllist[currentIndex].@IsApply != "false");
				info.Description=xmllist[currentIndex].@Description;
				info.Riches=int(xmllist[currentIndex].@Riches);
				info.Repute=int(xmllist[currentIndex].@Repute);
				list.push(info);
				currentIndex++;
			}

		}
		
	}
}