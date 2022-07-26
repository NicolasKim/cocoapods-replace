
module CococapodsReplacement
  class Replacement
    attr_reader :origin
    attr_reader :to
    attr_reader :configurations
    def initialize(origin, to, configurations)
      @origin = origin
      @to = to
      @configurations = configurations
    end
  end
end


module Pod
  class Podfile
    module DSL

      def fy_replace(origin, to, *requirements)
        configurations = r_parse_key(:configurations, requirements)
        replacementEntity = CococapodsReplacement::Replacement.new origin, to, configurations

        replacementEntities = r_get_internal_hash_value 'replacement'

        r_set_internal_hash_value 'replacement', [] unless replacementEntities != nil

        replacementEntities = r_get_internal_hash_value 'replacement'

        replacementEntities.append replacementEntity

      end

      private

      def r_parse_key(key, requirements)
        result = nil
        requirements.each do |obj|
          if obj.is_a?(Hash) && obj.has_key?(key)
            result = obj[key]
          end
        end
        result
      end


      def r_valid_bin_plugin
        raise Pod::Informative, 'You should add `plugin \'cocoapods-replace\'` before using its DSL' unless plugins.keys.include?('cocoapods-replace')
      end

      def r_set_internal_hash_value(key, value)
        r_valid_bin_plugin

        internal_hash[key] = value
      end

      def r_get_internal_hash_value(key, default = nil)
        internal_hash.fetch(key, default)
      end
    end
  end
end