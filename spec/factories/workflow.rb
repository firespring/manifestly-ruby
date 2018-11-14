FactoryBot.define do
  factory :workflow, class: Manifestly::Entity::Workflow do
    skip_create

    initialize_with do
      new(attributes)
    end

    account_id { Faker::Number.number(8) }
    description { Faker::Lorem.sentence }
    expected_duration { Faker::Number.between(1,30).to_i }
    expected_duration_units { ['hours', 'minutes', 'days'].sample }
    external_id { SecureRandom.hex(15) }
    title { Faker::Lorem.words(4).join(' ') }
  end
end
