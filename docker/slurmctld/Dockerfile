ARG UBUNTU_VERSION=20.04

FROM ubuntu:${UBUNTU_VERSION}

ARG USERNAME="ikimslurm"
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

# The following values must match their counterparts in slurm.conf.
ARG SLURM_STATE_SAVE_LOCATION=/var/spool/slurmctld
ARG SLURM_LOG_DIR=/var/log/slurm
ARG SLURMCTLD_PID_DIR=/run/slurm

ENV TZ=Etc/UTC

# Install packages.
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y install --no-install-recommends \
        freeipa-client \
        munge \
        openssh-server \
        slurmctld \
        sudo \
        supervisor \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Create a user.
RUN groupadd --gid "$USER_GID" "$USERNAME" \
    && useradd -s /bin/bash --uid "$USER_UID" --gid "$USERNAME" -m "$USERNAME"

# Make the user a sudoer.
RUN echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/99-${USERNAME} \
    && chmod 440 /etc/sudoers.d/99-${USERNAME} \
    && visudo -c

# Allow logging in via ssh as the created user.
# The README file is included in the COPY instruction to prevent it from failing
# if no .pub files are present.
COPY ssh/*.pub ssh/README /tmp/ssh/
RUN mkdir "/home/$USERNAME/.ssh" \
    && for pubkey in /tmp/ssh/*.pub; do (cat "$pubkey"; echo) >> "/home/$USERNAME/.ssh/authorized_keys"; done \
    && chmod 600 "/home/$USERNAME/.ssh/authorized_keys" \
    && chown -R "$USERNAME:$USERNAME" "/home/$USERNAME/.ssh" \
    && rm -rf /tmp/ssh

# Configure sshd.
COPY etc/ssh/sshd_config.d/*.conf /etc/ssh/sshd_config.d/
RUN mkdir /run/sshd

# Create directories used by SLURM.
RUN mkdir "$SLURM_STATE_SAVE_LOCATION" "$SLURM_LOG_DIR" "$SLURMCTLD_PID_DIR" \
    && chown slurm:slurm "$SLURM_STATE_SAVE_LOCATION" "$SLURM_LOG_DIR" "$SLURMCTLD_PID_DIR"

# Copy the supervisor definition files.
COPY etc/supervisor/conf.d/*.conf /etc/supervisor/conf.d/

# Copy the entrypoint script.
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--nodaemon"]

VOLUME ["/ipaadmin"]
EXPOSE 22
EXPOSE 6817
