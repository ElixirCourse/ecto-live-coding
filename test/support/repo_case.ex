defmodule App.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias App.Repo

      import Ecto
      import Ecto.Query
      import App.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(App.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(App.Repo, {:shared, self()})
    end

    :ok
  end
end
