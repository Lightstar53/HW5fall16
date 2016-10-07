# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end

 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

# PART 1
Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
   
  end
end

# PART 2
When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  
  if arg1.present?
    arg1 =arg1.gsub(/[,]/,"")
  end
  ratings = arg1.split
    ratings.each do |r|
     check("ratings_#{r}")
    end
end
Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
    if arg1.present?
      arg1 =arg1.gsub(/[,]/,"")
    end
    ratings = arg1.split
    ratings.each do |r|
        if r == "G"
            page.body.should match(/<td>G<\/td>/)
        end
        if r == "PG"
          page.body.should match(/<td>PG<\/td>/)
        end
        if r == "PG-13"
            page.body.should match(/<td>PG-13<\/td>/)
        end
        if r == "NC-17"
            page.body.should match(/<td>NC-17<\/td>/)
        end
        if r == "R"
            page.body.should match(/<td>R<\/td>/)
        end
    end
end

Then /^I should see all of the movies$/ do
    movies = Movie.all
    count = Movie.count()
    rows = page.all('#movies tr').size - 1
    rows.should == count
end

# PART 3
Then /I should see "(.*)" before "(.*)"/ do |movie1, movie2|
  m1 = (page.body =~ /#{movie1}/)
  m2 = (page.body =~ /#{movie2}/)
  m1.should < m2
end

When /I sort the results by (.*)/ do |sort_order|
  sort_id = sort_order.gsub(/\s/, '_')
  click_link "#{sort_id}_header"
end

When /I follow "Movie Title"/ do
  click_link "title_header"
end

When /I follow "Release Date"/ do
  click_link "release_date_header"
end