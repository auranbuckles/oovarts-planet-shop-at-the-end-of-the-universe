$(function() {

	$(".show-orders").on("click", function(e) {
    // $.ajax({
    //   method: "GET",
    //   url: this.href
    // }).success(function(response){
    //   // Get the response (it's the variable data)
    //   $("div.orders-list").html(response);
    //   // We'd really want to load that data into the DOM (add it to the current page)
    // }).error(function(){
    //   alert("There was an error.");
    // });

    // prevent response from loading a new page
    e.preventDefault();

    $.get(this.href).success(function(json) {
    	var list = $("div.orders-list")
    	list.html("")

    	json.forEach(function(order) {
    		debugger
    	})
    })
	});

	$("#next-feature").on("click", function(e) {

	});
});