package 
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import starling.core.Starling;
	
	[SWF(width="640", height="480", frameRate="60", backgroundColor="#000000")]
	public class Kixteroids extends Sprite
	{
		private var mStarling:Starling;
		
		public function Kixteroids()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			// Create a Starling instance that will run the "Game" class
			mStarling = new Starling(Game, stage);
			mStarling.showStats = false;
			mStarling.start();
		}
	}
}