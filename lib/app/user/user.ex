defmodule App.User do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias App.Repo

  @derive {Inspect, except: [:email, :salt, :password]}
  schema "users" do
    field(:username, :string)
    field(:email, :string)
    field(:age, :integer)
    field(:salt, :string)

    field(:password_hash, :string)
    field(:password, :string, virtual: true)

    has_many(:posts, App.Post)
  end

  def changeset(%__MODULE__{} = user, args \\ %{}) do
    user
    |> cast(args, [:username, :email, :age, :password, :salt])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> put_pass_hash()
    |> validate_number(:age, greater_than_or_equal_to: 0)
    |> validate_required([:username])
    |> unique_constraint(:username)
  end

  defp put_pass_hash(%{changes: %{password: password, salt: salt}} = changeset) do
    password_hash = :crypto.hash(:sha256, salt <> password) |> Base.encode64()
    put_change(changeset, :password_hash, password_hash)
  end

  defp put_pass_hash(changeset), do: changeset

  def add_user(args) do
    salt = Map.get(args, :salt) || :crypto.strong_rand_bytes(16) |> Base.encode64()
    args = Map.put(args, :salt, salt)

    %__MODULE__{}
    |> changeset(args)
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
