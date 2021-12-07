FROM ruby:3.0.3-slim-bullseye

COPY pkg/*.gem ./

RUN gem install *.gem

ENTRYPOINT ["dependagrab"]
CMD ["--help"]
