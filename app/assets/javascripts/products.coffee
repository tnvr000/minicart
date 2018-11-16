# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('document').ready () ->
	console.log("Ready")
	$('#products').dataTable({
		"bProcessing" : true,
		"sAjaxSource" : "products_tables.json",
		"autoWidth" : false,
		"aoColumns" : [
			{"mData" : "name"},
			{"mData" : "price"},
			{"mData" : "category.name"},
			{"mData" : "images.length"}
		]
	});