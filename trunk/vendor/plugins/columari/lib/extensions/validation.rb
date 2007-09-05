class ActiveRecord::Base
  module Columari
    module ValidationContext
      def validates(*args)
        self.klass.append_validation(self.column, args)
      end
    end

    module ValidationExtension
      def append_validation(column, options)
        return unless options
        options_array = options.is_a?(Array) ? options : [options]
        options_array.each do |validates_options|
          validates_options = {validates_options => nil} unless validates_options.is_a?(Hash)
          validates_options.each do |key, value|
            call_validates(column, key.to_s, value)
          end
        end
      end
      alias :append_validate :append_validation
      alias :append_validates :append_validation
      
      METHOD_NAME_PATTERNS = ['validates_%s_of', 'validates_%s']
      
      def call_validates(column, name, options)
        method_name = METHOD_NAME_PATTERNS.map{|pattern| pattern % name}.
          detect{|name| self.respond_to?(name)} or raise "method not found for '#{name}'"
        args = [column.name.to_sym]
        args << options if options
        ActiveRecord::Base.logger.info("#{self.name}.#{method_name}(*#{args.inspect})")
        self.send(method_name, *args)
      end
    end
  end
end
