defmodule App.User do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias App.Repo

  schema "users" do
    field(:username, :string)
    field(:email, :string)
    field(:age, :integer)

    has_many(:posts, App.Post)
  end

  def changeset(%__MODULE__{} = user, args \\ %{}) do
    user
    |> cast(args, [:username, :email, :age])
    |> validate_format(:email, ~r/@/)
    |> validate_number(:age, greater_than_or_equal_to: 0)
    |> validate_required([:username])
    |> unique_constraint(:username)
  end

  def add_user(username, email, age) do
    %__MODULE__{}
    |> changeset(%{username: username, email: email, age: age})
    |> Repo.insert()
  end

  def delete_user(user_id) when is_integer(user_id) do
    Repo.get!(__MODULE__, user_id) |> Repo.delete()
  end

  def delete_user(%__MODULE__{} = user) do
    user |> Repo.delete()
  end

  def all_adults() do
    all_users_query()
    |> where([u], u.age >= 18)
    |> Repo.all()
  end

  def all_users() do
    all_users_query()
    |> Repo.all()
  end

  defp all_users_query() do
    from(u in __MODULE__)
  end
end
