# Docker file that installs docker container for Selprom
#
# build with: "sudo docker build -t selprom ."

# Install basic image
FROM continuumio/anaconda3:5.0.1

# Install additional tools
RUN conda install -c conda-forge flask-restful=0.3.6
RUN conda install -c conda-forge plotly=2.2.3

# Start the server
ENTRYPOINT ["python"] 
CMD ["/selprom/serve.py", "/selprom/data"]

# Open server port
EXPOSE 7700
