from ruby:2.6.1

### rails

RUN gem install bundler:2.1.4

COPY . /code

WORKDIR /code

RUN cp -n config/secrets.yml.example config/secrets.yml

RUN bundle install

CMD ["rails", "s"]

### java

RUN apt-get update -y && \
  apt-get install -y openjdk-8-jre-headless && \
  rm -rf /var/lib/apt/lists/*

### swagger-codegen

RUN mkdir /usr/lib/swagger-codegen && \
  wget -q https://repo1.maven.org/maven2/io/swagger/swagger-codegen-cli/2.4.13/swagger-codegen-cli-2.4.13.jar -O /usr/lib/swagger-codegen/swagger-codegen-cli.jar && \
  echo "java -jar /usr/lib/swagger-codegen/swagger-codegen-cli.jar \$@" > /usr/bin/swagger-codegen && \
  chmod a+x /usr/bin/swagger-codegen
