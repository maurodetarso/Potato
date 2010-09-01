package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import potato.media.interfaces.IMedia;
	import potato.media.MediaEvent;
	
	public class MediaControl
	{
		public var btnPlay:Btn;
		public var btnPause:Btn;
		public var btnStop:Btn;
		public var barTime:ProgressBar;
		public var barLoading:ProgressBar;
		public var barVolume:ProgressBar;
		public var label:TextField;
		
		//Holds the SoundPlayback or VideoPlayback instance
		protected var _media:*;
		protected var _view:*;
		
		public function MediaControl(view:*)
		{
			//Only configs the btns and bars funcionality
			_view = view;
			btnPlay = new Btn(view["btnPlay"]);
			btnPause = new Btn(view["btnPause"]);
			btnStop = new Btn(view["btnStop"]);
			btnPause.enabled = btnStop.enabled = false;
			
			barTime = new ProgressBar(view["barTime"], 0, view["barTimeBase"]);
			barTime.onClick = barTimeClickHandler;
			barLoading = new ProgressBar(view["barLoading"]);
			barVolume = new ProgressBar(view["barVolume"], 0, view["barVolumeBase"]);
			barVolume.onClick = barVolumeClickHandler;
			
			label = view["label"];
			label.text = "";
		}
		
		public function get view():*
		{
			return _view;
		}
		
		public function set media(value:*):void
		{
			//The media instance. In this case, can be SoundPlayback or VideoPlayback.
			_media = value;
			
			//Setting the playback listeners to the media. (see potato.media.interfaces.IMedia, potato.media.interfaces.ITimeline) 
			_media.addEventListener(MediaEvent.PLAY, playHandler);
			_media.addEventListener(MediaEvent.PAUSE, pauseHandler);
			_media.addEventListener(MediaEvent.STOP, stopHandler);
			_media.addEventListener(MediaEvent.PLAYBACK_START, playbackStartHandler);
			_media.addEventListener(MediaEvent.PLAYBACK_PROGRESS, playbackProgressHandler);
			_media.addEventListener(MediaEvent.PLAYBACK_COMPLETE, playbackCompleteHandler);
			
			//Load events are dispathced only by IStream objects. (see potato.media.interfaces.IStream) 
			//In this case, either SoundPlayback or VideoPlayback contains a IStream instance that can be used: stream.
			_media.stream.addEventListener(MediaEvent.LOAD_START, loadStartHandler);
			_media.stream.addEventListener(MediaEvent.LOAD_PROGRESS, loadProgressHandler);
			_media.stream.addEventListener(MediaEvent.LOAD_COMPLETE, loadCompleteHandler);
			
			//Playback controls: play, pause and stop. (see potato.media.interfaces.IMedia)
			btnPlay.onClick = media.play;
			btnPause.onClick = media.pause;
			btnStop.onClick = media.stop;
		}
		
		public function get media():*
		{
			return _media;
		}
		
		public function dispose():void
		{
			if (!_media) return;
			_media.removeEventListener(MediaEvent.PLAY, playHandler);
			_media.removeEventListener(MediaEvent.PAUSE, pauseHandler);
			_media.removeEventListener(MediaEvent.STOP, stopHandler);
			_media.removeEventListener(MediaEvent.PLAYBACK_START, playbackStartHandler);
			_media.removeEventListener(MediaEvent.PLAYBACK_PROGRESS, playbackProgressHandler);
			_media.removeEventListener(MediaEvent.PLAYBACK_COMPLETE, playbackCompleteHandler);
			_media.stream.removeEventListener(MediaEvent.LOAD_START, loadStartHandler);
			_media.stream.removeEventListener(MediaEvent.LOAD_PROGRESS, loadProgressHandler);
			_media.stream.removeEventListener(MediaEvent.LOAD_COMPLETE, loadCompleteHandler);
			_media = null;
		}
		
		protected function playHandler(...e):void
		{
			btnPlay.enabled = false;
			btnPause.enabled = true;
			btnStop.enabled = true;
			log("play");
		}
		
		protected function pauseHandler(...e):void
		{
			btnPlay.enabled = true;
			btnPause.enabled = false;
			btnStop.enabled = true;
			log("pause");
		}
		
		protected function stopHandler(...e):void
		{
			btnPlay.enabled = true;
			btnPause.enabled = false;
			btnStop.enabled = false;
			log("stop");
		}
		
		protected function playbackStartHandler(...e):void
		{
			log("playback start");
		}
		
		protected function playbackProgressHandler(...e):void
		{
			barTime.ratio = _media.timeRatio;
		}
		
		protected function playbackCompleteHandler(...e):void
		{
			log("playback complete");
		}
		
		protected function loadStartHandler(...e):void
		{
			log("load start");
		}
		
		protected function loadProgressHandler(...e):void
		{
			barLoading.ratio = _media.stream.loadRatio;
		}
		
		protected function loadCompleteHandler(...e):void
		{
			log("load complete");
		}
		
		protected function barTimeClickHandler(...e):void
		{
			media.timeRatio = barTime.ratio;
		}
		
		protected function barVolumeClickHandler(...e):void
		{
			media.volume = barVolume.ratio;
		}
		
		protected function log(msg:String):void
		{
			label.appendText(label.numLines+": "+msg.toUpperCase()+"\n");
			label.scrollV = label.maxScrollV;
			trace(msg);
		}
	}
}



