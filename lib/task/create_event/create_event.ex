defmodule Mix.TasksHelper.CreateEvent do
  import Mix.TasksHelper.CreateApplicationService, only: [application_service_path: 3]
  @prefix Application.compile_env(:layeredex, :prefix, SomeModuleName)
  alias Mix.TasksHelper.CreateEventTemplate
  alias Mix.TasksHelper.CreateEventTestTemplate

  def create_event(%{"--e" => event_name, "--a" => application_service_name} = params) do
    domain_model_name = Map.get(params, "--m") || "DomainModelName"

    event_content =
      CreateEventTemplate.template(
        prefix: @prefix,
        event_name: event_name,
        domain_model_name: domain_model_name
      )

    file_name = Macro.underscore(event_name)

    File.write(
      application_service_path(application_service_name, "#{file_name}_event", "ex"),
      event_content
    )
  end

  def create_event_test(%{"--e" => event_name, "--a" => application_service_name} = params) do
    domain_model_name = Map.get(params, "--m") || "DomainModelName"

    event_content =
      CreateEventTestTemplate.template(
        prefix: @prefix,
        event_name: event_name,
        domain_model_name: domain_model_name
      )

    file_name = Macro.underscore(event_name)

    File.write(
      application_service_path(application_service_name, "#{file_name}_event_test", "exs"),
      event_content
    )
  end
end
