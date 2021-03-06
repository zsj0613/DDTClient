package ddt.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	


	/**
	 *  
	 * @author dordy
	 * 
	 */
	public class Helpers
	{
		//private static var registers:Dictionary=new Dictionary();
		private static var _stage:Stage;
		/**
		 * 快捷设置文本框format属性 
		 * @param textfield 
		 * @param chageObject 要改变的属性 exp:{size:10,color:0xff00ff};
		 * @param setAll false为只设置defaultTextFormat,true为设置setTextFormat加defaultTextFormat
		 * 
		 */		
		public static  function setTextfieldFormat(textfield:TextField,chageObject:Object,setAll:Boolean=false):void
		{
			var textformat:TextFormat=textfield.getTextFormat();
			for (var i:String in chageObject)
			{
				textformat[i]=chageObject[i]||textformat[i];
			}
			if(setAll)
			{
				textfield.setTextFormat(textformat);
			}
			textfield.defaultTextFormat=textformat;
		}
		/**
		 * 隐藏用于定位的mc(需要特定命名规则，被隐藏的mc的name属性都为以"_pos"结尾，隐藏方式为visible=false) 
		 * @param object
		 * 
		 */		
		public static function hidePosMc(object:DisplayObjectContainer):void
		{
			var reg:RegExp=/_pos$/;
			var child:DisplayObject;
			for(var i:int=0;i<object.numChildren;i++)
			{
				child=object.getChildAt(i);
				if(reg.test(child.name))
				{
					child.visible=false;
				}
			}
		}
		/**
		 * 为对象添加额外的鼠标事件
		 *  
		 * @param dobj
		 * 
		 */		
		public static function registExtendMouseEvent(dobj:InteractiveObject):void
		{
			dobj.addEventListener(MouseEvent.MOUSE_DOWN,__dobjDown);
		}
		/**
		 * 当在对象上按下鼠标再松开鼠标时派发(包括在对象外松开)
		 */		
		public static const STAGE_UP_EVENT:String="STAGE_UP_EVENT";
		/**
		 * 当在对象上按下鼠标再移动时派发(包括在对象外移动) 
		 */		
		public static const MOUSE_DOWN_AND_DRAGING_EVENT:String="MOUSE_DOWN_AND_DRAGING_EVENT";
		private static function __dobjDown(e:MouseEvent):void
		{
			var dobj:InteractiveObject=e.currentTarget as InteractiveObject;
			var fun_up:Function=function(e:MouseEvent):void
			{
				dobj.dispatchEvent(new Event(STAGE_UP_EVENT));
				dobj.stage.removeEventListener(MouseEvent.MOUSE_UP,fun_up);
				dobj.stage.removeEventListener(MouseEvent.MOUSE_MOVE,fun_move);
			}
			var fun_move:Function=function(e:MouseEvent):void
			{
				dobj.dispatchEvent(new Event(MOUSE_DOWN_AND_DRAGING_EVENT));
			}
			dobj.stage.addEventListener(MouseEvent.MOUSE_UP,fun_up);
			dobj.stage.addEventListener(MouseEvent.MOUSE_MOVE,fun_move);
		}
		private static var enterFrameDispatcher:Sprite=new Sprite();
		/**
		 * 延迟调用 
		 * @param fun
		 * @param delay_frame 延迟帧数
		 * 
		 */		
		public static function delayCall(fun:Function,delay_frame:int=1):void
		{
			var fun_new:Function=function(e:Event):void{
				if(--delay_frame<=0){
					fun();
					enterFrameDispatcher.removeEventListener(Event.ENTER_FRAME,fun_new);
				}
			}
			enterFrameDispatcher.addEventListener(Event.ENTER_FRAME,fun_new);
		}
		/**
		 * 拷贝指定属性 
		 * @param from_obja
		 * @param to_objb
		 * @param propertiy 属性Array
		 * 
		 */		
		public static function copyProperty(from_obja:Object,to_objb:Object,propertiy:Array=null):void
		{
			for each(var i:String in propertiy)
			{
				to_objb[i]=from_obja[i];
			}
		}
		private static const encode_arr:Array=[
			["%","%01"],
			["]","%02"],
			["\\[","%03"],
		]
		private static const decode_arr:Array=[
			["%","%01"],
			["]","%02"],
			["[","%03"],
		]
		public static function enCodeString(str:String):String
		{
			var i:int;
			for(i=0;i<encode_arr.length;i++)
			{
				str=str.replace(new RegExp(encode_arr[i][0],"g"),encode_arr[i][1]);
			}
			return str;
		}
		public static function deCodeString(str:String):String
		{
			var i:int;
			for(i=decode_arr.length-1;i>=0;i--)
			{
				str=str.replace(new RegExp(decode_arr[i][1],"g"),decode_arr[i][0]);
			}
			return str;
		}
		public static function setup(stage:Stage):void
		{
			_stage=stage;
//			stage.addEventListener(MouseEvent.MOUSE_UP,__stageMouseUp);
		}
//		private static function __stageMouseUp(e:Event):void
//		{
//			
//		}
	}
}