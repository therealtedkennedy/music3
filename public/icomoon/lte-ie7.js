/* Load this script using conditional IE comments if you need to support IE 7 and IE 6. */

window.onload = function() {
	function addIcon(el, entity) {
		var html = el.innerHTML;
		el.innerHTML = '<span style="font-family: \'icomoon\'">' + entity + '</span>' + html;
	}
	var icons = {
			'icon-bell' : '&#x2a;',
			'icon-untitled' : '&#x21;',
			'icon-untitled-2' : '&#x22;',
			'icon-untitled-3' : '&#x24;',
			'icon-untitled-4' : '&#x26;',
			'icon-untitled-5' : '&#x25;',
			'icon-untitled-6' : '&#x27;',
			'icon-untitled-7' : '&#x23;'
		},
		els = document.getElementsByTagName('*'),
		i, attr, c, el;
	for (i = 0; ; i += 1) {
		el = els[i];
		if(!el) {
			break;
		}
		attr = el.getAttribute('data-icon');
		if (attr) {
			addIcon(el, attr);
		}
		c = el.className;
		c = c.match(/icon-[^\s'"]+/);
		if (c && icons[c[0]]) {
			addIcon(el, icons[c[0]]);
		}
	}
};