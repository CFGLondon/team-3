class Message < ActiveRecord::Base
  belongs_to :category
  belongs_to :person
  belongs_to :location
  after_create :publish
  def self.parse text
    message = text.gsub("\n", " ")
    if message =~ /WHERE(.+?)(WHAT|WHEN|WHO|CAT|PHONE|EMAIL|DOB|$)/
      location = $1.to_s.strip
    end

    if message =~ /WHAT(.+?)(WHERE|WHEN|WHO|CAT|PHONE|EMAIL|DOB|$)/
      issue = $1.to_s.strip
    end

    if message =~ /WHO(.+?)(WHAT|WHEN|WHERE|CAT|PHONE|EMAIL|DOB|$)/
      name = $1.to_s.strip
    end

    if message =~ /CAT(.+?)(WHAT|WHEN|WHERE|WHO|PHONE|EMAIL|DOB|$)/
      category = $1.to_s.strip
    end

    if message =~ /EMAIL(.+?)(WHAT|WHEN|WHERE|WHO|PHONE|CAT|DOB|$)/
      email = $1.to_s.strip
    end

    if message =~ /DOB(.+?)(WHAT|WHEN|WHERE|WHO|PHONE|CAT|EMAIL|$)/
      dob = $1.to_s.strip
    end

    if message =~ /PHONE(.+?)(WHAT|WHEN|WHERE|WHO|CAT|EMAIL|DOB|$)/
      phone = $1.to_s.strip
    end

    category = 'Unknown' if category.blank?
    c = Category.find_or_create_by keyword: category

    p = Person.new
    p.email = email if email.present?
    p.phone = phone if phone.present?
    if name.present?
      name = name.split(" ")
      if name.length == 1
        p.first_name = name.first.strip
      else
        p.last_name  = name.pop.strip
        p.first_name = name.collect(&:strip).join(" ")
      end
    end
    p.dob = dob
    p.save

    l = Location.new
    if location.present?
      location = location.split(",").collect(&:strip)
      country = location.last
      country = ISO3166::Country.find_country_by_name(country) ||
        ISO3166::Country.find_country_by_alpha3(country) ||
        ISO3166::Country.find_country_by_alpha2(country)
      if country
        l.country = country.name
        l.lat     = (country.min_latitude.to_f  + country.max_latitude.to_f + rand(20))  / 2
        l.lng     = (country.min_longitude.to_f + country.max_longitude.to_f + rand(20)) / 2
        location.pop
      else
        l.country = location.pop
      end
      l.city = location.join(" ")
    end
    l.save
    m = new content: text, location_id: l.id, category_id: c.id, person_id: p.id, issue: issue
    m.save
  end

  def self.clear_db
    Message.destroy_all
    Person.destroy_all
    Location.destroy_all
    Category.destroy_all
  end

  def publish
    m = self
    data = {
      photo_id: m.id,
      photo_title: m.person.name,
      photo_url: "http://www.panoramio.com/photo/27932",
      photo_file_url: "http://www.panoramio.com/photo/27932",
      latitude: m.location.lat,
      longitude: m.location.lng,
      width: 500,
      height: 350,
      upload_date: m.person.dob.to_s,
      owner_name: m.person.name,
      owner_id: m.id,
      owner_url: "http://www.panoramio.com/photo/27932",
      content: m.content,
      phone: m.person.phone
    }
    $redis.publish 'chat_event', data.to_json
  end

  def self.dummy_create
    categories  = ["Education", "Health", "Poverty", "Food", "Unemployment", "Exclusion"]
    whos        = ["Alan", "Youri", "Zichen", "Laiq", "Danny"]
    impairments = ["Visual", "Hearing", "Disabled"]
    locations   = ["United Kingdom", "GB", "London, GB", "Bangladesh", "Sudan", "Cambodia", "Uganda", "Tanzania"]

    # WHO Syed Laiq Hussain Jafri WHERE London, GB WHAT Visually Impaired CAT Education
    1.times do |x|
      who   = whos[rand(5)]
      where = locations[rand(8)]
      cat   = categories[rand(6)]
      what  = impairments[rand(3)]
      email = SecureRandom.hex(16)
      phone = rand(10 ** 10) 
      dob   = (Time.now - (365 * rand(17)).days).strftime("%Y-%m-%d")

      Message.parse "WHO #{who} WHERE #{where} CAT #{cat} WHAT #{what} EMAIL #{email} PHONE #{phone} DOB #{dob}"
    end
  end
end

