package ddt.view.characterII
{
	import com.hurlant.util.Memory;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	
	import ddt.data.EquipType;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.manager.ItemManager;
	
	public class BaseCharacterLoader implements ICharacterLoader
	{
		protected var loaders:Array;
		protected var layerFactory:ILayerFactory;
		protected var info:PlayerInfo;
		protected var _recordStyle:Array;
		protected var _recordColor:Array;
		protected var _content:BitmapData;
		
		private var _callBack:Function;
		private var _completeCount:int;
		private var _wing:MovieClip = new MovieClip;	
		
		public function BaseCharacterLoader(info:PlayerInfo)
		{
			this.info = info;
			init();
		}
		
		private function init():void
		{
			_completeCount = 0;
		}
		
		protected function initLoaders():void
		{			
			loaders = [];
			_recordStyle = info.Style.split(",");
			_recordColor = info.Colors.split(",");
			//global.traceStr(info.Colors);
			loaders.push(layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[7])),_recordColor[7],BaseLayer.SHOW));
			loaders.push(layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[1])),_recordColor[1],BaseLayer.SHOW));
			loaders.push(layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[0])),_recordColor[0],BaseLayer.SHOW));
			loaders.push(layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[3])),_recordColor[3],BaseLayer.SHOW));
			loaders.push(layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[4])),_recordColor[4],BaseLayer.SHOW));
			loaders.push(layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[2])),_recordColor[2],BaseLayer.SHOW,false,info.getHairType()));
			loaders.push(layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[5])),_recordColor[5],BaseLayer.SHOW));
			loaders.push(layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[6])),_recordColor[6],BaseLayer.SHOW));
			loaders.push(layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[8])),_recordColor[8],BaseLayer.SHOW));
		}
	
		protected function getIndexByTemplateId(id:String):int
		{
			switch(id.charAt(0))
			{
				case "1":
				if(id.charAt(1) == String(3))
				{
					return 0;
				}else if(id.charAt(1) == String(5))
				{
					return 8;
				}else if(id.charAt(1) == String(6))
				{
					return 9;
				}else
				{
					return 2;
				}
				case "2":return 1;
				case "3":return 5;
				case "4":return 3;
				case "5":return 4;
				case "6":return 6;
				case "7":return 7;
				default:return -1;
			}
		}

		final public function load(callBack:Function=null):void
		{
			_callBack = callBack;
			if(layerFactory == null || info == null || info.Style == null)
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
		
		private function __layerComplete(layer:ILayer):void
		{
			_completeCount ++;
			if(_completeCount >= loaders.length)
			{
				drawCharacter();
				loadComplete();
			}			
		}
		
		protected function loadComplete():void
		{
			if(_callBack != null)
				_callBack(this);
		}
		
		protected function drawCharacter():void
		{
			var picWidth:Number = (loaders[1] as ILayer).width;
			var picHeight:Number = (loaders[1] as ILayer).height;
			if(picWidth == 0 || picHeight == 0)return;
			_content = new BitmapData(picWidth,picHeight,true,0);
			for(var i:int = loaders.length - 1; i >= 0; i--)
			{
				if(info.getShowSuits())
				{
					if(loaders[i].info.CategoryID != EquipType.SUITS && loaders[i].info.CategoryID != EquipType.WING && loaders[i].info.CategoryID != EquipType.ARM) continue;
				}else
				{
					if(loaders[i].info.CategoryID == EquipType.SUITS) continue;
				}
				if(loaders[i].info.CategoryID == EquipType.WING)
				{
					_wing = loaders[i].getContent() as MovieClip;
					
				}else
				{
					_content.draw((loaders[i] as ILayer).getContent(),null,null,BlendMode.NORMAL);
				}
			}
			Memory.gc();
		}
		
		public function getContent():Array
		{
			return [_content,_wing];
		}
		
		public function setFactory(factory:ILayerFactory):void
		{
			layerFactory = factory;
		}
		
		public function update():void
		{
			if(info.Style && loaders)
			{
				var st:Array = info.Style.split(",");
				var co:Array = info.Colors.split(",");
				var shouldchangehair:Boolean = false;
				var hadchangehair:Boolean = false;
				for(var i:int = 0; i < st.length; i++)
				{
					if(_recordStyle == null)break;
					if(i >= _recordStyle.length)break;
					var index:int = getIndexByTemplateId(st[i]);
					if(index == -1 || index == 9)continue;
					if(_recordStyle.indexOf(st[i]) == -1)
					{
						if(!shouldchangehair)
							shouldchangehair = st[i].charAt(0) == EquipType.HEAD;
						if(!hadchangehair)
							hadchangehair = st[i].charAt(0) == EquipType.HAIR;
						var item:ItemTemplateInfo = ItemManager.Instance.getTemplateById(int(st[i]));
						var t:ILayer = getCharacterLoader(item,co[i]);
						loaders[index] = t;
						_completeCount --;
						t.load(__layerComplete);
					}
					else
					{
						if(co[i] == null)continue;
						if(_recordColor[i] != co[i])
						{
							(loaders[index] as ILayer).setColor(co[i]);
						}
					}
				}
				if(shouldchangehair && !hadchangehair)
				{
					var hair:ItemTemplateInfo = ItemManager.Instance.getTemplateById(info.getPartStyle(EquipType.HAIR));
					var l:ILayer = getCharacterLoader(hair,info.getPartColor(EquipType.HAIR));
					loaders[getIndexByTemplateId(String(hair.TemplateID))] = l;
					_completeCount --;
					l.load(__layerComplete);
				}
				_recordStyle = st;
				_recordColor = co;
				_completeCount--;
				__layerComplete(null);
			}
		}
		
		protected function getCharacterLoader(value:ItemTemplateInfo,color:String = ""):ILayer
		{
			if(value.CategoryID == EquipType.HAIR)
				return layerFactory.createLayer(value,color,BaseLayer.SHOW,false,info.getHairType());
			else 
				return layerFactory.createLayer(value,color,BaseLayer.SHOW);
		}
		
		public function dispose():void
		{
			for each(var i:ILayer in loaders)
			{
				i.dispose();
			}
			layerFactory = null;
			info = null;
			_callBack = null;
		}
	}
}