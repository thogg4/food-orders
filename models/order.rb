class Order
  include Mongoid::Document

  field :burgers
  field :fries
  field :drinks
  field :total

end
