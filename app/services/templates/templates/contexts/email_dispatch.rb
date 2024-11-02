# frozen_string_literal: true

module Templates
  module Templates
    module Contexts
      class EmailDispatch < BaseService
        MailerInput = Struct.new(:user, :tmpfile, :template, keyword_input: true)
        performs_checks

        def initialize(input)
          @input = input
        end

        def call
          safely_execute do
            pdf_generation_ctx = PdfGeneration::Engine.run(template_id, input.strategy.to_sym)
            return fail!(pdf_generation_ctx.errors) unless pdf_generation_ctx.success?

            ::Mailer::PdfMailer.pdf_generated(mailer_input_from_ctx(pdf_generation_ctx))
            succeed(template_id)
          end

          private

          def mailer_input_from_ctx(ctx)
            {
              tmpfile: ctx.payload,
              template: ::Templates::Template.find(input.template_id),
              user: User.find(input.user_id)
            }
          end
        end
      end
    end
  end
end
