package potato.modules.tracking {
    
	/**
	* Tracking helper
	* */
    public function track(id:String, ...replace):void{
        Tracker.instance.track.apply(null, [id].concat(replace));
    }
}

