package ddt.manager
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import road.loader.LoaderSavingManager;
	import road.ui.manager.TipManager;
	
	import ddt.states.BaseStateView;
	import ddt.states.FadingBlock;
	import ddt.states.IStateCreator;
	import ddt.utils.MenoryUtil;
	import ddt.view.bagII.bagStore.BagStore;
	import ddt.view.common.BellowStripViewII;
	import ddt.view.common.WaitingView;
	
	
	public class StateManager
	{
		private static var dic:Dictionary;
		private static var root:Sprite;
		private static var current:BaseStateView;
		private static var next:BaseStateView;
		public static var currentStateType:String;
		
		private static var fadingBlock:FadingBlock;
		private static var _creator:IStateCreator;
		
		private static var _data:Object;
		
		public static function get nextState():BaseStateView
		{
			return next;
		}
		
		public static function setup(parent:Sprite,creator:IStateCreator):void
		{
			dic = new Dictionary();
			root = new Sprite();
			parent.addChild(root);
			
			_creator = creator;
			fadingBlock = new FadingBlock(addNextToStage,showLoading);
		}
		
		public static function setState(type:String = "default",data:Object = null):void
		{	
			var next:BaseStateView = getState(type);
			_data = data;
			if(next)
			{
				setStateImp(next);
			}
			else
			{
				createStateAsync(type,createCallbak);
			}
		}
		
		public static function stopImidily():void
		{
			fadingBlock.stopImidily();
		}
		
		private static function createCallbak(value:BaseStateView):void
		{
			if(value)
				dic[value.getType()] = value;
			setStateImp(value);
		}
			
		private static function setStateImp(value:BaseStateView):Boolean
		{
			if(value == null || value == current || next == value)
				return false;
			if(value.check(currentStateType))
			{
				QueueManager.pause();
				next = value;
				
				if(!next.prepared)
					next.prepare();
				TipManager.setCurrentTarget(null,null);
				TipManager.clearTipLayer();	
				if(current)
				{
					fadingBlock.setNextState(next);
					fadingBlock.update();
				}	
				else
				{
					next.enter(current,_data);
					addNextToStage();
				}
				
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private static function addNextToStage():void
		{
			QueueManager.resume();
			if(current)
			{
				current.leaving(next);
				next.enter(current,_data);
			}
			WaitingView.instance.hide();
			MenoryUtil.clearMenory();
			root.addChild(next.getView());
			next.addedToStage();
			
			if(current)
			{
				if(current.getView().parent)
					current.getView().parent.removeChild(current.getView());
				current.removedFromStage();
			}
			current = next;
			currentStateType = current.getType();
			next = null;
			
			if(current.goBack())
			{
				fadingBlock.executed = false;
				back();
			}
			EnthrallManager.getInstance().updateEnthrallView();
		}
		
		private static function showLoading():void
		{
			if(LoaderSavingManager.hasFileToSave)
			{
				
				WaitingView.instance.show(WaitingView.DEFAULT,LanguageMgr.GetTranslation("ddt.manager.StateManager.save"),false);
				//WaitingView.instance.show(WaitingView.DEFAULT,"保存文件，以便下次不再加载",false);
			}
		}
		
	
		public static function back():void
		{
			if(current != null)
			{
				var backtype:String = current.getBackType();
				if(backtype != "")
				{
					setState(backtype)
				}
			}
		}
		
		public static function getState(type:String):BaseStateView
		{
			return dic[type] as BaseStateView;
		}
		
		
		public static function createStateAsync(type:String,callbak:Function):void
		{
			var state:BaseStateView = _creator.create(type);
			if(state != null)
			{
				callbak(state);
			}
			else
			{
				_creator.createAsync(type,callbak);
			}
		}
	}
}