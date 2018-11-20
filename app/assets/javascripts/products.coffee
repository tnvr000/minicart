# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('document').ready () ->
	console.log("Ready")
	$('#products').dataTable({
		"sAjaxSource" : "products_tables.json",
		"bProcessing" : true,
		"bServerSide" : true,
		"autoWidth" : false,
		"aLengthMenu" : [[25, 50, -1], [25, 50, "All"]],
		"aoColumns" : [
			{"mData" : "id"},
			{"mData" : "name"},
			{"mData" : "price"},
			{"mData" : "category.name", "bSearchable" : "false"},
			{"mData" : "images.length", "bSearchable" : "false"}
		]
	});