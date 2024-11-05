FactoryBot.define do
  factory :user do
    password { 'test.password' }
  end
  factory :token, class: 'Tokens::Token'

  factory :template, class: 'Templates::Template' do
    sequence(:title) { |n| "template-#{n}" }
  end

  factory :template_component, class: 'Templates::Component' do
    sequence(:title) { |n| "template-component-#{n}" }
    key_type { :issue_date }
    key_tags { [:p] }
  end
end
