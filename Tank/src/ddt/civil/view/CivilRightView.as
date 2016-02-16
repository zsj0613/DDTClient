package ddt.civil.view
{
	import ddt.civil.CivilControler;
	import ddt.civil.CivilDataEvent;
	import ddt.civil.CivilModel;
	import ddt.civil.view.CivilPlayerInfoList;
	
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	
	import tank.civil.RightViewAsset;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	
	public class CivilRightView extends RightViewAsset
	{
		private var _controler 		:CivilControler;
		private var _memberList		:CivilPlayerInfoList;
		private var _model     		:CivilModel;
		private var _firstBtn  		:HBaseButton;
		private var _preBtn    		:HBaseButton;
		private var _nextBtn   		:HBaseButton;
		private var _lastBtn   		:HBaseButton;
		private var _registerbtn	:HBaseButton;
		private var _searchBtn		:HBaseButton;
		private var _woManBtn       :HBaseButton;
		private var _manBtn      	:HBaseButton;
		private var _currentPage    :int;
		private var _sex			:Boolean;
		public function CivilRightView(controler:CivilControler,model:CivilModel)
		{
			_controler = controler;
			_model     = model;
			init();
			initEvent();
		}
		
		private function init():void
		{
			_currentPage = 1;
			manBtn.gotoAndStop(1);
			womanBtn.gotoAndStop(1);
			_sex         = true
			
			_firstBtn  =  new HBaseButton(firstBtn);
			initButton(_firstBtn);
			addChild(_firstBtn);
			
			_preBtn  =  new HBaseButton(preBtn);
			initButton(_preBtn);
			addChild(_preBtn);
			
			_nextBtn  =  new HBaseButton(nextBtn);
			initButton(_nextBtn);
			addChild(_nextBtn);
			
			_lastBtn  =  new HBaseButton(lastBtn);
			initButton(_lastBtn);
			addChild(_lastBtn);
			
			_registerbtn  =  new HBaseButton(register_btn);
			initButton(_registerbtn);
			_registerbtn.enable = true;
			addChild(_registerbtn);
			
			_searchBtn  =  new HBaseButton(searchBtn);
			initButton(_searchBtn);
			_searchBtn.enable = true;
			addChild(_searchBtn);
			
			_woManBtn  =  new HBaseButton(womanBtn);
			initButton(_woManBtn);
			_woManBtn.enable = true;
			addChild(_woManBtn);
			
			_manBtn  =  new HBaseButton(manBtn);
			initButton(_manBtn);
			_manBtn.enable  = true
			addChild(_manBtn);
			
			_memberList = new CivilPlayerInfoList(_model);
			_memberList.x = listPos.x;
			_memberList.y = listPos.y;
			addChild(_memberList);
			removeChild(listPos);
		}
		
		private function initEvent():void
		{
			_firstBtn.addEventListener(MouseEvent.CLICK  	 ,__leafBtnClick);
			_preBtn.addEventListener(MouseEvent.CLICK    	 ,__leafBtnClick);
			_nextBtn.addEventListener(MouseEvent.CLICK   	 ,__leafBtnClick);
			_lastBtn.addEventListener(MouseEvent.CLICK   	 ,__leafBtnClick);
			_searchBtn.addEventListener(MouseEvent.CLICK   	 ,__leafBtnClick);
			_woManBtn.addEventListener(MouseEvent.CLICK  	 ,__sexBtnClick);
			_manBtn.addEventListener(MouseEvent.CLICK  		 ,__sexBtnClick);
			_registerbtn.addEventListener(MouseEvent.CLICK   ,__btnClick);
			_model.addEventListener(CivilDataEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE,__updateView);
			_model.addEventListener(CivilDataEvent.CIVIL_UPDATE,__updateView);
			_model.addEventListener(CivilDataEvent.CIVIL_UPDATE_BTN ,__updateRegisterGlow);
		}
		
		private function removeEvent():void
		{
			if(_firstBtn)_firstBtn.removeEventListener(MouseEvent.CLICK  		 ,__leafBtnClick);
			if(_preBtn)_preBtn.removeEventListener(MouseEvent.CLICK    			 ,__leafBtnClick);
			if(_nextBtn)_nextBtn.removeEventListener(MouseEvent.CLICK   	 	 ,__leafBtnClick);
			if(_lastBtn)_lastBtn.removeEventListener(MouseEvent.CLICK   	 	 ,__leafBtnClick);
			if(_searchBtn)_searchBtn.removeEventListener(MouseEvent.CLICK   	 ,__leafBtnClick);
			if(_woManBtn)_woManBtn.removeEventListener(MouseEvent.CLICK  	 	 ,__sexBtnClick);
			if(_manBtn)_manBtn.removeEventListener(MouseEvent.CLICK  		 	 ,__sexBtnClick);
			if(_registerbtn)_registerbtn.removeEventListener(MouseEvent.CLICK    ,__btnClick);
			if(_model)_model.removeEventListener(CivilDataEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE,__updateView);
			if(_model)_model.removeEventListener(CivilDataEvent.CIVIL_UPDATE,__updateView);
			if(_model)_model.removeEventListener(CivilDataEvent.CIVIL_UPDATE_BTN ,__updateRegisterGlow);
		}
		
		private function __btnClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			_controler.Register();
		}
		
		private function __sexBtnClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			_currentPage = 1;
			if(evt.currentTarget == _woManBtn)
			{
				_sex = false;
				if(_sex == _model.sex)return;
				_model.sex = false;
				manBtn.gotoAndStop(2);
				womanBtn.gotoAndStop(2);
			}else
			{
				_sex = true;
				if(_sex == _model.sex)return;
				_model.sex = true;
				manBtn.gotoAndStop(1);
				womanBtn.gotoAndStop(1);	
			}
			search_txt.text = "";
			_sex = _model.sex
			_controler.loadCivilMemberList(_currentPage,_model.sex);
		}
		
		private function __leafBtnClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			switch(evt.currentTarget)
			{
				case _firstBtn:
				{
					_currentPage = 1;
				}
				break;
				case _preBtn:
				{
					_currentPage = --_currentPage;
				}
				break;
				case _nextBtn:
				{
					_currentPage = ++_currentPage;
				}
				break;
				case _lastBtn:
				{
					_currentPage = _model.TotalPage;
				}
				break;
				case _searchBtn:
				{
					if(search_txt.text == "")
					{
//						_controler.loadCivilMemberList(_currentPage,_sex);
						MessageTipManager.getInstance().show("请输入要搜索的名字");
					}
					else
					{
						_controler.loadCivilMemberList(_currentPage,_sex,search_txt.text);
					}
					return;
				}
				break;
			}
			_controler.loadCivilMemberList(_currentPage,_sex);
		}
		
		private function updateButton():void
		{
			
			if(_model.TotalPage == 1)
			{
				setButtonState(false,false);
			}
			else if(_currentPage == 1)
			{
				setButtonState(false,true);
			}
			else if(_currentPage == _model.TotalPage && _currentPage != 0)
			{
				setButtonState(true,false);
			}
			else if(_model.TotalPage == 0)
			{
				setButtonState(false,false);
			}
			else
			{
				setButtonState(true,true);
			}
			
			if(!_model.TotalPage)
			{
				page_txt.htmlText = String(1) + " / " + String(1);
			}
			else
			{
				page_txt.htmlText = String(_currentPage) + " / " + String(_model.TotalPage);
			}
			if(!PlayerManager.Instance.Self.MarryInfoID)
			{
				addChild(registerGlow);
				registerGlow.mouseEnabled = false;
				registerGlow.mouseChildren = false;
			}
			else if(PlayerManager.Instance.Self.MarryInfoID)
			{
				if(registerGlow)registerGlow.visible = false;
			}
			updateSex();
		}
		
		private function updateSex():void
		{
			if(_model.sex)
			{
				manBtn.gotoAndStop(1);
				womanBtn.gotoAndStop(1);	
			}else
			{
				manBtn.gotoAndStop(2);
				womanBtn.gotoAndStop(2);
			}
			_sex = _model.sex;
		}		
		private function __updateRegisterGlow(evt:CivilDataEvent):void
		{
			if(registerGlow)registerGlow.visible = false;
		}
		
		private function setButtonState($pre:Boolean,$next:Boolean):void
		{
			_firstBtn.mouseChildren = $pre;
			_firstBtn.enable = $pre;
			_preBtn.mouseChildren   = $pre;
			_preBtn.enable   = $pre;
			_nextBtn.mouseChildren  = $next;
			_nextBtn.enable  = $next;
			_lastBtn.mouseChildren  = $next;
			_lastBtn.enable  = $next;
		}
		
		private function __updateView(evt:CivilDataEvent):void
		{
			updateButton();
//			updateSex();
		}
			
		private function initButton(btn:HBaseButton):void
		{
			btn.useBackgoundPos = true;
			btn.enable          = false;
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_firstBtn)
			{
				removeChild(_firstBtn);
				_firstBtn.dispose();
			}
			_firstBtn = null;
			if(_preBtn)
			{
				removeChild(_preBtn);
				_preBtn.dispose();
			}
			_preBtn = null;
			if(_preBtn)
			{
				removeChild(_preBtn);
				_preBtn.dispose();
			}
			_preBtn = null;
			if(_nextBtn)
			{
				removeChild(_nextBtn);
				_nextBtn.dispose();
			}
			_nextBtn = null;
			if(_lastBtn)
			{
				removeChild(_lastBtn);
				_lastBtn.dispose();
			}
			_lastBtn = null;
			if(_registerbtn)
			{
				removeChild(_registerbtn);
				_registerbtn.dispose();
			}
			_registerbtn = null;
			if(_searchBtn)
			{
				removeChild(_searchBtn);
				_searchBtn.dispose();
			}
			_searchBtn = null;
			if(_woManBtn)
			{
				removeChild(_woManBtn);
				_woManBtn.dispose();
			}
			_woManBtn = null;
			if(_manBtn)
			{
				removeChild(_manBtn);
				_manBtn.dispose();
			}
			_manBtn = null;
		}

	}
}