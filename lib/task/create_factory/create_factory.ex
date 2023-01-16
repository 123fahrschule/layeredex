defmodule Mix.TasksHelper.CreateFactory do
  import Mix.TasksHelper.CreateDomainModel
  alias Mix.TasksHelper.FactoryTemplate
  @prefix Application.compile_env(:layeredex, :prefix, SomeModuleName)


  def create_factory(%{"--m" => domain_model_name} = params) do
    model_fields = Map.get(params, "--mf")
    domain_model_variable_name = Macro.underscore(domain_model_name)

    content =
      FactoryTemplate.template(
        prefix: @prefix,
        domain_model_name: domain_model_name,
        model_fields: model_fields
      )

    File.write(
      get_domain_model_path(domain_model_name, "#{domain_model_variable_name}_factory", "ex"),
      content
    )
  end
end
