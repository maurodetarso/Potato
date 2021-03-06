package potato.media.sound
{
	import flash.events.Event;
	
	import potato.media.MediaEvent;
	import potato.media.MediaState;
	
	/**
	 * SoundPlayback is an extension of SoundPlayer with a SoundStream instance, making it able to control the load and playback of the sounds.
	 * 
	 * @see potato.media.SoundPlayer
	 * @see potato.media.SoundStream
	 */
	public class SoundPlayback extends SoundPlayer
	{
		/**
		 * Holds the SoundStream instance.
		 */
		protected var _stream:SoundStream;
		
		/**
		 * Construtor.
		 */
		public function SoundPlayback()
		{
			super();
			_stream = new SoundStream();
			_stream.addEventListener(MediaEvent.METADATA_LOADED, id3LoadHandler);
		}
		
		/**
		 * The SoundStream instance.
		 */
		public function get stream():SoundStream
		{
			return _stream;
		}
		
		/**
		 * Begins the load operation, using the SoundStream instance.
		 */
		public function load(url:String):void
		{
			_state = MediaState.STOPPED;
			_stream.load(url);
			sound = stream.sound;
		}
		
		/**
		 * Handles the ID3 load.
		 */
		protected function id3LoadHandler(e:Event):void
		{
			if (_stream.sound.id3.TLEN) _timeTotal = _stream.sound.id3.TLEN;
		}

	}
}