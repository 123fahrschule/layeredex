defmodule Mix.TasksHelper.CreateDomainModelRepositoryTemplate do
  def template(prefix: prefix, domain_model_name: domain_model_name, model_fields: model_fields) do
    domain_model_variable_name = Macro.underscore(domain_model_name)

    permitted_params =
      if model_fields do
        model_fields
        |> String.split(" ")
        |> Enum.map(fn field -> String.split(field, ":") end)
        |> Enum.map(fn [field_name, _] ->
          ":#{field_name},\n"
        end)
      else
        ""
      end

    """
    defmodule #{prefix}.#{domain_model_name}Repository do
      use #{prefix}.Includes, :repository

      alias #{prefix}.#{domain_model_name}

      @permitted_params [
        #{permitted_params}
      ]

      def save(%#{domain_model_name}{} = #{domain_model_variable_name}) do
        #{domain_model_variable_name}
        |> cast(@permitted_params)
        |> insert_or_update()
      end

      def by_id(id) when is_binary(id) do
        case Repo.get_by(#{domain_model_name}, id: id) do
          %#{domain_model_name}{} = #{domain_model_variable_name} -> {:ok, #{domain_model_variable_name}}
          nil -> {:error, :#{domain_model_variable_name}_not_found}
        end
      end
    end

    """
  end
end
