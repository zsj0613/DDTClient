package ddt.request
{
	import flash.events.Event;
	
	import road.ui.controls.hframe.HAlertDialog;
	
	import ddt.data.AccountInfo;
	import ddt.loader.RequestLoader;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ShopManager;

	public class RegisterCharacter extends RequestLoader
	{
		public static const REGISTER_COMPLETE:String = "registercomplete";
		public static const ERROR:String = "registererror";
		private static const PATH:String = "VisualizeRegister.ashx";
		public var registerSucceed : Boolean;
		
		private var _acc:AccountInfo;
		private var _nickName:String;
		public function RegisterCharacter(acc:AccountInfo,Sex:Boolean,NickName:String,arm:String,hair:String,face:String,cloth:String,armID:String,hairID:String,faceID:String,clothID:String)
		{
			_acc = acc;
			_nickName = NickName;
			super(PATH,{Sex:Sex,Name:_acc.Account,Pass:_acc.Password,Sex:Sex,NickName:NickName,Arm:arm,Hair:hair,Face:face,Cloth:cloth,ArmID:armID,HairID:hairID,FaceID:faceID,ClothID:clothID,site:PathManager.solveConfigSite()});
		}
		
		override protected function onRequestReturn(xml:XML):void
		{
			var result:String = xml.@value;
			if(result != "true")
			{
				PlayerManager.registerSucceed = false;
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),xml.@message,true);
				isSuccess = false;
				dispatchEvent(new Event(ERROR));
			}
			else
			{
				PlayerManager.registerSucceed = true;
				new LoginAction(PlayerManager.Instance.Account,_nickName).loadSync(__complete);
			}
		}
		
		private function __complete(loader:LoginAction):void
		{
			if(ItemManager.Instance.goodsTemplates == null)
			{
				ItemManager.Instance.addEventListener("templateReady",__waitItemTemplate);
			}
			else
			{
				__waitItemTemplate(null);
			}
		}
		
		private function __waitItemTemplate(event:Event):void
		{
			if(ShopManager.Instance.initialized == false)
			{
				ShopManager.Instance.addEventListener("shopManagerReady",__waitForShopGoods);
			}else
			{
				createView();
			}
		}
		
		private function __waitForShopGoods():void
		{
			createView();
		}
		
		private function createView():void
		{
			dispatchEvent(new Event(REGISTER_COMPLETE));
		}
	}
}