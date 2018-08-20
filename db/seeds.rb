User.create! name:  "Example User",
  email: "example@railstutorial.org", password: "1111",
  password_confirmation: "1111", admin: true

19.times do |n|
  name  = FFaker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "1111"
  User.create! name: name, email: email, password: password,
    password_confirmation: password
end
