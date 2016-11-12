// functions that convert strings to proper image file names and feature names
String.prototype.parameterize = function () {
  return this.trim().replace(/[^a-zA-Z0-9-\s]/g, '').replace(/[^a-zA-Z0-9-]/g, '-').toLowerCase();
}

String.prototype.capitalize = function() {
  return this.charAt(0).toUpperCase() + this.slice(1);
}

String.prototype.titleize = function() {
  var string_array = this.split(' ');
  string_array = string_array.map(function(str) {
     return str.capitalize(); 
  });
  
  return string_array.join(' ');
}

// click events on feature show page

$(function() {

	$(".show-orders").on("click", function(e) {
    // prevent response from loading a new page
    e.preventDefault();

    $(this).data('clicked', true);

    var currentId = $(".js-next").attr("data-id");

    $.get("/features/" + currentId + "/orders").success(function(json) {
    	console.log(currentId);
    	var list = $("div.orders-list table")
    	list.html("")

    	list.append("<tr><th>Order ID</th><th>Feature</th><th>Planet</th><th>Size (fy sq.)</th><th>Price (Pu)</th></tr>");

    	json.forEach(function(order) {
    		list.append("<tr><td>"
    		 + order.id + "</td>"
    		 + "<td>" + order.feature.name + "</td>"
    		 + "<td>" + order.planet.name + "</td>"
    		 + "<td>" + order.size + "</td>"
    		 + "<td>" + order.price * 1000
    		 + "</td></tr>")
    	})
    })
	});

	$(".js-next").on("click", function() {

		var nextId = parseInt($(".js-next").attr("data-id")) + 1;
    $.get("/features/" + nextId + ".json", function(feature) {
      $("#featureName").text(feature["name"].titleize());
      $("#featureDescription").text(feature["description"]);
      $("#featureImage").attr("src", "/assets/" + feature["name"].parameterize() + ".jpg");

      // re-set the id to current on the link
      $(".js-next").attr("data-id", feature["id"]);

      // does not show orders if user has not already clicked for it
	    if($(".show-orders").data('clicked')) {
		    $(".show-orders").click();
			}
    });
	});

	$(".js-previous").on("click", function() {

		var nextId = parseInt($(".js-next").attr("data-id")) - 1;
    $.get("/features/" + nextId + ".json", function(feature) {
      $("#featureName").text(feature["name"].titleize());
      $("#featureDescription").text(feature["description"]);
      $("#featureImage").attr("src", "/assets/" + feature["name"].parameterize() + ".jpg");

      // re-set the id to current on the link
      $(".js-next").attr("data-id", feature["id"]);

      // does not show orders if user has not already clicked for it
	    if($(".show-orders").data('clicked')) {
		    $(".show-orders").click();
			}
    });
	});
});

// feature object prototype added to the code through handlebars

function Feature(attributes) {
	this.id = attributes.id;
	this.name = attributes.name.titleize();
}

Feature.success = function(response) {
	var feature = new Feature(response);
	var featureLi = feature.renderLi();
	// featureLi through renderLi() is built from handlebars and the Feature object prototype
  $("#features-list ul").append(featureLi);
}

Feature.error = function(response) {
	console.log("Error", response);
}

$(function() {
	Feature.source = $("#feature-template").html();
	Feature.template = Handlebars.compile(Feature.source);
});

Feature.prototype.renderLi = function() {
	// this refers to the object itself that is being pass on to the template
	return Feature.template(this);
}

// new feature form submit events

$(function() {

	$("#new_feature").on('submit', function(e) {
		e.preventDefault();

	// 	$.ajax({
	// 		type: "post",
	// 		url: "/features",
	// 		data: $(this).serialize();
	// 		success: function(response) {
	// 			alert("success")
	// 		}
	// 	})

		var values = $(this).serialize();
		var posting = $.post('/features', values);
		posting.success(Feature.success)
		.error(Feature.error)
	});
});


