package effects
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Explosion extends starling.display.Sprite
	{
		protected const EXPLOSION_LIFETIME:Number = 0.38;  //seconds
		protected var _numParticles:int;
		protected var _speed:Number = 2;
		protected var _particleLifetimeTimer:Timer = new Timer(EXPLOSION_LIFETIME * 1000, 1);
		protected var _particleTexture:Texture;
		protected var _particles:Vector.<Image>;
		
		
		public function Explosion()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		protected function init():void
		{
			_particleLifetimeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, animationComplete);
			/*
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
			*/
			createParticles();
		}
		
		protected function updateLoop():void
		{
			var angle:Number = 0;
			var numParticle:int = _particles.length;
			for each(var particle:Image in _particles)
			{
				particle.x += _speed * Math.cos(angle);
				particle.y += _speed * Math.sin(angle);
				angle += (2 * Math.PI) / numParticle
			}
			
		}
		
		protected function createParticles():void
		{
			/*
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
			for(var i:int = 0; i < NUM_OF_PARTICLES; i++)
			{
				particle = new Image(_particleTexture);
				_particles.push(particle);
				stage.addChild(particle);
			}
			*/
		}
		
		protected function animationComplete(event:TimerEvent):void
		{
			
			_particleLifetimeTimer.reset();
			dispatchEventWith("ANIMATION_COMPLETE", true);
			removeEventListener(EnterFrameEvent.ENTER_FRAME, updateLoop);
			for each(var particle:Image in _particles)
				particle.visible = false;
			
		}
		
		public function explode(startPoint:Point):void
		{
			var a:int;
			var b:int;
			trace("PL " +_particles.length);
			for each(var particle:Image in _particles)
			{
				particle.x = startPoint.x;
				particle.y = startPoint.y;
				particle.visible = true;
			}
			_particleLifetimeTimer.start();
			addEventListener(EnterFrameEvent.ENTER_FRAME, updateLoop);
			
		}
		
		
	}
}