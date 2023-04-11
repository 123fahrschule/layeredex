defmodule Mix.TasksHelper.FactoryTemplate do
  def template(
        prefix: prefix,
        domain_model_name: domain_model_name,
        model_fields: model_fields
      ) do
    domain_model_variable_name = Macro.underscore(domain_model_name)

    keywords_get =
      if model_fields do
        model_fields
        |> String.split(" ")
        |> Enum.map(fn field -> String.split(field, ":") end)
        |> Enum.map(fn [field_name, _field_type] ->
          keyword_get(field_name)
        end)
        |> Enum.join("\n")
      else
        ""
      end

    """
    defmodule #{prefix}.#{domain_model_name}Factory do
      use #{prefix}.Includes, :factory

      alias #{prefix}.#{domain_model_name}
      alias #{prefix}.#{domain_model_name}Repository

      def fake_#{domain_model_variable_name}(opts \\\\ []) do
        #{keywords_get}

        #{domain_model_variable_name} = #{domain_model_name}.new()
        case Keyword.get(opts, :persisted) do
          true ->
            {:ok, #{domain_model_variable_name}} =
              #{domain_model_name}Repository.save(#{domain_model_variable_name})

            #{domain_model_variable_name}

          _ ->
            #{domain_model_variable_name}
        end
      end
    end

    """
  end

  defp keyword_get(field_name) do
    """
    #{field_name} = Keyword.get(opts, :#{field_name})
    """
  end
end
