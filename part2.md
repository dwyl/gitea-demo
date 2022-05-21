# Part _Two!_

In Part 1 of the demo, 
we focussed on simply rendering
a `README.md` file hosted on `Gitea` 
in our **`Phoenix`** App.

Next we are going to do 
something a bit more advanced: 
_update_ the `README.md` file 
using `gitea` 
from the `Phoenix` App!


## 7. _Update_ the `README.md` File using `gitea`! 📝



Open the `lib/app_web/controllers/page_controller.ex` <br />
and replace the `index/2` function with the following:

```elixir
def index(conn, _params) do
  org_name = "demo-org"
  repo_name = "hello-world"
  file_name = "README.md"

  # Git clone the remote repo:
  git_repo_url = Gitea.Helpers.remote_url_ssh(org_name, repo_name)
  local_path = Gitea.clone(git_repo_url)
  Logger.info("local_path: #{local_path}")
  # Note: if the dir already exists it will not "throw" an error,
  # but logger will output "[error] Gitea.clone/1 tried to clone ..."
  
  # Read the contents of the local version of README.md
  {:ok, text} = Gitea.local_file_read(org_name, repo_name, file_name)
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
```

Save the file and run the `Phoenix` server:
```sh
mix phx.server
```


Now when you refresh the homepage of the app: 
http://localhost:4000/ <br />
You will see something similar to the following:

![gitea-demo-homepage-updated](https://user-images.githubusercontent.com/194400/169069757-754dc222-fc0d-47a7-83dd-0889bfbe7b8d.png)

And if you view the repository on the `Gitea` Server:
https://gitea-server.fly.dev/demo-org/hello-world <br />
You will see that it was updated:
![gitea-repo-updaetd](https://user-images.githubusercontent.com/194400/169069920-37014556-2291-482a-bde3-3119bccd3db3.png)

#### 9 Seconds to Update and Re-render a Markdown File? ⏳

You may have noticed that the round-trip 
to update the `README.md` on the remote `Gitea` repo
takes quite a few seconds. 
This is because the server is quite far away, 
relatively speaking ...
If we deploy this demo to `Fly.io`
so that it's on the same server cluster 
as the https://gitea-server.fly.dev
then the round-trip time should be _considerably_ faster.
Let's do that now!

<br />

## 8. Deploy to Fly.io [Part 2: `ssh`]

Login to the Fly.io instance via the CLI:

```sh
fly ssh console
```
You should see output similar to the following:
```sh
Connecting to top1.nearest.of.gitea-demo.internal... complete
```

Once you have successfully logged into the server,
run:

```sh
mkdir -p /home/nobody/.ssh/
```

Then create an `ssh` key:

```sh
ssh-keygen -t ed25519 -C "nelson@gmail.com" -f /home/nobody/.ssh/id_ed25519 -q -N ""
```

Change the ownership of the key:
```sh
chown nobody /home/nobody/.ssh/id_ed25519
```

<!--
Accept all the defaults and don't bother with a passphrase
as you would need to put the passphrase on the server to be able to use it,
which totally defeats the objective. 
Like putting a post-it of your password on your laptop. 

Next:
```sh
mkdir /app/demo-org
git clone git@gitea-server.fly.dev:demo-org/hello-world.git
```

When asked to confirm the identity of the server,
type: `yes` followed by the <kbd>Enter</kbd> key.


On our instance the `ssh` key was created as the `root` user ...

```
/home/nobody/.ssh/id_ed25519
```
-->
You should see output similar to the following:

```sh
Your identification has been saved in /home/nobody/.ssh/id_ed25519
Your public key has been saved in /home/nobody/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:jWOxs9wW3axCww9yJGJglNbaWDA8VoKHthqs+JidliQ nelson@gmail.com
The key's randomart image is:
+--[ED25519 256]--+
|   =B=.          |
|  +.B+o          |
|.. = *o o .      |
|... o... O . o   |
|oo      S O . o  |
|E .    o O = .   |
| B o    o + o    |
|o *      . .     |
| .               |
+----[SHA256]-----+
```

Run:

```sh
cat /home/nobody/.ssh/id_ed25519.pub
```

You should see output similar to the following:

```sh
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQdEbgW7qhEARi1i3TfCZ7yIKNPmVfKSxIwC77bm1QV nelson@gmail.com
```

Copy the output.

Visit: https://gitea-server.fly.dev/user/settings/keys
and add the key.


Then visit: https://gitea-server.fly.dev/admin 
and find the following on the page: 
"Update the '.ssh/authorized_keys' file" <br />
Click the button!

Now back in your terminal run:

```sh
cd /app/demo-org/
```

Followed by:

```sh
ssh-add /home/nobody/.ssh/id_ed25519 
```

```sh
GIT_SSH_COMMAND='ssh -i /home/nobody/.ssh/id_ed25519 -o IdentitiesOnly=yes' git clone git@gitea-server.fly.dev:demo-org/test-repo.git
```

You will see output similar to the following:

```sh
Cloning into 'test-repo'...
The authenticity of host 'gitea-server.fly.dev (2a09:8280:1::1:3ac4)' can't be established.
ECDSA key fingerprint is SHA256:GBijJMz7j9NhfHmXAbrY+kmKfrTnAXKbx9WG6M65hf0.
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```
Type: `yes` followed by the <kbd>Enter</kbd> key.

Check that the `git clone` command worked, 
running:

```sh
cat /app/demo-org/test-repo/README.md
```

You should see:

```sh
# test-repo
```

Test the ssh connection to the `gitea-searver`

```sh
ssh -T git@gitea-server.fly.dev -i /home/nobody/.ssh/id_ed25519 -o IdentitiesOnly=yes
```

<!--
If you see:
```sh
git@gitea-server.fly.dev: Permission denied (publickey).
```
Don't Panic!

try:
```sh
GIT_SSH_COMMAND='ssh -i /home/nobody/.ssh/id_ed25519 -o IdentitiesOnly=yes' git push 
```
-->

You should see:
```sh
Hi there, nelsonic! You've successfully authenticated with the key named MBP 2022, but Gitea does not provide shell access.
If this is unexpected, please log in with password and setup Gitea under another user.
```

Deploy verbose:
```sh
LOG_LEVEL=debug fly deploy --verbose
```

<br />

[![HitCount](http://hits.dwyl.com/dwyl/gitea-demo-part2.svg)](http://hits.dwyl.com/dwyl/gitea-demo)
