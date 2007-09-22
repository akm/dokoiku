class Course < ActiveRecord::Base
  
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'

  has_many :entries, :foreign_key => 'course_id', :class_name => 'CourseEntry'
  has_many :spots, :through => :entries

  has_many :ratings, :class_name => 'CourseRating', :foreign_key => 'course_id'

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
  
  attr_accessor :rating
  
  def self.find_with_rating(options = {})
    result = Course.find(:all, options)
    ratings = Course.rating_avesages_for(result.map{|course|course.id})
    
    logger.debug("\n" * 5)
    logger.debug("ratings => #{ratings.inspect}")
    logger.debug("\n" * 5)
    
    result.each do |course|
      course.rating = ratings[course.id] || 0
    end
    result
  end
  
  def self.rating_avesages_for(ids)
    averages = CourseRating.average('rating',
      :group => 'course_id', 
      :conditions => ['course_id in (?)', ids])
    
    logger.debug("averages => #{averages.inspect}")
    
    averages.inject({}) do |dest, row|
      dest[row[0]] = row[1]
      dest
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
    
    HASH_KEYS = [:start_x, :start_y, :feeling_x, :feeling_y, :purpose_cd, :budget_cd]
    
    def to_hash
      HASH_KEYS.inject({}) do |dest, key|
        value = self.send(key)
        dest[key] = value
        dest
      end
    end
    
    def to_find_options(options = nil)
      wheres = []
      select = "courses.*"
      if start_x and start_y
        distance_sqlet = "(first_spot.latitude - #{start_y.to_f}) * (first_spot.latitude - #{start_y.to_f}) + (first_spot.longitude - #{start_x.to_f}) * (first_spot.longitude - #{start_x.to_f})"
        select << ',' << distance_sqlet << ' distance'
        # wheres << "#{distance_sqlet} < 0.01"
      else
        select << ',0 distance'
      end
      joins = ' inner join course_entries first_entry on courses.id = first_entry.course_id' <<
          ' inner join spots first_spot on first_spot.id = first_entry.spot_id'
      wheres << " first_entry.line_no = 1"

      result = {
        :select => select,
        :conditions => [wheres.join(' and '), self.to_hash],
        :joins => joins,
        :order => 'distance asc',
        :limit => 3
      }
    end
    
  end
  
end
