# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('document').ready () ->
	console.log("Ready")
	$('#products').dataTable({
		"pagingType": "full_numbers",
		"lengthMenu": [[25, 50, -1], [25, 50, "All"]],
		"scrollY": "250px"
	});