Groupstrip
==========

GroupStrip is a OS-agnostic batch management platform inspired by [MKVOptimizer](https://www.videohelp.com/software/MKV-Optimizer). It runs in a dockerized container with a locally accessible Web GUI, much like [Sonarr](https://github.com/Sonarr/Sonarr) (has queue, can have different directories formatting differently, asynchronous processes), and integrates with [MKVToolNix](https://mkvtoolnix.download) to provide easy batch management for baked-in tracks on your video files.

Requirements
------------

Elixir 1.12/OTP 24 Docker

Docker Installation (recommended)
---------------------------------

**Short version:**

1. `bash  curl -fsSL https://get.docker.com -o get-docker.sh`

2. `git clone git@github.com:shakajones/groupstrip.git`

3. `docker compose build`

4. `docker compose up`

    - `-d` flag runs in detatched mode
  
    - instead of 3 & 4, when you're comfortable feel free to run `docker compose up --build` after stopping it if you need to mess with the image or if you're having dependency management issues.

5. See all running containers with `docker ps` and see all recent images with `docker imasges` 

6. To use an interactive development console: Is the container currently running?
  
    - if yes, then find the container name (default: groupstrip) and perform `docker exec -it { container_name } iex -S mix phx.server`
  
    - if no, then find the image name (default: emmajhyde/groupstrip:latest) you just built and perform `docker run -it --rm { image_name} iex -S mix phx.server`
  
    - use these same strategies for accessing the container filesystem/shell: `docker exec -it groupstrip /bin/bash` will take you to the shell.

7. Mounts your app directory into the filesystem, so changes are propagated on the other side when made & the application will live reload. You can try this out: visit `localhost:4000` & mess around with the copy in `lib/groupstrip_web/templates/page/index.html.eex`, and refresh. You should see the application log its recompilation and the request logging, as well as seeing the frontend app!

**Further explanation of steps and hints:**

1.  In order to develop locally with docker, execute: `bash  curl -fsSL https://get.docker.com -o get-docker.sh` (*See more generic docker setup instructions in* [the docker documentation](https://docs.docker.com/get-docker/)*.*)

2.  `git clone` this repository and `cd` in.

3.  Execute `docker compose build` to build the image.

    -   The resulting container will mount the current directory into its filesystem so that files you change locally will trigger live reload, etc. inside the container.

    -   The dockerfile will not rebuild dependencies on its own because they're baked into the image. It's possible elixir will but I haven't tested it. You can use `docker compose restart` to reboot the app, but in order to rebuild dependencies you should probably stop the container (ctrl+c) and `docker compose up --build`. This will 100% trigger the dependencies to be rebuilt if you've changed them, or you can shell in with below instructions and perform the commands manually (`mix deps.get` in `/app` directory, `npm install` in `/app/assets` directory).

4.  Execute `docker compose up` to run the image.

    -   This will start the docker container and automatically run `mix phx.server` on port `4000`, tailing the debug logs to your console. That's it! It will behave exactly like you are running it locally, but it's actually running on a thin Alpine linux distribution.

5.  Start a container in detached mode with `docker compose up -d`.

6.  You can find the running container names with `docker ps`.

7.  If you'd like to look around inside the container or interact with the container command line, perform `docker compose up -d` where the -d flag indicates that it will run in detached mode. Then execute

    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ elixir
    docker exec -it { container_name } /bin/bash
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    The container name is most likely `groupstrip_phoenix_1`.

    -   This will shell you into the container and its filesystem, much like `ssh`.

    -   If you'd like to start the interactive console, you have to run the build image instead of the compose specified `up` process: `elixir   docker run -it --rm groupstrip:latest iex -S mix phx.server` Where `groupstrip:latest` is the image name.

    -   using `docker images` will show you all of the images you have recently built.

Note: All the above commands handle the elixir commands inside the container implicitly. Technically there is no need to even install elixir on your local instance. IDE integrations for docker do allow you to pull dependencies from a container and use those deps, but if you'd like a local copy I am using `asdf` for version management. See the next section for further details.

Local Environment Dev (non-dockerized)
--------------------------------------

A manual installation is helpful in terms of using the CLI tooling whether or not the container is running. In theory, you will spend 90% of your time outside the container, so not super helpful to only have the CLI functionality (mix, iex, etc.) there. Think of docker as the `npm install & npm start`, or `bundle install & rails server`, of this application, but it won't hurt to be able to run it locally either. I will look into debugging in the container and see if I can simplify things.

### Installation

Either way, non-dockerized installation instructions: 

1. Install asdf with `brew install asdf` 

2. Install plugin for elixir with `asdf add plugin elixir` 

3. Install needed Elixir version with `asdf install elixir 1.12.1-otp-24`

4. Enable necessary Elixir version with `asdf shell elixir 1.12.1-otp-24` - The `.tool-versions` file will automatically enable this elixir version when you cd into the directory from now on (requires asdf to be installed). 

5. Hex is the Elixir package manager, but it is not installed automatically. You can install Hex with `mix local.hex`. 

6. Check that the correct versions are enabled with `elixir -v`.

### Development

1.  Install Elixir and Node dependencies in root with `mix setup`, which is a directive defined in the aliases in `mix.exs`.

2.  Start Phoenix endpoint from root with `mix phx.server`

3.  Run the Groupstrip instide IEx (Interactive Elixir, basically, `rails console`) with `iex -S mix phx.server`

Now you can visit [localhost:4000](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

iEX
---

Run:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ elixir
recompile()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

in iex to force compilation from inside the shell.

Learn more
----------

-   Official website: https://www.phoenixframework.org/

-   Guides: https://hexdocs.pm/phoenix/overview.html

-   Docs: https://hexdocs.pm/phoenix

-   Forum: https://elixirforum.com/c/phoenix-forum

-   Source: https://github.com/phoenixframework/phoenix
