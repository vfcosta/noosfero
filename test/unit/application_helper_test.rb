require File.dirname(__FILE__) + '/../test_helper'

class ApplicationHelperTest < Test::Unit::TestCase

  include ApplicationHelper

  def setup
    self.stubs(:session).returns({})
  end

  should 'calculate correctly partial for object' do
    self.stubs(:params).returns({:controller => 'test'})

    File.expects(:exists?).with("#{RAILS_ROOT}/app/views/test/_float.rhtml").returns(false)
    File.expects(:exists?).with("#{RAILS_ROOT}/app/views/test/_numeric.rhtml").returns(true).times(2)
    File.expects(:exists?).with("#{RAILS_ROOT}/app/views/test/_runtime_error.rhtml").returns(true).at_least_once

    assert_equal 'numeric', partial_for_class(Float)
    assert_equal 'numeric', partial_for_class(Numeric)
    assert_equal 'runtime_error', partial_for_class(RuntimeError)
  end

  should 'give error when there is no partial for class' do
    assert_raises ArgumentError do
      partial_for_class(nil)
    end
  end

  should 'generate link to stylesheet' do
    File.expects(:exists?).with(File.join(RAILS_ROOT, 'public', 'stylesheets', 'something.css')).returns(true)
    expects(:filename_for_stylesheet).with('something', nil).returns('/stylesheets/something.css')
    assert_match '@import url(/stylesheets/something.css)', stylesheet_import('something')
  end

  should 'not generate link to unexisting stylesheet' do
    File.expects(:exists?).with(File.join(RAILS_ROOT, 'public', 'stylesheets', 'something.css')).returns(false)
    expects(:filename_for_stylesheet).with('something', nil).returns('/stylesheets/something.css')
    assert_no_match %r{@import url(/stylesheets/something.css)}, stylesheet_import('something')
  end

  should 'handle nil dates' do
    assert_equal '', show_date(nil)
  end


  should 'append with-text class and keep existing classes' do
    expects(:button_without_text).with('type', 'label', 'url', { :class => 'with-text class1'})
    button('type', 'label', 'url', { :class => 'class1' })
  end

  should 'generate correct link to category' do
    cat = mock
    cat.expects(:path).returns('my-category/my-subcatagory')
    cat.expects(:full_name).returns('category name')
    cat.expects(:environment).returns(Environment.default)
    Environment.any_instance.expects(:default_hostname).returns('example.com')

    result = "/cat/my-category/my-subcatagory"
    expects(:link_to).with('category name', :controller => 'search', :action => 'category_index', :category_path => ['my-category', 'my-subcatagory'], :host => 'example.com').returns(result)
    assert_same result, link_to_category(cat)
  end

  should 'nil theme option when no exists theme' do
    stubs(:current_theme).returns('something-very-unlikely')
    File.expects(:exists?).returns(false)
    assert_nil theme_option()
  end

  should 'nil javascript theme when no exists theme' do
    stubs(:current_theme).returns('something-very-unlikely')
    File.expects(:exists?).returns(false)
    assert_nil theme_javascript
  end

  should 'role color for admin role' do
    assert_equal 'blue', role_color(Profile::Roles.admin)
  end
  should 'role color for member role' do
    assert_equal 'green', role_color(Profile::Roles.member)
  end
  should 'role color for moderator role' do
    assert_equal 'gray', role_color(Profile::Roles.moderator)
  end
  should 'default role color' do
    assert_equal 'black', role_color('none')
  end

  should 'rolename for' do
    person = create_user('usertest').person
    community = Community.create!(:name => 'new community', :identifier => 'new-community', :environment => Environment.default)
    community.add_member(person)
    assert_equal 'Profile Member', rolename_for(person, community)
  end

  should 'display categories' do
    # FIXME implement this test!!!
    assert true
    #category = Category.create!(:name => 'parent category for testing', :environment_id => Environment.default)
    #child = Category.create!(:name => 'child category for testing',   :environment => Environment.default, :display_in_menu => true, :parent => category)
    #owner = create_user('testuser').person
    #@article = owner.articles.create!(:name => 'ytest')
    #@article.add_category(category)
    #expects(:environment).returns(Environment.default)
    #result = select_categories(:article)
    #assert_match /parent category/, result
  end

  should 'not display categories if has no child' do
    # FIXME implement this test!!!
    assert true
    #category = Category.create!(:name => 'parent category for testing', :environment_id => Environment.default)
    #owner = create_user('testuser').person
    #@article = owner.articles.create!(:name => 'ytest')
    #@article.add_category(category)
    #expects(:environment).returns(Environment.default)
    #result = select_categories(:article)
    #assert_no_match /parent category/, result
  end

  should 'get theme from environment by default' do
    @environment = mock
    @environment.stubs(:theme).returns('my-environment-theme')
    stubs(:profile).returns(nil)
    assert_equal 'my-environment-theme', current_theme
  end

  should 'get theme from profile when profile is present' do
    profile = mock
    profile.stubs(:theme).returns('my-profile-theme')
    stubs(:profile).returns(profile)
    assert_equal 'my-profile-theme', current_theme
  end

  should 'override theme with testing theme from session' do
    stubs(:session).returns(:theme => 'theme-under-test')
    assert_equal 'theme-under-test', current_theme
  end

  should 'point to system theme path by default' do
    expects(:current_theme).returns('my-system-theme')
    assert_equal '/designs/themes/my-system-theme', theme_path
  end

  should 'point to user theme path when testing theme' do
    stubs(:session).returns({:theme => 'theme-under-test'})
    assert_equal '/user_themes/theme-under-test', theme_path
  end

  should 'render theme footer' do
    stubs(:theme_path).returns('/user_themes/mytheme')
    footer = '../../public/user_themes/mytheme/footer.rhtml'

    File.expects(:exists?).with(RAILS_ROOT + '/app/views/../../public/user_themes/mytheme/footer.rhtml').returns(true)
    expects(:render).with(:file => footer).returns("BLI")

    assert_equal "BLI", theme_footer
  end

  should 'ignore unexisting theme footer' do
    stubs(:theme_path).returns('/user_themes/mytheme')
    footer = '../../public/user_themes/mytheme/footer.rhtml'

    File.expects(:exists?).with(RAILS_ROOT + '/app/views/../../public/user_themes/mytheme/footer.rhtml').returns(false)
    expects(:render).with(:file => footer).never

    assert_nil theme_footer
  end

  should 'expose theme owner' do
    theme = mock
    profile = mock
    Theme.expects(:find).with('theme-under-test').returns(theme)
    theme.expects(:owner).returns(profile)
    profile.expects(:identifier).returns('sampleuser')

    stubs(:current_theme).returns('theme-under-test')

    assert_equal 'sampleuser', theme_owner
  end

  should 'use default template when no profile' do
    stubs(:profile).returns(nil)

    foo = mock
    expects(:stylesheet_link_tag).with('/designs/templates/default/stylesheets/style.css').returns(foo)

    assert_same foo, template_stylesheet_tag
  end

  should 'use template from profile' do
    profile = mock
    profile.expects(:layout_template).returns('mytemplate')
    stubs(:profile).returns(profile)

    foo = mock
    expects(:stylesheet_link_tag).with('/designs/templates/mytemplate/stylesheets/style.css').returns(foo)

    assert_same foo, template_stylesheet_tag
  end

  should 'not force ssl when environment has ssl disabled' do
    environment = mock
    environment.expects(:disable_ssl).returns(true).at_least_once
    stubs(:environment).returns(environment)

    expects(:url_for).with(has_entries(:protocol => 'https://')).never
    expects(:url_for).with(has_key(:controller)).returns("LALALA")
    assert_equal "LALALA", login_url
  end

  should 'return nil if disable_categories is enabled' do
    env = Environment.create!(:name => 'env test')
    stubs(:environment).returns(env)
    assert_not_nil env
    env.enable(:disable_categories)
    assert env.enabled?(:disable_categories)
    assert_nil select_categories(mock)
  end

  should 'create rss feed link to blog' do
    p = create_user('testuser').person
    b = Blog.create!(:profile => p, :name => 'blog_feed_test')
    assert_tag_in_string meta_tags_for_article(b), :tag => 'link', :attributes => {:type => 'application/rss+xml', :title => 'feed'}
  end

  should 'provide sex icon for males' do
    stubs(:environment).returns(Environment.default)
    expects(:content_tag).with(anything, 'male').returns('MALE!!')
    expects(:content_tag).with(anything, 'MALE!!', is_a(Hash)).returns("FINAL")
    assert_equal "FINAL", profile_sex_icon(Person.new(:sex => 'male'))
  end

  should 'provide sex icon for females' do
    stubs(:environment).returns(Environment.default)
    expects(:content_tag).with(anything, 'female').returns('FEMALE!!')
    expects(:content_tag).with(anything, 'FEMALE!!', is_a(Hash)).returns("FINAL")
    assert_equal "FINAL", profile_sex_icon(Person.new(:sex => 'female'))
  end

  should 'provide undef sex icon' do
    stubs(:environment).returns(Environment.default)
    expects(:content_tag).with(anything, 'undef').returns('UNDEF!!')
    expects(:content_tag).with(anything, 'UNDEF!!', is_a(Hash)).returns("FINAL")
    assert_equal "FINAL", profile_sex_icon(Person.new(:sex => nil))
  end

  should 'not draw sex icon for non-person profiles' do
    assert_equal '', profile_sex_icon(Community.new)
  end

  should 'not draw sex icon when disabled in the environment' do
    env = Environment.create!(:name => 'env test')
    env.expects(:enabled?).with('disable_gender_icon').returns(true)
    stubs(:environment).returns(env)
    assert_equal '', profile_sex_icon(Person.new(:sex => 'male'))
  end

  should 'display field on signup' do
    env = Environment.create!(:name => 'env test')
    stubs(:environment).returns(env)

    controller = mock
    stubs(:controller).returns(controller)
    controller.expects(:action_name).returns('signup')

    profile = Person.new
    profile.expects(:signup_fields).returns(['field'])
    assert_equal 'SIGNUP_FIELD', optional_field(profile, 'field', 'SIGNUP_FIELD')
  end

  should 'not display field on signup' do
    env = Environment.create!(:name => 'env test')
    stubs(:environment).returns(env)

    controller = mock
    stubs(:controller).returns(controller)
    controller.expects(:action_name).returns('signup')

    profile = Person.new
    profile.expects(:signup_fields).returns([])
    assert_equal '', optional_field(profile, 'field', 'SIGNUP_FIELD')
  end

  should 'display active fields' do
    env = Environment.create!(:name => 'env test')
    stubs(:environment).returns(env)

    controller = mock
    stubs(:controller).returns(controller)
    controller.expects(:action_name).returns('edit')

    profile = Person.new
    profile.expects(:active_fields).returns(['field'])
    assert_equal 'SIGNUP_FIELD', optional_field(profile, 'field', 'SIGNUP_FIELD')
  end

  should 'not display active fields' do
    env = Environment.create!(:name => 'env test')
    stubs(:environment).returns(env)

    controller = mock
    stubs(:controller).returns(controller)
    controller.expects(:action_name).returns('edit')

    profile = Person.new
    profile.expects(:active_fields).returns([])
    assert_equal '', optional_field(profile, 'field', 'SIGNUP_FIELD')
  end

  should 'display required fields' do
    env = Environment.create!(:name => 'env test')
    stubs(:environment).returns(env)

    controller = mock
    stubs(:controller).returns(controller)
    controller.expects(:action_name).returns('edit')

    stubs(:required).with('SIGNUP_FIELD').returns('<span>SIGNUP_FIELD</span>')
    profile = Person.new
    profile.expects(:active_fields).returns(['field'])
    profile.expects(:required_fields).returns(['field'])
    assert_equal '<span>SIGNUP_FIELD</span>', optional_field(profile, 'field', 'SIGNUP_FIELD')
  end

  should 'display required fields on signup even if admin did not marked field to show up in signup' do
    env = Environment.create!(:name => 'env test')
    stubs(:environment).returns(env)

    controller = mock
    stubs(:controller).returns(controller)
    controller.expects(:action_name).returns('signup')

    stubs(:required).with('SIGNUP_FIELD').returns('<span>SIGNUP_FIELD</span>')
    profile = Person.new
    profile.stubs(:required_fields).returns(['field'])
    profile.stubs(:signup_fields).returns([])
    assert_equal '<span>SIGNUP_FIELD</span>', optional_field(profile, 'field', 'SIGNUP_FIELD')
  end

  should 'not ask_to_join unless profile defined' do
    e = Environment.default
    e.stubs(:enabled?).with(:disable_join_community_popup).returns(false)
    stubs(:environment).returns(e)

    stubs(:profile).returns(nil)
    assert ! ask_to_join?
  end

  should 'not ask_to_join unless profile is community' do
    e = Environment.default
    e.stubs(:enabled?).with(:disable_join_community_popup).returns(false)
    stubs(:environment).returns(e)

    p = create_user('test_user').person
    stubs(:profile).returns(p)
    assert ! ask_to_join?
  end

  should 'ask_to_join if its not logged and in a community' do
    e = Environment.default
    e.stubs(:enabled?).with(:disable_join_community_popup).returns(false)
    stubs(:environment).returns(e)

    c = Community.create(:name => 'test_comm', :identifier => 'test_comm')
    stubs(:profile).returns(c)
    stubs(:logged_in?).returns(false)
    assert ask_to_join?
  end

  should 'ask_to_join if user say so' do
    e = Environment.default
    e.stubs(:enabled?).with(:disable_join_community_popup).returns(false)
    stubs(:environment).returns(e)

    c = Community.create(:name => 'test_comm', :identifier => 'test_comm')
    stubs(:profile).returns(c)
    stubs(:logged_in?).returns(true)
    p = create_user('test_user').person
    p.stubs(:ask_to_join?).with(c).returns(true)
    stubs(:user).returns(p)

    assert ask_to_join?
  end

  should 'not ask_to_join if user say no' do
    e = Environment.default
    e.stubs(:enabled?).with(:disable_join_community_popup).returns(false)
    stubs(:environment).returns(e)
    c = Community.create(:name => 'test_comm', :identifier => 'test_comm')
    stubs(:profile).returns(c)
    stubs(:logged_in?).returns(true)
    p = create_user('test_user').person
    p.stubs(:ask_to_join?).with(c).returns(false)
    stubs(:user).returns(p)

    assert !ask_to_join?
  end

  should 'not ask_to_join if environment say no even if its not logged and in a community' do
    e = Environment.default
    e.stubs(:enabled?).with(:disable_join_community_popup).returns(true)
    stubs(:environment).returns(e)
    c = Community.create(:name => 'test_comm', :identifier => 'test_comm')
    stubs(:profile).returns(c)
    stubs(:logged_in?).returns(false)
    assert !ask_to_join?
  end

  should 'not ask_to_join if environment say no even if user say so' do
    e = Environment.default
    e.stubs(:enabled?).with(:disable_join_community_popup).returns(true)
    stubs(:environment).returns(e)
    c = Community.create(:name => 'test_comm', :identifier => 'test_comm')
    stubs(:profile).returns(c)
    stubs(:logged_in?).returns(true)
    p = create_user('test_user').person
    p.stubs(:ask_to_join?).with(c).returns(true)
    stubs(:user).returns(p)

    assert !ask_to_join?
  end


  protected

  def url_for(args = {})
    args
  end
  def content_tag(tag, content, options = {})
    content.strip
  end
  def javascript_tag(any)
    ''
  end
  def link_to(label, action, options = {})
    label
  end
  def check_box_tag(name, value = 1, checked = false, options = {})
    name
  end

end
