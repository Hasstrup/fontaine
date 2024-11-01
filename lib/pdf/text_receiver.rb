# frozen_string_literal: true

module PdfUtils
  class TextReceiver < PDF::Reader::RegisterReceiver
    attr_reader :components

    def initialize
      super
      @components = []
    end

    # def show_text(string)
    #   str = super(string)
    #   @components << str
    # end

    # def move_text_position(*args)
    #   @components << args
    # end

    # def show_text_with_positioning(text_array)
    #   x = 0
    #   y = 0
    #   text_array.each do |text|
    #     if text.is_a?(String)
    #       @components << { text:, x:, y: }
    #     elsif text.is_a?(Array)
    #       x, y = text
    #     end
    #   end
    # end
  end
end
