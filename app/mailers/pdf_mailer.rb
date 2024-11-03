# frozen_string_literal: true

module Mailer
  class PdfMailer < ApplicationMailer
    def pdf_generated(input)
      after_inserting_attachments(input) do
        mail(**mailer_params_from_input(input))
      end
    end

    private

    def mailer_params_from_input(input)
      {
        to: input.target.email,
        from: "#{input.user.first_name} <#{default_email_sender}>",
        subject: "#{input.user.first_name}'s Invoice - #{formatted_todays_date} "
      }
    end

    def after_inserting_attachments(input)
      attachments[input.template.reference_file_name] = File.read(input.tmpfile.path)
    end

    def formatted_todays_date
      Date.today.strftime('%a, %b %e, %Y')
    end
  end
end
