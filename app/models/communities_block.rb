class CommunitiesBlock < ProfileListBlock

  attr_accessible :accessor_id, :accessor_type, :role_id, :resource_id, :resource_type

  def self.description
    _("<p>Display all of your communities.</p><p>You could choose the amount of communities will be displayed and you could priorize that profiles with images.</p> <p>The view all button is always present in the block.</p>")
  end

  def self.short_description
    _('Communities')
  end

  def self.pretty_name
    _('Communities Block')
  end

  def default_title
    n_('{#} community', '{#} communities', profile_count)
  end

  def help
    _('This block displays the communities in which the user is a member.')
  end

  def suggestions
    return nil unless owner.kind_of?(Profile)
    owner.profile_suggestions.of_community.enabled.limit(3).includes(:suggestion)
  end

  def profiles
    owner.communities.no_templates
  end

  def api_content(params = {})
    content = {}
    content['communities'] = Api::Entities::Community.represent(profiles.limit(self.limit)).as_json
    content['#'] = profiles.size
    content
  end
end
