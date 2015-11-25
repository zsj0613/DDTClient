package par.emitters
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import par.enginees.ParticleEnginee;
	import par.particals.Particle;
	import par.particals.ParticleInfo;
	
	import road.math.randRange;
	
	[Event(name="complete",type="flash.events.Event")]
	public class Emitter extends EventDispatcher
	{
		public var x:Number = 0;
		
		public var y:Number = 0;
		
		private var _info:EmitterInfo;
		
		private var _enginee:ParticleEnginee;
		
		private var _interval:Number = 0;
		
		private var _age:Number = 0;
		
		public var angle:Number = 0;
		
		public var autoRestart:Boolean = false;
		
		public function Emitter()
		{
			_interval = 0;
		}
		public function setEnginee(enginee:ParticleEnginee):void
		{
			_enginee = enginee;
		}
		
		public function restart():void
		{
			_age = 0;
		}
		
		public function get info():EmitterInfo
		{
			return _info;
		}
		
		public function set info(value:EmitterInfo):void
		{
			_info = value;
			_interval = _info.interval;
		}
		
		public function execute(time:Number):void
		{
			if(_enginee && info)
			{
				_age += time;
				if( info.life <= 0 || _age < info.life)
				{
					_interval += time;
					if(_interval > info.interval)
					{
						_interval = 0;
						emit();
					}
				}
				else
				{
					if(autoRestart)
					{
						restart();
					}
					else
					{
						dispose();
					}
				}
			}
		}
		
		public function dispose():void
		{
			_enginee.removeEmitter(this);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function emit():void
		{
			for each(var pi:ParticleInfo in info.particales)
			{
				if(pi.beginTime < _age && pi.endTime > _age)
				{
					var count:int = pi.countOrient + int(randRange(0,pi.countSize));
					
					for(var i:int = 0; i < count; i ++)
					{
						var p:Particle = _enginee.createParticle(pi);
						p.life = pi.lifeOrient + randRange(0,pi.lifeSize);
						p.size = pi.sizeOrient + randRange(0,pi.sizeSize);
						p.v = pi.vOrient + randRange(0,pi.vSize)
						p.angle = angle + randRange(info.beginAngle,info.endAngle);
						p.motionV = pi.motionVOrient + randRange(0,pi.motionVOrient);
						p.weight = pi.weightOrient + randRange(0,pi.weightSize);
						p.spin = pi.spinOrient + randRange(0,pi.spinSize);
						p.rotation = pi.rotation + angle;
						p.x = x;
						p.y = y;
						p.color = pi.colorOrient;
						p.alpha = pi.alphaOrient;
						//trace(angle,p.rotation);
						_enginee.addParticle(p);
					}
				}
			}
		}

	}
}