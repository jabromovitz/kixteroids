package
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.utils.Timer;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import settings.Levels;
	import effects.EnemyExplosion;
	import enemies.Astroid;
	import settings.Constants;
	import enemies.AstroidGenerator;
	import helpers.RespawnCircle;
	import helpers.CollisionDetection;
	import gui.HUD;
	import player.Ship;
	
	public class Game extends starling.display.Sprite
	{
		private const ASTROID_SPEED:Number = 20;
		private var assets:AssetManager;
		private var _ship:Ship;
		private var _asteroids:Vector.<Astroid>;
		private var _astroidGenerator:AstroidGenerator;
		private var _enemyExplosion:EnemyExplosion;
		private var _explosionSound:Sound;
		private var _bgHighTone:Sound;
		private var _bgLowTone:Sound;
		private var _hud:HUD;
		private var _respawnTimer:Timer = new Timer(500, 1);
		private var _enterToStartText:TextField;
		private var _isGameRunning:Boolean = false;
		private var _lives:int = 3;
		private var _level:int = 0;
		private var _backgroundMusicTimer:Timer = new Timer(500);
		private var _backgroundMusicToneAlternater:Boolean = false;  //to alternate to the two bg tones
		private var _firstGame:Boolean = true // to start playing against the initial asteroids
		
		
		
		public function Game()
		{
			super();
			
			assets = new AssetManager();
			assets.verbose = true;
			
			// enqueue assets
			assets.enqueue(EmbeddedAssets);
			
			//Hackey, change this
			assets.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1)
				{
					//Create the game world
					init();
				}
			});
			
		}
		
		private function init():void
		{
			
			//Setting up...
			
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, startGame) ;

			//Init explosion sound
			_explosionSound = new EmbeddedAssets.BangLarge() as Sound;
			_bgHighTone = new EmbeddedAssets.ToneHigh() as Sound;
			_bgLowTone = new EmbeddedAssets.ToneLow() as Sound;
			
			//Create texture for ship
			var shipTexture:Texture = createShipTexture();
			
			//Background
			var bg:Quad = new Quad(640, 480, 0x222222);
			addChild(bg);
			
			//Set up HUD
			_hud = new HUD(0.1 * width, 0.1 * height, _lives, shipTexture);
			_hud.x = 0.1 * width;
			_hud.y = 0;
			addChild(_hud);
			
			//Init collision detection
			var cD:CollisionDetection = new CollisionDetection();
			addChild(cD);
			cD.addEventListener(Constants.SHIP_DESTROYED, shipDestroyed);
			cD.addEventListener(Constants.ENEMY_DESTROYED, enemyDestroyed);
			
			//Init astroid generator
			_astroidGenerator = new AstroidGenerator();
			
			//Create ship
			_ship = new Ship( shipTexture );
			addChild(_ship);
			_ship.x = stage.stageWidth/2;
			_ship.y = stage.stageHeight/2;
			_ship.visible = false;
			
			
			//Explosion effect to move around when enemies are blown up
			//I'm just using the same one everywhere, but I feel like 
			//it produces the desired effect
			_enemyExplosion = new EnemyExplosion();
			addChild(_enemyExplosion);
			
			//Register ship with CD
			//CollisionDetection.registerShip(_ship);
			
			
			
			//Bg music player
			_backgroundMusicTimer.addEventListener(TimerEvent.TIMER, switchBgTone);
			
			//Create Astroids
			_asteroids = new Vector.<Astroid>();
			for(var i:int = 0; i < 4; i++)
			{
				var randomAngle:Number = Math.PI * (1 - 2 * Math.random());
				var astroid:Astroid = new Astroid(_astroidGenerator.generateAstroid(Astroid.LARGE), Levels.LEVELS[_level].astroidSpeed * ASTROID_SPEED, Astroid.LARGE, new Point(Math.cos(randomAngle), Math.sin(randomAngle)));
				astroid.x = stage.width * Math.random();
				astroid.y = stage.height * Math.random();
				_asteroids.push(astroid);
				addChild(astroid);
				CollisionDetection.registerEnemy(astroid);
			}
			
			//Show Start Screen
			_enterToStartText = new TextField(0.2 * width, 0.1 * height, "PRESS ENTER TO START", "Hyperspace", 24, 0xffffff, true);
			_enterToStartText.autoScale = true;
			addChild(_enterToStartText);
			_enterToStartText.x = (stage.stageWidth - _enterToStartText.width)/2;
			_enterToStartText.y = (stage.stageHeight - _enterToStartText.height)/2;
			
			
		}
		
		protected function switchBgTone(event:TimerEvent):void
		{
				
			if(_backgroundMusicToneAlternater)
				_bgHighTone.play();
			else
				_bgLowTone.play();
			
			_backgroundMusicToneAlternater = !_backgroundMusicToneAlternater;
			
		}
		
		private function startGame(e:KeyboardEvent):void
		{
			if(e.keyCode == 13 && !_isGameRunning)
			{
			
				_backgroundMusicTimer.delay = Levels.LEVELS[_level].bgMusicSpeed;
				_backgroundMusicTimer.start();
				_enterToStartText.visible = false;
				_lives = 3;
				_level = 0;
				_hud.reset();
				_isGameRunning = true;
				//_ship.visible = true;
				_respawnTimer.addEventListener(TimerEvent.TIMER_COMPLETE, checkSafeRespawn);
				_respawnTimer.start();
				
				//Reset asteroids
				if(!_firstGame)
				{
					if(_asteroids.length > 0)
					{
						CollisionDetection.deregisterAllAsteroids();
						var tempAsteroid:Astroid;
						while(_asteroids.length)
						{
							tempAsteroid = _asteroids.pop();
							removeChild(tempAsteroid);
							tempAsteroid.dispose();
						}
					}
					
					createNewAstroids(Levels.LEVELS[_level].numberOfAstroids, Levels.LEVELS[_level].astroidSpeed);
				}
				_firstGame = false;
			}
		}
			
		
		
		private function createShipTexture():Texture
		{
			//Ship image
			var shipImageS:flash.display.Sprite = new flash.display.Sprite();
			shipImageS.graphics.lineStyle(1, 0xffffff);
			shipImageS.graphics.moveTo(0, 0);
			shipImageS.graphics.lineTo(18, 6);
			shipImageS.graphics.lineTo(0, 12);
			shipImageS.graphics.lineTo(0, 0);
			
			var bounds:Rectangle = shipImageS.getBounds(shipImageS);
			var nBMP_D:BitmapData = new BitmapData(int(bounds.width + 0.5), int(bounds.height + 0.5), true, 0x00000000);
			nBMP_D.draw(shipImageS, new Matrix(1,0,0,1,-bounds.x,-bounds.y));
			
			return Texture.fromBitmapData(nBMP_D, false, false);
		}
		
		private function createNewAstroids(howMany:uint, howFast:Number):void
		{
			//Create Astroids
			_asteroids = new Vector.<Astroid>();
			for(var i:int = 0; i < howMany; i++)
			{
				var randomAngle:Number = Math.PI * (1 - 2 * Math.random());
				var astroid:Astroid = new Astroid(_astroidGenerator.generateAstroid(Astroid.LARGE), Levels.LEVELS[_level].astroidSpeed * ASTROID_SPEED, Astroid.LARGE, new Point(Math.cos(randomAngle), Math.sin(randomAngle)));
				astroid.x = stage.width * Math.random();
				astroid.y = stage.height * Math.random();
				_asteroids.push(astroid);
				addChild(astroid);
				CollisionDetection.registerEnemy(astroid);
			}
		}
		
		private function enemyDestroyed(e:Event):void
		{
			var enemy:Astroid = e.data as Astroid;
			
			_explosionSound.play();
			_enemyExplosion.explode(new Point(enemy.x + enemy.width/2, enemy.y + enemy.height/2));
			
			_asteroids.splice(_asteroids.indexOf(enemy), 1);
			
			enemy.dispose();
			removeChild(enemy);
			
			//smaller astroids?
			var astroid:Astroid;
			if(enemy.size == Astroid.LARGE)
			{
				//Large astroid shot
				_hud.updateScore(25);
				astroid = new Astroid(_astroidGenerator.generateAstroid(Astroid.MEDIUM), 2 * ASTROID_SPEED, Astroid.MEDIUM, new Point(Math.cos(enemy.initialAngle + Math.PI/8), Math.sin(enemy.initialAngle + Math.PI/8)));
				astroid.x = enemy.x;
				astroid.y = enemy.y;
				_asteroids.push(astroid);
				addChild(astroid);
				CollisionDetection.registerEnemy(astroid);
				
				astroid = new Astroid(_astroidGenerator.generateAstroid(Astroid.MEDIUM), 2 * ASTROID_SPEED, Astroid.MEDIUM, new Point(Math.cos(enemy.initialAngle - Math.PI/8), Math.sin(enemy.initialAngle - Math.PI/8)));
				astroid.x = enemy.x;
				astroid.y = enemy.y;
				_asteroids.push(astroid);
				addChild(astroid);
				CollisionDetection.registerEnemy(astroid);
			}
			else if(enemy.size == Astroid.MEDIUM)
			{
				//Medium astroid shot
				_hud.updateScore(50);
				astroid = new Astroid(_astroidGenerator.generateAstroid(Astroid.SMALL), 3 * ASTROID_SPEED, Astroid.SMALL, new Point(Math.cos(enemy.initialAngle - Math.PI/8), Math.sin(enemy.initialAngle - Math.PI/8)));
				astroid.x = enemy.x;
				astroid.y = enemy.y;
				_asteroids.push(astroid);
				addChild(astroid);
				CollisionDetection.registerEnemy(astroid);
				
				astroid = new Astroid(_astroidGenerator.generateAstroid(Astroid.SMALL), 3 * ASTROID_SPEED, Astroid.SMALL, new Point(Math.cos(enemy.initialAngle + Math.PI/8), Math.sin(enemy.initialAngle + Math.PI/8)));
				astroid.x = enemy.x;
				astroid.y = enemy.y;
				_asteroids.push(astroid);
				addChild(astroid);
				CollisionDetection.registerEnemy(astroid);
				
			}
			else
			{
				//Small astroid shot
				_hud.updateScore(100);
			}
			
			if(_asteroids.length == 0)
			{
				if(_level < Levels.LEVELS.length)
					_level++
				createNewAstroids(Levels.LEVELS[_level].numberOfAstroids, Levels.LEVELS[_level].astroidSpeed);
				_backgroundMusicTimer.delay = Levels.LEVELS[_level].bgMusicSpeed;
				
			}
			
			
		}
		
		private function shipDestroyed():void
		{
			_lives--;
			_ship.shipDestroyed();
			CollisionDetection.deRegisterShip();

			//Lives left?
			if(_lives > 0)
			{
				_respawnTimer.addEventListener(TimerEvent.TIMER_COMPLETE, checkSafeRespawn);
				_respawnTimer.start();
				_hud.lifeLossed();
			}
			else
			{
				//Game Over
				_isGameRunning = false;
				_ship.visible = false;
				_enterToStartText.visible = true;
				_backgroundMusicTimer.reset();
			}
		}
		
		//Make sure ship is respawned when no asteroids are around
		private function checkSafeRespawn(e:TimerEvent):void
		{

			if( !CollisionDetection.quickRepawnSafeCheck(new RespawnCircle(width/2, height/2, 75)) )
			{
				_respawnTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, checkSafeRespawn);
				resetShip();
			}
			else
			{
				_respawnTimer.reset();
				_respawnTimer.start();
			}
			
		}
		
		private function resetShip():void
		{
			_ship.x = width/2;
			_ship.y = height/2;
			_ship.resetShip();
			
		}
		

	}
}