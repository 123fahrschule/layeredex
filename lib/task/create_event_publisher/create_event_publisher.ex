defmodule Mix.TasksHelper.CreateEventPublisher do
  import Mix.TasksHelper.CreateApplicationService, only: [application_service_path: 3]
  @prefix Application.compile_env(:layeredex, :prefix, SomeModuleName)
  alias Mix.TasksHelper.CreateEventPublisherTemplate
  alias Mix.TasksHelper.CreateEventPublisherTestTemplate

  def create_external_event_publisher(%{"--a" => application_service_name, "--e" => event_name}) do
    event_variable_name = Macro.underscore(event_name)

    content =
      CreateEventPublisherTemplate.template(
        prefix: @prefix,
        event_name: event_name
      )

    File.write(
      application_service_path(
        application_service_name,
        "#{event_variable_name}_event_publisher",
        "ex"
      ),
      content
    )
  end

  def create_external_event_publisher_test(
        %{"--a" => application_service_name, "--e" => event_name} = params
      ) do
    event_variable_name = Macro.underscore(event_name)
    model_name = Map.get(params, "-m")

    content =
      CreateEventPublisherTestTemplate.template(
        prefix: @prefix,
        event_name: event_name,
        model_name: model_name
      )

    File.write(
      application_service_path(
        application_service_name,
        "#{event_variable_name}_event_publisher_test",
        "exs"
      ),
      content
    )
  end
end
