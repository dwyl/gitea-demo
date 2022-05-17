defmodule AppWeb.PageController do
  use AppWeb, :controller

  def index(conn, _params) do
    org_name = "demo-org"
    repo_name = "hello-world"
    file_name = "README.md"
    {:ok, %{body: raw_html}} = 
      Gitea.remote_render_markdown_html(org_name, repo_name, file_name)
    render(conn, "index.html", html: raw_html)
  end
end
