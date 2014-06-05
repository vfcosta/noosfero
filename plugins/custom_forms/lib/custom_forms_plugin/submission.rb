class CustomFormsPlugin::Submission < Noosfero::Plugin::ActiveRecord
  belongs_to :form, :class_name => 'CustomFormsPlugin::Form'
  belongs_to :profile

  has_many :answers, :class_name => 'CustomFormsPlugin::Answer', :dependent => :destroy

  attr_accessible :form, :profile

  validates_presence_of :form
  validates_presence_of :author_name, :author_email, :if => lambda {|submission| submission.profile.nil?}
  validates_uniqueness_of :author_email, :scope => :form_id, :allow_nil => true
  validates_format_of :author_email, :with => Noosfero::Constants::EMAIL_FORMAT, :if => (lambda {|submission| !submission.author_email.blank?})

  def self.human_attribute_name(attrib)
    if /\d+/ =~ attrib and (f = CustomFormsPlugin::Field.find_by_id(attrib.to_i))
      f.name
    else
      attrib
    end
  end

end

