# Install dependencies
FROM ubuntu:18.04

ARG PROJECT_DIR=/srv/api
ENV PATH=/opt/flutter/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update 
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3 psmisc
RUN apt-get clean
    
# Clone the flutter repo
RUN git clone https://github.com/dannellim/study_mama_flutter.git /usr/local/flutter

RUN curl -L https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.7.8+hotfix.4-stable.tar.xz | tar -C /opt -xJ

WORKDIR ${PROJECT_DIR}
COPY ./ ./

# Enable flutter web
RUN flutter channel beta
RUN flutter upgrade
RUN flutter config --enable-web

# Run flutter doctor
RUN flutter doctor -v

# Copy the app files to the container
COPY . /usr/local/bin/app

# Set the working directory to the app files within the container
WORKDIR /usr/local/bin/app

# Get App Dependencies
RUN flutter pub get

# Build the app for the web
RUN flutter build web --release --no-sound-null-safety

# Document the exposed port
EXPOSE 4040

# Set the server startup script as executable
RUN ["chmod", "+x", "/usr/local/bin/app/server.sh"]

# Start the web server
ENTRYPOINT [ "/usr/local/bin/app/server/server.sh" ]
