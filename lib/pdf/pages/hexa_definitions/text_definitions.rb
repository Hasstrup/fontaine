# frozen_string_literal: true

module PDF
  module Pages
    module HexaDefinitions
      module TextDefinitions 
        def set_text_font_and_size(instruction, page)
          font_name, size = instruction[:args]
          font = doc.fonts.add(font_name.to_s)
          page.canvas.font(font, size:)
        end

        def show_text(instruction, page)
          page.canvas.text(decode_text(instruction.dig(:args, 0)))
        end

        def show_text_with_positioning(_instruction, page)
          page.canvas.text(decode_text(instruction.dig(:args, 0), at: instruction.last))
        end

        def set_line_width(instruction, page)
          page.canvas.line_width(instruction[:args][0])
        end

        def begin_text_object(_instruction, page)
          page.canvas.begin_text
        end

        def end_text_object(_instruction, page)
          page.canvas.end_text
        end

        def move_to_start_of_next_line(_instruction, _page)
          raise NotImplementedError
        end

        def set_character_spacing(instruction, page)
          page.canvas.character_spacing = instruction[:args][0]
        end

        def move_text_position(instruction, page)
          page.canvas.move_to(*instruction[:args])
        end

        def move_text_position_and_set_leading(*args)
          move_text_position(*args)
        end

        def set_text_leading(instruction, page)
          page.canvas.leading = instruction[:args][0]
        end

        def set_text_matrix_and_text_line_matrix(instruction, page)
          page.canvas.transformation_matrix(*instruction[:args])
        end

        def set_text_rendering_mode(instruction, page)
          page.canvas.text_rendering_mode = instruction[:args][0]
        end

        def set_text_rise(instruction, page)
          page.canvas.text_rise = instruction[:args][0]
        end

        def set_word_spacing(instruction, page)
          page.canvas.word_spacing = instruction[:args][0]
        end

        def set_horizontal_scaling(instruction, page)
          page.canvas.horizontal_scaling = instruction[:args][0]
        end

        def move_to_next_line_and_and_show_text(_instruction, _page)
          page.canvas.show_goto_text
        end

        def set_spacing_next_line_show_text(_isntruction, _page)
          page.canvas.show_goto_text
        end

        private

        def decode_text(binary_string)
          # Fetch the font object from the HexaPDF document
          font_object = page.canvas.fonts.fonts.first
          font_object.decode(binary_string)
        end
      end
    end
  end
end
