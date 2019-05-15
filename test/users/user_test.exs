defmodule App.UserTest do
  use App.RepoCase

  alias App.User

  test "create basic user" do
    username = "ivan"
    age = 24
    email = "ivan@gmail.com"

    {:ok, %User{} = user} = User.add_user(%{username: username, age: age, email: email})

    assert user.username == username
    assert user.age == age
    assert user.email == email
  end

  test "autogenerates salt" do
    {:ok, %User{} = user} = User.add_user(%{username: "ivan"})
    assert is_binary(user.salt)
    assert String.length(user.salt) == 24
  end

  test "can manually set salt" do
    salt = "some_salt"
    {:ok, %User{} = user} = User.add_user(%{username: "ivan", salt: salt})
    assert user.salt == salt
  end

  test "create user with password" do
    username = "ivan"
    password = "12345678"
    salt = "some_salt"

    {:ok, %User{} = user} = User.add_user(%{username: username, password: password, salt: salt})

    # bad
    assert user.password_hash == :crypto.hash(:sha256, salt <> password) |> Base.encode64()
  end

  test "does not log password, email and salt" do
    username = "ivan"
    password = "12345678"
    email = "ivan@gmail.com"
    salt = "some_salt"

    {:ok, %User{} = user} =
      User.add_user(%{username: username, email: email, password: password, salt: salt})

    log = inspect(user)

    assert not (password =~ log)
    assert not (email =~ log)
    assert not (salt =~ log)
  end
end
