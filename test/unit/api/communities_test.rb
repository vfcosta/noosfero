require File.dirname(__FILE__) + '/test_helper'

class CommunitiesTest < ActiveSupport::TestCase

  def setup
    login_api
  end

  should 'list all communities' do
    community1 = fast_create(Community, :public_profile => true)
    community2 = fast_create(Community)
    get "/api/v1/communities?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equivalent [community1.id, community2.id], json['communities'].map {|c| c['id']}
  end

  should 'not list invisible communities' do
    community1 = fast_create(Community)
    fast_create(Community, :visible => false)

    get "/api/v1/communities?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal [community1.id], json['communities'].map {|c| c['id']}
  end

  should 'not list private communities without permission' do
    community1 = fast_create(Community)
    fast_create(Community, :public_profile => false)

    get "/api/v1/communities?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal [community1.id], json['communities'].map {|c| c['id']}
  end

  should 'list private community for members' do
    c1 = fast_create(Community)
    c2 = fast_create(Community, :public_profile => false)
    c2.add_member(person)

    get "/api/v1/communities?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equivalent [c1.id, c2.id], json['communities'].map {|c| c['id']}
  end

  should 'get community' do
    community = fast_create(Community)

    get "/api/v1/communities/#{community.id}?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal community.id, json['community']['id']
  end

  should 'not get invisible community' do
    community = fast_create(Community, :visible => false)

    get "/api/v1/communities/#{community.id}?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert json['community'].blank?
  end

  should 'not get private communities without permission' do
    community = fast_create(Community)
    fast_create(Community, :public_profile => false)

    get "/api/v1/communities/#{community.id}?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal community.id, json['community']['id']
  end

  should 'get private community for members' do
    community = fast_create(Community, :public_profile => false)
    community.add_member(person)

    get "/api/v1/communities/#{community.id}?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal community.id, json['community']['id']
  end

  should 'list person communities' do
    community = fast_create(Community)
    fast_create(Community)
    community.add_member(person)

    get "/api/v1/people/#{person.id}/communities?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equivalent [community.id], json['communities'].map {|c| c['id']}
  end

  should 'not list person communities invisible' do
    c1 = fast_create(Community)
    c2 = fast_create(Community, :visible => false)
    c1.add_member(person)
    c2.add_member(person)

    get "/api/v1/people/#{person.id}/communities?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equivalent [c1.id], json['communities'].map {|c| c['id']}
  end

end
