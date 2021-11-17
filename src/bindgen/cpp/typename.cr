module Bindgen
  module Cpp
    # C++ type-name generation logic.
    struct Typename
      # Formats the type in *result* in C++ style.
      def full(result : Call::Expression, *, wrap = false) : String
        full(result.type_name, result.type.const?, result.pointer, result.reference, wrap: wrap)
      end

      # :ditto:
      def full(base_name : String, const, pointer, is_reference, *, wrap = false) : String
        String.build do |b|
          b << "bg_type<" if wrap
          b << "const " if const
          b << base_name

          if pointer > 0 || is_reference
            b << ' ' << ("*" * pointer)
            b << '&' if is_reference
          end

          b << " >::type" if wrap
        end
      end

      # Formats many *results*.
      def full(results : Enumerable(Call::Expression), *, wrap = false) : Array(String)
        results.map { |result| full(result, wrap: wrap) }
      end

      # Generates the C++ type name of a *template* class with the given
      # template type *arguments*.
      def template_class(template : String, arguments : Enumerable(String)) : String
        String.build do |b|
          b << template << '<'

          first = true
          needs_space = false
          arguments.each do |arg|
            b << ", " unless first
            b << arg
            first = false
            needs_space = arg.ends_with?('>')
          end

          b << ' ' if needs_space
          b << '>'
        end
      end
    end
  end
end
