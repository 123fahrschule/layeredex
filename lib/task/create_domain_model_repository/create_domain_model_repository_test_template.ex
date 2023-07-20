defmodule Mix.TasksHelper.CreateDomainModelRepositoryTestTemplate do
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
    defmodule #{prefix}.#{domain_model_name}RepositoryTest do
      use Support.DataCase, async: true

      alias #{prefix}.#{domain_model_name}Repository

      test "save" do
        #{setup}

        #{domain_model_variable_name} = insert(:#{domain_model_variable_name})

        #{assertions}
      end

      describe "by id" do
        test "found" do
          #{domain_model_variable_name} = insert(:#{domain_model_variable_name})

          assert {:ok, _#{domain_model_variable_name}} = #{domain_model_name}Repository.by_id(#{domain_model_variable_name}.id)
        end

        test "error: not found" do
          assert {:error, :#{domain_model_variable_name}_not_found} = #{domain_model_name}Repository.by_id(new_uuid())
        end
      end
    end

    """
  end
end
