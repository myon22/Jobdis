User.create!(name:"host",email:"host_user@gmail.com",
            password:"password",password_confirmation:"password",
            admin:true,
            activated:true,
            activate_at: Time.zone.now)

100.times do |n|
  name = Faker::Name.name
  email = "rails-#{n}@gmail.com"
  password = "password"
  User.create!(name:name,email:email,password:password,password_confirmation:password,
               activated:true,
               activate_at: Time.zone.now)
end