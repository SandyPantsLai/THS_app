$(document).on('ready page:load', function() {
	$('#nav-toggle').on('click', function() {
		$(this).toggleClass('is-open');
	});
});