FactoryBot.define do
  factory :checklist_run, class: Manifestly::Entity::ChecklistRun do
    skip_create

    initialize_with do
      workflow = attributes[:workflow]
      other_attributes = attributes.select { |k, _| k != :workflow }
      new(workflow, other_attributes)
    end

    account_id { Faker::Number.number(8) }
    description { Faker::Lorem.sentence }
    title { Faker::Lorem.words(4).join(' ') }
  end
end
