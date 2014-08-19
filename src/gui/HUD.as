package gui
{
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class HUD extends Sprite
	{
		private var _textWidth:int;
		private var _textHeight:int;
		private var _scoreText:TextField;
		private var _score:int;
		private var _lives:int;
		private var _shipImages:Vector.<Image>;
		private var _startingLives:int;
		private var _shipTexture:Texture;
		
		public function HUD(textWidth:int, textHeight:int, startingLives:int, shipTexture:Texture)
		{
			super();
			_textWidth = textWidth;
			_textHeight = textHeight;
			_startingLives = startingLives;
			_shipTexture = shipTexture;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_scoreText = new TextField(_textWidth, _textHeight, "00", "Hyperspace", 32, 0xffffff);
			_scoreText.autoScale = true;
			addChild(_scoreText);
			
			_shipImages = new Vector.<Image>();
			var tempShipImage:Image
			for(var i:int; i < _startingLives; i++)
			{
				tempShipImage = new Image(_shipTexture)
				_shipImages.push(tempShipImage);
				tempShipImage.rotation = -Math.PI/2;
				tempShipImage.scaleX = 0.75;
				tempShipImage.scaleY = 0.75
				tempShipImage.x = i * tempShipImage.width;
				tempShipImage.y = _scoreText.height + tempShipImage.height;
				addChild(tempShipImage);
			}
			
			reset();
			
			
		}
		
		public function reset():void
		{
			_score = 0;
			_scoreText.text = "00";
			_lives = _startingLives;
			for(var i:int; i < _lives; i++)
				_shipImages[i].visible = true;
		}
		
		public function updateScore(points:int):void
		{
			_score += points
			_scoreText.text = String(_score);
		}
		
		public function lifeLossed():void
		{
			if(_lives >= 1)
				_lives--;
			_shipImages[_lives].visible = false;
			
		}
	}
}