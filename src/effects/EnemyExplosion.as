package effects
{
	import starling.events.Event;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import starling.display.Image;
	import starling.textures.Texture;


	public class EnemyExplosion extends Explosion
	{
		public function EnemyExplosion()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
			_numParticles = 14;
			_speed = 2;
		}
		
		override protected function init():void
		{
			super.init();
			
		}
		
		override protected function createParticles():void
		{
	
			//Create explosion texture
			var explosionVec:flash.display.Sprite = new flash.display.Sprite();
			explosionVec.graphics.beginFill(0xffffff);
			explosionVec.graphics.drawCircle(0, 0, 1);
			explosionVec.graphics.endFill();
			var bounds:Rectangle = explosionVec.getBounds(explosionVec);
			var nBMP_D:BitmapData = new BitmapData(int(bounds.width + 0.5), int(bounds.height + 0.5), true, 0x00000000);
			nBMP_D.draw(explosionVec, new Matrix(1,0,0,1,-bounds.x,-bounds.y));
			_particleTexture = Texture.fromBitmapData(nBMP_D, false, false);
			
			//Paricle update
			_particles = new Vector.<Image>();
			
			var particle:Image;
			for(var i:int = 0; i < _numParticles; i++)
			{
			particle = new Image(_particleTexture);
			_particles.push(particle);
			stage.addChild(particle);
			}
			
		}
	}
}