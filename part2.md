# Part _Two!_

In Part 1 of the demo, 
we focussed on simply rendering
a `README.md` file hosted on `Gitea` 
in our **`Phoenix`** App.

_Next_ we are going to do 
something a bit more advanced ...

## Prerequisites 

For the next section to work,
you will need to add your **`public` SSH key**
to your **`Gitea`** server instance. 
Please see: 
[gitea-server#6-add-ssh-key](https://github.com/dwyl/gitea-server#6-add-ssh-key) 
for instructions.

_Test_ your `ssh` connection to the **`gitea` server**
***before*** continuing. If that's not working, none of the rest will.

<br />

## 7. _Update_ the `README.md` file using `gitea`! 📝

Open the `lib/app_web/controllers/page_controller.ex` file <br />
and replace the `index/2` function with the following:

```elixir
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
```

> **Note**: there's quite a lot of code in that function.
> Hopefully the inline comments are helpful. 
> If you have any doubts/questions, _please_
> open an issue: 
> [dwyl/gitea-demo/issues](https://github.com/dwyl/gitea-demo/issues)

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
This is because 
**(a)** this new code is making **_four_ API requests**
and 
**(b)** the **server** is quite **far away**, 
relatively speaking ...
If we **deploy** this **demo App** to `Fly.io`
so that it's on the _same_ server cluster 
as the **`gitea` server** https://gitea-server.fly.dev
then the round-trip time should be _considerably_ faster.
Let's do that now!

<br />


## 8. Deploy to Fly.io (Part 2: `ssh`)

In previous section,
the code to _update_ the `README.md` file 
on the **`Gitea` Server** (remote repository)
worked because you added your 
**_personal_ `public` SSH key** 
to the **`Gitea` Server**. 
But if we want it to work on `Fly.io`
we need to 
***either*** export our _personal_ **`private` ssh key** 
to the Fly instance (_probably not what you want to do_)
***or*** 
**create** a **_`new`_ ssh key**
which you can upload to the Fly instance.

### 8.1 Create a _`new`_ ssh key on `localhost`

In your terminal, 
create a new directory called `keys`
and append it to your `.gitignore` file:

```sh
mkdir keys
echo "keys/*" >> .gitignore 
```

Next, 
run the following command 
to create the new `ssh` keys:

```sh
ssh-keygen -t ed25519 -C "your.name@gmail.com" -f ./keys/id_ed25519 -q -N ""
```

> **Note**: the email address _optional_ 
> and only used as label in the `public` key file. <br />
> You can update it to your email address 
> or leave it blank if you prefer.


The `./keys` directory should now contain two files, e.g:

```sh
keys
├── id_ed25519
└── id_ed25519.pub
```

Armed with these two files, you can now update the `Dockerfile` 

### 8.2 Update the `Dockerfile`

Add the following lines to the "runner" section of your `Dockerfile`:

```dockerfile
# Create dir for ssh key on Fly instance
RUN mkdir -p /root/.ssh/
# Copy the keys you've created on your localhost to the Fly instance:
COPY keys/id_ed25519 /root/.ssh/      
# Update permissions of the key so open-ssh doesn't complain
RUN chmod 600 /root/.ssh/id_ed25519

# Add the gitea server to known_hosts so no ssh prompting required: 
RUN ssh-keyscan -H gitea-server.fly.dev > /root/.ssh/known_hosts 
```

> **Note**: These lines are commented for clarity.
> If you have any doubts/questions, _please_
> open an issue: 
> [dwyl/gitea-demo/issues](https://github.com/dwyl/gitea-demo/issues)
### 8.3 Add the `public` key to `

Open the `keys/id_ed25519.pub` file 
copy the contents and
add it to **`gitea` server**
https://gitea-server.fly.dev/user/settings/keys
by following the instructions in:
[gitea-server#6-add-ssh-key](https://github.com/dwyl/gitea-server#6-add-ssh-key).
### 8.4 Deploy! 

Deploy verbose:
```sh
LOG_LEVEL=debug fly deploy --verbose
```






## _OPTIONAL_: GitHub CI Continuous Deployment


### Add the `private` key to GitHub Secrets

> **Note**: This is why we suggested 
> you create a `new` ssh key above ...


Visit: https://github.com/dwyl/gitea-demo/settings/secrets/actions
and create a **New repository secret** 
called **`SSH_PRIVATE_KEY`**
with the contents of your `keys/id_ed25519` file.




<br />

[![HitCount](http://hits.dwyl.com/dwyl/gitea-demo-part2.svg)](http://hits.dwyl.com/dwyl/gitea-demo)