import flash.display.Sprite;
import flash.events.MouseEvent;

internal class Btn
{
	public var onClick:Function;
	
	protected var _view:Sprite;
	protected var _enabled:Boolean;
	
	public function Btn(view:Sprite)
	{
		_view = view;
		view.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		view.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
		view.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
		enabled = true;
	}
	
	public function get view():Sprite
	{
		return _view;
	}
	
	public function dispose():void
	{
		_view.removeEventListener(MouseEvent.CLICK, clickHandler);
		_view.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
		_view.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		_view = null;
	}
	
	public function set enabled(value:Boolean):void
	{
		if (_enabled == value) return;
		_enabled = value;
		_view.buttonMode = _enabled;
		_view.mouseEnabled = _enabled;
		_view.alpha = _enabled ? 1 : .3;
	}
	
	public function get enabled():Boolean
	{
		return _enabled;
	}
	
	protected function clickHandler(...e):void
	{
		if (onClick != null) onClick();
	}
	
	protected function rollOverHandler(...e):void
	{
		if (!_enabled) return;
		_view.alpha = .7;
	}
	
	protected function rollOutHandler(...e):void
	{
		if (!_enabled) return;
		_view.alpha = 1;
	}
}

internal class ProgressBar
{
	public var onClick:Function;
	
	protected var _view:Sprite;
	protected var _ratio:Number;
	protected var _range:Number;
	protected var _base:Sprite;
	
	public function ProgressBar(view:Sprite, range:Number = 0, base:Sprite = null)
	{
		_view = view;
		_range = range > 0 ? range : _view.width;
		_ratio = 0;
		_base = base;
		_view.mouseEnabled = false;
		
		if(base != null) {
			base.addEventListener(MouseEvent.CLICK, baseClickHandler, false, 0, true);
			base.buttonMode = true;
		}
	}
	
	public function get view():Sprite
	{
		return _view;
	}
	
	public function set ratio(value:Number):void
	{
		_ratio = value;
		_view.width = _range * _ratio;
	}
	
	public function get ratio():Number
	{
		return _ratio;
	}
	
	public function dispose():void
	{
		if (_base) {
			_base.removeEventListener(MouseEvent.CLICK, baseClickHandler);
			_base = null;
		}	
		_view = null;
	}
	
	protected function baseClickHandler(...e):void
	{
		ratio = _base.mouseX/_base.width;
		if (onClick != null) onClick();
	}
}