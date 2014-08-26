class Format < ActiveRecord::Base

  sortable

  has_many :formattings, dependent: :destroy, inverse_of: :format

end
