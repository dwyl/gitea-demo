defmodule AppWeb.PageController do
  use AppWeb, :controller

  require Logger

  def index(conn, _params) do
    org_name = "demo-org"
    repo_name = "hello-world"
    file_name = "README.md"
  
    # # Git clone the existing remote repo:
    git_repo_url = Gitea.Helpers.remote_url_ssh(org_name, repo_name)
    Gitea.clone(git_repo_url)
    local_path = Gitea.Helpers.local_repo_path(org_name, repo_name)
    Logger.info("local_path: #{local_path}")
    # Note: if the dir already exists it will not "throw" an error,
    # but logger will output "[error] Gitea.clone/1 tried to clone ..."
    
    # Read the contents of the local version of README.md
    file_path = Path.join([local_path, file_name]) |> Path.expand()
    Logger.info("File.exists?(#{file_path}) #{File.exists?(file_path)}")
    {:ok, text} = Gitea.local_file_read(org_name, repo_name, file_name)
    Logger.info(text)
    lines = String.split(text, "\n")
  
    # Current date time e.g. "2022-05-17 12:42"
    now = DateTime.utc_now |> DateTime.to_string |> String.split(".") |> List.first
  
    # Prepare content to be written:
    content = 
      # Delete the last line from lines:
      List.delete_at(lines, length(lines)-1) 
      # Add "last updated #{now}" to the lines:
      |> Enum.concat(["Last updated #{now}"])
      # Join to make a string:
      |> Enum.join("\n")
  
    # Write to the *local* version of the README.md
    Gitea.local_file_write_text(org_name, repo_name, file_name, content)
    
    # Commit the changes:
    {:ok, msg} = Gitea.commit(org_name, repo_name, 
      %{message: "last updated #{now}", full_name: "Al Ex", email: "alex@dwyl.co"})
    Logger.info(msg)
  
    # Push the changes to the remote:
    Gitea.push(org_name, repo_name)
  
    # Now, finally read back the updated README.md
    {:ok, %{body: raw_html}} = 
      Gitea.remote_render_markdown_html(org_name, repo_name, file_name)
    render(conn, "index.html", html: raw_html)
  end

  def init(conn, _params) do
    # Make the required directory: /home/nobody/.ssh/
    

    render(conn, "init.html")
    
  end

end
