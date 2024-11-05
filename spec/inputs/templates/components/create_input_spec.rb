# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Templates::Components::CreateInput do
  let(:user) { create(:user) }
  let(:template) { create(:template, user:) }
  let(:errors) { input.errors.map(&:message) }

  describe '#validate!' do
    context 'with valid attributes' do
      let(:input) do
        described_class.new(title: 'Component Title', key_tags: %i[td p], key_type: 'text', text_accessor: 'content',
                            template_id: template.id, user_id: user.id)
      end

      it 'validates successfully' do
        expect { input.validate! }.not_to(change { errors.count })
      end
    end

    context 'with missing required keys' do
      let(:input) { described_class.new(title: 'Component Title', key_tags: []) }

      it 'stores errors for missing attributes' do
        input.validate!
        expect(errors).to include('template_id is missing')
        expect(errors).to include('user_id is missing')
      end
    end

    context 'with invalid template association' do
      let(:input) do
        described_class.new(title: 'Component Title', key_tags: %i[td p], key_type: 'text', text_accessor: 'content',
                            template_id: 'non_existent_template_id', user_id: user.id)
      end

      it 'stores an error for invalid template' do
        input.validate!
        expect(errors).to include("Could not find any 'Templates::template' with id: non_existent_template_id")
      end
    end

    context 'with invalid user association' do
      let(:input) do
        described_class.new(title: 'Component Title', key_tags: %i[td p], key_type: 'text', text_accessor: 'content',
                            template_id: template.id, user_id: 'non_existent_user_id')
      end

      it 'stores an error for invalid user' do
        input.validate!
        expect(errors).to include("Could not find any 'User' with id: non_existent_user_id")
      end
    end

    context 'when user does not own the template' do
      let(:other_user) { create(:user) }
      let(:input) do
        described_class.new(title: 'Component Title', key_tags: %i[td p], key_type: 'text', text_accessor: 'content',
                            template_id: template.id, user_id: other_user.id)
      end

      it 'stores an error for unauthorized access' do
        input.validate!
        expect(errors).to include('Unauthorized access')
      end
    end
  end
end
