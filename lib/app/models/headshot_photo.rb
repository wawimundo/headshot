class HeadshotPhoto < ActiveRecord::Base
  belongs_to :capturable, :polymorphic => true

  #has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
end
