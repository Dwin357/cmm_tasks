FactoryGirl.define do
  factory :customer do
    company "Wayne Tech"
    address "141 W Jackson"
    city "Gotham"
    state "IL"
    zip "60604"
  end

  factory :alt_customer, class: Customer do
    company "Daily Planet"
    address "350 5th Ave"
    city "Metropolis"
    state "NY"
    zip "10118"
  end
end
