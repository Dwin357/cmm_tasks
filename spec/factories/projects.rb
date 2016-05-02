FactoryGirl.define do
  factory :project do
    project_name "Clean up Gotham"
    customer
  end

  factory :alt_project, class: Project do
    project_name "Build outter ring El line"
    customer
  end

end
