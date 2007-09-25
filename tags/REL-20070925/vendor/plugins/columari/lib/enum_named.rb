module EnumNamed
  
  def self.included(mod)
    mod.extend(ClassMethods)
  end
  
  class Entry
    attr_reader :id, :key, :name
    def initialize(id, key, name, options = nil, &proc)
      @id = id
      @key = key
      @name = name
      @options = options
      self.instance_eval(&proc) if proc
    end
    def [](option_key)
      @options ? @options[option_key] : nil
    end
    def match?(options)
      @options === options
    end
    def null?
      false
    end
    def null_object?
      self.null?
    end
    def to_hash
      (@options || {}).merge(:id => @id, :key => @key, :name => @name)
    end
    
    NULL = new(nil, nil, nil) do
      def null?; true; end
    end
  end
  
  module ClassMethods
    attr_reader :entries
    def define(id, key, name, options = nil, &proc)
      entry = Entry.new(id, key, name, options, &proc)
      (@entries ||= []) << entry
    end
    alias_method :entry, :define
    
    def [](id_key)
      @entries.detect{|entry| entry.id == id_key or entry.key == id_key } || Entry::NULL
    end
    
    def values(*args)
      args = args.empty? ? [:name, :id] : args
      result = @entries.collect{|entry| args.collect{|arg| entry.send(arg) }}
      (args.length == 1) ? result.flatten : result
    end
    
    def ids(*args)
      args.empty? ? @entries.collect{|entry|entry.id} : args.map{|k|self[k].id}
    end
    
    def keys(*args)
      args.empty? ? @entries.collect{|entry|entry.key} : args.map{|k|self[k].key}
    end
    
    def names(*args)
      args.empty? ? @entries.collect{|entry|entry.name} : args.map{|k|self[k].name}
    end
    
    def get(options)
      @entries.detect{|entry| entry.match?(options) } || Entry::NULL
    end
    
    def to_hash_array
      @entries.map do |entry|
        result = entry.to_hash
        yield(result) if defined? yield
        result
      end
    end
  end

end