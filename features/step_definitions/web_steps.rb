# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.


require 'uri'
require 'cgi'
require_relative '../support/paths'

module WithinHelpers
  def with_scope(locator)
    if locator
      locator = first(locator) || locator
      within(locator) do
        yield
      end
    else
      yield
    end
  end
end
World(WithinHelpers)

Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )press "([^"]*)"(?: within "([^"]*)")?$/ do |button, selector|
  with_scope(selector) do
    click_button(button, :match => :prefer_exact)
  end
end

When /^(?:|I )follow "([^"]*)"(?: within "([^"]*)")?$/ do |link, selector|
  with_scope(selector) do
    link   = find :link_or_button, link, match: :prefer_exact
    # If the link has child elements, then $(link).click() has no effect,
    # so find the first child and click on it.
    if Capybara.default_driver == :selenium
      target = link.all('*').first || link
    else
      target = link
    end
    target.click
  end
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"(?: within "([^"]*)")?$/ do |field, value, selector|
  with_scope(selector) do
    fill_in(field, :with => value, :match => :prefer_exact)
  end
end

When /^(?:|I )fill in "([^"]*)" for "([^"]*)"(?: within "([^"]*)")?$/ do |value, field, selector|
  with_scope(selector) do
    fill_in(field, :with => value)
  end
end

When /^(?:|I )move the cursor over "([^"]*)"/ do |selector|
  find(selector).hover if Capybara.default_driver == :selenium
end

# Use this to fill in an entire form with data from a table. Example:
#
#   When I fill in the following:
#     | Account Number | 5002       |
#     | Expiry date    | 2009-11-01 |
#     | Note           | Nice guy   |
#     | Wants Email?   |            |
#
# TODO: Add support for checkbox, select og option
# based on naming conventions.
#
When /^(?:|I )fill in the following(?: within "([^"]*)")?:$/ do |selector, fields|
  with_scope(selector) do
    fields.rows_hash.each do |name, value|
      step %{I fill in "#{name}" with "#{value}"}
    end
  end
end

When /^(?:|I )select "([^"]*)" from "([^"]*)"(?: within "([^"]*)")?$/ do |value, field, selector|
  with_scope(selector) do
    select(value, :from => field)
  end
end

When /^(?:|I )check "([^"]*)"(?: within "([^"]*)")?$/ do |field, selector|
  with_scope(selector) do
    check(field)
  end
end

When /^(?:|I )uncheck "([^"]*)"(?: within "([^"]*)")?$/ do |field, selector|
  with_scope(selector) do
    uncheck(field)
  end
end

When /^(?:|I )choose "([^"]*)"(?: within "([^"]*)")?$/ do |field, selector|
  with_scope(selector) do
    choose(field, :match => :prefer_exact)
  end
end

When /^(?:|I )attach the file "([^"]*)" to "([^"]*)"(?: within "([^"]*)")?$/ do |path, field, selector|
  path = File.expand_path(path).gsub('/', File::ALT_SEPARATOR || File::SEPARATOR)
  with_scope(selector) do
    attach_file(field, path)
  end
  sleep 1
end

Then /^(?:|I )should see JSON:$/ do |expected_json|
  require 'json'
  expected = JSON.pretty_generate(JSON.parse(expected_json))
  actual   = JSON.pretty_generate(JSON.parse(response.body))
  expected.should == actual
end

Then /^(?:|I )should see "([^"]*)"(?: within "([^"]*)")?$/ do |text, selector|
  with_scope(selector) do
    expect(page).to have_content(text)
  end
end


Then /^(?:|I )should see "([^"]*)" within any "([^"]*)"?$/ do |text, selector|
  if page.respond_to? :should
    page.should have_css(selector, :text => text)
  else
    assert page.has_css?(selector, :text => text)
  end
end

Then /^(?:|I )should see \/([^\/]*)\/(?: within "([^"]*)")?$/ do |regexp, selector|
  regexp = Regexp.new(regexp)
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_xpath('//*', :text => regexp)
    else
      assert page.has_xpath?('//*', :text => regexp)
    end
  end
end

Then /^(?:|I )should not see "([^"]*)"(?: within "([^"]*)")?$/ do |text, selector|
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_no_content(text)
    else
      assert page.has_no_content?(text)
    end
  end
end

Then /^(?:|I )should not see \/([^\/]*)\/(?: within "([^"]*)")?$/ do |regexp, selector|
  regexp = Regexp.new(regexp)
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_no_xpath('//*', :text => regexp)
    else
      assert page.has_no_xpath?('//*', :text => regexp)
    end
  end
