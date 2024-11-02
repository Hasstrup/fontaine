# frozen_string_literal: true

module Templates
  module KeyTypeApplicators
    class Base
      attr_reader :current_value

      def self.apply(*args)
        new(*args).apply
      end

      # @param [Templates::Component] template_component
      # @param [String] html
      # @return [Templates::KeyTypeApplicators::Base]
      def initialize(template_component, html)
        @component = template_component
        @html = html
      end

      def apply!
        raise NotImplementedError
      end

      delegate(*%i[key_tags text_accessor template], to: :component)

      private

      attr_reader :component, :html

      def selector
        @selector ||= if key_tags.length > 1
                        document.xpath("//#{key_tags.first}[contains(text(),
                          '#{text_accessor}')]/following-sibling::#{key_tags.first}//#{key_tags.last}")
                      else
                        document.xpath("//#{key_tags.first}[contains(text(), '#{text_accessor}')]/b")
                      end
      end

      def component_for(key_type)
        template.components.find_by(key_type:)
      end

      def document
        @document ||= Nokogiri::HTML(html_content)
      end

      def current_value
        @current_value ||= selector.text.strip
      end
    end
  end
end
