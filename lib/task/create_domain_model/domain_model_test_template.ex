defmodule Mix.TasksHelper.DomainModelTestTemplate do
  import Layeredex.Shared

  def template(
        prefix: prefix,
        domain_model_name: domain_model_name,
        model_fields: model_fields
      ) do
    domain_model_variable_name = Macro.underscore(domain_model_name)

    assertions =
      if model_fields do
        model_fields
        |> String.split(" ")
        |> Enum.map(fn field -> String.split(field, ":") end)
        |> Enum.map(fn [field_name, _] ->
          create_asserts(domain_model_variable_name, field_name)
        end)
      else
        ""
      end

    setup =
      if model_fields do
        model_fields
        |> String.split(" ")
        |> Enum.map(fn field -> String.split(field, ":") end)
        |> Enum.map(fn [field_name, field_type] -> create_setup(field_name, field_type) end)
      else
        ""
      end

    """
    defmodule #{prefix}.#{domain_model_name}Test do
      alias #{prefix}.#{domain_model_name}
      use Support.DataCase, async: true
      use #{prefix}.Includes, :factory

      test "build" do
        #{setup}

        #{domain_model_variable_name} = build(:#{domain_model_variable_name})

        #{assertions}
      end
    end
    """
  end
end
