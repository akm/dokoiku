class ActiveRecord::Base
  module Columari
    module AssociationContext
      def associates(*args)
        self.klass.append_association(self.column, args)
      end
    end

    module AssociationExtension
      def append_association(column, options)
        return unless options
        options = [options] unless options.is_a?(Array)
        options.each do |option|
          call_association(column, option)
        end
      end
      alias :append_associations :append_association
      
      def call_association(column, definitions)
        definitions = {definitions => {}} unless definitions.is_a?(Hash)
        definitions.each do |method_name, options|
          raise "unsupported association: #{method_name.to_s}" unless self.respond_to?(method_name)
          options = {
            :name => column.base_name.to_sym,
            :foreign_key => column.name
          }.merge(options)
          args = [options.delete(:name), options]
          ActiveRecord::Base.logger.info("#{self.name}.#{method_name}(*#{args.inspect})")
          self.send(method_name, *args)
        end
      end
    end
  end
end
