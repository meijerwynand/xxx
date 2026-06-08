# Use the official Asterisk image as a base
FROM andrius/asterisk:latest

# Set the working directory
WORKDIR /etc/asterisk

# Copy configuration files
COPY config/sip.conf .
COPY config/extensions.conf .
COPY config/rtp.conf .
COPY config/asterisk.conf .
COPY config/stasis.conf .
COPY config/logger.conf .
COPY config/modules.conf .

# Expose necessary ports
EXPOSE 5060/udp
EXPOSE 10000-10010/udp

# Start Asterisk in foreground mode
CMD ["asterisk", "-vvvvd", "-c", "-g"]
