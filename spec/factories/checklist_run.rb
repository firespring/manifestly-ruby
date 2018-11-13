FactoryBot.define do
  factory :checklist_run, class: Manifestly::Entity::ChecklistRun do
    skip_create

    initialize_with do
      new(attributes)
    end

    account_id { Faker::Number.number(8) }
    description { Faker::Lorem.sentence }
    title { Faker::Lorem.words(4).join(' ') }
  end
end
