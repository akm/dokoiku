JSON = {
	// escape a character
	escapeJSONChar: function (c) {
	    if(c == "\"" || c == "\\") return "\\" + c;
	    else if (c == "\b") return "\\b";
	    else if (c == "\f") return "\\f";
	    else if (c == "\n") return "\\n";
	    else if (c == "\r") return "\\r";
	    else if (c == "\t") return "\\t";
	    var hex = c.charCodeAt(0).toString(16);
	    if(hex.length == 1) return "\\u000" + hex;
	    else if(hex.length == 2) return "\\u00" + hex;
	    else if(hex.length == 3) return "\\u0" + hex;
	    else return "\\u" + hex;
	},
	
	toQuoted: function( s) {
	    var parts = s.split("");
	    for(var i=0; i < parts.length; i++) {
			var c =parts[i];
			if(c == '"' || c == '\\' )
			    parts[i] = JSON.escapeJSONChar(parts[i]);
	    }
	    return "\"" + parts.join("") + "\"";
	},
	
	// encode a string into JSON format
	escapeJSONString: function (s) {
	    // The following should suffice but Safari's regex is b0rken
	    // (doesn't support callback substitutions)
	    //
	    //   return "\"" + s.replace(/([^\u0020-\u007f]|[\\\"])/g,
	    //                           JSON.escapeJSONChar) + "\"";
	
	    // Rather inefficient way to do it
	    var parts = s.split("");
	    for(var i=0; i < parts.length; i++) {
			var c =parts[i];
			if(c == '"' ||  c == '\\' || c.charCodeAt(0) < 32 || c.charCodeAt(0) >= 128)
				parts[i] = JSON.escapeJSONChar(parts[i]);
	    }
	    return "\"" + parts.join("") + "\"";
	}, 
	
	// Marshall objects to JSON format
	toJSON: function (o, propertyPredicate, unescapedString) {
	    if(o == null) {
			return "null";
	    } else if(o.constructor == String) {
			return (unescapedString) ? JSON.toQuoted(o) : JSON.escapeJSONString(o);
	    } else if(o.constructor == Number) {
			return o.toString();
	    } else if(o.constructor == Boolean) {
			return o.toString();
	    } else if(o.constructor == Date) {
	    	return '{javaClass: "java.util.Date", time: ' + o.valueOf() +'}';
		//return o.valueOf().toString();
	    } else if(o.constructor == Array) {
			var v = [];
			for(var i = 0; i < o.length; i++)
				v.push(JSON.toJSON(o[i], propertyPredicate, unescapedString));
			return "[" + v.join(", ") + "]";
	    } else {
		var v = [];
		for(attr in o) {
			if (propertyPredicate) {
				if (propertyPredicate.constructor == Function) {
					if (!propertyPredicate( attr ))
						continue;
				} else if ((propertyPredicate.evaluate) && (propertyPredicate.evaluate.constructor == Function)) {
					if (!propertyPredicate.evaluate( attr ))
						continue;
				} else {
					if (propertyPredicate != attr)
						continue;
				}
			}
			if(o[attr] == null) 
				v.push("\"" + attr + "\": null");
			else if(typeof o[attr] == "function"); 
				// skip
			else 
				v.push(JSON.escapeJSONString(attr) + ": " + JSON.toJSON(o[attr], propertyPredicate, unescapedString));
		}
		return "{" + v.join(", ") + "}";
	    }
	}
}
