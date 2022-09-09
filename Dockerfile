FROM elixir:1.14

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    curl

RUN curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ bullseye-pgdg main" | tee  /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && \
    apt-get install -y \
    postgresql-client-14 \
    && rm -rf /var/lib/apt/lists/*

RUN mix local.hex --force && mix local.rebar --force

RUN mkdir /app
WORKDIR /app

COPY ./mix.exs ./mix.lock ./
RUN mix deps.get
RUN mix deps.compile && MIX_ENV=test mix deps.compile
RUN mix dialyzer --plt

COPY ./ .
RUN mix deps.get
RUN mix compile && MIX_ENV=test mix compile

CMD ["bash"]
