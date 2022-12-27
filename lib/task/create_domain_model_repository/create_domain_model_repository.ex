defmodule Mix.TasksHelper.CreateDomainModelRepository do
  import Mix.TasksHelper.CreateDomainModel
  @prefix Application.compile_env(:layeredex, :prefix, SomeModuleName)
  alias Mix.TasksHelper.CreateDomainModelRepositoryTemplate
  alias Mix.TasksHelper.CreateDomainModelRepositoryTestTemplate

  def create_domain_model_repository(%{"--m" => domain_model_name} = params) do
    model_fields = Map.get(params, "--mf")
    domain_model_variable_name = Macro.underscore(domain_model_name)

    content =
      CreateDomainModelRepositoryTemplate.template(
        prefix: @prefix,
        domain_model_name: domain_model_name,
        model_fields: model_fields
      )

    File.write(
      get_domain_model_path(domain_model_name, "#{domain_model_variable_name}_repository", "ex"),
      content
    )
  end

  def create_domain_model_repository_test(%{"--m" => domain_model_name} = params) do
    model_fields = Map.get(params, "--mf")
    domain_model_variable_name = Macro.underscore(domain_model_name)

    content =
      CreateDomainModelRepositoryTestTemplate.template(
        prefix: @prefix,
        domain_model_name: domain_model_name,
        model_fields: model_fields
      )

    File.write(
      get_domain_model_path(
        domain_model_name,
        "#{domain_model_variable_name}_repository_test",
        "exs"
      ),
      content
    )
  end
end
