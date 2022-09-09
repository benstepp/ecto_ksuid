FROM elixir:1.14

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN mix local.hex --force && mix local.rebar --force

RUN mkdir /app
WORKDIR /app

COPY ./mix.exs ./mix.lock ./
RUN mix deps.get
RUN mix deps.compile

COPY ./ .
RUN mix deps.get
RUN mix compile && MIX_ENV=test mix compile

CMD ["bash"]
