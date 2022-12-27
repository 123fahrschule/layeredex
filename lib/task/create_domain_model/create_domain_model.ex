defmodule Mix.TasksHelper.CreateDomainModel do
  @prefix Application.compile_env(:layeredex, :prefix, SomeModuleName)
  @project_folder_name Application.compile_env(:layeredex, :folder_name, "project_folder")

  def create_domain_model(%{"--m" => domain_model_name} = params) do
    model_fields = Map.get(params, "--mf")
    domain_model_variable_name = Macro.underscore(domain_model_name)

    content =
      Mix.TasksHelper.DomainModelTemplate.template(
        prefix: @prefix,
        domain_model_name: domain_model_name,
        model_fields: model_fields
      )

    File.write(
      get_domain_model_path(domain_model_name, domain_model_variable_name),
      content
    )
  end

  def create_domain_model_test(%{"--m" => domain_model_name} = params) do
    model_fields = Map.get(params, "--mf")
    domain_model_variable_name = Macro.underscore(domain_model_name)

    content =
      Mix.TasksHelper.DomainModelTestTemplate.template(
        prefix: @prefix,
        domain_model_name: domain_model_name,
        model_fields: model_fields
      )

    File.write(
      get_domain_model_path(domain_model_name, "#{domain_model_variable_name}_test", "exs"),
      content
    )
  end

  def get_domain_model_path(domain_model_name, file_name \\ nil, extension \\ "ex") do
    domain_model_filename = Macro.underscore(domain_model_name)

    file_name =
      if file_name do
        file_name
      else
        domain_model_filename
      end

    app_dir = File.cwd!()
    File.mkdir("#{app_dir}/lib/#{@project_folder_name}/domain_model/#{domain_model_filename}")

    Path.join([
      app_dir,
      "lib",
      "#{@project_folder_name}",
      "domain_model",
      domain_model_filename,
      "#{file_name}.#{extension}"
    ])
  end
end
