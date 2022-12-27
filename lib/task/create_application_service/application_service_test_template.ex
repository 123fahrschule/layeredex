defmodule Mix.TasksHelper.ApplicationServiceTestTemplate do
  def template(
        prefix: prefix,
        application_service_name: application_service_name,
        domain_model_name: domain_model_name,
        event_name: event_name
      ) do
    domain_model_variable_name = Macro.underscore(domain_model_name)

    application_service_defdelegate_name = Macro.underscore(application_service_name)

    """
    defmodule #{prefix}.#{application_service_name}Test do
      use Support.DataCase, async: false

      alias #{prefix}.#{domain_model_name}
      alias #{prefix}.#{domain_model_name}Repository
      alias #{prefix}.#{event_name}

      @moduletag :integration

      test "#{String.replace(application_service_defdelegate_name, "_", " ")}" do

        assert :ok =
                 #{prefix}.#{application_service_defdelegate_name}(
                   student_id: student.id,
                   metadata: [enacted_by: "enacted_by"]
                 )

        assert {:ok, #{domain_model_variable_name}} = #{domain_model_name}Repository.bu_id(id)
        assert #{domain_model_variable_name}.id == id

        assert [{%#{event_name}{} = event, metadata}] = all_events()
        assert event.id == id

        assert metadata.enacted_by == "enacted_by"
        assert metadata.causation_id
      end
    end
    """
  end
end
