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

	productsPromise = shopify_buy_api.productsPromise()
	productsPromise.then (products) ->
		product_list = document.getElementById('product_list')
		product_template = document.getElementById('product_template').innerHTML
		product_template = product_template.replace('style="display:none"', '')
		for product in products
			productHTML = product_template
			productHTML = productHTML.replace('{image_source}', product.images[0].src)
			productHTML = productHTML.replace('{title}', product.title)
			productHTML = productHTML.replace('{price}', product.variants[0].price)
			product_list.innerHTML += productHTML

	$("#add_to_cart").click( () ->
		cart = undefined
		shopify_buy_api.checkoutPromise.then( (checkout) ->
			cart = checkout
		)
	)