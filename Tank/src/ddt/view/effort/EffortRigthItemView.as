package ddt.view.effort
{
	import crazytank.view.effort.EffortRightItemAsset;
	
	import fl.containers.ScrollPane;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	import road.data.DictionaryData;
	
	import ddt.data.effort.EffortInfo;
	import ddt.data.effort.EffortProgressInfo;
	import ddt.data.effort.EffortQualificationInfo;
	import ddt.data.effort.EffortRewardInfo;
	import ddt.events.EffortEvent;
	import tank.fightLibChooseFightLibTypeView.BookShine;
	import ddt.manager.EffortManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.view.common.VerticalScaleFrame;
	
	public class EffortRigthItemView extends EffortRightItemAsset
	{
		private var _info:EffortInfo;
		private var _rightItemPane:ScrollPane;
		private var _isSelect:Boolean;
		private var _scaleStrip:EffortScaleStrip;
		private var _vertica:VerticalScaleFrame;
		private var _lightVertica:VerticalScaleFrame;
		private var _maskVertica:VerticalScaleFrame;
		private var _effortIcon:EffortIconView;
		private var _maxHeight:int;
		private var _minHeight:int;
		private var myColorMatrix_filter:ColorMatrixFilter;
		private var _achievementPointView:AchievementPointView;
		public function EffortRigthItemView(info:EffortInfo = null)
		{
			super();
			_info = info;
			init();
			initEvent();
		}
		
		private function init():void
		{
			myColorMatrix_filter = new ColorMatrixFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0]);
			_vertica = new VerticalScaleFrame(background.bg_top , background.bg_middle , background.bg_bottom);
			_lightVertica = new VerticalScaleFrame(light_top , light_middle , light_bottom);
			_maskVertica  = new VerticalScaleFrame(mask_top  , mask_middle  , mask_bottom);
			initScaleStrip();
			_isSelect = false;
			initMaxHeight()
			_effortIcon = new EffortIconView(String(_info.picId));
			_effortIcon.x = 5;
			_effortIcon.y = 5;
			addChildAt(_effortIcon,1);
			_achievementPointView   = new AchievementPointView(_info.AchievementPoint)
			_achievementPointView.x = scaleStrip_pos.x;
			_achievementPointView.y = scaleStrip_pos.y;
			addChildAt(_achievementPointView,1);
			_vertica.setHeight(_minHeight);
			_maskVertica.setHeight(_minHeight);
			_lightVertica.setHeight(_minHeight - 3);
			honorName();
			award_txt.y = background.height - award_txt.height - 5;
			if(EffortManager.Instance.isSelf)
			{
				this.buttonMode = true;
			}else
			{
				this.buttonMode = false;
			}
			updateItem();
			setSelectState(false);
			setSelectState(true);
			setLightVisible(false);
		}
		
		public function set info(info:EffortInfo):void
		{
			_info = info;
			updateItem();
		}
		
		private function initEvent():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,__rigthItemOver);
			addEventListener(MouseEvent.MOUSE_OUT,__rigthItemOut);
			if(_info)_info.addEventListener(EffortEvent.CHANGED , __infoChanged);
		}
		
		private function initScaleStrip():void
		{
			if(!_info.CanHide || !EffortManager.Instance.isSelf)return;
			if(_info.EffortQualificationList.length > 1)return;
			var totalValue:int = 0
			for each(var i:EffortQualificationInfo in _info.EffortQualificationList)totalValue = i.Condiction_Para2;
			_scaleStrip = new EffortScaleStrip(totalValue);
			_scaleStrip.setAutoSize(2);
			_scaleStrip.setButtonMode(false);
			_scaleStrip.x = 100;
			_scaleStrip.y = background.height - _scaleStrip.height + 5;
			addChild(_scaleStrip);
			_scaleStrip.visible = false;
		}
		
		private function initMaxHeight():void
		{
			if(_info && _info.effortRewardArray && _info.CanHide && EffortManager.Instance.isSelf)
			{
				_maxHeight = 110;
			}else
			{
				_maxHeight = 88;
			}
			_minHeight = 88;
		}
		
		public function updateItem():void
		{
			if(_info)
			{
				title_txt.htmlText = setText(EffortManager.Instance.splitTitle(_info.Title),0);
				detail_txt.htmlText= setText(_info.Detail,1);
				titleII_txt.htmlText = setText(EffortManager.Instance.splitTitle(_info.Title),3);
				detailII_txt.htmlText= setText(_info.Detail,4);
				var date:Date = new Date();
				if(_info.CompleteStateInfo)date = _info.CompleteStateInfo.CompletedDate;
				if(_info.CompleteStateInfo && EffortManager.Instance.isSelf)
				{
					date_txt.text = String(date.fullYearUTC) + "/" + String(date.monthUTC) + "/" + String(date.dateUTC);
				}else
				{
					date_txt.text = "";
				}
				if(_scaleStrip)_scaleStrip.currentVlaue = getQualificationValue(_info.EffortQualificationList);
				setSelectState(true);
			}
		}
		
		public static function setText(str:String , type:int):String
		{
			var strI:String = "";
			var strII:String = "";
			switch(type)
			{
				case 0:
					strI = "<TEXTFORMAT LEADING='2'><P ALIGN='CENTER'><FONT FACE='宋体' SIZE='15' COLOR='#FFE292' LETTERSPACING='0' KERNING='1'><B>"
					strII = "</B></FONT></P></TEXTFORMAT>"
					break;
				case 1:
					strI = "<TEXTFORMAT LEADING='2'><P ALIGN='CENTER'><FONT FACE='SimSun' SIZE='13' COLOR='#9E7123' LETTERSPACING='0' KERNING='1'><B>"
					strII = "</B></FONT></P></TEXTFORMAT>"
					break;
				case 3:
					strI = "<TEXTFORMAT LEADING='2'><P ALIGN='CENTER'><FONT FACE='宋体' SIZE='15' COLOR='#7E6931' LETTERSPACING='0' KERNING='1'><B>"
					strII = "</B></FONT></P></TEXTFORMAT>"
					break;
				case 4:
					strI = "<TEXTFORMAT LEADING='2'><P ALIGN='CENTER'><FONT FACE='SimSun' SIZE='13' COLOR='#7C4F01' LETTERSPACING='0' KERNING='1'><B>"
					strII = "</B></FONT></P></TEXTFORMAT>"
					break;
			}
			return strI + str + strII;
			
		}
		
		private function honorName():void
		{
			if(_info && _info.effortRewardArray)
			{
				for(var i:int = 0 ; i<_info.effortRewardArray.length;i++ )
				{
					if((_info.effortRewardArray[i] as EffortRewardInfo).RewardType == 1)
					{
						award_txt.htmlText =setText(LanguageMgr.GetTranslation("ddt.view.effort.EffortRigthItemView.honorName") + EffortManager.Instance.splitTitle((_info.effortRewardArray[i] as EffortRewardInfo).RewardPara),0);
						awardII_txt.htmlText =setText(LanguageMgr.GetTranslation("ddt.view.effort.EffortRigthItemView.honorName") + EffortManager.Instance.splitTitle((_info.effortRewardArray[i] as EffortRewardInfo).RewardPara),3);
					}
				}
			}else
			{
				award_txt.text = "";
			}
		}
		
		private function setSelectState(value:Boolean):void
		{
			if(EffortManager.Instance.isSelf)
			{
				if(value)
				{
					if(!_info.CompleteStateInfo)
					{
						setTextVisible(false);
						setMaskVisible(true);
					}else
					{
						setMaskVisible(false);
					}
				}else
				{
					if(!_info.CompleteStateInfo)
					{
						setTextVisible(false);
						setMaskVisible(true);
					}else
					{
						gotoAndStop(4);
						setTextVisible(true);
						setMaskVisible(false);
					}
				}
			}else
			{
				if(value)
				{
					if(!EffortManager.Instance.tempEffortIsComplete(_info.ID))
					{
						setTextVisible(false);
						setMaskVisible(true);
					}else
					{
						setTextVisible(true);
						setMaskVisible(false);
					}
				}else
				{
					if(!EffortManager.Instance.tempEffortIsComplete(_info.ID))
					{
						setTextVisible(false);
						setMaskVisible(true);
					}else
					{
						setTextVisible(true);
						setMaskVisible(false);
					}
				}
			}
		}
		
		private function setTextVisible(value:Boolean):void
		{
			title_txt.visible   =  value;
			award_txt.visible   =  value;
			detail_txt.visible  =  value;
			titleII_txt.visible = !value;
			awardII_txt.visible = !value;
			detailII_txt.visible= !value;
		}
		
		private function setLightVisible(value:Boolean):void
		{
			light_top.visible    = value;
			light_middle.visible = value;
			light_bottom.visible = value;
		}
		
		private function setMaskVisible(value:Boolean):void
		{
			mask_top.visible    = value;
			mask_middle.visible = value;
			mask_bottom.visible = value;
		}
		
		private function getQualificationValue(dic:DictionaryData):int
		{
			for each(var info:EffortQualificationInfo in dic)
			{
				if(info.Condiction_Para2 > info.para2_currentValue)
				{
					return info.para2_currentValue;
				}else
				{
					return info.Condiction_Para2;
				}
			}
			return 0;
		}
		
		private function __infoChanged(evt:Event):void
		{
			updateItem();
		}
		
		public function get currentHeight():int
		{
			return 0;
		}
		private var isOver:Boolean = false;
		private function __rigthItemOver(evt:Event):void
		{
			setSelectState(false);
			setLightVisible(true);
			isOver = true;
		}
		
		private function __rigthItemOut(evt:Event):void
		{
			isOver = false;
			if(!_isSelect)
			{
				setSelectState(true);
				setLightVisible(false);
			}
		}
		
		public function set select(value:Boolean):void
		{
			_isSelect = value;
			update();
		}
		
		public function get select():Boolean
		{
			return _isSelect;
		}
		
		private function update():void
		{
			if(_isSelect)
			{
				setSelectState(false);
				_vertica.setHeight(_maxHeight);
				_lightVertica.setHeight(_maxHeight - 3);
				_maskVertica.setHeight(_maxHeight);
				if(_scaleStrip)_scaleStrip.visible = true;
				setLightVisible(true);
			}else
			{
				setSelectState(true);
				_vertica.setHeight(_minHeight);
				_lightVertica.setHeight(_minHeight - 3);
				_maskVertica.setHeight(_minHeight);
				if(_scaleStrip)_scaleStrip.visible = false;
				if(!isOver)setLightVisible(false);
			}
			updateDisplayObjectPos();
		}
		
		private function updateDisplayObjectPos():void
		{
			if(_scaleStrip)
			{
				_scaleStrip.x = 100;
				if(award_txt.text == "")
				{
					_scaleStrip.y = background.height - _scaleStrip.height + 5;
				}else
				{
					_scaleStrip.y = background.height - _scaleStrip.height - award_txt.height + 5;
					award_txt.y = background.height - award_txt.height - 5;
					awardII_txt.y = award_txt.y;
				}
			}
		}
		
		public function dispose():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER,__rigthItemOver);
			removeEventListener(MouseEvent.MOUSE_OUT,__rigthItemOut);
			if(_info)_info.removeEventListener(EffortEvent.CHANGED , __infoChanged);
			if(this.parent)
			{
				this.parent.removeChild(this);	
			}
			if(_scaleStrip)
			{
				_scaleStrip.parent.removeChild(_scaleStrip);
				_scaleStrip.dispose();
				_scaleStrip = null;
			}
			if(_effortIcon)
			{
				_effortIcon.parent.removeChild(_effortIcon);
				_effortIcon.dispose();
				_effortIcon = null;
			}
			if(_achievementPointView)
			{
				_achievementPointView.parent.removeChild(_achievementPointView);
				_achievementPointView.dispose();
				_achievementPointView = null;
			}
			
		}

	}
}