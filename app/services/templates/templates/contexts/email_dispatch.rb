# frozen_string_literal: true

# The EmailDispatch class is responsible for dispatching emails containing generated PDFs.
# It uses a specified PDF generation strategy and the associated template to create the PDF,
# then sends it to the user via email.
class Templates::Templates::Contexts::EmailDispatch < BaseService
  MailerInput = Struct.new(:user, :tmpfile, :template, keyword_init: true)
  performs_checks

  # Initializes a new instance of the EmailDispatch class.
  #
  # @param [Object] input The input data required for the email dispatch.
  # @return [void]
  def initialize(input)
    @input = input
  end

  # Executes the email dispatch process.
  #
  # @return [Integer, nil] The ID of the template if successful; nil otherwise.
  def call
    safely_execute do
      pdf_generation_ctx = PdfGeneration::Service.call(template_id, input.strategy.to_sym)
      return fail!(pdf_generation_ctx.errors) unless pdf_generation_ctx.success?

      ::Mailer::PdfMailer.pdf_generated(mailer_input_from_ctx(pdf_generation_ctx))
      succeed(template_id)
    end
  end

  private

  # Constructs the input for the mailer from the PDF generation context.
  #
  # @param [Object] ctx The context object containing the PDF generation results.
  # @return [Hash] A hash containing the user, temporary file, and template.
  def mailer_input_from_ctx(ctx)
    {
      tmpfile: ctx.payload,
      template: ::Templates::Template.find(input.template_id),
      user: User.find(input.user_id)
    }
  end
end
