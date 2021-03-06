class TaskEntry < ActiveRecord::Base
  belongs_to :task, counter_cache: true
  after_initialize :set_default_model_values

  # these are in UTC
  def end_time
    start_time + duration
  end
  def end_time=(new_value)
    self.duration = (new_value - start_time)
  end

  ##### these are the attr_accessors for the form ####
  ##  these should be in & out of local time  ##

  def s_time
    to_form_time(start_time.getlocal)
  end
  def s_time=(form_time)
    if form_time != ""
      (self.start_time = Time.now) unless start_time
      self.start_time = time_adjusted_datetime(start_time.getlocal, form_time).utc
    end
  end
  def s_date
    to_form_date(start_time.getlocal)
  end
  def s_date=(form_date)
    if form_date != ""      
      (self.start_time = Time.now) unless start_time
      self.start_time = date_adjusted_datetime(start_time.getlocal, form_date).utc
    end
  end
  def e_time
    to_form_time(end_time.getlocal)
  end
  def e_time=(form_time)
    if form_time != ""
      self.end_time = time_adjusted_datetime(end_time.getlocal, form_time).utc
    end
  end
  def e_date
    to_form_date(end_time.getlocal)
  end
  def e_date=(form_date)
    if form_date != ""
      self.end_time = date_adjusted_datetime(end_time.getlocal, form_date).utc
    end
  end  

  def set_default_model_values
    self.start_time = Time.now.utc if (self.new_record? && self.start_time.nil?)
    self.duration = 0 if (self.new_record? && self.duration.nil?)
  end

  ###########  helpers for the form attr_accessors  ################
  def to_form_date(datetime)
    datetime.strftime("%Y-%m-%d")
  end
  def to_form_time(datetime)
    datetime.strftime("%H:%M")
  end
  def time_adjusted_datetime(datetime, form_time)
    hour, min = form_time.split(":").map(&:to_i)
    datetime.clone.change({hour: hour, min: min})
  end
  def date_adjusted_datetime(datetime, form_date)
    yr, month, day = form_date.split("-").map(&:to_i)
    datetime.clone.change({year: yr, month: month, day: day})
  end


##### booleans  #####
  def active?
    !pending? && !completed?
  end

  def pending?
    start_time > Time.now.utc
  end

  def completed?
    end_time < Time.now.utc
  end

######  display methods  #####

  def time_display
    "#{format_timestamp(start_time)} - #{format_timestamp(end_time)}"
  end



  def display_duration
    remainder = duration || 0

    hr        = remainder / 3600
    remainder = remainder % 3600
    min       = remainder / 60
    remainder = remainder % 60
    second    = remainder
    "#{hr}:#{min}:#{second}"
  end

  # def opening_time_display
  #   format_timestamp(start_time)
  # end

  def format_timestamp(datetime)
    datetime.getlocal.to_formatted_s(:long_ordinal)
  end
end