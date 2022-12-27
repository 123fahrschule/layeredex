defmodule Mix.TasksHelper.CreateEventListener do
  import Mix.TasksHelper.CreateApplicationService, only: [application_service_path: 3]
  @prefix Application.compile_env(:layeredex, :prefix, SomeModuleName)

  def create_internal_event_listener(%{"--a" => application_service_name, "--e" => event_name}) do
    event_variable_name = Macro.underscore(event_name)

    content =
      Mix.TasksHelper.EventListenerTemplate.template(
        event_name: event_name,
        prefix: @prefix
      )

    File.write(
      application_service_path(
        application_service_name,
        "#{event_variable_name}_event_listener",
        "ex"
      ),
      content
    )
  end

  def create_internal_event_listener_test(%{
        "--a" => application_service_name,
        "--e" => event_name
      }) do
    event_variable_name = Macro.underscore(event_name)

    content =
      Mix.TasksHelper.EventListenerTestTemplate.template(
        event_name: event_name,
        prefix: @prefix
      )

    File.write(
      application_service_path(
        application_service_name,
        "#{event_variable_name}_event_listener_test",
        "exs"
      ),
      content
    )
  end
end
