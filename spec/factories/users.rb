FactoryGirl.define do
  factory :user do
    username "Batman"
    password "joker"
    email "bruce@waynetech.com"
  end

  factory :alt_user, class: User do
    username "Wonderwoman"
    password "circe"
    email "princess@amazonia.com"
  end

end
