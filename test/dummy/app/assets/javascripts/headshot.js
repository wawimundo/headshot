/* headshot */
/* Easily capture webcam images on Rails applications. */
/* Initially based on JPEGCam v1.0.9 by Joseph Huckaby. */
/* Copyright 2012 - Diwa del Mundo <diwadm@gmail.com> */
/* Licensed under the GNU Lesser Public License */
/* http://www.gnu.org/licenses/lgpl.html */

/* Usage:
	<script language="JavaScript">
		document.write( headshot.get_html(320, 240) );
		headshot.set_api_url( 'test.php' );
		headshot.set_hook( 'onComplete', 'my_callback_function' );
		function my_callback_function(response) {
			console.log("Server responded: " + response);
		}
	</script>
	<a href="javascript:void(headshot.snap())">Take Snapshot</a>
*/

window.headshot = {
	version: '0.1.0',
	
	// globals
	ie: !!navigator.userAgent.match(/MSIE/),
	protocol: location.protocol.match(/https/i) ? 'https' : 'http',
	callback: null, // user callback for completed uploads
	swf_url: 'headshot.swf', // URI to headshot.swf movie (defaults to cwd)
	shutter_url: 'shutter.mp3', // URI to shutter.mp3 sound
	api_url: '', // URL to upload script
	loaded: false, // true when headshot movie finishes loading
	quality: 90, // JPEG quality (1 - 100)
	shutter_sound: true, // shutter sound effect on/off
	stealth: false, // stealth mode (do not freeze image upon capture)
	hooks: {
		onLoad: null,
		onComplete: null,
		onError: null
	}, // callback hook functions
	
	set_hook: function(name, callback) {
		// set callback hook
		// supported hooks: onLoad, onComplete, onError
		if (typeof(this.hooks[name]) == 'undefined')
			return alert("Hook type not supported: " + name);
		
		this.hooks[name] = callback;
	},
	
	fire_hook: function(name, value) {
		// fire hook callback, passing optional value to it
		if (this.hooks[name]) {
			if (typeof(this.hooks[name]) == 'function') {
				// callback is function reference, call directly
				this.hooks[name](value);
			}
			else if (typeof(this.hooks[name]) == 'array') {
				// callback is PHP-style object instance method
				this.hooks[name][0][this.hooks[name][1]](value);
			}
			else if (window[this.hooks[name]]) {
				// callback is global function name
				window[ this.hooks[name] ](value);
			}
            else if (typeof(this.hooks[name]) == 'string') {
                // callback is a function but has a namespace
                var funcName = this.hooks[name] + "('" + value + "')";
                eval(funcName);
            }
			return true;
		}
		return false; // no hook defined
	},
	
	set_api_url: function(url) {
		// set location of upload API script
		this.api_url = url;
	},
	
	set_swf_url: function(url) {
		// set location of SWF movie (defaults to headshot.swf in cwd)
		this.swf_url = url;
	},
	
	get_html: function(width, height, params) {
		// Return HTML for embedding headshot capture movie
		// Specify pixel width and height (640x480, 320x240, etc.)
		// Server width and height are optional, and default to movie width/height
        server_width = params.server_width ? params.server_width : width;
        server_height = params.server_height ? params.server_height : height;
        session_key_name = params.session_key_name ? params.session_key_name : '';
        csrf_token = params.csrf_token ? params.csrf_token : '';
		
		var html = '';
		var flashvars = 'shutter_enabled=' + (this.shutter_sound ? 1 : 0) + 
			'&shutter_url=' + escape(this.shutter_url) + 
			'&width=' + width + 
			'&height=' + height + 
			'&server_width=' + server_width + 
			'&server_height=' + server_height +
            '&session_key_name=' + session_key_name +
            '&csrf_token=' + csrf_token;
		
		if (this.ie) {
			html += '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="'+this.protocol+'://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0" width="'+width+'" height="'+height+'" id="headshot_movie" align="middle"><param name="allowScriptAccess" value="always" /><param name="allowFullScreen" value="false" /><param name="movie" value="'+this.swf_url+'" /><param name="loop" value="false" /><param name="menu" value="false" /><param name="quality" value="best" /><param name="bgcolor" value="#ffffff" /><param name="flashvars" value="'+flashvars+'"/></object>';
		}
		else {
			html += '<embed id="headshot_movie" src="'+this.swf_url+'" loop="false" menu="false" quality="best" bgcolor="#ffffff" width="'+width+'" height="'+height+'" name="headshot_movie" align="middle" allowScriptAccess="always" allowFullScreen="false" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" flashvars="'+flashvars+'" />';
		}
		
		this.loaded = false;
		return html;
	},
	
	get_movie: function() {
		// get reference to movie object/embed in DOM
		if (!this.loaded) return alert("ERROR: Movie is not loaded yet");
		var movie = document.getElementById('headshot_movie');
		if (!movie) alert("ERROR: Cannot locate movie 'headshot_movie' in DOM");
		return movie;
	},
	
	set_stealth: function(stealth) {
		// set or disable stealth mode
		this.stealth = stealth;
	},
	
	snap: function(url, callback, stealth) {
		// take snapshot and send to server
		// specify fully-qualified URL to server API script
		// and callback function (string or function object)
		if (callback) this.set_hook('onComplete', callback);
		if (url) this.set_api_url(url);
		if (typeof(stealth) != 'undefined') this.set_stealth( stealth );
		
		this.get_movie()._snap( this.api_url, this.quality, this.shutter_sound ? 1 : 0, this.stealth ? 1 : 0 );
	},
	
	freeze: function() {
		// freeze headshot image (capture but do not upload)
		this.get_movie()._snap('', this.quality, this.shutter_sound ? 1 : 0, 0 );
	},
	
	upload: function(url, callback) {
		// upload image to server after taking snapshot
		// specify fully-qualified URL to server API script
		// and callback function (string or function object)
		if (callback) this.set_hook('onComplete', callback);
		if (url) this.set_api_url(url);
		
		this.get_movie()._upload( this.api_url );
	},
	
	reset: function() {
		// reset movie after taking snapshot
		this.get_movie()._reset();
	},
	
	configure: function(panel) {
		// open flash configuration panel -- specify tab name:
		// "camera", "privacy", "default", "localStorage", "microphone", "settingsManager"
		if (!panel) panel = "camera";
		this.get_movie()._configure(panel);
	},
	
	set_quality: function(new_quality) {
		// set the JPEG quality (1 - 100)
		// default is 90
		this.quality = new_quality;
	},
	
	set_shutter_sound: function(enabled, url) {
		// enable or disable the shutter sound effect
		// defaults to enabled
		this.shutter_sound = enabled;
		this.shutter_url = url ? url : 'shutter.mp3';
	},
	
	flash_notify: function(type, msg) {
		// receive notification from flash about event
		switch (type) {
			case 'flashLoadComplete':
				// movie loaded successfully
				this.loaded = true;
				this.fire_hook('onLoad');
				break;

			case 'error':
				// HTTP POST error most likely
				if (!this.fire_hook('onError', msg)) {
					alert("Flash Error: " + msg);
				}
				break;

			case 'success':
				// upload complete, execute user callback function
				// and pass raw API script results to function
				this.fire_hook('onComplete', msg.toString());
				break;

			default:
				// catch-all, just in case
				alert("flash_notify: " + type + ": " + msg);
				break;
		}
	}
};
