class Media < ActiveRecord::Base
  default_scope :order=> "position"
  has_attachment :content_type  => :image,
                 :storage       => :file_system,
                 :min_size      => 0,
                 :max_size      => 500.kilobytes,
                 :resize_to     => '500x500>',
                 :thumbnails    => { :thumb => 'c200x250' }

  validates_as_attachment
  
  belongs_to :owner, :polymorphic=> true
  
  def source_url=(url)
    data      = open(url)
    filename  = url.split("/").last
    data.instance_variable_set("@filename", filename)
    data.instance_eval do
      def original_filename
        @filename
      end
    end
    self.uploaded_data = data
    self[:source_url] = url
  end 
end
