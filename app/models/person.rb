class Person < ActiveRecord::Base
  def name
    [self.first_name.to_s, self.last_name.to_s].join(" ")
  end
end
