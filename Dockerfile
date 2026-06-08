# Use the official Alpine Linux image as the base
FROM alpine:latest

# Install necessary dependencies
RUN apk add --no-cache \
    asterisk \
    asterisk-res-pjsip \
    asterisk-chan-pjsip \
    asterisk-codec-opus \
    asterisk-codec-g722 \
    asterisk-codec-gsm \
    asterisk-codec-alaw \
    asterisk-codec-ulaw

# Create necessary directories
RUN mkdir -p /etc/asterisk \
    && mkdir -p /var/lib/asterisk \
    && mkdir -p /var/spool/asterisk

# Copy your custom configuration files
COPY asterisk.conf /etc/asterisk/
COPY pjsip.conf /etc/asterisk/
COPY extensions.conf /etc/asterisk/

# Expose the necessary ports
EXPOSE 5060/udp 5060/tcp 10000-20000/udp

# Start Asterisk
# CMD ["asterisk", "-f", "-c", "-g"]

# Start a shell
CMD ["/bin/sh"]