end

Then /^(?:|I )should not see "([^"]*)" within any "([^"]*)"?$/ do |text, selector|
  if page.respond_to? :should
    page.should have_no_css(selector, :text => text)
  else
    assert page.has_no_css?(selector, :text => text)
  end
end

Then /^the "([^"]*)" field(?: within "([^"]*)")? should contain "([^"]*)"$/ do |field, selector, value|
  with_scope(selector) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    if field_value.respond_to? :should
      field_value.should =~ /#{value}/
    else
      assert_match(/#{value}/, field_value)
    end
  end
end

Then /^the "([^"]*)" field(?: within "([^"]*)")? should not contain "([^"]*)"$/ do |field, selector, value|
  with_scope(selector) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    if field_value.respond_to? :should_not
      field_value.should_not =~ /#{value}/
    else
      assert_no_match(/#{value}/, field_value)
    end
  end
end

Then /^the "([^"]*)" checkbox(?: within "([^"]*)")? should be checked$/ do |label, selector|
  with_scope(selector) do
    field_checked = find_field(label)['checked']
    if field_checked.respond_to? :should
      field_checked.should be_truthy
    else
      assert field_checked
    end
  end
end

Then /^the "([^"]*)" checkbox(?: within "([^"]*)")? should not be checked$/ do |label, selector|
  with_scope(selector) do
    field_checked = find_field(label)['checked']
    if field_checked.respond_to? :should
      field_checked.should be_falsey
    else
      assert !field_checked
    end
  end
end

Then /^(?:|I )should be on (.+)$/ do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == path_to(page_name)
  else
    assert_equal path_to(page_name), current_path
  end
end

Then /^(?:|I )should be exactly on (.+)$/ do |page_name|
  uri = URI.parse(current_url)
  path_with_params = "#{uri.path}?#{uri.query}"
  if path_with_params.respond_to? :should
    path_with_params.should == path_to(page_name)
  else
    assert_equal path_to(page_name), path_with_params
  end
end

Then /^(?:|I )should have the following query string:$/ do |expected_pairs|
  query = URI.parse(current_url).query
  actual_params = query ? CGI.parse(query) : {}
  expected_params = {}
  expected_pairs.rows_hash.each_pair{|k,v| expected_params[k] = v.split(',')}

  if actual_params.respond_to? :should
    actual_params.should == expected_params
  else
    assert_equal expected_params, actual_params
  end
end

Then /^show me the page$/ do
  save_and_open_page
end

Then /^display "([^\"]*)"$/ do |element|
  # Need this " && false " work-around because this version of selenium doesn't
  # have the execute_script method which does not returns the script. Checout:
  #   * https://github.com/jnicklas/capybara/issues/76
  evaluate_script("jQuery('#{element}').show() && false;")
end

Then /^I fill in tinyMCE "(.*?)" with "(.*?)"$/ do |field, content|
  n = 0
  begin
    execute_script("tinymce.editors['#{field}'].setContent('#{content}')")
  rescue Selenium::WebDriver::Error::JavascriptError
    n += 1
    if n < 5
      sleep 1
      retry
    else
      raise
    end
  end
end

Then /^there should be a div with class "([^"]*)"$/ do |klass|
  should have_selector("div.#{klass}")
end

When /^(?:|I )follow exact "([^"]*)"(?: within "([^"]*)")?$/ do |link, selector|
  with_scope(selector) do
    find("a", :text => /\A#{link}\z/).click
  end
end

When /^(?:|I )wait ([^ ]+) seconds?(?:| .+)$/ do |seconds|
  sleep seconds.to_f
end

