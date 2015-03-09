module Paid
  class APIClass
    attr_accessor :json

    def self.path
      raise NotImplementedError.new("APIClass is an abstract class. Please refer to its subclasses: #{subclasses}")
    end

    def path
      raise NotImplementedError.new("APIClass is an abstract class. Please refer to its subclasses: #{APIClass.subclasses}")
    end

    def self.api_class_method(name, method, path=nil, opts={})
      singleton = class << self; self end
      singleton.send(:define_method, name, api_lambda(name, method, path, opts))
    end

    def self.api_instance_method(name, method, path=nil, opts={})
      self.send(:define_method, name, api_lambda(name, method, path, opts))
    end

    def self.attribute(name, klass=nil)
      @attribute_names ||= Set.new
      @attribute_names << name.to_sym

      self.send(:define_method, "#{name}", attribute_get_lambda(name))
      self.send(:define_method, "#{name}=", attribute_set_lambda(name, klass))
    end

    def attributes
      attributes = {}
      self.class.attribute_names.each do |attr|
        attributes[attr.to_sym] = self.send(attr)
      end
      attributes
    end

    def set_attributes
      attributes.select{|k, v| !v.nil? }
    end

    def self.attribute_names
      @attribute_names ||= Set.new
      unless self == APIClass
        @attribute_names + self.superclass.attribute_names
      else
        @attribute_names
      end
    end

    def mark_attribute_changed(attr_name)
      @changed_attribute_names ||= Set.new
      @changed_attribute_names << attr_name.to_sym
    end

    def changed_attribute_names
      @changed_attribute_names ||= Set.new
      attributes.each do |key, val|
        next if @changed_attribute_names.include?(key)
        if val.is_a?(Array) || val.is_a?(Hash)
          @changed_attribute_names << key if json[key] != val
        end
      end
      @changed_attribute_names
    end

    def changed_attributes
      ret = {}
      changed_attribute_names.each do |attr|
        ret[attr] = send(attr)
      end
      ret
    end

    def clear_changed_attributes
      @changed_attribute_names = Set.new
    end


    def self.changed_lambda
      # This runs in the context of an instance since it is used in
      # an api_instance_method
      lambda do |instance|
        instance.changed_attributes
      end
    end

    def initialize(id=nil)
      refresh_from(id)
    end

    def self.construct(json={})
      self.new.refresh_from(json)
    end

    def refresh_from(json={})
      unless json.is_a?(Hash)
        json = { :id => json }
      end
      self.json = Util.sorta_deep_clone(json)

      json.each do |k, v|
        if self.class.attribute_names.include?(k.to_sym)
          self.send("#{k}=", v)
        end
      end
      clear_changed_attributes
      self
    end

    # Alias, but dont declare it as one because we need to use overloaded methods.
    def construct(json={})
      refresh_from(json)
    end

    def self.subclasses
      return @subclasses ||= Set.new
    end

    def self.subclass_fetch(name)
      @subclasses_hash ||= {}
      if @subclasses_hash.has_key?(name)
        @subclasses_hash[name]
      end
    end

    def self.register_subclass(subclass, name=nil)
      @subclasses ||= Set.new
      @subclasses << subclass

      unless name.nil?
        @subclasses_hash ||= {}
        @subclasses_hash[name] = subclass
      end
    end

    def inspect
      id_string = (self.respond_to?(:id) && !self.id.nil?) ? " id=#{self.id}" : ""
      "#<#{self.class}:0x#{self.object_id.to_s(16)}#{id_string}> JSON: " + JSON.pretty_generate(set_attributes)
    end

    def to_json(*a)
      JSON.generate(set_attributes)
    end


    private

    def self.attribute_get_lambda(name)
      lambda do
        unless instance_variables.include?("@#{name}".to_sym)
          nil
        else
          instance_variable_get("@#{name}")
        end
      end
    end

    def self.attribute_set_lambda(name, klass=nil)
      lambda do |val|
        if klass
          val = klass.construct(val)
        end
        instance_variable_set("@#{name}", val)
        mark_attribute_changed(name)
      end
    end

    def self.api_lambda(out_name, out_method, out_path=nil, out_opts={})
      # Path, Opts, and Klass are all optional, so we have to determine
      # which were provided using the criteria:
      temp = [out_path, out_opts]
      out_path = temp.select{ |t| t.is_a?(String) }.first || nil
      out_opts = temp.select{ |t| t.is_a?(Hash) }.first || {}

      out_arg_names = out_opts[:arguments] || []
      out_constructor = out_opts[:constructor] || :self
      out_default_params = out_opts[:default_params] || {}

      lambda do |*args|
        # Make sure we have clean data
        constructor = out_constructor
        method = out_method
        path = nil
        path = out_path.dup if out_path
        arg_names = nil
        arg_names = out_arg_names.dup if out_arg_names
        default_params = out_default_params # dont need to dup this since it isn't modified directly

        validate_args(arg_names, *args)
        arguments = compose_arguments(method, arg_names, *args)
        composed_path = compose_api_path(path, arguments)
        unused_args = determine_unused_args(path, arg_names, arguments)
        arguments[:params] = compose_params(arguments[:params], unused_args, default_params)

        resp = Paid.request(method, composed_path, arguments[:params], arguments[:opts])


        if constructor.is_a?(Class)
          constructor.construct(resp)
        elsif constructor.is_a?(Proc)
          constructor.call(resp)
        elsif constructor.is_a?(Symbol)
          if constructor == :self
            self.construct(resp)
          else
            raise ArgumentError.new("Invalid constructor. See method definition.")
          end
        end
      end
    end

    def self.validate_args(arg_names, *args)
      # Make sure we have valid arguments
      if args.length > arg_names.length
        if args.length > arg_names.length + 2 # more than params and opts were included
          raise ArgumentError.new("Too many arguments")
        else
          # Params and opts are allowed, but they must be hashes
          args[arg_names.length..-1].each do |arg|
            unless arg.is_a?(Hash) || arg.nil?
              raise ArgumentError.new("Invalid Param or Opts argument")
            end
          end
        end
      end

      if args.length < arg_names.length
        missing = arg_names[args.length..-1]
        raise ArgumentError.new("Missing arguments #{missing}")
      end
    end
    def validate_args(arg_names, *args)
      self.class.validate_args(arg_names, *args)
    end

    # Priority: params > unused_args > default_params
    def self.compose_params(params={}, unused_args={}, default_params={}, this=self)
      ret = {}

      # Handle the default params
      if default_params.is_a?(Proc)
        default_params = default_params.call(this)
      elsif default_params.is_a?(Symbol)
        default_params = this.send(default_params)
      end

      ret.update(default_params || {})
      ret.update(unused_args || {})
      ret.update(params || {})
      ret
    end
    def compose_params(params={}, unused_args={}, default_params={})
      self.class.compose_params(params, unused_args, default_params, self)
    end

    def self.compose_arguments(method, arg_names, *args)
      arguments = {}
      names = arg_names.dup + [:params, :opts]

      names.each_with_index do |k, i|
        arguments[k] = args[i] if args.length > i
      end
      arguments[:params] ||= {}
      arguments[:opts] ||= {}

      arguments
    end
    def compose_arguments(method, arg_names, *args)
      self.class.compose_arguments(method, arg_names, *args)
    end

    def self.compose_api_path(path, arguments, this=self)
      # Setup the path using the following attribute order:
      #   1. Args passed in
      #   2. Args on this
      #   3. Args on this.class
      ret = (path || this.path).dup
      if ret.include?(":")
        missing = Set.new
        matches = ret.scan(/:([^\/]*)/).flatten.map(&:to_sym)
        matches.each do |match|
          value = arguments[match]
          begin
            value ||= this.send(match)
          rescue NoMethodError
          end
          begin
            value ||= this.class.send(match) unless this.class == Class
          rescue NoMethodError
          end

          if value.nil?
            missing << match
          end

          ret.sub!(match.inspect, "#{value}")
        end

        unless missing.empty?
          raise InvalidRequestError.new("Could not determine the full URL to request. Missing the following values: #{missing.to_a.join(', ')}.")
        end
      end
      ret
    end
    def compose_api_path(path, arguments)
      self.class.compose_api_path(path, arguments, self)
    end

    def self.determine_unused_args(path, arg_names, arguments, this=self)
      unused = Set.new(arg_names)
      path ||= this.path
      if path.include?(":")
        matches = path.scan(/:([^\/]*)/).flatten.map(&:to_sym)
        matches.each{ |m| unused.delete(m) }
      end
      ret = {}
      unused.each do |arg_name|
        ret[arg_name] = arguments[arg_name]
      end
      ret
    end
    def determine_unused_args(path, arg_names, arguments)
      self.class.determine_unused_args(path, arg_names, arguments, self)
    end

  end
end
