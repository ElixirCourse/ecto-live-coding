defmodule App.Repo.Migrations.CreatePostsTable do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add(:title, :string, null: false)
      add(:text, :text)

      add(:user_id, references(:users), null: false)
    end
  end
end
