require 'carrierwave/orm/activerecord'
class Picture < ActiveRecord::Base
belongs_to :user
mount_uploader :image , ImageUploader

end