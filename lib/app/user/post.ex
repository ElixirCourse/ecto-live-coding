defmodule App.Post do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias App.Repo

  schema "posts" do
    field(:title, :string)
    field(:text, :string)

    belongs_to(:user, App.User)
  end

  def changeset(%__MODULE__{} = post, args \\ %{}) do
    post
    |> cast(args, [:title, :text, :user_id])
  end

  def add_post(title, text, user_id) do
    %__MODULE__{}
    |> changeset(%{title: title, text: text, user_id: user_id})
    |> Repo.insert()
  end

  def posts_by_user(user_id) do
    from(p in __MODULE__, where: p.user_id == ^user_id)
    |> Repo.all()
  end
end
