class Rails::Initializer
  def initialize_routing_with_javascript
    initialize_routing_without_javascript
    if JSRoutes.options[:append]
      JSRoutes.build
    end
  end
  alias_method_chain :initialize_routing, :javascript
end