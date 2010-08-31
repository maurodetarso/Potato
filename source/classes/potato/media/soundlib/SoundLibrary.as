package potato.media.soundlib
{
	import flash.media.Sound;
	import flash.utils.Dictionary;
	
	/**
	 * SoundLibrary holds many soundClips and groups, and manage them.
	 *  
	 * @see potato.media.soundlib.SoundClip
	 * @see potato.media.soundlib.SoundClipGroup
	 */
	public class SoundLibrary
	{ 	
		/**
		 * All added groups.
		 */
		protected var _groups:Dictionary;
		
		/**
		 * The group of all sounds added in this instance, doesn't matter what groups the sound was included.   
		 */
		protected var allSounds:SoundClipGroup;
		
		/**
		 * Construtor.
		 */
		public function SoundLibrary()
		{
			_groups = new Dictionary(true);
			allSounds = new SoundClipGroup("all");
			_groups["all"] = allSounds;
		}

		/**
		 * Can get one SoundClip instance or create a new, depending on the parameters specified.
		 * 
		 * <p>When id and sound paramenters was setted, it will create a new SoundClip instance with these both parameters,
		 * and add it at groups specified in the third parameter (if null, the soundClip go to "default" and "all" groups).
		 * If only id was given, this will simply return a SoundClip object.</p>
		 * 
		 * @param id The id of the SoundClip instance desired.
		 * @param sound The Sound instance that will be attached in the SoundClip instance.
		 * @param groups One or more groups that the SoundClip instance must be attached. (if the group don't exists, SoundLibrary will create a new group).  
		 */
		public function clip(id:String, sound:Sound = null, groups:Array = null):SoundClip
		{
			var clip:SoundClip = allSounds.pick(id);
			
			if (groups == null) groups = ["default"];
			
			if (clip == null) {
				clip = new SoundClip(id, sound);
				allSounds.add(clip);
				for each (var g:String in groups) {
					var group:SoundClipGroup = group(g);
					group.add(clip);
				}
			}
			
			return clip;
		}
		
		/**
		 * Can get one SoundClipGroup instance or create a new, depending on the parameters specified.
		 * 
		 * <p>If there is none instances with the specified id, a new one will be created with the id passed.</p>
		 * 
		 * @param id The id of the SoundClipGroup instance requested.
		 */
		public function group(id:String):SoundClipGroup
		{
			var group:SoundClipGroup = groups[id];
			
			if (group == null) {
				group = new SoundClipGroup(id);
				_groups[id] = group;
			}
			
			return group;
		}
		
		/**
		 * The group "all" that contains all the soundClips added.
		 */
		public function get all():SoundClipGroup
		{
			return allSounds;
		}
		
		/**
		 * The list of groups.
		 */
		public function get groups():Dictionary
		{
			return _groups;
		}
	}
}