# Docker file that installs docker container for Selenzyme
#
# build with: "sudo docker build -t selenzyme ."
FROM continuumio/anaconda3:5.0.1

# Install tools
RUN conda install -c conda-forge flask-restful=0.3.6
RUN conda install -c conda-forge plotly=2.2.3

ENTRYPOINT ["python"] 
CMD ["/selprom/serve.py", "/selprom/data"]

EXPOSE 7700
