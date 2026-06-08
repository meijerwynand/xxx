# Use the official Asterisk image as a base
FROM asterisk:latest

# Set the working directory
WORKDIR /etc/asterisk

# Copy configuration files
COPY config/sip.conf .
COPY config/extensions.conf .

# Expose necessary ports
EXPOSE 5060/udp
EXPOSE 10000-20000/udp

# Start Asterisk in foreground mode
CMD ["asterisk", "-vvvvd", "-c", "-g"]