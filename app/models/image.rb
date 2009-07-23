class Image < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true

  def self.max_size
    Image.attachment_options[:max_size]
  end

  has_attachment :content_type => :image, 
                 :storage => :file_system, 
                 :resize_to => '320x200>',
                 :thumbnails => { :big      => '150x150',
                                  :thumb    => '100x100',
                                  :portrait => '64x64',
                                  :minor    => '50x50',
                                  :icon     => '20x20!' },
                 :max_size => 500.kilobytes # remember to update validate message below

  validates_attachment :size => N_("%{fn} of uploaded file was larger than the maximum size of 500.0 KB")
end
