StaffRoll = Class.create();
StaffRoll.DefaultOptions = {
	header: '<div style="background-color: black; margin-top: 600px;">' + 
		"<div style='margin-bottom: 500px;'>#{project}</div>" + 
		"<div style='margin-bottom: 200px;'>STAFF</div>" + 
		'<dl>',
	staff_template: "<dt>#{title}</dt><dd style='margin-bottom: 200px;'>#{name}</dd><dt>&nbsp;</dt><dd>#{comment}</dd>",
	before_special_thanks: '<div style="margin: 300px 0px;">SPECIAL THANKS</div>',
	footer: "</dl>" + 
		"<div style='margin-top:400px; margin-bottom:200px;'>produced by<br/>#{team}</div>" + 
		"</div>"
}
Object.extend(StaffRoll.prototype, {
	initialize: function(container, data, options){
		this.container = $(container);
		this.data = data;
		this.options = $H(StaffRoll.DefaultOptions).merge($H(options || {}));
	},
	
	build: function(){
		if (this.options['staff_template'] == null){
			throw "staff_template not specified!";
		}
		var staff_template = this.options['staff_template'];
		var header = this.options['header'];
		var footer = this.options['footer'];
		var before_special_thanks = this.options['before_special_thanks'];
		
		if (!staff_template.evaluate) staff_template = new Template(staff_template);
		if (!before_special_thanks.evaluate) before_special_thanks = new Template(before_special_thanks);
		if (!header.evaluate) header = new Template(header);
		if (!footer.evaluate) footer = new Template(footer);
		var html = header.evaluate(this.data);
		this.data.staff.each(function(staff){
			html = html + staff_template.evaluate(staff);
		})
		html = html + before_special_thanks.evaluate(this.data);
		this.data.special_thanks.each(function(thank){
			html = html + staff_template.evaluate(thank);
		})
		html = html + footer.evaluate(this.data);
		this.container.innerHTML = html;
		this.container.style.overflowY = 'hidden';
		this.container.style.height = this.options['max-height'] || '500px';
		this.container.style.maxHeight = this.options['max-height'] || '500px';
		this.container.style.textAlign = 'center';
		this.container.style.fontSize = 'x-large';
		this.container.style.fontWeight = 'bolder';
	},
	
	process: function(){
		this.container.scrollTop = 0;
		setInterval(function(){
			this.container.scrollTop = this.container.scrollTop + 3;
		}.bind(this), 50);
	}
})