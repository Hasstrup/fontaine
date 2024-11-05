# frozen_string_literal: true

class PdfMailer < ApplicationMailer
  def pdf_generated(input)
    after_inserting_attachments(input) do
      @user = input[:user]
      mail(**mailer_params_from_input(input))
    end
  end

  private

  def mailer_params_from_input(input)
    {
      to: input[:user].email,
      from: "#{input[:user].first_name} <#{default_email_sender}>",
      template_path: 'pdf_mailer',
      template_name: 'basic_example',
      formats: [:html],
      subject: "#{input[:user].first_name}'s Invoice - #{formatted_todays_date} "
    }
  end

  def after_inserting_attachments(input)
    attachments[input[:template].reference_file_name] = File.read(input[:tmpfile].path)
    yield
  end

  def formatted_todays_date
    Date.today.strftime('%a, %b %e, %Y')
  end

  def default_email_sender
    @default_email_sender ||= ENV["EMAIL_SENDER"]
  end
end
