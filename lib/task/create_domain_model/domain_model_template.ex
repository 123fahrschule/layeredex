defmodule Mix.TasksHelper.DomainModelTemplate do
  def template(
        prefix: prefix,
        domain_model_name: domain_model_name,
        model_fields: model_fields
      ) do
    domain_model_variable_name = Macro.underscore(domain_model_name)

    fields =
      if model_fields do
        model_fields
        |> String.split(" ")
        |> Enum.map(fn field -> "field :#{String.replace(field, ":", ", :")}" end)
        |> Enum.join("\n")
      else
        ""
      end

    functions_with =
      if model_fields do
        model_fields
        |> String.split(" ")
        |> Enum.map(fn field -> String.split(field, ":") end)
        |> Enum.map(fn [field_name, field_type] ->
          create_function_with(domain_model_variable_name, field_name, field_type)
        end)
        |> Enum.join("\n")
      else
        ""
      end

    """
    defmodule #{prefix}.#{domain_model_name} do
      use #{prefix}.Includes, :domain_model

      @primary_key {:id, :binary_id, autogenerate: false}

      schema "#{domain_model_variable_name}" do
        #{fields}

        field :lock_version, :integer, default: 1

        timestamps()
      end

      def new() do
        %@me{
          id: Shared.UUID.generate(),
        }
      end

      #{functions_with}
    end

    """
  end

  defp create_function_with(domain_model_variable_name, field_name, field_type) do
    guard =
      case field_type do
        "integer" -> "is_integer"
        _ -> "is_binary"
      end

    """
    defp with_#{field_name}(%@me{} = #{domain_model_variable_name}, #{field_name}) when #{guard}(#{field_name}) do
        %@me{#{domain_model_variable_name} | #{field_name}: #{field_name}}
      end
    """
  end
end
