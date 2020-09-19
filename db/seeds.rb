require_relative "../user.rb"

def rand_str
  8.times.map{('A'..'Z').to_a[rand(26)]}.join
end

10000.times do
  name = rand_str
  address = rand_str
  tel = rand_str
  User.create!(name: name, address: address, tel: tel)
end