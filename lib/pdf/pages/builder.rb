# frozen_string_literal: true

module PDF
  module Pages
    # The Builder class is responsible for constructing a PDF page by applying a series of instructions
    # to a HexaPDF page object. It utilizes methods defined in the HexaDefinitions modules to process
    # graphical and text elements.
    class Builder
      include ::PDF::Pages::HexaDefinitions::Adapter

      # Constructs a new Builder instance and applies the instructions to the page.
      #
      # @param [HexaPDF::Object] page The HexaPDF page object to build upon.
      # @param [String] instructions The instructions for building the page in a string format.
      # @return [PDF::InstructionParser]
      def initialize(page, instructions)
        @page = page
        # Security risk here - I know. but necessary, sorry.
        @instructions = eval(instructions)
      end

      # Applies the instructions to the HexaPDF page by executing each defined instruction.
      #
      # @return [HexaPDF::Object] The modified HexaPDF page object.
      def build!
        instructions.each do |instruction|
          send(instruction[:name], instruction, page)
        rescue NotImplementedError
          next
        end
        page
      end

      private

      attr_reader :page, :instructions
    end
  end
end
