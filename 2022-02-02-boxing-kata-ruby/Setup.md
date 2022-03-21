My Boxing Kata Setup & Documentation
=================

Instructions to run Boxing Kata
------------
Run the Boxing Kata
1. Install any dependencies with command `bundle install`
2. To run the kata enter command `ruby ./bin/boxing-kata spec/fixtures/family_preferences.csv`

Run the Boxing Kata test specs
1. In command line run: `bin/rspec`


Technical Decision Making
------------
I chose to break up my code following a few tasks that we needed complete:
- Reading CSV file
- Building starter boxes (count the colors, group any together, print the leftover)
- Building refill boxes
- Calculating delivery the schedule
- Calculating Mail class from box weight

I decided to move most of the logic into a separate BuildBox class to keep the access point to the project smaller. Also I thought it made more sense for using instance variables and sharing variables across methods.

When building both starter and refill boxes I decided to separate the problem into two parts.
- If a family had more than 1 brush of a color they would be grouped together for shipping
- The leftover single brush colors can be grouped for shipping


Next Steps
------------
- Continued refactor - breaking out the starter box & refill box methods into their own classes. These box classes could have a type (starter/refill), capacity(2/4), mail class, schedule. 
  - This would probably be easier to track the boxes (and write tests). Each box class would then have its own methods that are associated with building the box.
- Adding more edge case tests
- Adding tests to check the output of the starter and refill boxes, needed more refactoring before this since I was having issues verifying the long output.   
