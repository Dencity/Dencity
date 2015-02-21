// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("getPopsAndPeople", function(request, response) {
	var query = new Parse.Query("Place");
	query.equalTo("name", request.params.name);
	query.find({
		success: function(results){
			var success = {"population" : results[0].get("population"), 
						   "people" : results[0].get("people"),
						   "oldPopulation" : results[0].get("oldPopulation")};
			response.success(success);
		},
		error: function(){
			response.error("Unable to retrieve data");
		}
	});
}); 

Parse.Cloud.job("recordCurrentPop", function(request, status){
	var query = new Parse.Query("Place");
	query.limit(1000);
	query.find({
		success: function(results){
			for (var i = 0; i < results.length; i++){
				var place = results[i];
				place.set("storedOldPopulation", place.get("population"));
				place.save();
			}
		},
		error: function(){
			//something went wrong
		}
	});
});

Parse.Cloud.job("setOldPop", function(request, status){
	var query = new Parse.Query("Place");
	query.limit(1000);
	query.find({
		success: function(results){
			for (var i = 0; i < results.length; i++){
				var place = results[i];
				var old = place.get("storedOldPopulation");
				place.set("oldPopulation", old);
				place.save();
			}
		},
		error: function(){
			//something went wrong
		}
	});
});