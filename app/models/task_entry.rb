class TaskEntry < ActiveRecord::Base
  belongs_to :task, counter_cache: true

#Time.now.to_a => [second, min, hr, day, month, yr]
#Time.new(yr, month, day, hr, min, sec) => datetime

  # #name space idea
  def start_at
    # for html to work, needs to return string w/
    # HH:mm
    to_time(start_time)
  end
  def end_at
    # for html to work, needs to return string w/
    # HH:mm
    #gives just hr, min, sec
    to_time(end_time)
  end
  def start_date
    #for html to work, needs to return string w/
    # yyyy-mm-dd
    to_date(start_time)
  end
  def end_date
    #for html to work, needs to return string w/
    # yyyy-mm-dd
    to_date(end_time)
  end

  def to_date(datetime)
    # ary = datetime.to_a
    # "#{ary[5]}-#{ary[4]}-#{ary[3]}"
    datetime.strftime("%Y-%m-%d")
  end

  def to_time(datetime)
    #this needs to be converted from utc to local
    datetime.strftime("%H:%M")
  end

  def end_time
    start_time + duration
  end

  def end_time=(new_value)
    self.duration = (new_value - start_time)
  end

  def adjust_date(existing_datetime, new_date)
    if (new_date != "")
      yr, month, day = new_date.split("-")
      ary = existing_date.to_a
      Time.new(yr, month, day, ary[2], ary[1], ary[0])
    end
  end

  def adjust_time(existing_datetime, new_time)
    if new_time != ""
      hour, min = new_time.split(":")
      ary = existing_datetime.to_a
      Time.new(ary[5], ary[4], ary[3], hour, min)
    end
  end

##### booleans  #####
  def active?
    !pending? && !logged?
  end

  def pending?
    start_time > Time.now
  end

  def logged?
    end_time < Time.now
  end




  # def completion_time
  #   duration / 60
  # end

  # def completion_time=(value)
  #   self.duration = (value.to_i * 60)
  # end


  # def init_time=(value)
  # end

  # def init_date=(value)
  # end


  # def init_time
  #   start_time.strftime("%H:%M")
  # end

  # def init_date
  #   start_time.strftime("%Y-%m-%d")
  # end
end