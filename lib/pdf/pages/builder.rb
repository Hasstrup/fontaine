# frozen_string_literal: true

module PDF
  module Pages
    class Builder
      include ::PDF::Pages::HexaDefinitions::Adapter

      # @param [HexaPDF::Object] page
      # @param [String] instructions
      # @return [PDF::InstructionParser]
      def initialize(page, instructions)
        @page = page
        # Security risk here - I know. but necessary, sorry.
        @instructions = eval(instructions)
      end

      # loops through the instructions and tries to apply them using rules
      # defined in definitions files
      #
      #
      # @return [HexaPDF::Object]
      def parse!
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
