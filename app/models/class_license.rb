class ClassLicense < ApplicationRecord

  sortable_class scope: :class_name

  belongs_to :license

  has_many :same_class, class_name: 'ClassLicense',
           foreign_key: :class_name, primary_key: :class_name

  validates :class_name, presence: true, uniqueness: { scope: :license_id }

end
