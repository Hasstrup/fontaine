FactoryBot.define do
  factory :user do
    password { 'test.password' }
  end
  factory :token, class: 'Tokens::Token'
  factory :template, class: 'Templates::Template'
  factory :template_component, class: 'Templates::Component'
end
