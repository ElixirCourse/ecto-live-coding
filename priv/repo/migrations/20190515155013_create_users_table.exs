defmodule App.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:username, :string, null: false)
      add(:email, :string)
      add(:age, :integer)
    end

    create(unique_index(:users, [:username]))
  end
end
