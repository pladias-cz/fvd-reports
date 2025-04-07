FROM rocker/shiny

RUN apt-get update && apt-get install -y \
    libpq-dev \
    libudunits2-dev \
    libproj-dev \
    libgdal-dev \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /home/shiny-app
RUN R -e "install.packages(c('dplyr', 'ggplot2', 'DBI', 'RPostgres', 'leaflet', 'sf', 'yaml'))"

COPY app.R /home/shiny-app/app.R
COPY config.yaml /home/shiny-app/config.yaml

WORKDIR /home/shiny-app

EXPOSE 8180
CMD Rscript /home/shiny-app/app.R