FROM nfcore/base:1.9
LABEL authors="ahmad zyoud" \
      description="Docker image containing all software requirements for the nf-core/localdatahub pipeline"

# Install the conda environment
COPY environment.yml /
RUN conda env create -f /environment.yml && conda clean -a

# Add conda installation dir to PATH (instead of doing 'conda activate')
ENV PATH /opt/conda/envs/nf-core-localdatahub-1.0/bin:$PATH

# Dump the details of the installed packages to a file for posterity
RUN conda env export --name ena-localdatahub-1.0 > ena-localdatahub-1.0.yml
