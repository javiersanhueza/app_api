class Book < ApplicationRecord
  has_many :reviews

  def self.allowed_attributes
    [:image, :author, :title]
  end
end
