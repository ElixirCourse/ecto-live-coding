defmodule App.Repo.Migrations.AddSaltAndPasswordUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:password_hash, :string)
      add(:salt, :string)
    end
  end
end
