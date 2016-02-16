package ddt.view.feedback
{
	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;
	import fl.controls.TextArea;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.feedback.feedbackQuestionContentAsset;
	import game.crazyTank.view.feedback.feedbackSubmitViewAsset;
	
	import road.data.DictionaryData;
	import road.ui.controls.HButton.ToggleButtonGroup;
	import road.ui.controls.HButton.TogleButton;
	import road.ui.controls.HButton.togleButtonAsset;
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	import road.utils.ComponentHelper;
	import road.utils.StringHelper;
	
	import ddt.data.feedback.FeedbackInfo;
	import ddt.events.FeedbackDropDownItemEvent;
	import ddt.loader.RequestLoader;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.request.feedback.LoadFeedbackSubmit;
	
	import webgame.crazytank.game.view.task.BgAsset;
	
	public class FeedbackSubmitView extends HConfirmFrame
	{
		private var _feedbackInfo:FeedbackInfo;
		private var _feedbackSubmitViewAsset:feedbackSubmitViewAsset;
		private var _loadFeedbackSubmit:LoadFeedbackSubmit;
		private var _feedbackDropDownView:FeedbackDropDownView;
		private var _occurrenceDateYearDropDownView:FeedbackDropDownView;
		private var _occurrenceDateMonthDropDownView:FeedbackDropDownView;
		private var _occurrenceDateDayDropDownView:FeedbackDropDownView;
		private var _questionTypeValue:int=1;//最终选中的问题类型项编号
		private var _questionContentAsset:feedbackQuestionContentAsset;//内容填写框
		private var _panel:ScrollPane;
		private var _questionContent:TextArea;//详细描述填写框
		private var _exemptionContent:TextArea;//用与道具消失问题的免责声明的内容框
		private var _tbgActivityIsError:ToggleButtonGroup;//咨询活动相关，活动是否异常单选组
		private var _rbtnActivityIsErrorYes:TogleButton;
		private var _rbtnActivityIsErrorNo:TogleButton;
		private var _feedbackContactView:FeedbackContactView;
		private var _exemptionContentText:String="<b>被盗返还标准：</b><br>" +
			"<b>A类：充值＜4W点券，且等级＜30级玩家群体</b><br>" +
			"	1、返还：武器、衣服、帽子、手镯、戒指（原属性）项链、翅膀、套装，以上物品全部按照7天返还。<br><br>" +
			"	2、未绑定物品被转移与点券丢失不予处理。<br><br>" +
			"	3、任务物品乔尼币与勋章被卖按原数返还。<br><br>" +
			"<b>B类：充值≥4W点券，且等级≥20级：</b><br>" +
			"	1、返还：武器、衣服、帽子、手镯、戒指（原属性）项链、翅膀、套装，以上物品全部按照7天返还。<br><br>" +
			"	2、未绑定物品被转移，若还未进行消耗，则可进行删除被盗物品并补发被盗人操作，同时对被盗物品持有人进行3天时间封号处理。若已经进行消耗，则不予补偿，点券同理。<br><br>" +
			"	3、任务物品乔尼币与勋章被卖按原数返还。<br><br>";
		
		/**
		 * 提交问题类型 
		 * [1, "咨询游戏问题"]:1=系统内置问题类型编号，"咨询游戏问题"=问题类型名称
		 */		
		private var _questionTypeArray:Array = [
			[1, "咨询游戏问题"]
			,[2, "咨询活动相关"]
			,[3, "物品道具异常消失类"]
			,[4, "物品道具被盗消失类"]
			,[5, "充值卡类"]
			,[6, "建议反馈"]
			,[7, "BUG信息反馈"]			
			,[8, "举报非法"]			
			,[9, "服务投诉"]			
			,[10, "其它"]
		];
		
		/**
		 * 提交问题类型数据集
		 */		
		private var _questionTypeData:DictionaryData;
		
		/**
		 *发生时间 -年数据集
		 */		
		private var _occurrenceDateYearData:DictionaryData;
		
		/**
		 *发生时间 -月数据集
		 */		
		private var _occurrenceDateMonthData:DictionaryData;
		
		/**
		 *发生时间 -日数据集
		 */		
		private var _occurrenceDateDayData:DictionaryData;
		
		public function FeedbackSubmitView()
		{
			initialize();
		}
		
		/**
		 * 初始化运行
		 */		
		protected function initialize():void
		{
			this.okFunction = confirmSubmit;
			this.cancelFunction=cancelSubmit;
			this.closeCallBack=cancelSubmit;
			
			this.titleText="弹弹堂意见反馈";
			this.okLabel="提交";
			this.cancelLabel="关闭"
			this.centerTitle = true;
			this.blackGound = false;
			this.alphaGound = false;
			this.moveEnable = false;
			this.fireEvent = false;
			this.showBottom = true;
			this.showClose = true;
			this.buttonGape = 100;
			this.setContentSize(307,390);
			this.stopKeyEvent=true;
			
			_feedbackSubmitViewAsset=new feedbackSubmitViewAsset();
			addChild(_feedbackSubmitViewAsset);
			
			_exemptionContent=new TextArea();
			_exemptionContent.htmlText=_exemptionContentText;
			_exemptionContent.editable=false;
			_questionContentAsset=new feedbackQuestionContentAsset();
			_questionContent=new TextArea();
			_questionContent.maxChars=500;
			_feedbackSubmitViewAsset.questionType.questionTypeBase.txtQuestionTitle.maxChars=20;
			var textFormat:TextFormat = new TextFormat();
			textFormat.size=14;
			_questionContent.setStyle("textFormat",textFormat);
			_exemptionContent.setStyle("textFormat",textFormat);
			_questionContent.x=_questionContentAsset.txtQuestionContent.x;
			_questionContent.y=_questionContentAsset.txtQuestionContent.y;
			_questionContent.height=_questionContentAsset.txtQuestionContent.height;
			_questionContent.width=_questionContentAsset.txtQuestionContent.width;
			
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0x000000,0);
			bg.graphics.drawRect(0,0,10,10);
			bg.graphics.endFill();
			_questionContent.setStyle("upSkin",bg);
			_exemptionContent.setStyle("upSkin",bg);
			_questionContentAsset.addChild(_questionContent);
			if(_questionContentAsset.txtQuestionContent.parent) _questionContentAsset.txtQuestionContent.parent.removeChild(_questionContentAsset.txtQuestionContent);
			
			_panel=new ScrollPane();
			var myBg:Shape = new Shape();
			myBg.graphics.beginFill(0x000000,0);
			myBg.graphics.drawRect(0,0,10,10);
			myBg.graphics.endFill();
			_panel.setStyle("upSkin",myBg);
			_panel.width=310;
			_panel.height=328;
			_panel.x=_feedbackSubmitViewAsset.questionType.x;
			_panel.y=_feedbackSubmitViewAsset.questionType.y;
			_panel.horizontalScrollPolicy = ScrollPolicy.OFF;
			_panel.source=_feedbackSubmitViewAsset.questionType;
			_feedbackSubmitViewAsset.addChild(_panel);
			
			setQuestionTypeView();
			setEvent();
		}
		
		/**
		 *设置不同问题类型的视图相关数据
		 */	
		private function setQuestionTypeView():void
		{
			setQuestionTypeData();
			setOccurrenceDateData();
			getQuestionTypeView();
			
			_feedbackSubmitViewAsset.questionType.gotoAndStop(1);
			_feedbackSubmitViewAsset.questionType.dropQuestionType.buttonMode=true;
			_feedbackSubmitViewAsset.btnContact.buttonMode=_feedbackSubmitViewAsset.questionType.questionTypeBase.dropOccurrenceDateYear.buttonMode=_feedbackSubmitViewAsset.questionType.questionTypeBase.dropOccurrenceDateMonth.buttonMode=_feedbackSubmitViewAsset.questionType.questionTypeBase.dropOccurrenceDateDay.buttonMode=true;
		}
		
		/**
		 *设置问题类型数据 
		 */		
		private function setQuestionTypeData():void
		{
			_questionTypeData=new DictionaryData();
			for(var i:int=0;i<_questionTypeArray.length;i++)
			{
				var questionType:Object=new Object();
				questionType.value=_questionTypeArray[i][0];
				questionType.text=_questionTypeArray[i][1];
				_questionTypeData.add(_questionTypeArray[i][0], questionType);
			}
		}
		
		/**
		 *设置发生时间数据 
		 */		
		private function setOccurrenceDateData():void
		{
			var object:Object;
			
			//年
			_occurrenceDateYearData=new DictionaryData();
			var year:Number=new Date().getFullYear();
			for(var y:int=year-2;y<=year;y++)
			{
				object=new Object();
				object.value=y.toString();
				object.text=y.toString();
				_occurrenceDateYearData.add(object.value, object);
			}
			
			//月
			_occurrenceDateMonthData=new DictionaryData();
			for(var m:int=1;m<=12;m++)
			{
				object=new Object();
				object.value=m.toString();
				object.text=m.toString();
				_occurrenceDateMonthData.add(object.value, object);
			}
			
			//日
			_occurrenceDateDayData=new DictionaryData();
			for(var d:int=1;d<=31;d++)
			{
				object=new Object();
				object.value=d.toString();
				object.text=d.toString();
				_occurrenceDateDayData.add(object.value, object);
			}
		}
		
		private function setEvent():void
		{
			//问题类型下拉
			_feedbackSubmitViewAsset.questionType.dropQuestionType.addEventListener(MouseEvent.CLICK, onQuestionTypeClick);
			_feedbackSubmitViewAsset.questionType.questionTypeBase.dropOccurrenceDateYear.addEventListener(MouseEvent.CLICK, onOccurrenceDateYearClick);
			_feedbackSubmitViewAsset.questionType.questionTypeBase.dropOccurrenceDateMonth.addEventListener(MouseEvent.CLICK, onOccurrenceDateMonthClick);
			_feedbackSubmitViewAsset.questionType.questionTypeBase.dropOccurrenceDateDay.addEventListener(MouseEvent.CLICK, onOccurrenceDateDayClick);
			_feedbackSubmitViewAsset.btnContact.addEventListener(MouseEvent.CLICK, openContactView);
		}
		
		/**
		 * 问题类型下拉 
		 */		
		private function onQuestionTypeClick(event:MouseEvent):void
		{
			if(_feedbackDropDownView)
			{
				_feedbackDropDownView.removeEventListener(FeedbackDropDownItemEvent.SELECTED, feedbackDropDownItemSelected);
				if(_feedbackDropDownView.parent) _feedbackDropDownView.parent.removeChild(_feedbackDropDownView);
				_feedbackDropDownView=null;
			}
			else
			{
				_feedbackDropDownView=new FeedbackDropDownView(_questionTypeData, 197, 22);
				_feedbackDropDownView.setSize(197, 110);
				_feedbackDropDownView.addEventListener(FeedbackDropDownItemEvent.SELECTED, feedbackDropDownItemSelected);
				_feedbackDropDownView.x=_feedbackSubmitViewAsset.questionType.dropQuestionType.x;
				_feedbackDropDownView.y=_feedbackSubmitViewAsset.questionType.dropQuestionType.y + _feedbackSubmitViewAsset.questionType.dropQuestionType.height;;
				_feedbackSubmitViewAsset.questionType.addChild(_feedbackDropDownView);
			}
		}
		
		/**
		 *发生时间-年下拉 
		 */		
		private function onOccurrenceDateYearClick(event:MouseEvent):void
		{
			if(_occurrenceDateYearDropDownView)
			{
				_occurrenceDateYearDropDownView.removeEventListener(FeedbackDropDownItemEvent.SELECTED, occurrenceDateYearDropDownSelected);
				if(_occurrenceDateYearDropDownView.parent) _occurrenceDateYearDropDownView.parent.removeChild(_occurrenceDateYearDropDownView);
				_occurrenceDateYearDropDownView=null;
			}
			else
			{
				_occurrenceDateYearDropDownView=new FeedbackDropDownView(_occurrenceDateYearData, 72, 21);
				_occurrenceDateYearDropDownView.setSize(72, 63);
				_occurrenceDateYearDropDownView.addEventListener(FeedbackDropDownItemEvent.SELECTED, occurrenceDateYearDropDownSelected);
				_occurrenceDateYearDropDownView.x=_feedbackSubmitViewAsset.questionType.questionTypeBase.dropOccurrenceDateYear.x;
				_occurrenceDateYearDropDownView.y=_feedbackSubmitViewAsset.questionType.questionTypeBase.dropOccurrenceDateYear.y + _feedbackSubmitViewAsset.questionType.questionTypeBase.dropOccurrenceDateYear.height;;
				_feedbackSubmitViewAsset.questionType.questionTypeBase.addChild(_occurrenceDateYearDropDownView);
			}	
		}
		
		/**
		 *发生时间-月下拉 
		 */		
		private function onOccurrenceDateMonthClick(event:MouseEvent):void
		{
			if(_occurrenceDateMonthDropDownView)
			{
				_occurrenceDateMonthDropDownView.removeEventListener(FeedbackDropDownItemEvent.SELECTED, occurrenceDateMonthDropDownSelected);
				if(_occurrenceDateMonthDropDownView.parent) _occurrenceDateMonthDropDownView.parent.removeChild(_occurrenceDateMonthDropDownView);
				_occurrenceDateMonthDropDownView=null;
			}
			else
			{
				_occurrenceDateMonthDropDownView=new FeedbackDropDownView(_occurrenceDateMonthData, 72, 21);
				_occurrenceDateMonthDropDownView.setSize(72, 110);
				_occurrenceDateMonthDropDownView.addEventListener(FeedbackDropDownItemEvent.SELECTED, occurrenceDateMonthDropDownSelected);
				_occurrenceDateMonthDropDownView.x=_feedbackSubmitViewAsset.questionType.questionTypeBase.dropOccurrenceDateMonth.x;
				_occurrenceDateMonthDropDownView.y=_feedbackSubmitViewAsset.questionType.questionTypeBase.dropOccurrenceDateMonth.y + _feedbackSubmitViewAsset.questionType.questionTypeBase.dropOccurrenceDateMonth.height;;
				_feedbackSubmitViewAsset.questionType.questionTypeBase.addChild(_occurrenceDateMonthDropDownView);
			}
		}
		
		/**
		 *发生时间-日下拉 
		 */		
		private function onOccurrenceDateDayClick(event:MouseEvent):void
		{
			if(_occurrenceDateDayDropDownView)
			{
				_occurrenceDateDayDropDownView.removeEventListener(FeedbackDropDownItemEvent.SELECTED, occurrenceDateDayDropDownSelected);
				if(_occurrenceDateDayDropDownView.parent) _occurrenceDateDayDropDownView.parent.removeChild(_occurrenceDateDayDropDownView);
				_occurrenceDateDayDropDownView=null;
			}
			else
			{
				_occurrenceDateDayDropDownView=new FeedbackDropDownView(_occurrenceDateDayData, 72, 21);
				_occurrenceDateDayDropDownView.setSize(72, 110);
				_occurrenceDateDayDropDownView.addEventListener(FeedbackDropDownItemEvent.SELECTED, occurrenceDateDayDropDownSelected);
				_occurrenceDateDayDropDownView.x=_feedbackSubmitViewAsset.questionType.questionTypeBase.dropOccurrenceDateDay.x;
				_occurrenceDateDayDropDownView.y=_feedbackSubmitViewAsset.questionType.questionTypeBase.dropOccurrenceDateDay.y + _feedbackSubmitViewAsset.questionType.questionTypeBase.dropOccurrenceDateDay.height;;
				_feedbackSubmitViewAsset.questionType.questionTypeBase.addChild(_occurrenceDateDayDropDownView);
			}
		}
		
		/**
		 *问题类型已选中项 
		 */		
		private function feedbackDropDownItemSelected(event:FeedbackDropDownItemEvent):void
		{
			if(_feedbackDropDownView)
			{
				if(_feedbackDropDownView.parent) _feedbackDropDownView.parent.removeChild(_feedbackDropDownView);
				_feedbackDropDownView=null;
			}
			
			var data:Object=event.data;
			if(!data) return;
			
			_questionTypeValue=int(data.value);
			_feedbackSubmitViewAsset.questionType.txtQuestionType.text=data.text;
			
			getQuestionTypeView();
		}
		
		/**
		 *根据不同的问题类型 加载不同的视图 
		 */		
		private function getQuestionTypeView():void
		{
			_feedbackSubmitViewAsset.questionType.gotoAndStop(_questionTypeValue);
			
			setQuestionContentAsset();
			setQuestionTypeViewOther();
			
			_panel.update();
		}
		
		/**
		 * 设置公共的内容详情填写框
		 */		
		private function setQuestionContentAsset():void
		{
			if(_questionTypeValue!=3 && _questionTypeValue!=4)
			{
				//不为物品道具消失类问题类型时(物品道具消失类问题类型有前置项，在未通过前置项时，不需要显示内容详情填写框)
				setQuestionContentAdd();
			}
			
			//根据不同类型的问题，设置内容填写框的宽度及宽度改变后的座标
			//设置内容填写框的显示状态、宽度及坐标(不同类型的问题所填写的内容不一样，对于超过对象框的内容体，需要滚动条)
			if(_questionTypeValue==1 || _questionTypeValue==6 || _questionTypeValue==7 || _questionTypeValue==10)
			{
				_questionContentAsset.bgQuestionContent.width=306.9;
				_questionContentAsset.bgQuestionContent.x=170.15;
				_questionContent.width=301.85;
			}
			else
			{
				_questionContentAsset.bgQuestionContent.width=283.2;
				_questionContentAsset.bgQuestionContent.x=157.05;
				_questionContent.width=275.85;
			}
		}
		
		/**
		 *加载详细信息填写框 
		 */		
		private function setQuestionContentAdd():void
		{
			var questionTypeView:MovieClip=_feedbackSubmitViewAsset.questionType.questionTypeView as MovieClip;
			if(!questionTypeView) return;
			
			if(questionTypeView.posQuestionContent.parent) questionTypeView.posQuestionContent.parent.removeChild(questionTypeView.posQuestionContent);
			_questionContentAsset.x=questionTypeView.posQuestionContent.x;
			_questionContentAsset.y=questionTypeView.posQuestionContent.y;
			questionTypeView.addChild(_questionContentAsset);
			if(questionTypeView.posQuestionContent.parent) questionTypeView.posQuestionContent.parent.removeChild(questionTypeView.posQuestionContent);
		}
		
		/**
		 *移除详细信息填写框 
		 */		
		private function setQuestionContentRemove():void
		{
			if(_questionContentAsset.parent) _questionContentAsset.parent.removeChild(_questionContentAsset);
		}
		
		/**
		 * 设置视图其它相关属性
		 */		
		private function setQuestionTypeViewOther():void
		{
			this.okLabel="提交";
			this.okFunction=confirmSubmit;
			this.cancelFunction=cancelSubmit;
			this.cancelLabel="关闭";
			
			if(_questionTypeValue==2)
			{//如果为咨询活动相关时，加载活动是否异常项
				setActivityIsErrorRadioBtn();
			}
			
			if(_questionTypeValue==3 || _questionTypeValue==4)
			{//物品道具消失类
				this.okLabel="下一步";
				this.okFunction=nextStep;
				setQuestionTypeExemption();//加载声明文本
			}
			else
			{
				_feedbackSubmitViewAsset.questionType.questionTypeView.gotoAndStop(1);
				_feedbackSubmitViewAsset.questionType.questionTypeBase.visible=true;
			}
		}
		
		/**
		 *设置道具消失问题类型的声明 
		 */		
		private function setQuestionTypeExemption():void
		{
			_feedbackSubmitViewAsset.questionType.questionTypeView.gotoAndStop(2);
			_feedbackSubmitViewAsset.questionType.questionTypeBase.visible=false;
			
			_exemptionContent.x=_feedbackSubmitViewAsset.questionType.questionTypeView.txtQuestionContent.x;
			_exemptionContent.y=_feedbackSubmitViewAsset.questionType.questionTypeView.txtQuestionContent.y;
			_exemptionContent.width=_feedbackSubmitViewAsset.questionType.questionTypeView.txtQuestionContent.width;
			_exemptionContent.height=_feedbackSubmitViewAsset.questionType.questionTypeView.txtQuestionContent.height;
			_feedbackSubmitViewAsset.questionType.questionTypeView.addChild(_exemptionContent);
		}
		
		/**
		 *设置为咨询活动相关时，活动是否异常项的单选组
		 */		
		private function setActivityIsErrorRadioBtn():void
		{
			if(!_rbtnActivityIsErrorYes)
			{
				_rbtnActivityIsErrorYes = new TogleButton(new togleButtonAsset(),"是");
				_rbtnActivityIsErrorYes.textGape = 4;
				_rbtnActivityIsErrorYes.textFilters=null;
				_rbtnActivityIsErrorYes.textFormat=_rbtnActivityIsErrorYes.unableTextFormat=_rbtnActivityIsErrorYes.enableTextFormat = new TextFormat(LanguageMgr.GetTranslation("heiti"),16,0x000000,true);
				_rbtnActivityIsErrorYes.x=_feedbackSubmitViewAsset.questionType.questionTypeView.posActivityIsErrorYes.x;
				_rbtnActivityIsErrorYes.y=_feedbackSubmitViewAsset.questionType.questionTypeView.posActivityIsErrorYes.y;
			}
			if(_feedbackSubmitViewAsset.questionType.questionTypeView.posActivityIsErrorYes.parent) _feedbackSubmitViewAsset.questionType.questionTypeView.posActivityIsErrorYes.parent.removeChild(_feedbackSubmitViewAsset.questionType.questionTypeView.posActivityIsErrorYes);
			_feedbackSubmitViewAsset.questionType.questionTypeView.addChild(_rbtnActivityIsErrorYes);
			
			if(!_rbtnActivityIsErrorNo)
			{
				_rbtnActivityIsErrorNo = new TogleButton(new togleButtonAsset(),"否");
				_rbtnActivityIsErrorNo.textGape = 4;
				_rbtnActivityIsErrorNo.textFilters=null;
				_rbtnActivityIsErrorNo.textFormat=_rbtnActivityIsErrorNo.unableTextFormat=_rbtnActivityIsErrorNo.enableTextFormat = new TextFormat(LanguageMgr.GetTranslation("heiti"),16,0x000000,true);
				_rbtnActivityIsErrorNo.x=_feedbackSubmitViewAsset.questionType.questionTypeView.posActivityIsErrorNo.x;
				_rbtnActivityIsErrorNo.y=_feedbackSubmitViewAsset.questionType.questionTypeView.posActivityIsErrorNo.y;
			}
			if(_feedbackSubmitViewAsset.questionType.questionTypeView.posActivityIsErrorNo.parent) _feedbackSubmitViewAsset.questionType.questionTypeView.posActivityIsErrorNo.parent.removeChild(_feedbackSubmitViewAsset.questionType.questionTypeView.posActivityIsErrorNo);
			_feedbackSubmitViewAsset.questionType.questionTypeView.addChild(_rbtnActivityIsErrorNo);
			
			if(!_tbgActivityIsError)
			{
				_tbgActivityIsError=new ToggleButtonGroup();
				_tbgActivityIsError.addItem(_rbtnActivityIsErrorYes);
				_tbgActivityIsError.addItem(_rbtnActivityIsErrorNo);
			}
		}
		
		/**
		 *发生时间-年已选中项 
		 */		
		private function occurrenceDateYearDropDownSelected(event:FeedbackDropDownItemEvent):void
		{
			if(_occurrenceDateYearDropDownView)
			{
				if(_occurrenceDateYearDropDownView.parent) _occurrenceDateYearDropDownView.parent.removeChild(_occurrenceDateYearDropDownView);
				_occurrenceDateYearDropDownView=null;
			}
			
			var data:Object=event.data;
			if(!data) return;
			
			_feedbackSubmitViewAsset.questionType.questionTypeBase.txtOccurrenceDateYear.text=data.value;
		}	
		
		/**
		 *发生时间-月已选中项 
		 */		
		private function occurrenceDateMonthDropDownSelected(event:FeedbackDropDownItemEvent):void
		{
			if(_occurrenceDateMonthDropDownView)
			{
				if(_occurrenceDateMonthDropDownView.parent) _occurrenceDateMonthDropDownView.parent.removeChild(_occurrenceDateMonthDropDownView);
				_occurrenceDateMonthDropDownView=null;
			}
			
			var data:Object=event.data;
			if(!data) return;
			
			_feedbackSubmitViewAsset.questionType.questionTypeBase.txtOccurrenceDateMonth.text=data.value;
		}
		
		/**
		 *发生时间-月已选中项 
		 */		
		private function occurrenceDateDayDropDownSelected(event:FeedbackDropDownItemEvent):void
		{
			if(_occurrenceDateDayDropDownView)
			{
				if(_occurrenceDateDayDropDownView.parent) _occurrenceDateDayDropDownView.parent.removeChild(_occurrenceDateDayDropDownView);
				_occurrenceDateDayDropDownView=null;
			}
			
			var data:Object=event.data;
			if(!data) return;
			
			_feedbackSubmitViewAsset.questionType.questionTypeBase.txtOccurrenceDateDay.text=data.value;
		}
		
		/**
		 *为道具消失类,下一步操作 
		 */		
		private function nextStep():void
		{
			this.okFunction=confirmSubmit;
			this.okLabel="提交";
			this.cancelFunction=backStep;
			this.cancelLabel="上一步";
			
			_feedbackSubmitViewAsset.questionType.questionTypeView.gotoAndStop(1);
			_feedbackSubmitViewAsset.questionType.questionTypeBase.visible=true;
			_exemptionContent.visible=false;
			setQuestionContentAdd();
			_panel.update();
		}
		
		/**
		 *为道具消失类,上一步操作 
		 */		
		private function backStep():void
		{
			_feedbackSubmitViewAsset.questionType.questionTypeView.gotoAndStop(2);
			_feedbackSubmitViewAsset.questionType.questionTypeBase.visible=false;
			setQuestionTypeExemption();
			this.okFunction=nextStep;
			this.okLabel="下一步";
			this.cancelLabel="关闭";
			this.cancelFunction=cancelSubmit;
			_exemptionContent.visible=true;
			setQuestionContentRemove();
			_panel.update();
		}
		
		/**
		 *确定提交 
		 */		
		private function confirmSubmit():void
		{
			if(_questionTypeValue<=0
				|| StringHelper.IsNullOrEmpty(_questionContent.text)
				|| StringHelper.IsNullOrEmpty(_feedbackSubmitViewAsset.questionType.questionTypeBase.txtQuestionTitle.text)
				|| StringHelper.IsNullOrEmpty(_feedbackSubmitViewAsset.questionType.questionTypeBase.txtOccurrenceDateYear.text)
				|| StringHelper.IsNullOrEmpty(_feedbackSubmitViewAsset.questionType.questionTypeBase.txtOccurrenceDateMonth.text)
				|| StringHelper.IsNullOrEmpty(_feedbackSubmitViewAsset.questionType.questionTypeBase.txtOccurrenceDateDay.text)
			)
			{
				MessageTipManager.getInstance().show("请填写完整必填项。");
				return;
			}
			
			_feedbackInfo=new FeedbackInfo();
			_feedbackInfo.user_id=PlayerManager.Instance.Self.ID;
			_feedbackInfo.user_name=PlayerManager.Instance.Self.LoginName;
			_feedbackInfo.user_nick_name=PlayerManager.Instance.Self.NickName;
			_feedbackInfo.question_type=_questionTypeValue;
			_feedbackInfo.question_title=_feedbackSubmitViewAsset.questionType.questionTypeBase.txtQuestionTitle.text;
			_feedbackInfo.occurrence_date=_feedbackSubmitViewAsset.questionType.questionTypeBase.txtOccurrenceDateYear.text + "-" + _feedbackSubmitViewAsset.questionType.questionTypeBase.txtOccurrenceDateMonth.text + "-" + _feedbackSubmitViewAsset.questionType.questionTypeBase.txtOccurrenceDateDay.text;
			_feedbackInfo.question_content=_questionContent.text;
			switch(_questionTypeValue)
			{
				case 2://咨询活动相关
					if(_rbtnActivityIsErrorYes.selected && _rbtnActivityIsErrorNo.selected)
					{
						MessageTipManager.getInstance().show("请填写完整必填项。");
						return;
					}
					_feedbackInfo.activity_is_error=_rbtnActivityIsErrorYes.selected;
					_feedbackInfo.activity_name=_feedbackSubmitViewAsset.questionType.questionTypeView.txtActivityName.text;
					break;
				case 3://物品道具消失类-异常消失
				case 4://物品道具消失类-被盗
					if(StringHelper.IsNullOrEmpty(_feedbackSubmitViewAsset.questionType.questionTypeView.txtGoodsGetMethod.text) || StringHelper.IsNullOrEmpty(_feedbackSubmitViewAsset.questionType.questionTypeView.txtGoodsGetDate.text))
					{
						MessageTipManager.getInstance().show("请填写完整必填项。");
						return;
					}
					
					_feedbackInfo.goods_get_method=_feedbackSubmitViewAsset.questionType.questionTypeView.txtGoodsGetMethod.text;
					_feedbackInfo.goods_get_date=_feedbackSubmitViewAsset.questionType.questionTypeView.txtGoodsGetDate.text;
					break;
				case 5://充值卡类
					if(StringHelper.IsNullOrEmpty(_feedbackSubmitViewAsset.questionType.questionTypeView.txtChargeOrderId.text) || StringHelper.IsNullOrEmpty(_feedbackSubmitViewAsset.questionType.questionTypeView.txtChargeMethod.text) || StringHelper.IsNullOrEmpty(_feedbackSubmitViewAsset.questionType.questionTypeView.txtChargeMoneys.text))
					{
						MessageTipManager.getInstance().show("请填写完整必填项。");
						return;
					}
						
					_feedbackInfo.charge_order_id=_feedbackSubmitViewAsset.questionType.questionTypeView.txtChargeOrderId.text;
					_feedbackInfo.charge_method=_feedbackSubmitViewAsset.questionType.questionTypeView.txtChargeMethod.text;
					var charge_moneys:Number=Number(_feedbackSubmitViewAsset.questionType.questionTypeView.txtChargeMoneys.text);
					if(charge_moneys<=0)
					{
						MessageTipManager.getInstance().show("“充值金额”项填只能填写数字。");
						return;
					}
					_feedbackInfo.charge_moneys=charge_moneys;
					break;
				case 8://举报非法
					_feedbackInfo.report_user_name=_feedbackSubmitViewAsset.questionType.questionTypeView.txtReportUserName.text;
					_feedbackInfo.report_url=_feedbackSubmitViewAsset.questionType.questionTypeView.txtReportUrl.text;
					break;
				case 9://服务投诉
					if(StringHelper.IsNullOrEmpty(_feedbackSubmitViewAsset.questionType.questionTypeView.txtUserFullName.text)
						|| StringHelper.IsNullOrEmpty(_feedbackSubmitViewAsset.questionType.questionTypeView.txtUserPhone.text)
						|| StringHelper.IsNullOrEmpty(_feedbackSubmitViewAsset.questionType.questionTypeView.txtComplaintsTitle.text)
						|| StringHelper.IsNullOrEmpty(_feedbackSubmitViewAsset.questionType.questionTypeView.txtComplaintsSource.text)
					)
					{
						MessageTipManager.getInstance().show("请填写完整必填项。");
						return;
					}
					
					_feedbackInfo.user_full_name=_feedbackSubmitViewAsset.questionType.questionTypeView.txtUserFullName.text;
					_feedbackInfo.user_phone=_feedbackSubmitViewAsset.questionType.questionTypeView.txtUserPhone.text;
					_feedbackInfo.complaints_title=_feedbackSubmitViewAsset.questionType.questionTypeView.txtComplaintsTitle.text;
					_feedbackInfo.complaints_source=_feedbackSubmitViewAsset.questionType.questionTypeView.txtComplaintsSource.text;
					break;
			}
			
			this.okBtnEnable=false;
			
			_loadFeedbackSubmit = new LoadFeedbackSubmit(_feedbackInfo, loadFeedbackSubmitCallBack);
			_loadFeedbackSubmit.loadSync();
		}
		
		/**
		 *提交结果返回 
		 * @param result 返回结果：1=成功,0=失败
		 */	
		private function loadFeedbackSubmitCallBack(result:int):void
		{
			this.okBtnEnable=true;
			if(result==1)
			{
				MessageTipManager.getInstance().show("您的问题已提交，感谢您的支持！");
				
				dispose();
				this.close();
			}
			else if(result==-1)
			{//每天提交超上限
				MessageTipManager.getInstance().show("今日提交次数已达上限。");
			}
			else
			{
				MessageTipManager.getInstance().show("系统繁忙，请稍后再试。");
			}
		}
		
		/**
		 *取消提交 
		 */		
		private function cancelSubmit():void
		{
			dispose();
			this.close();
		}
		
		/**
		 *打开联系方式 
		 */		
		private function openContactView(event:MouseEvent):void
		{
			if(_feedbackContactView)
			{
				if(_feedbackContactView.parent) _feedbackContactView.parent.removeChild(_feedbackContactView);
				_feedbackContactView=null;
			}
			else
			{
				_feedbackContactView=new FeedbackContactView();
				_feedbackContactView.show();
			}
		}
		
		/**
		 *重置基础项提交项数据 
		 */		
		private function restSubmitItem():void
		{
			_feedbackSubmitViewAsset.questionType.questionTypeBase.txtQuestionTitle.text="";
			_feedbackSubmitViewAsset.questionType.questionTypeBase.txtOccurrenceDateYear.text="";
			_feedbackSubmitViewAsset.questionType.questionTypeBase.txtOccurrenceDateMonth.text="";
			_feedbackSubmitViewAsset.questionType.questionTypeBase.txtOccurrenceDateDay.text="";
			_questionContent.text="";
		}
		
		override protected function __onKeyDownd(e:KeyboardEvent):void
		{
			if(stopKeyEvent)
			{
				e.stopImmediatePropagation();
			}
		}
		
		override public function show():void
		{
			super.show();
			blackGound = true;
		}
		
		override protected function __closeClick(e:MouseEvent):void
		{
			if(this.cancelFunction != null) this.cancelFunction();
			dispose();
			super.__closeClick(e);
		}
		
		override protected function __addToStage(e:Event):void
		{
			super.__addToStage(e);
		}
		
		override public function dispose():void
		{
			if(_feedbackSubmitViewAsset) _feedbackSubmitViewAsset.questionType.dropQuestionType.removeEventListener(MouseEvent.CLICK, onQuestionTypeClick);
			if(_feedbackSubmitViewAsset) _feedbackSubmitViewAsset.questionType.questionTypeBase.dropOccurrenceDateYear.removeEventListener(MouseEvent.CLICK, onOccurrenceDateYearClick);
			if(_feedbackSubmitViewAsset) _feedbackSubmitViewAsset.questionType.questionTypeBase.dropOccurrenceDateMonth.removeEventListener(MouseEvent.CLICK, onOccurrenceDateMonthClick);
			if(_feedbackSubmitViewAsset) _feedbackSubmitViewAsset.questionType.questionTypeBase.dropOccurrenceDateDay.removeEventListener(MouseEvent.CLICK, onOccurrenceDateDayClick);
			if(_feedbackSubmitViewAsset) _feedbackSubmitViewAsset.btnContact.removeEventListener(MouseEvent.CLICK, openContactView);
			
			_feedbackInfo=null;
			_loadFeedbackSubmit=null;
			_questionTypeArray=[];
			_questionTypeArray=null;
			if(_questionTypeData) _questionTypeData.clear();
			_questionTypeData=null;
			if(_occurrenceDateYearData) _occurrenceDateYearData.clear();
			_occurrenceDateYearData=null;
			if(_occurrenceDateMonthData) _occurrenceDateMonthData.clear();
			_occurrenceDateMonthData=null;
			if(_occurrenceDateDayData) _occurrenceDateDayData.clear();
			_occurrenceDateDayData=null;
			
			if(_feedbackDropDownView)
			{
				if(_feedbackDropDownView.parent) _feedbackDropDownView.parent.removeChild(_feedbackDropDownView);
				_feedbackDropDownView.dispose();
			}
			_feedbackDropDownView=null;
			
			if(_questionContentAsset && _questionContentAsset.parent) _questionContentAsset.parent.removeChild(_questionContentAsset);
			_questionContentAsset=null;
			
			if(_panel && _panel.parent) _panel.parent.removeChild(_panel);
			_panel=null;
			
			if(_questionContent && _questionContent.parent) _questionContent.parent.removeChild(_questionContent);
			_questionContent=null;
			
			if(_exemptionContent && _exemptionContent.parent) _exemptionContent.parent.removeChild(_exemptionContent);
			_exemptionContent=null;			
			
			if(_tbgActivityIsError)
			{
				if(_tbgActivityIsError.parent) _tbgActivityIsError.parent.removeChild(_tbgActivityIsError);
				_tbgActivityIsError.dispose()
			}
			_tbgActivityIsError=null;				
			
			if(_rbtnActivityIsErrorYes)
			{
				if(_rbtnActivityIsErrorYes.parent) _rbtnActivityIsErrorYes.parent.removeChild(_rbtnActivityIsErrorYes);
				_rbtnActivityIsErrorYes.dispose()
			}
			_rbtnActivityIsErrorYes=null;
			
			if(_rbtnActivityIsErrorNo)
			{
				if(_rbtnActivityIsErrorNo.parent) _rbtnActivityIsErrorNo.parent.removeChild(_rbtnActivityIsErrorNo);
				_rbtnActivityIsErrorNo.dispose()
			}
			_rbtnActivityIsErrorNo=null;		
			
			if(_feedbackContactView)
			{
				if(_feedbackContactView.parent) _feedbackContactView.parent.removeChild(_feedbackContactView);
				_feedbackContactView.dispose();
			}
			_feedbackContactView=null;
			
			if(_feedbackSubmitViewAsset && _feedbackSubmitViewAsset.parent) _feedbackSubmitViewAsset.parent.removeChild(_feedbackSubmitViewAsset);
			_feedbackSubmitViewAsset=null;
		}
	}
}