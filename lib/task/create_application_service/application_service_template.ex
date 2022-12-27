defmodule Mix.TasksHelper.ApplicationServiceTemplate do
  def template(
        prefix: prefix,
        application_service_name: application_service_name,
        domain_model_name: domain_model_name,
        event_name: event_name
      ) do
    domain_model_variable_name = Macro.underscore(domain_model_name)

    application_service_event_name =
      application_service_name
      |> Macro.underscore()
      |> String.replace("_", "-")

    """
    defmodule #{prefix}.#{application_service_name} do
      use #{prefix}.Includes, :application_service

      alias #{prefix}.#{domain_model_name}
      alias #{prefix}.#{domain_model_name}Repository
      alias #{prefix}.#{event_name}

      def execute(
            field1: field1,
            metadata: metadata
          ) do
        #{domain_model_variable_name} = #{domain_model_name}.new()

        event = #{event_name}.for(#{domain_model_variable_name})

        start_transaction()
        |> persist_#{domain_model_variable_name}(#{domain_model_variable_name})
        |> persist_event(event, metadata)
        |> finish_transaction()
        |> return_result()
      end

      defp persist_#{domain_model_variable_name}(multi, #{domain_model_variable_name}) do
        Multi.run(multi, :persist_new_#{domain_model_variable_name}, fn _, _ ->
          #{domain_model_name}Repository.save(#{domain_model_variable_name})
        end)
      end

      defp persist_event(multi, event, metadata) do
        Multi.run(multi, :persist_#{domain_model_variable_name}_event, fn _, _ ->
          append_event(event, event_metadata("#{application_service_event_name}", metadata))
        end)
      end
    end
    """
  end
end
