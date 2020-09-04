# Create Docker container that can run dtiError analysis.

# Start with the Matlab runtime container
FROM flywheel/matlab-mcr:v92.1

MAINTAINER Michael Perry <lmperry@stanford.edu>

# ADD the Matlab Stand-Alone (MSA) into the container
COPY src/bin/*dtiinitDiffusionMaps* /usr/local/bin/

# Ensure that the executable files are executable
RUN chmod +x /usr/local/bin/*dtiinitDiffusionMaps*

# Copy and configure run script and metadata code
COPY manifest.json ${FLYWHEEL}/manifest.json

# Configure entrypoint
ENTRYPOINT ["/usr/local/bin/run_dtiinitDiffusionMaps.sh"]
