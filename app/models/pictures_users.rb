class PicturesUsers < ActiveRecord::Base
  belongs_to :user
  belongs_to :picture 
  
  def self.addsharedpicture(picture_id, user_id) 
    create(:picture_id => picture_id, :user_id => user_id)
  end
  
end
