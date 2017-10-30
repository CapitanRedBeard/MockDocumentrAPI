defmodule ExampleProject.PostController do
  use ExampleProject.Web, :controller
  require Documentr.Logger
  alias ExampleProject.Post

  plug :scrub_params, "post" when action in [:create, :update]

  def index(conn, _params) do
    posts = Repo.all(Post)

    response_payload = to_string Poison.Encoder.encode(posts,[])
    path_params = %{
      "method" => "get",
      "url" => "/posts",
      "response_payload" => response_payload
    }

    Documentr.Logger.post(path_params)

    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    changeset = Post.changeset(%Post{}, post_params)

    request_payload = to_string Poison.Encoder.encode(post_params,[])
    response_payload = to_string Poison.Encoder.encode(changeset,[])
    path_params = %{
      "method" => "post",
      "url" => "/posts",
      "request_payload" => request_payload,
      "response_payload" => response_payload,
    }
    Documentr.Logger.post(path_params)

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

    response_payload = to_string Poison.Encoder.encode(post,[])
    path_params = %{
      "method" => "get",
      "url" => "/posts/#{id}",
      "response_payload" => response_payload
    }

    Documentr.Logger.post(path_params)

    render(conn, "show.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, post_params)

    response_payload = to_string Poison.Encoder.encode(changeset,[])
    request_payload = to_string Poison.Encoder.encode(post_params,[])
    path_params = %{
      "method" => "put",
      "url" => "/posts/#{id}",
      "response_payload" => response_payload,
      "request_payload" => request_payload
    }

    Documentr.Logger.post(path_params)

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

    response_payload = to_string Poison.Encoder.encode(post,[])
    path_params = %{
      "method" => "delete",
      "url" => "/posts/#{id}",
      "response_payload" => response_payload,
    }

    Documentr.Logger.post(path_params)


    send_resp(conn, :no_content, "")
  end
end
