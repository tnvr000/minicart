var client;
$(document).ready(function() {
	// code to initialize the client to interact with storefront
	client = ShopifyBuy.buildClient({
		domain: 'tnvr-demo.myshopify.com',
		storefrontAccessToken: '60df3ab40e520857fddf6bf446e67cd0'
	});

	//Fetch a product by id
	// id = 'Z2lkOi8vc2hvcGlmeS9Qcm9kdWN0LzI0NzAzMjgxMzk4NDA='
	// var pr
	// client.product.fetch(id).then(function(prt){pr = prt});
	// console.log(pr);

	//fetch all the products
	// client.product.fetchAll().then(function(products) {
	// 	for(i = 0; i < products.length; ++i) {
	// 		console.log(products[i].title);
	// 	}
	// });

	//fetch products by query
	// client.product.fetchQuery({handle: "short-sleeve-t-shirt"}).then(function(products) {
	// 	for(i = 0; i < products.length; ++i) {
	// 		console.log(products[i].title);
	// 	}
	// })

	//fetch product in promise and then resolve it
	// productsPromise = client.product.fetchQuery({handle: "short-sleeve-t-shirt"})
	// return productsPromise.then(function(products) {
	// 	for(i = 0; i < products.length; ++i) {
	// 		console.log(products[i].title);
	// 	}
	// })

	
});
