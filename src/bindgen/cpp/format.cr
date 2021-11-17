module Bindgen
  module Cpp
    # Formatter for C++ style code.
    struct Format
      # Formats *arg* as `type name`
      def argument(arg : Call::Argument, idx, *, wrap = false) : String
        typer = Typename.new
        "#{typer.full(arg, wrap: wrap)} #{Argument.name(arg, idx)}"
      end

      # Formats *arguments* as `type name, ...`
      def argument_list(arguments : Enumerable(Call::Argument), *, wrap = false) : String
        arguments.map_with_index { |arg, idx| argument(arg, idx, wrap: wrap) }.join(", ")
      end

      # Returns a C++ function pointer type, matching *method*.
      def function_pointer(call : Call) : String
        method = call.origin
        prefix = "#{method.class_name}::" if method.needs_instance?

        typer = Typename.new
        result = typer.full(call.result)
        arguments = call.arguments.map { |arg| typer.full arg }.join(", ")
        "#{result}(#{prefix}*)(#{arguments})"
      end
    end
  end
end
