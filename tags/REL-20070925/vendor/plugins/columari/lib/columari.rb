class ActiveRecord::Base
  module Columari
    BASE_NAME_REGEXP = /(_id$|_cd$|_code$)/
    
    module ColumnDefinition
      def base_name
        @base_name ||= name.gsub(BASE_NAME_REGEXP, '')
        @base_name
      end
      def base_name=(value)
        @base_name = value
      end
    end
    
    class DummyColumn
      attr_reader :name, :base_name
      def initialize(attributes = {})
        @name = attributes[:name]
        @base_name = (attributes[:base_name] || @name.to_s.gsub(BASE_NAME_REGEXP, '')).to_s
      end
    end
    
    class Context
      attr_reader :klass, :column, :extends_options
      def initialize(klass, column, extends_options = {})
        @klass = klass
        @column = column.is_a?(Hash) ? DummyColumn.new(column) : column
        @extends_options = extends_options
      end
    end
    
    module ClassMethods
      
      USAGE_extends_by_column_comment = 'extends_by_column_comment([:all/(:on/:except) => column_name1 [,column_name2 [,column_name3...]]])'
      def extends_by_column_comment(*args)
        if args.length == 1 and args[0] == :all
          return extends_by_column_comment({:except => []})
        elsif args.length < 1
          raise ArgumentError, USAGE_extends_by_column_comment
        elsif args.length > 1
          return extends_by_column_comment({:on => args})
        end
        find_columns(args[0]).uniq.each do |column|
          extends_column_by_comment(column)
        end
      end
      
      USAGE_extends_column = 'extends_column(column_name1 [,column_name2 [,column_name3...]]], extends_options)'
      def extends_column(*args, &proc)
        if proc
          raise ArgumentError, USAGE_extends_column if args.empty?
          extends_options = (args.last === Hash ? args.pop : {})  
        else
          raise ArgumentError, USAGE_extends_column if args.length < 2
          extends_options = args.pop
          raise ArgumentError, USAGE_extends_column unless extends_options.is_a?(Hash)
        end
        args.each do |arg|
          column = self.columns.detect{|col|col.name == arg.to_s}
          raise ArgumentError, "Unknown column: #{arg.inspect}" unless column
          extends_column_by_options(column, extends_options, &proc)
        end
      end
      
      private
      def extends_column_by_comment(column)
        # return unless column.respond_to?(:comment)
        comment = column.comment
        return if comment.blank?
        begin
          scanned = comment.scan(/\{(.*)\}/).flatten.first
          return if scanned.blank?
          extends_options = instance_eval('{' << scanned.to_s << '}')
        rescue
          $!.message << "\n" << <<-EOS
            Invalid extends_by_column_comment options in comment of #{table_name}.#{column.name}
            #{comment}
          EOS
          raise $!
        end
        extends_column_by_options(column, extends_options)
      end
      
      def extends_column_by_options(column, extends_options, &proc)
        column.extend(ColumnDefinition)
        column.base_name = extends_options[:base_name]
        extends_options.delete(:base_name)
        extends_options.each do |key, value|
          self.send("append_#{key.to_s}", column, value)
        end
        if proc
          context = Context.new(self, column, extends_options)
          context.instance_eval(&proc)
        end
      end
      
      def find_columns(options)
        all_columns = self.columns
        enum_method = options[:on] ? :select : 
          options[:except] ? :reject :
          (raise 'validates_by_column_comment [:on/:except] =>] column_name1 [,column_name2 [,column_name3...]]')
        column_names = (options[:on] or options[:except]).to_ary.map{|name| name.is_a?(Symbol) ? name.to_s : name}
        column_names.each do |column_name|
          unless all_columns.any?{|col| column_name === col.name }
            raise "column '#{column_name}' not found on table '#{self.table_name}'" 
          end
        end
        all_columns.send(enum_method) do |column|
          column_names.any?{|column_name| column_name === column.name}
        end
      end
    end
    
    def self.append_features(base) #:nodoc:
      super
      base.instance_eval do
        base.extend ClassMethods
      end
    end
  end
  
end
