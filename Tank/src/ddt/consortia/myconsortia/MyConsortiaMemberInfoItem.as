package ddt.consortia.myconsortia
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import road.manager.SoundManager;
	import road.utils.ComponentHelper;
	
	import tank.consortia.accect.ConsortiaMemberItemAsset;
	import ddt.consortia.event.ConsortiaDataEvent;
	import ddt.data.player.ConsortiaPlayerInfo;
	import ddt.events.PlayerEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.view.common.LevelIcon;

	public class MyConsortiaMemberInfoItem extends ConsortiaMemberItemAsset
	{
		private var _info :ConsortiaPlayerInfo;
		private var _levelIcon:LevelIcon;
		private var _isSelect : Boolean;
		
		/*排序属性字段*/
		public var NickName    : String;
		public var Level       : Number;
		public var Grade       : Number;
		public var Offer       : Number;
//		public var RichesOffer : Number;
//		public var RichesRob   : Number;
		public var battle      : Number;
		public var LastDate    : Number;
		public var offLineHour : int;
		public var _State      : int;
		
		public function MyConsortiaMemberInfoItem()
		{
			super();
			init();
			
		}
		private function init() : void
		{
//			setTextField(this.contributeTxt);
			setTextField(this.memberJobTxt);
//			setTextField(this.memberLevelTxt);
			setTextField(this.memberNameTxt);
			setTextField(this.offlineTxt);
//			setTextField(this.plunderTxt);
			setTextField(this.fightingCapacityText);
			setTextField(this.profferDegreeTxt);
			this.selectEffectAsset.visible = false; 
			this.itemBgAsset.gotoAndStop(1);
			_levelIcon = new LevelIcon("s",1,0,0,0,0);
			_isSelect = false;
			_levelIcon.visible = false;
			ComponentHelper.replaceChild(this,levelPos,_levelIcon);
			buttonMode = false;
			
			
		}
		
		private function __online(e:PlayerEvent):void {
			upView();	
		}
		
		private function addEvent() : void
		{
			this.addEventListener(MouseEvent.CLICK, __onItmeClickHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER,  __mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT ,  __mouseOutHandler);
			//_info.addEventListener(PlayerEvent.ONLINE, __online);
			buttonMode = true;
		}
		public function set info(o : ConsortiaPlayerInfo) : void
		{
			this._info  = o;
			if(_info.info.ID > (int.MAX_VALUE - 10))return;
			upView();
			addEvent();
		}
		public function get info() : ConsortiaPlayerInfo
		{
			return this._info;
		}
		
		private function __mouseOverHandler(evt : MouseEvent) : void
		{
			this.selectEffectAsset.visible = true;
		}
		private function __mouseOutHandler(evt : MouseEvent) : void
		{
			this.selectEffectAsset.visible = _isSelect;
		}
	
		
		private function upView() : void
		{
            NickName = _info.NickName;
            Grade    = Number(_info.Grade);
            Level    = Number(_info.info.DutyLevel);
//            Offer    = Number(_info.info.Offer);
            Offer    = Number(_info.info.RichesRob + _info.info.RichesOffer);
			battle   = Number(_info.info.FightPower);
//            RichesOffer = Number(_info.info.RichesOffer);
//            RichesRob = Number(_info.info.RichesRob);
            _State = _info.State;
            
//            var dateArr : Array = solveDate(_info.LastDate).split("-");
//            LastDate = Number(dateArr[0])*10000 + Number(dateArr[1])*100 + Number(dateArr[2]);
//            LastDate = _State ? 999999 : LastDate;
            
			this.memberJobTxt.text    = _info.DutyName;
			_levelIcon.level = _info.Grade;
			_levelIcon.setRepute(_info.info.Repute);
			_levelIcon.setRate(_info.info.WinCount,_info.info.TotalCount);
			_levelIcon.Battle = _info.info.FightPower;
			_levelIcon.visible = true;
			_levelIcon.stop();
			this.memberNameTxt.text   = _info.NickName;
			/* 玩家是否在线 */
			//if(_State)this.offlineTxt.text  = "在 线";
			if(_State || _info.NickName == PlayerManager.Instance.Self.NickName) {
				offLineHour = 0;
				this.offlineTxt.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.MyConsortiaMemberInfoItem.offlineTxt");	
			}
			else {
				if(_info.CurrentDate) {
//					_info.LastDate = "2010-07-22 10:46:24"; //测试数据
//					_info.CurrentDate="7/22/2010 3:53:37 PM";
					this.offlineTxt.text = solveDate(_info.LastDate, _info.CurrentDate);
				}
				if(offLineHour > 720) {
					this.offlineTxt.text = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.MyConsortiaMemberInfoItem.long");
				}
			} 
			this.fightingCapacityText.text = String(_info.info.FightPower);
//			this.plunderTxt.text      = String(_info.info.RichesRob);
//			this.profferDegreeTxt.text= String(_info.RichesOffer);
//			this.contributeTxt.text = String(_info.info.RichesOffer);
//            var proffer : int =  _info.info.RichesRob + _info.info.RichesOffer
            
			this.profferDegreeTxt.text = String(Offer);
		}
		
		
		private function __onItmeClickHandler(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			this.dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.SELECT_CLICK_ITEM,this));
		}
		
		private function setTextField(txt : TextField) : void
		{
			txt.selectable = false;
			txt.mouseEnabled = false;
			txt.text = "";
		}
		
		private function solveDate(date:String, currentDate:String) : String
		{
			var str : String = "";
			var totalHours:int = 0;
			
			var oldDate:Date = dealWithStringDate(date);
			var nowDate:Date = dealWithStringDate(currentDate);
			var hours:int = (nowDate.valueOf() - oldDate.valueOf())/3600000;
			totalHours = hours < 1 ? 1 : hours ;
			
			str += totalHours;
			offLineHour = totalHours;
			str += LanguageMgr.GetTranslation("hours");
			return str;
		}
		
		private function dealWithStringDate(date:String):Date {
			var h:int = 0;
			var d:int = 0;
			var m:int = 0;
			var y:int = 0;
			if(date.indexOf("-") > 0) {
				h = parseInt(date.split(" ")[1].split(":")[0]);
				d = parseInt(date.split(" ")[0].split("-")[2]);
				m = parseInt(date.split(" ")[0].split("-")[1]) - 1;
				y = parseInt(date.split(" ")[0].split("-")[0]);
			}
			if(date.indexOf("/") > 0) {
				if(date.indexOf("PM") > 0) {
					h = parseInt(date.split(" ")[1].split(":")[0]) + 12;
				}
				else {
					h = parseInt(date.split(" ")[1].split(":")[0]);
				}
				d = parseInt(date.split(" ")[0].split("/")[1]);
				m = parseInt(date.split(" ")[0].split("/")[0]) - 1;
				y = parseInt(date.split(" ")[0].split("/")[2]);
			}
			
			var realDate:Date = new Date(y,m,d,h);
			return realDate;
		}
		
		
		internal function isSelelct(b : Boolean) : void
		{
			this.selectEffectAsset.visible = _isSelect = b;
		}
		private function removeEvent() : void
		{
			this.removeEventListener(MouseEvent.CLICK, __onItmeClickHandler);
			this.removeEventListener(MouseEvent.MOUSE_OVER,  __mouseOverHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT ,  __mouseOutHandler);
		}
		internal function dispose() : void
		{
			removeEvent();
			_info = null;
			if(_levelIcon)_levelIcon.dispose();
			_levelIcon = null;
			if(this.parent)this.parent.removeChild(this);
		}
		
	}
}