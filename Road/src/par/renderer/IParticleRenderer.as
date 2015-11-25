
package par.renderer
{
	import par.particals.Particle;
	
	public interface IParticleRenderer
	{
		function renderParticles( particles:Array ):void;
		function addParticle( particle:Particle):void;
		function removeParticle( particle:Particle):void;
		function reset():void;
		function dispose():void;
	}
}
