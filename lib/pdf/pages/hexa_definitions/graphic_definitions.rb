# frozen_string_literal: true

module PDF
  module Pages
    module HexaDefinitions
      module GraphicDefinitions
        def close_fill_stroke(instruction, page)
          page.canvas.close_fill_stroke(*instruction[:args])
        end

        def fill_stroke(instruction, page)
          page.canvas.fill_stroke(*instruction[:args])
        end

        def begin_marked_content_with_pl(*args)
          begin_marked_content(*args)
        end

        def begin_marked_content(instruction, page)
          page.canvas.marked_content(*instruction[:args])
        end

        def end_marked_content(_instruction, _page)
          raise NotImplementedError
        end

        def begin_inline_image(instruction, page)
          page.canvas.image(*instruction[:args])
        end

        def end_inline_image(instruction, page)
          page.canvas.image(*instruction[:args])
        end

        def begin_inline_image_data(instruction, page)
          page.canvas.image(*instruction[:args])
        end

        def append_curved_segment(instruction, page)
          page.canvas.curve_to(*instruction[:args])
        end

        def save_graphics_state(instruction, page)
          page.canvas.save_graphics_state(*instruction[:args])
        end

        def restore_graphics_state(instruction, page)
          page.canvas.save_graphics_state(*instruction[:args])
        end

        def concatenate_matrix(instruction, page)
          page.canvas.transformation_matrix(*instruction[:args])
        end

        def set_stroke_color_space(instruction, page)
          page.canvas.stroke_color_space(*instruction[:args])
        end

        def set_nonstroke_color_space(instruction, page)
          page.canvas.fill_color_space(*instruction[:args])
        end

        def set_line_dash(_instruction, page)
          page.canvas.line_dash_pattern = %i[dashes phase]
        end

        def fill_path_with_nonzero(_, page)
          page.canvas.fill(nonzero: true)
        end

        def fill_path_with_even_odd(_, page)
          page.canvas.fill(nonzero: false)
        end

        def set_gray_for_stroking(_, page)
          page.canvas.stroke_color(:gray)
        end

        def set_gray_for_nonstroking(_, page)
          page.canvas.fill_color(:gray)
        end

        def set_graphics_state_parameters(instruction, page)
          page.canvas.graphics_state(*instruction[:args])
        end

        def close_subpath(_, page)
          page.canvas.close_subpath
        end

        def set_flatness_tolerance(_, _)
          raise NotImplementedError
        end

        def set_line_join_style(instruction, page)
          page.canvas.set_line_join_style(*instruction[:args])
        end

        def set_line_cap_style(instruction, page)
          page.canvas.set_line_cap_style(*instruction[:args])
        end

        def set_miter_limit(instruction, page)
          page.canvas.miter_limit(*instruction[:args])
        end

        def append_line(instruction, page)
          page.canvas.line_to(*instruction[:args])
        end

        def begin_new_subpath(instruction, page)
          page.canvas.move_to(*instruction[:args])
        end

        def append_rectangle(instruction, page)
          page.canvas.rectangle(*instruction[:args])
        end

        def set_rgb_color_for_stroking(instruction, page)
          page.canvas.stroke_color(*instruction[:args])
        end

        alias set_cmyk_color_for_stroking set_rgb_color_for_stroking

        def set_rgb_color_for_nonstroking(instruction, page)
          page.canvas.fill_color(*instruction[:args])
        end

        alias set_cmyk_color_for_nonstroking set_rgb_color_for_nonstroking

        def paint_area_with_shading_pattern(instruction, page)
          raise NotImplementedError
        end

        def stroke_path(instruction, page)
          page.canvas.stroke(*instruction[:args])
        end

        def close_and_stroke_path(instruction, page)
          page.canvas.close_and_stroke(*instruction[:args])
        end

        def set_clipping_path_with_nonzero(_, page)
          page.canvas.clip_path(nonzero: true)
        end

        def set_clipping_path_with_even_odd(_, page)
          page.canvas.clip_path(nonzero: false)
        end

        alias_method(*%i[
                       append_curved_segment_initial_point_replicated
                       append_curved_segment_final_point_replicated
                     ], :append_currved_segment)
      end
    end
  end
end
