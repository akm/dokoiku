require 'columari'
require 'extensions/enum'
require 'extensions/validation'
require 'extensions/association'
class ActiveRecord::Base
  module Columari
    class Context
      include ValidationContext
      include AssociationContext
      include EnumContext
    end
    module ClassMethods
      include ValidationExtension
      include AssociationExtension
      include EnumExtension
    end
  end
  include Columari
end