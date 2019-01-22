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
	// client.product.fetchQuery({query:"title:'Short-Sleeve T-Shirt'"}).then(function(products) {
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

	// fetch only the collections(all of it)
	// client.collection.fetchAll().then(function(collections) {
	// 	for(i = 0; i < collections.length; ++i) {
	// 		console.log(collections[i].title);
	// 	}
	// });

	//fetch all collections and all the products in it
	// client.collection.fetchAllWithProducts().then(function(collections) {
	// 	console.log("collections length " + collections.length);
	// 	for(i = 0; i < collections.length; ++i) {
	// 		console.log(collections[i].title);
	// 		products = collections[i].products;
	// 		for(j = 0; j < products.length; ++j) {
	// 			console.log(products[j].title);
	// 		}
	// 		console.log("++++++++++++++++++++++++");
	// 	}
	// });

	//fetch collection following given conditions
	// client.collection.fetchQuery({query:"title:'Long Sleeve'"}).then(function(collections) {
	// 	for(i = 0; i < collections.length; ++i) {
	// 		console.log(collections[i].title)
	// 	}
	// 	console.log(collections);
	// })

	//fetch collection and its products following given conditions
	// var collectionID;
	// client.collection.fetchQuery({query:"title:'Long Sleeve'"}).then(function(collections) {
	// 	collectionID = collections[0].id
	// 	console.log(collections);

	// 	client.collection.fetchWithProducts(collectionID).then(function(collection) {
	// 		products = collection.products;
	// 		for (var i = 0; i < products.length; i++) {
	// 			console.log(products[i].title)
	// 		}
	// 	})
	// })
});

var shopifyBuy_api = {
	productsPromise : function(client, conditions = {}) {
		if(conditions.length === 0)
			return client.product.fetchAll();
		else {
			return client.product.fetchQuery(conditions);
		}
	},
	allProduct : function(client) {
		var allProducts
		client.product.fetchAll().then(function(products) {
			allProducts = products;
		})
		return allProducts;
	},
	productsWith : function(client, conditions={}) {
		var product;
		client.product.fetchQuery(conditions).then(function(products) {
			product = products;
		})
		return product
	}
}