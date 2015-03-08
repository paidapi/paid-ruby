# Setup a fake resource for testing the APIResource

class NestedResource < Paid::APIResource
  attribute :price

  def self.path
    "/nested_resources"
  end
end

class MockResource < Paid::APIResource
  attribute :name
  attribute :tarray
  attribute :thash
  attribute :nested, NestedResource

  api_class_method :retrieve, :get, ":path/:id", :arguments => [:id]
  api_class_method :all, :get, :constructor => Paid::APIList.constructor(MockResource)
  api_class_method :create, :post
  api_class_method :many_args_get, :get, ":path/:b/many", :arguments => [:a, :b, :c]
  api_class_method :many_args_post, :post, ":path/:b/many", :arguments => [:a, :b, :c]
  api_class_method :crazy_path, :get, ":crazy"

  api_class_method :with_con_self, :get, :constructor => :self
  api_class_method :with_con_class, :get, :constructor => MockResource
  api_class_method :with_con_lambda, :get, :constructor => lambda{ |json| "lamdba result" }
  api_class_method :with_con_default, :get

  def self.default_lambda
    lambda do |this|
      self.default_values
    end
  end
  api_class_method :with_lambda, :post, :default_params => self.default_lambda
  api_class_method :with_symbol, :post, :default_params => :default_values
  api_class_method :with_symbol_and_args, :post, :default_params => :default_values, :arguments => [:name]

  api_instance_method :refresh, :get, :constructor => :self
  api_instance_method :save, :put, :default_params => changed_lambda, :constructor => :self
  api_instance_method :delete, :delete
  api_instance_method :custom_path, :get, ":path", :arguments => [:path]
  api_instance_method :name_path, :get, ":name"
  api_instance_method :crazy_path, :get, ":crazy"

  api_instance_method :with_con_self, :get, :constructor => :self
  api_instance_method :with_con_class, :get, :constructor => MockResource
  api_instance_method :with_con_lambda, :get, :constructor => lambda{ |json| "lamdba result" }
  api_instance_method :with_con_default, :get

  api_instance_method :with_lambda, :put, :default_params => changed_lambda
  api_instance_method :with_symbol, :put, :default_params => :changed_attributes
  api_instance_method :with_symbol_and_args, :put, :default_params => :changed_attributes, :arguments => [:name]

  def self.path
    "/mocks"
  end

  def self.crazy
    "/crazy_path"
  end

  def self.default_values
    {
      :name => "default name",
      :tarray => [1,2,3]
    }
  end

end
