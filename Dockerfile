from ruby:2.7

### rails

RUN gem install bundler:2.3.14

COPY . /code

WORKDIR /code

RUN bundle install

CMD ["rails", "s"]

### java

RUN apt-get update -y && \
  apt-get install -y openjdk-11-jre-headless && \
  rm -rf /var/lib/apt/lists/*

### swagger-codegen

RUN mkdir /usr/lib/swagger-codegen && \
    wget -q https://repo1.maven.org/maven2/io/swagger/codegen/v3/swagger-codegen-cli/3.0.35/swagger-codegen-cli-3.0.35.jar -O /usr/lib/swagger-codegen/swagger-codegen-cli.jar && \
    echo "java -jar /usr/lib/swagger-codegen/swagger-codegen-cli.jar \$@" > /usr/bin/swagger-codegen && \
    chmod a+x /usr/bin/swagger-codegen
