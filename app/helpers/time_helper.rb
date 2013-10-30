module TimeHelper
  def hour_angle
    (Time.now.hour % 12) * 30 + Time.now.min * 0.5 + Time.now.sec * 0.00833
  end
  
  def minute_angle
    Time.now.min * 6.0 + Time.now.sec * 0.1
  end
  
  def second_angle
    Time.now.sec * 6 + Time.now.nsec * 0.0000000006
  end
end
