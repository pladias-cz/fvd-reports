FROM rocker/shiny

RUN apt-get update && apt-get install -y \
    libpq-dev \
    libudunits2-dev \
    libproj-dev \
    libgdal-dev \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /home/shiny-app
RUN R -e "install.packages(c('dplyr', 'ggplot2', 'DBI', 'RPostgres', 'leaflet', 'sf', 'yaml','readr', 'writexl', 'markdown', 'DT', 'sf'))"
RUN R -e "install.packages(c())"

COPY app /home/shiny-app

WORKDIR /home/shiny-app

EXPOSE 8180

CMD R -e "options(shiny.host = '0.0.0.0'); options(shiny.port = 8180); shiny::runApp('/home/shiny-app')"
