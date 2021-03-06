User.delete_all if User.any?
Customer.delete_all if Customer.any?
Project.delete_all if Project.any?
Task.delete_all if Task.any?
TaskEntry.delete_all if TaskEntry.any?

batman = 
  User.create!(username: "Batman",
              password: "joker",
              email: "bruce@waynetech.com")



wayne_tech = 
  Customer.create!(company: "Wayne Tech",
                  address: "141 W Jackson",
                  city: "Gotham",
                  state: "IL",
                  zip: "60604")

daily_planet = 
  Customer.create!(company: "Daily Planet",
                  address: "350 5th Ave",
                  city: "Metropolis",
                  state: "NY",
                  zip: "10118")

companies = [wayne_tech, daily_planet]

companies.each do |company|
  3.times do |n|
    project = 
      Project.create!(project_name: "project #{n} for customer planet",
                      customer: company)

    2.times do |m|
      task = 
        Task.create!(task_name: "task #{m} of prj #{n} for customer planet",
                     project: project,
                     user: batman)

      2.times do |o|
        TaskEntry.create!(note: "line #{o} of task #{m} of prj #{n} for customer planet",
                          duration: 10_000,
                          start_time: o.hours.ago,
                          task: task)
      end
    end
  end
end