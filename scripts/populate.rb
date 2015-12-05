categories  = ["Education", "Health", "Poverty", "Food", "Unemployment", "Exclusion"]
whos        = ["Alan", "Youri", "Zichen", "Laiq", "Danny"]
impairments = ["Visual", "Hearing", "Disabled"]
locations   = ["United Kingdom", "GB", "London, GB", "Bangladesh", "Sudan", "Cambodia", "Uganda", "Tanzania"]

# WHO Syed Laiq Hussain Jafri WHERE London, GB WHAT Visually Impaired CAT Education
10.times do |x|
  who   = whos[rand(5)]
  where = locations[rand(8)]
  cat   = categories[rand(6)]
  what  = impairments[rand(3)]
  email = SecureRandom.hex(16)
  phone = rand(10 ** 10)
  dob   = (Time.now - (365 * rand(17)).days).strftime("%Y-%m-%d")

  Message.parse "WHO #{who} WHERE #{where} CAT #{cat} WHAT #{what} EMAIL #{email} PHONE #{phone} DOB #{dob}"
end
