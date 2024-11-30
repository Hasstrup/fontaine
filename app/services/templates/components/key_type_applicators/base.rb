# frozen_string_literal: true

# The Base class serves as a foundational class for key type applicators.
# It defines the common interface and behavior for specific key type implementations.
class Templates::Components::KeyTypeApplicators::Base
  attr_reader :current_value

  # Applies the key type applicator to the provided arguments.
  #
  # @param [Templates::Component] template_component The component to be applied.
  # @param [String] document The HTML document to modify.
  # @return [Templates::Components::KeyTypeApplicators::Base] The instance of the applicator.
  def self.apply!(*args)
    new(*args).apply!
  end

  # Initializes a new Base instance.
  #
  # @param [Templates::Component] template_component The component to be applied.
  # @param [String] document The HTML document to modify.
  # @return [void]
  def initialize(template_component, document)
    @component = template_component
    @document = document
  end

  # Applies the key type logic. This method must be implemented by subclasses.
  #
  # @raise [NotImplementedError] When not implemented in a subclass.
  def apply!
    raise NotImplementedError
  end

  delegate(*%i[key_tags text_accessor template], to: :component)

  private

  attr_reader :component, :document

  # Constructs an XPath selector based on the key tags and text accessor.
  #
  # @return [Nokogiri::XML::NodeSet] The nodes matching the selector criteria.
  def selector
    @selector ||= if multiple_key_tags?
                    document.xpath("//#{key_tags.first}[contains(., '#{text_accessor}')]/following-sibling::#{key_tags.last}[1]")
                  else
                    document.xpath("//#{key_tags.first}[contains(., '#{text_accessor}')]")
                  end
  end

  # Checks if there are multiple key tags defined.
  #
  # @return [Boolean] True if multiple key tags exist; otherwise, false.
  def multiple_key_tags?
    key_tags.length > 1
  end

  # Finds the component associated with the given key type.
  #
  # @param [Symbol] key_type The type of key to search for.
  # @return [Templates::Component, nil] The associated component, or nil if not found.
  def component_for(key_type)
    template.components.find_by(key_type:)
  end

  # Returns the current value extracted from the document using the selector.
  #
  # @return [String] The current value as a string.
  def current_value
    @current_value ||= selector.text.strip
  end
end
