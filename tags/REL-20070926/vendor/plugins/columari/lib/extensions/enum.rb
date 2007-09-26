require 'enum_named'
class ActiveRecord::Base
  module Columari
    module EnumContext
      def enum(*args, &proc)
        self.klass.append_enum(self.column, {:entries => args}, &proc)
      end
    end

    module EnumExtension
      class UndefinedEnumKeyError < StandardError #:nodoc:
      end
      
      EMPTY_HASH = {}.freeze
      ENUM_CLASS_METHOD_PATTERNS = [
        ['cd', 'name'],
        ['key', 'name'],
        ['cd', 'key'],
        ['key', 'cd']
      ]
      ENUM_INSTANCE_METHOD_PATTERNS = ['name', 'key']
    
      def append_enum(column, options, &proc)
        mod_name = column.base_name.camelize

        mod = Module.new
        mod.__send__(:include, EnumNamed)
        mod.module_eval(&proc) if proc
        options[:entries].each do |entry_args|
          mod.define(*entry_args)
        end
        self.const_set(mod_name, mod)
        # ActiveRecord::Base.logger.info("define #{mod.name}")
        
#        instance_eval do
#          unless options[:define_validates_inclusion_of] == false
#            ActiveRecord::Base.logger.info(
#              "#{self.name}.validates_inclusion_of #{column.name.to_sym.inspect}, :in => #{mod.values(:id).inspect}")
#            validates_inclusion_of column.name.to_sym, 
#              :in => mod.values(:id),
#              :message => "は%sのいづれかでなければなりません" % mod.values(:id, :name).map{|ary|"#{ary[0]}(#{ary[1]})"}.join(', ')
#          end
#        end
        
        class << self
          def enum_for(column)
            return nil unless @enums
            @enums[column.respond_to?(:name) ? column.name : column.to_s]
          end
          def add_enum_for(column, enum)
            @enums ||= {}
            @enums[column.respond_to?(:name) ? column.name : column.to_s] = enum
          end
        end
        self.add_enum_for(column, mod)
        
        class_methods = ''
        enum_method_name = nil
        unless (def_options = options[:defines_enum]) == false
          def_options ||= EMPTY_HASH
          enum_method_name = def_options[:name] || "#{column.base_name}_enum"
          class_methods << <<-EOS
            def #{enum_method_name}(*keys)
              #{self.name}::#{mod_name}
            end
          EOS
        end
        enum_method_name ||= "#{self.name}::#{mod_name}"
        unless (def_options = options[:defines_class_select_options]) == false
          def_options ||= EMPTY_HASH
          class_methods << <<-EOS
            def #{def_options[:name] || "#{column.base_name}_options"}
              #{enum_method_name}.values(:name, :id)
            end
          EOS
        end
        unless (def_options = options[:defines_class_ids]) == false
          def_options ||= EMPTY_HASH
          class_methods << <<-EOS
            def #{def_options[:name] || "#{column.base_name}_ids"}(*keys)
              #{enum_method_name}.ids(*keys)
            end
          EOS
        end
        ENUM_CLASS_METHOD_PATTERNS.each do |pattern|
          param, result = *pattern
          param_inside, result_inside = *(pattern.map{|item|(item == 'cd') ? 'id' : item})
          unless (def_options = options['defines_class_#{result}_by_#{param}'.to_sym]) == false
            def_options ||= EMPTY_HASH
            class_methods << <<-EOS
              def #{def_options[:name] || "#{column.base_name}_#{result}_by_#{param}"}(#{param})
                #{self.name}::#{mod_name}[#{param}].#{result_inside}
              end
            EOS
          end
        end
        # ActiveRecord::Base.logger.info("#{self.name}.instance_eval(\n#{class_methods}\n)")
        self.instance_eval class_methods
        
        instance_methods = ''
        ENUM_INSTANCE_METHOD_PATTERNS.each do |pattern|
          result = *pattern
          unless (def_options = options['defines_#{result}'.to_sym]) == false
            def_options ||= EMPTY_HASH
            instance_methods << <<-EOS
              def #{def_options[:name] || "#{column.base_name}_#{result}"}
                self.class.#{column.base_name}_#{result}_by_cd(#{column.name})
              end
            EOS
          end
        end

        unless (def_options = options[:defines_key=]) == false
          def_options ||= EMPTY_HASH
          instance_methods << <<-EOS
            def #{def_options[:name] || "#{column.base_name}_key"}=(key)
              cd = key.nil? ? nil : (
                  self.class.#{column.base_name}_cd_by_key(key) or
                  raise UndefinedEnumKeyError, "undefined key of #{column.base_name}: #{'#'}{key}"
                )
              self.#{column.name} = cd
            end
          EOS
        end
        # ActiveRecord::Base.logger.info("#{self.name}.class_eval(\n#{instance_methods}\n)")
        self.class_eval instance_methods
      end
      
    end
  end
end
