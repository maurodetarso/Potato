package
{
	import flash.display.Sprite;
	import potato.media.video.VideoPlayback;
	
	public class VideoPlaybackSample extends Sprite
	{
		public var videoPlayback:VideoPlayback;
		public var control:MediaControl;
		
		public function VideoPlaybackSample()
		{
			stage.scaleMode = "noScale";
			stage.align = "TL";

			//Just instantiate, add to displayList and load the video file, then you can play, pause, stop...
			//AutoPlay do not work here. If you want that the video plays imediattly after load, just do videoPlayback.play().
			videoPlayback = new VideoPlayback();
			videoPlayback.load("data/robo.f4v");
			container.addChild(videoPlayback);
			
			//See MediaControl.as for examples of VideoPlayback controlling.
			control = new MediaControl(mediaControl);
			addChild(control.view);
			control.media = videoPlayback;
			
			container.mask = videoMask;
		}
	}
}