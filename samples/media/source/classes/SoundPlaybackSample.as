package
{
	import flash.display.Sprite;
	import potato.media.sound.SoundPlayback;
	
	public class SoundPlaybackSample extends Sprite
	{
		public var soundPlayback:SoundPlayback;
		public var control:MediaControl;
		
		public function SoundPlaybackSample()
		{
			stage.scaleMode = "noScale";
			stage.align = "TL";

			//Create a new instance and load the mp3.
			//AutoPlay do not work here. If you want that the sound plays imediattly after load, just do soundPlayback.play().
			soundPlayback = new SoundPlayback();
			soundPlayback.load("data/watery.mp3");
			
			//See MediaControl.as for examples of SoundPlayback controlling.
			control = new MediaControl(mediaControl);
			addChild(control.view);
			control.media = soundPlayback;
		}
	}
}