package ddt.church.player
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	
	import ddt.data.player.PlayerInfo;
	import ddt.manager.ChurchRoomManager;
	import ddt.manager.ItemManager;
	import ddt.view.characterII.ILayer;

	public class ChurchLoader extends Sprite
	{
		private var loaders:Array;

		private var info:PlayerInfo;
		
		private var _recordStyle:Array;
		private var _recordColor:Array;
		private var _content:BitmapData;
		
		private var _callBack:Function;
		private var _completeCount:int;	
		
		public function ChurchLoader(info:PlayerInfo)
		{
			this.info = info;
			init();
		}
		
		private function init():void
		{
			_completeCount = 0;
		}
		
		public function load(callBack:Function=null):void
		{
			_callBack = callBack;
			if(info == null || info.Style == null)
			{
				loadComplete();
				return;
			}
			initLoaders();
			for(var i:int = 0; i < loaders.length;  i++)
			{
				var t:ILayer = loaders[i];
				t.load(__layerComplete);
			}
		}
		/**
		 *public static const HEAD:uint = 1;
		  public static const GLASS:uint = 2;
		  public static const HAIR:uint = 3;
		  public static const EFF:uint = 4;
		  public static const CLOTH:uint = 5;
		  public static const FACE:uint = 6; 
		 */		
		private function initLoaders():void
		{			
			loaders = [];
			_recordStyle = info.Style.split(",");
			_recordColor = info.Colors.split(",");
			
			var isAdmin:Boolean = ChurchRoomManager.instance.isAdmin(info);
			
			loaders.push(new ChurchLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[4])),info.Sex,_recordColor[4],false,isAdmin));
			loaders.push(new ChurchLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[5])),info.Sex,_recordColor[5]));
			loaders.push(new ChurchLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[2])),info.Sex,_recordColor[2]));
			loaders.push(new ChurchLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[3])),info.Sex,_recordColor[3]));
//			loaders.push(new ChurchLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[0])),_recordColor[0]));
			
			loaders.push(new ChurchLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[4])),info.Sex,_recordColor[4],true,isAdmin));
		}
		
		private function drawCharacter():void
		{
			var picWidth:Number = (loaders[0] as ILayer).width;
			var picHeight:Number = (loaders[0] as ILayer).height;
			if(picWidth == 0 || picHeight == 0)return;
			
			_content = new BitmapData(picWidth,picHeight,true,0);
			
			for(var i:uint = 0;i<loaders.length;i++)
			{
				var layer:ILayer = loaders[i] as ILayer;
				_content.draw(layer.getContent(),null,null,BlendMode.NORMAL);
			}
		}
		
		private function __layerComplete(layer:ILayer):void
		{
			_completeCount ++;
			if(_completeCount >= loaders.length)
			{
				drawCharacter();
				loadComplete();
			}			
		}
		
		private function loadComplete():void
		{
			if(_callBack != null)
				_callBack(this);
		}

		public function getContent():Array
		{
			return [_content];
		}
		
		public function dispose():void
		{
			for each(var i:ILayer in loaders)
			{
				i.dispose();
			}
			info = null;
			_callBack = null;
		}
	}
}