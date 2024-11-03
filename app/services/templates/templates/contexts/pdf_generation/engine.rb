# frozen_string_literal: true

module Templates
  module Templates
    module Contexts
      module PdfGeneration
        # The Engine class is responsible for generating PDFs based on a specified strategy
        # and a given template ID. It modifies the original HTML document by applying
        # components from the template before generating the final PDF file.
        #
        # Supported strategies for PDF generation include :pdfkit and :hexapdf.
        class Engine < BaseService
          HTML_GENERATION_STRATEGIES = %i[pdfkit hexapdf].freeze

          # Runs the PDF generation engine with the given arguments.
          #
          # @param [*args] args Arguments to be passed to the Engine initializer.
          # @return [String] The generated PDF content as a string.
          def self.run(*args)
            new(*args).run
          end

          # Initializes a new instance of the Engine.
          #
          # @param [Integer] template_id The ID of the template to be used for PDF generation.
          # @param [Symbol] strategy The library for PDF generation (:pdfkit or :hexapdf).
          # @return [void]
          def initialize(template_id, strategy)
            @template_id = template_id
            @strategy = strategy
          end

          # Executes the PDF generation process.
          #
          # @return [String] The content of the generated PDF.
          def run
            safely_execute do
              modified_document = template.components.reduce(original_html_doc) do |document, component|
                key_type_applicator_for(component).apply!(component, document)
              end
              PDFKit.new(modified_document.to_html).to_file(tmpfile.path)
              succeed(tmpfile.read)
            ensure
              tmpfile.close
            end
          end

          private

          attr_reader :template_id, :strategy

          # Retrieves the template associated with the given template ID.
          #
          # @return [Templates::Template] The template object.
          def template
            @template ||= ::Templates::Template.includes(:components, :user).find(template_id)
          end

          # Returns the appropriate key type applicator for the given component.
          #
          # @param [Object] component The component for which to find the applicator.
          # @return [Object] The applicator class for the component's key type.
          def key_type_applicator_for(component)
            "::Templates::Components::KeyTypeApplicator::#{component.key_type.to_s.camelize}Applicator".constantize
          end

          # Creates a temporary file for storing the generated PDF.
          #
          # @return [Tempfile] The temporary file for the PDF.
          def tmpfile
            @tmpfile ||= Tempfile.new(template.reference_file_name)
          end

          # Retrieves the original HTML document based on the chosen strategy.
          #
          # @return [Nokogiri::HTML::Document] The original HTML document.
          def original_html_doc
            @original_html_doc ||= Nokogiri::HTML(
              basic_strategy? ? template.html_content : Strategies::HexaPdf.generate_html_content(content)
            )
          end

          # Determines if the basic PDF generation strategy is being used.
          #
          # @return [Boolean] True if using the :pdfkit strategy, false otherwise.
          def basic_strategy?
            strategy == :pdfkit
          end
        end
      end
    end
  end
end
