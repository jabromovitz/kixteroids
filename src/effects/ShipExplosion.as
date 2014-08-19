package effects
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.textures.Texture;
	import player.Ship;

	
	
	public class ShipExplosion extends Explosion
	{
		
		private var _ship:Ship;
		
		public function ShipExplosion(ship:Ship)
		{
			super();
			_ship = ship;
			_numParticles = 5;
			_speed = 1.5;
		}
		
		override protected function init():void
		{
			super.init();
		}
		
		override protected function createParticles():void
		{
			//Paricle update
			_particles = new Vector.<Image>();
			var particle:Image;
			var explosionVec:flash.display.Sprite;
			var bounds:Rectangle;
			var nBMP_D:BitmapData;
			
			for(var i:int = 0; i < _numParticles; i++)
			{
			//Create explosion texture
			explosionVec =  new flash.display.Sprite();
			explosionVec.graphics.beginFill(0xffffff);
			explosionVec.graphics.lineStyle(1, 0xffffff);
			explosionVec.graphics.lineTo(_ship.width, 0);
			explosionVec.graphics.endFill();
			bounds = explosionVec.getBounds(explosionVec);
			nBMP_D = new BitmapData(int(bounds.width + 0.5), int(bounds.height + 0.5), true, 0x00000000);
			nBMP_D.draw(explosionVec, new Matrix(1,0,0,1,-bounds.x,-bounds.y));
			_particleTexture = Texture.fromBitmapData(nBMP_D, false, false);
			particle = new Image(_particleTexture);
			particle.rotation = 2 * Math.PI * Math.random();
			particle.visible = false;
			_particles.push(particle);
			stage.addChild(particle);
			}
			
		}
	}
}