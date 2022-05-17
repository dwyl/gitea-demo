<div align="center">

# Gitea _Demo_

<img alt="Gitea" src="https://user-images.githubusercontent.com/194400/168781665-a52d2c00-8b69-44ae-a10a-7bd1c3932020.svg" width="240"/>
    

A fully functional **demo** app
showing interaction between an<br />
**`Elixir`** (**`Phoenix`**) App
and **`Gitea`** server
using the
[`gitea`](https://github.com/dwyl/gitea) package. <br />
**_Step-by-step_ tutorial** showing you how to do it yourself!

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/dwyl/gitea-demo/Elixir%20CI?label=build&style=flat-square)](https://github.com/dwyl/gitea-demo/actions/workflows/ci.yml)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/gitea-demo/main.svg?style=flat-square)](http://codecov.io/github/dwyl/gitea-demo?branch=main)
[![Hex.pm](https://img.shields.io/hexpm/v/gitea?color=brightgreen&style=flat-square)](https://hex.pm/packages/gitea)
[![Libraries.io dependency status](https://img.shields.io/librariesio/release/hex/gitea?logoColor=brightgreen&style=flat-square)](https://libraries.io/hex/gitea)
[![docs](https://img.shields.io/badge/docs-maintained-brightgreen?style=flat-square)](https://hexdocs.pm/gitea/api-reference.html)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/gitea-demo/issues)
[![HitCount](http://hits.dwyl.com/dwyl/gitea-demo.svg)](http://hits.dwyl.com/dwyl/gitea-demo)

</div>

# _Why_? 🤷

We love having _detailed docs and **examples**_
that explain _exactly_ how to get up-and-running. <br />
**_Comprehensive_ docs/tutorials**
are a _gift_ to our future selves and teammates. 🎁 
They allow us to get up-to-speed
or remember what's going on
especially when returning to a project after a while.
We constantly refer back to them 
and update them when required.
If you find them useful, please ⭐ the repo to let us know.

# _What_? 💭

This project is a _barebones_ demonstration
of using
[`gitea`](https://github.com/dwyl/gitea)
in any **`Phoenix`** App. <br />
It's intended to be beginner-friendly
and focus on showcasing **_one_ thing**.

It can be used as the basis for another app
or you can borrow chunks of setup/code.

# _Who_? 👥

This demo is intended for people of all Elixir/Phoenix skill levels. <br />
Following all the steps in this example should take around **`10 minutes`**. <br />
If you get stuck, please _don't suffer_ in silence!
**Get help** by opening an issue:
[github.com/dwyl/**gitea-demo/issues**](https://github.com/dwyl/gitea-demo/issues)

<br />

# _How?_ 💻

### 0. Prerequisites 📝 

_Before_ you start,
make sure you have the following installed:

1. `Elixir`: https://elixir-lang.org/install.html <br />
   New to `Elixir`? see: 
   [github.com/dwyl/**learn-elixir**](https://github.com/dwyl/learn-elixir)
2. `Phoenix`: https://hexdocs.pm/phoenix/installation.html <br />
   New to `Phoenix`? see:
   [github.com/dwyl/**learn-phoenix-framework**](https://github.com/dwyl/learn-phoenix-framework)

<br />

### 1. Create a New `Phoenix` App 🆕 

For this example,
we are creating a _basic_ **`Phoenix`** App
without the live dashboard or mailer (email)
or `Ecto` (Postgres database)
because we don't need those components
in order to showcase the `gitea` package.

```sh
mix phx.new app --no-ecto --no-dashboard --no-mailer
```

When prompted to install dependencies:

```sh
Fetch and install dependencies? [Yn]
```

Type `y` and hit the `[Enter]` key to install.

You should see something like this:

```sh
* running mix deps.get
* running cd assets && npm install && node node_modules/webpack/bin/webpack.js
* running mix deps.compile
```

#### Checkpoint: Working `Phoenix` App 🏁 

Change into the directory of your newly created `Phoenix` app

```sh
cd app
```

And start the app:

```sh
mix setup
mix phx.server
```

You should see output similar to the following:

```sh
Generated app app
[info] Running AppWeb.Endpoint with cowboy 2.9.0 at 127.0.0.1:4000 (http)
[info] Access AppWeb.Endpoint at http://localhost:4000
[debug] Downloading esbuild from https://registry.npmjs.org/esbuild-darwin-64/-/esbuild-darwin-64-0.14.29.tgz
[watch] build finished, watching for changes...
```

That confirms the app is working.

Open your web browser to the URL: http://localhost:4000

You should see the default **`Phoenix`** home page:

<img width="828" alt="image" src="https://user-images.githubusercontent.com/194400/165493125-0e714185-e268-411f-bb7d-99f7cd0eb8ba.png">

So far so good. 👌 <br />

#### 1.1 Clear out `page` template

Before we continue, 
let's do a clear out of the `page` template:
`lib/app_web/templates/page/index.html.heex`

Open the file and delete the contents so it's completely empty.

With the `Phoenix` server running (`mix phx.server`),
the page should refresh and now look like this:

![phoenix-app-clean-slate](https://user-images.githubusercontent.com/194400/168068678-60b8eab1-ee7c-49a7-81d8-c8ecc22eb123.png)

#### 1.2 Fix the Failing Test

If you run the tests after the previous step:

```sh
mix test
```

You will see output similar to the following:

```sh
1) test GET / (AppWeb.PageControllerTest)
    test/app_web/controllers/page_controller_test.exs:4
    Assertion with =~ failed
    code:  assert html_response(conn, 200) =~ "Welcome to Phoenix!"
    left:  "<!DOCTYPE html>\n<html lang=\"en\">\n  <head>\n    <meta charset=\"utf-8\">\n \n<meta content=\"Am45cWxzFjAKCBcxXQAYHRUmaQZ5RjUFoYS35KUzdLCk3YBN-IQU8rs3\" name=\"csrf-token\">\n<title data-suffix=\" · Phoenix Framework\">App · Phoenix Framework</title> etc."
    right: "Welcome to Phoenix!"
    stacktrace:
      test/app_web/controllers/page_controller_test.exs:6: (test)

Finished in 0.1 seconds (0.08s async, 0.07s sync)
3 tests, 1 failure
```

This is because we removed the block of text that the test expects to be on the page.
Easy enough to fix by updating the assertion in the test.

Open the `test/app_web/controllers/page_controller_test.exs` file
and replace the line:

```elixir
assert html_response(conn, 200) =~ "Welcome to Phoenix!"
```

With the following:

```elixir
assert html_response(conn, 200) =~ "Get Started"
```

Once you save the file and re-run the tests `mix test`,
they should pass:

```sh
...

Finished in 0.1 seconds (0.08s async, 0.06s sync)
3 tests, 0 failures
```

With that out-of-the way,
let's crack on with the actual demo!

<br />

### 2. Add `gitea` to `deps` ⬇️ 

Open the 
[`mix.exs`]()
file,
locate the `defp deps do` section and add the following line:

```elixir
{:gitea, "~> 0.1.0"},
```

Once you've saved your `mix.exs` file, 
e.g:
[`mix.exs#L55-L56`](https://github.com/dwyl/gitea-demo/blob/58c6bf0f7b96a370f6a90408526f6e335014025a/mix.exs#L55-L56) <br />
run: 
```sh
mix deps.get
```

With the dependency installed, 
we can now setup.

### 3. Setup: Environment Variables 📝

To get the **`gitea`** package working in your **`Phoenix`** App,
you will need **4 environment variables**.
See:
[**`.env_sample`**](https://github.com/dwyl/gitea/blob/main/.env_sample)
for a sample.

1. `gitea_URL` - the domain where your gitea Server is deployed,
   without the protocol, <br />
   e.g: `gitea-server.fly.dev`

2. `gitea_ACCESS_TOKEN` - the REST API Access Token 
See: 
[gitea-server#connect-via-rest-api-https](https://github.com/dwyl/gitea-server#connect-via-rest-api-https)

3. `gitea_SSH_PORT` - The TCP port allocated to SSH on your gitea Server,
   in our case it's: `10022`.

4. `gitea_SSH_PRIVATE_KEY_PATH` - absolute path to the `id_rsa` file
  on your `localhost` or `Phoenix` server instance.

> If you're new to Environment Variables
> Please see: 
> [github.com/dwyl/**learn-environment-variables**](https://github.com/dwyl/learn-environment-variables)


#### Context: `gitea` Server on Fly.io

In _our_ case our **`gitea`** Server instance
is deployed to [fly.io](https://fly.io/)
at:
[gitea-server.fly.dev](https://gitea-server.fly.dev/) <br />
To understand how this was deployed, 
please see: 
[github.com/dwyl/**gitea-server**](https://github.com/dwyl/gitea-server)


<br />

<!--
#### _Test_ Your Setup!
-->


### 4. Create Function to Interact with gitea Repo

As noted in the first step above, 
the homepage of our app 
is the default `Phoenix` homepage.

In this section we're going to change that!

Open the `lib/app_web/controllers/page_controller.ex` file.
You should see the following:

```elixir
defmodule AppWeb.PageController do
  use AppWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
```

Inside the file, 
replace the `index/2` function with the following:

```elixir
def index(conn, _params) do
  org_name = "demo-org"
  repo_name = "hello-world"
  file_name = "README.md"
  {:ok, %{body: raw_html}} = 
    Gitea.remote_render_markdown_html(org_name, repo_name, file_name)
  render(conn, "index.html", html: raw_html)
end
```

### 5. Update the Template to Display the Text

Open the file:
`lib/app_web/templates/page/index.html.heex`

Insert the following line:

```html
<%= raw(@html) %>
```

Now you will see the `Markdown` rendered in the template:

![rendered-markdown](https://user-images.githubusercontent.com/194400/168069048-15dd5b50-235c-4cbe-9f3e-fb306933e17c.png)

#### Recap!

At this point we have demonstrated 
rendering a Markdown (`README.md`)
file hosted on a `gitea` server
in a `Phoenix` app using the `gitea` package.
This is already cool,
but it doesn't even scratch the surface of what's possible!

At this point in the journey, 
you can either chose 


<br />

## 6. _Deploy_ to Fly.io 🚀 

The `Dockerfile`, `fly.toml` and `config/runtime.exs` files
can be used to deploy to Fly.io: 
https://gitea-demo.fly.dev
![image](https://user-images.githubusercontent.com/194400/168398126-05c147ef-7fcc-4867-8a05-c89669027674.png)

### Deployment Instructions:

```sh
mix release.init
```

> Borrow the init from an app that we've deployed before. 
> e.g: 
> https://github.com/dwyl/gitea-demo/pull/1/commits/9bb69a57364ac51e0ce5ba84106954d2c7a5377f

Initialize the Fly.io config:


```sh
fly launch
```

> Select the relevant options.


Setup environment variables:

```sh
flyctl secrets set GITEA_URL=gitea-server.fly.dev 
flyctl secrets set GITEA_ACCESS_TOKEN=your-token-here
```

Deploy:
```sh
flyctl deploy --verbose
```


<br /><br /><br />

<!-- 

# _Bonus Level_: _Optional_ UI/UX! 💃 



#### ⚠️ Warning: the next 2 steps will _temporarily_ "break" the Phoenix app. Be patient and keep going!


## 4. Create 2 New Files ➕

Create two new directories`lib/app_web/live`

e.g:

```sh
mkdir lib/app_web/live
mkdir 
```



Create 2 new file with the following paths:
1. 

### Note on **`Phoenix`** **`LiveView`**

In this demo we will be using **`Phoenix`** **`LiveView`**
because we feel that the programming model 
is simpler than "MVC" 
from a dev perspective. 

If you are new to **`LiveView`**,
please see our complete beginners' tutorial:
[github.com/dwyl/**phoenix-liveview-counter-tutorial**](https://github.com/dwyl/phoenix-liveview-counter-tutorial)



### The Repo!

https://gitea-server.fly.dev/demo-org/gitea-demo




### 

This Rich Text Editor is based off our work in:
[github.com/nelsonic/amemo](https://github.com/nelsonic/amemo/tree/3a3872663698d93abe29a75add462a7f4285ac26)


## Checkpoint: Working on `localhost` 🏁 


-->

