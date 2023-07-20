defmodule Mix.TasksHelper.CreateApplicationService do
  @prefix Application.compile_env(:layeredex, :prefix, SomeModuleName)
  @project_folder_name Application.compile_env(:layeredex, :folder_name, "project_folder")

  def create_application_service(%{"--a" => application_service_name} = params) do
    domain_model_name = Map.get(params, "--m") || "DomainModelName"
    event_name = Map.get(params, "--e") || "EventName"

    content =
      Mix.TasksHelper.ApplicationServiceTemplate.template(
        prefix: @prefix,
        application_service_name: application_service_name,
        domain_model_name: domain_model_name,
        event_name: event_name
      )

    IO.inspect("we in generator")

    File.write(
      application_service_path(application_service_name),
      content
    )

    IO.inspect("O, generated!")
  end

  def create_application_service_test(%{"--a" => application_service_name} = params) do
    domain_model_name = Map.get(params, "--m") || "DomainModelName"
    event_name = Map.get(params, "--e") || "EventName"
    application_service_filename = Macro.underscore(application_service_name)

    content =
      Mix.TasksHelper.ApplicationServiceTestTemplate.template(
        prefix: @prefix,
        application_service_name: application_service_name,
        domain_model_name: domain_model_name,
        event_name: event_name
      )

    File.write(
      application_service_path(
        application_service_name,
        "#{application_service_filename}_application_service_test",
        "exs"
      ),
      content
    )
  end

  def application_service_path(application_service_name, file_name \\ nil, extension \\ "ex") do
    application_service_filename = Macro.underscore(application_service_name)

    file_name =
      if file_name do
        file_name
      else
        "#{application_service_filename}_application_service"
      end

    app_dir = File.cwd!()
    File.mkdir("#{app_dir}/lib/#{@project_folder_name}/#{application_service_filename}")

    Path.join([
      app_dir,
      "lib",
      "#{@project_folder_name}",
      application_service_filename,
      "#{file_name}.#{extension}"
    ])
  end
end
