# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('document').ready () ->
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

	shopify_buy_api.productsPromise().then (products) ->
		renderer.drawProducts(products)
		# product_list = document.getElementById('product_list');
		# product_template = document.getElementById('product_template').innerHTML;
		# for product in products
		# 	productHTML = product_template.replace('style="display:none', '');
		# 	productHTML = productHTML.replace('{image_source}', product.images[0].src);
		# 	productHTML = productHTML.replace('{title}', product.title);
		# 	productHTML = productHTML.replace('{price}', product.variants[0].price);
		# 	productHTML = productHTML.replace('{vid}', product.variants[0].id);
		# 	product_list.innerHTML += productHTML;

	shopify_buy_api.checkoutPromise().then (checkout) ->
		renderer.drawCart(checkout)
		# cartList = document.getElementById('cartList');
		# lineItemTemplate = document.getElementById('lineItemTemplate').innerHTML;
		# for lineItem in checkout.lineItems
		# 	lineItemHTML = lineItemTemplate
		# 	lineItemHTML = lineItemHTML.replace('{title}', lineItem.title);
		# 	while lineItemHTML.indexOf('{liid}') != -1
		# 		lineItemHTML = lineItemHTML.replace('{liid}', lineItem.id);
		# 	lineItemHTML = lineItemHTML.replace('{quantity}', lineItem.quantity)
		# 	lineItemHTML = lineItemHTML.replace('{price}', lineItem.variant.price)
		# 	lineItemHTML = lineItemHTML.replace('{image_source}', lineItem.variant.image.src)
		# 	cartList.innerHTML += lineItemHTML;
