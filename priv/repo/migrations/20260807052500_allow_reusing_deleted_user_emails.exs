defmodule Claper.Repo.Migrations.AllowReusingDeletedUserEmails do
  use Ecto.Migration

  def change do
    drop_if_exists unique_index(:users, [:email])
    create unique_index(:users, [:email], where: "deleted_at IS NULL")
  end
end
