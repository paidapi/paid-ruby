module Paid
  class SingletonAPIResource < APIResource
    def self.api_url
      if self == SingletonAPIResource
        raise NotImplementedError.new('SingletonAPIResource is an abstract class.  You should perform actions on its subclasses (Account, etc.)')
      end
      "/v0/#{CGI.escape(class_name.downcase)}"
    end

    def api_url
      self.class.api_url
    end

    def self.retrieve(api_key=nil)
      instance = self.new(nil, api_key)
      instance.refresh
      instance
    end
  end
end
