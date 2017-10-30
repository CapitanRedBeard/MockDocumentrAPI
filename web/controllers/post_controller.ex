defmodule ExampleProject.PostController do
  use ExampleProject.Web, :controller

  alias ExampleProject.Post

  plug :scrub_params, "post" when action in [:create, :update]

  def index(conn, _params) do
    posts = Repo.all(Post)

    response_payload = to_string Poison.Encoder.encode(posts,[])
    path_params = %{
      "path" => %{
        "method" => "get",
        "url" => "/posts",
        "response_type" => "application/json",
        "request_type" => "application/json",
        "response_payload" => response_payload,
        "api_key" => "794190d0-bd7e-11e7-977d-dca90475b70a"
      }
    }
    header = [Accepts: "application/json", "Content-Type": "application/json"]
    HTTPotion.post "http://localhost:4000/v1/api/path", [headers: header, body: to_string Poison.Encoder.encode(path_params,[])]

    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    changeset = Post.changeset(%Post{}, post_params)

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", post_path(conn, :show, post))
        |> render("show.json", post: post)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ExampleProject.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    render(conn, "show.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        render(conn, "show.json", post: post)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ExampleProject.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    send_resp(conn, :no_content, "")
  end
end
