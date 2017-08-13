class Provider < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :user, inverse_of: :providers

  enum type: {
    facebook: 0,
    instagram: 1
  }

end
