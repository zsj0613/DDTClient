package par.manager
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.describeType;
	
	import par.emitters.Emitter;
	import par.emitters.EmitterInfo;
	import par.lifeeasing.AbstractLifeEasing;
	import par.particals.ParticleInfo;
	
	import road.math.ColorLine;
	import road.math.XLine;
	import road.serialize.xml.XmlSerialize;
	
	public class ParticleManager
	{
		public static var list:Array = new Array();
		
		private static var _ready:Boolean;
		
		public static function get ready():Boolean
		{
			return _ready;
		}
		
		public static function addEmitterInfo(info:EmitterInfo):void
		{
			list.push(info);
		}
		
		public static function removeEmitterInfo(info:EmitterInfo):void
		{
			for(var i:int = 0; i < list.length;i++)
			{
				if(list[i] == info)
				{
					list.splice(i,1);
					return;
				}
			}
		}
		
		public static function creatEmitter(id:Number):Emitter
		{
			for each(var info:EmitterInfo in list)
			{
				if(info.id == id)
				{
					var emitter:Emitter = new Emitter();
					emitter.info = info;
					return emitter;
				}
			}
			return null;
		}
		
		public static function clear():void
		{
			list = new Array();
		}
		
		public static function load(xml:XML):void
		{
			var xml_emitter:XMLList = xml..emitter;
			var pcInfo:XML = describeType(new ParticleInfo());
			var ecInfo:XML = describeType(new EmitterInfo()); 
			
			for each(var x:XML in xml_emitter)
			{
				var ei:EmitterInfo = XmlSerialize.decodeType(x,EmitterInfo,ecInfo);
				
				var xml_pars:XMLList = x.particle;
				for each(var p:XML in xml_pars)
				{
					var po:ParticleInfo  = XmlSerialize.decodeType(p,ParticleInfo,pcInfo);
					var easing:XMLList = p.easing;
					var lifeEasing:AbstractLifeEasing = new AbstractLifeEasing();
					for each(var e:XML in easing)
					{
						if(e.@name != "colorLine")
						{
							lifeEasing[e.@name].line = XLine.parse(e.@value);
						}
						else
						{
							lifeEasing.colorLine = new ColorLine();
							lifeEasing.colorLine.line = XLine.parse(e.@value);
						}
					}
					po.lifeEasing = lifeEasing;
					ei.particales.push(po);
				}
				list.push(ei);
			}
			_ready = true;
		}
		
		public static function loadSyc(path:String):void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,__loadCompleted);
			loader.load(new URLRequest(path));
		}
		
		private static function __loadCompleted(event:Event):void
		{
			var loader:URLLoader = event.currentTarget as URLLoader;
			try
			{
				load(new XML(loader.data));
			}
			catch(err:Error){}
		}

		public static function save():XML
		{
			var doc:XML = new XML("<list></list>");

			for each(var ei:EmitterInfo in list)
			{
				var exml:XML = XmlSerialize.encode("emitter",ei);
				for each(var pi:ParticleInfo in ei.particales)
				{
					var xpi:XML = XmlSerialize.encode("particle",pi);
					xpi.appendChild(encodeXLine("vLine",pi.lifeEasing.vLine));
					xpi.appendChild(encodeXLine("rvLine",pi.lifeEasing.rvLine));
					xpi.appendChild(encodeXLine("spLine",pi.lifeEasing.spLine));
					xpi.appendChild(encodeXLine("sizeLine",pi.lifeEasing.sizeLine));
					xpi.appendChild(encodeXLine("weightLine",pi.lifeEasing.weightLine));
					xpi.appendChild(encodeXLine("alphaLine",pi.lifeEasing.alphaLine));
					if(pi.lifeEasing.colorLine)
					{
						xpi.appendChild(encodeXLine("colorLine",pi.lifeEasing.colorLine));
					}
					exml.appendChild(xpi);
				}
				doc.appendChild(exml);
			}
			
			return doc;
		}
		
		private static function encodeXLine(name:String,value:XLine):XML
		{
			return new XML("<easing name=\""+name+"\" value=\""+XLine.ToString(value.line)+"\" />");
		}

	}
}