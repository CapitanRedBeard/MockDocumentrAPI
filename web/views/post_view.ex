defmodule ExampleProject.PostView do
  use ExampleProject.Web, :view

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, ExampleProject.PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, ExampleProject.PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{id: post.id,
      title: post.title,
      content: post.content}
  end
end
