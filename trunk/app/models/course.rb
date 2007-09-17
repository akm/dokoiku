class Course < ActiveRecord::Base
  
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'

  has_many :entries, :foreign_key => 'course_id', :class_name => 'CourseEntry'
  has_many :spots, :through => :entries

  def save_with_spots(spots)
    Course.transaction do 
      self.save!
      spots.each_with_index do |spot_hash, index|
        entry = {
          :course_id => self.id, :line_no => spot_hash.delete(:line_no)
        }
        spot = Spot.create!(spot_hash)
        entry = CourseEntry.create!(entry.merge(:line_no => index + 1, :spot_id => spot.id))
      end
    end
  end

  class Finder
    attr_accessor :start_x, :start_y
    attr_accessor :feeling_x, :feeling_y
    attr_accessor :purpose_cd, :budget_cd
    include ActiveRecord::Base::Columari
  
    def initialize(attrs = nil)
      (attrs || {}).each{|k,v|self.send("#{k.to_s}=", v)}
    end
    
    Context.new(self, :name => :purpose_cd).instance_eval do
      enum do
        entry 1, :date, 'デート'
        entry 2, :alone, '1人'
        entry 3, :friend, '友達と'
        entry 4, :big_party, '大勢で'
        entry 5, :sightseen, '観光で'
      end
    end

    Context.new(self, :name => :budget_cd).instance_eval do
      enum do
        entry nil, :none, "指定なし"
        entry 1, :budget1, "1,000円以下", :max => 1000
        entry 2, :budget1, "1,000円～3,000円", :rage => 1000..3000
        entry 3, :budget1, "3,000円～5,000円", :rage => 3000..5000
        entry 4, :budget1, "5,000円～10,000円", :rage => 5000..10000
        entry 5, :budget1, "10,000円以上", :min => 10000
      end
    end
  end

end