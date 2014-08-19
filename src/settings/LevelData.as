package settings
{
	public class LevelData
	{
		public var numberOfAstroids:int;
		public var astroidSpeed:Number;
		public var bgMusicSpeed:int;
		
		public function LevelData(numberOfAstroids:int, astroidSpeed:Number, bgMusicSpeed:int)
		{
			this.numberOfAstroids = numberOfAstroids;
			this.astroidSpeed = astroidSpeed;
			this.bgMusicSpeed = Constants.BASE_BG_MUSIC_SPEED * bgMusicSpeed;
		}
	}
}