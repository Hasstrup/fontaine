# frozen_string_literal: true

module Templates
  module Invoices
    module Contexts
      class Creation < BaseService
        # performs_checks

        def initialize(input:)
          @input = input
        end

        def call
          safely_execute do
            after_extracting_pdf_instructions do
              succeed(create_template!)
            end
          end
        end

        private

        def after_extracting_pdf_instructions
          reader.pages.each.with_index do |page, index|
            receiver = ::PDF::Reader::RegisterReceiver.new
            page.walk(receiver)
            pages_instructions_map[index + 1] =
              # the first entry specifies the page number, redundant to save it.
              receiver.callbacks[1..receiver.callbacks.length].to_s
          end
          yield
        end

        def pages_instructions_map
          @pages_instructions_map ||= {}
        end

        def create_template!
          ::Templates::Template.create!(
            reference_file_name: input.file_name,
            title: input.title,
            instructions: pages_instructions_map,
            user_id: input.user_id
          )
        end

        def reader
          @reader ||= ::PDF::Reader.new(file.path)
        end

        def file
          @file ||= begin
            tmp = Tempfile.new(input.file_name)
            tmp.binmode
            tmp.write(Base64.decode64(input.file_base64))
            tmp
          end
        end
      end
    end
  end
end
