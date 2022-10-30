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
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/gitea-demo/main.svg?style=flat-square)](https://codecov.io/github/dwyl/gitea-demo?branch=main)
[![Hex.pm](https://img.shields.io/hexpm/v/gitea?color=brightgreen&style=flat-square)](https://hex.pm/packages/gitea)
[![Libraries.io dependency status](https://img.shields.io/librariesio/release/hex/gitea?logoColor=brightgreen&style=flat-square)](https://libraries.io/hex/gitea)
[![docs](https://img.shields.io/badge/docs-maintained-brightgreen?style=flat-square)](https://hexdocs.pm/gitea/api-reference.html)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/gitea-demo/issues)
[![HitCount](https://hits.dwyl.com/dwyl/gitea-demo.svg)](https://hits.dwyl.com/dwyl/gitea-demo)

</div>

# _Why_? 🤷

**We love** having **_detailed_ docs** and **examples**
that **explain _exactly_ how** to get **up-and-running**. 😍 <br />
**_Comprehensive_ docs/tutorials**
are a _gift_ to our future selves and teammates. 🎁  <br />
We constantly refer back to them
and update them as required. <br />
If you find them useful,
please ⭐ the repo to let us know.

# _What_? 💭

This project is a _barebones_ demonstration
of using
[`gitea`](https://github.com/dwyl/gitea)
in a **`Phoenix`** App. <br />
Our intention is to be beginner-friendly
and focus on showcasing **_one_ thing**.

It can be used as the basis for another app
or you can borrow chunks of setup/code.

# _Who_? 👥

The demo is made for people of all Elixir/Phoenix skill levels. <br />
Following all the steps in this example should take around **`10 minutes`**. <br />

If you get stuck, please _don't suffer_ in silence! <br />
It's probably something we didn't cover well enough, it's not you! <br />
**Get help** by opening an issue:
[**gitea-demo/issues**](https://github.com/dwyl/gitea-demo/issues)

<br />

# _How?_ 💻

### 0. Prerequisites 📝

***Before*** you start,
make sure you have the following:

1. `Elixir`: https://elixir-lang.org/install.html <br />
  New to `Elixir`? see:
  [github.com/dwyl/**learn-elixir**](https://github.com/dwyl/learn-elixir)
2. `Phoenix`: https://hexdocs.pm/phoenix/installation.html <br />
  New to `Phoenix`? see:
  [github.com/dwyl/**learn-phoenix-framework**](https://github.com/dwyl/learn-phoenix-framework)
3. Access to a `Gitea` Server
  e.g: https://github.com/dwyl/gitea-server

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
[`mix.exs`](https://github.com/dwyl/gitea-demo/blob/main/mix.exs)
file in the root of your `app` folder,
locate the `defp deps do` section and add the following line:

```elixir
{:gitea, "~> 1.1.0"},
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
you will need **2 environment variables**.
See:
[**`.env_sample`**](https://github.com/dwyl/gitea/blob/main/.env_sample)
for a sample.

1. `GITEA_URL` - the domain where your gitea Server is deployed,
   without the protocol, <br />
   e.g: `gitea-server.fly.dev`

2. `GITEA_ACCESS_TOKEN` - the REST API Access Token
Instructions for getting your token:
[gitea-server#connect-via-rest-api-https](https://github.com/dwyl/gitea-server#connect-via-rest-api-https)

#### 3.1 Create your `.env` File

Create a new file in root the `app` project called `.env`.
Copy the contents of the
[**`.env_sample`**](https://github.com/dwyl/gitea/blob/main/.env_sample)
file and paste it in the `.env` file.

Update the _values_ of the environment variables with the real ones.
Run the following command in your terminal (in the root of your project):

```sh
source .env
```

This will export the environment variables into your terminal environment.

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


### 4. Create Function to Interact with the `gitea` Repo

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
replace the `index/2` function
with the following:

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

This updated function specifies 3 variables:

1. `org_name`: the organisation/owner name for a repository on the `gitea` server.
2. `repo_name`: repository name on the `gitea` server
3. `file_name`: the Markdown file we want to render as HTML.

It invokes the
[`Gitea.remote_render_markdown_html/3`](https://hexdocs.pm/gitea/Gitea.html#remote_render_markdown_html/4)
function that renders the Markdown contained in the `file_name`
as `HTML` which can be rendered on a page.

<br />

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
This is _already_ cool,
but it doesn't even scratch the surface of what's possible!

Let's _deploy_ the app to
[Fly.io](https://fly.io/)
so that we can _show_ our progress
to other people in our team!


<br />

## 6. _Deploy_ to Fly.io 🚀

We have simplified the steps to deploy a **`Phoenix`** App to Fly.io
for the sake of brevity.
If you are totally new to Fly.io in _general_
or deploying a **`Phoenix`** App _specifically_,
Please see:
https://fly.io/docs/speedrun/

The `Dockerfile`, `fly.toml` and `config/runtime.exs` files
can be used to deploy to Fly.io,
e.g:
https://gitea-demo.fly.dev


> The `Dockerfile` is inspired by:
> https://github.com/fly-apps/hello_elixir/blob/main/Dockerfile

### Deployment Instructions:

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


Setup the required environment variables
on Fly using the CLI:

```sh
flyctl secrets set GITEA_URL=gitea-server.fly.dev
flyctl secrets set GITEA_ACCESS_TOKEN=your-token-here
flyctl secrets set SECRET_KEY_BASE=https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Secret.html
```

Deploy:
```sh
flyctl deploy
```

You should see:

```sh
Release v1 created
Monitoring Deployment

1 desired, 1 placed, 1 healthy, 0 unhealthy [health checks: 1 total, 1 passing]
```

And when you visit the App URL in your browser:
https://gitea-demo.fly.dev/

![gitea-demo-on-flyio](https://user-images.githubusercontent.com/194400/168806932-d5d405a6-4d3a-41e1-9ac1-038f083d74c9.png)

<br/>

## Conclusion!

That concludes our **_basic_ demo**.
What we covered:
1. Setup a new **`Phoenix`** App
2. Added the **`gitea`** dependency
3. Added the required environment variables
4. Created code to render a markdown file
  using the `Gitea.remote_render_markdown_html/3` function.
5. Deployed the demo to Fly.io!


If you found this demo/tutorial useful,
please ⭐ the repo to let us know.

Thank you!

<hr />

But wait! There's more!!
See: [**Part _Two_!**](https://github.com/dwyl/gitea-demo/blob/main/part2.md)

<br /><br /><br />
