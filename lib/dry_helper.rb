require 'dry-types'
require 'dry-struct'

# This automatically transforms keys to symbols when you pass Structs a hash
# that has string keys
class Dry::Struct
  transform_keys(&:to_sym)
end

# The following allow you to access types with Types.<type reference>
#
# ```ruby
# email = Types.string.constrained(
#   format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
# )
# drinking_age = Types.integer.constrained(gt: 21)
# ````
module Types
  include Dry.Types()

  class << self

    # @param String The key of the Dry::Type -- see Dry::Types.type_keys
    def [] (type_key)
      Dry::Types[type_key]
    end

    # This aliases all the Dry::Types keys as class methods
    Dry::Types.type_keys.each do |method_name|
      define_method method_name do
        Dry::Types[method_name]
      end
    end
  end

end
